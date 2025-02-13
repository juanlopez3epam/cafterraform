#!/bin/bash
# -------------------------------------------------------------------------------------
# This script is triggered from within the GH workflow. The purpose of the script is
# to detect the HDInsight cluster in the subscription, then to derive the resource group
# and the kafka keyvault.
# From the keyvault, the public and private keys are extracted needed to configure 
# the cluster. Once all data is found, the SSH connection is setup to the headnode and 
# the initialization script is sent to it. From there the cluster will be configured
# Once done, all key information is removed from the runner
# -------------------------------------------------------------------------------------

# Exit immediately if a command exits with a non-zero status
set -e

# Trap function to handle errors
handle_error() {
  echo "Error on line $1: command failed."
  exit 1
}

# Set trap to call handle_error with the line number of the error
trap 'handle_error $LINENO' ERR

BLUE='\033[1;36m'
YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

head_user=''
ambari_user=''
ambari_pwd=''
keystore_pwd=''
vault_name=''
dns_zone=''
regenerate_certs="$1"
# WILL EVENTUALLY BE PART OF A GH ACTION
echo -e "${YELLOW}Finding correct keyvault${NOCOLOR}"

#filter key vaults that contains 'kafka' but not 'kafka-worker'
kvnames=$(az keyvault list --query "[].name" --output tsv | grep '.*kafka.*' | grep -v 'kafka-worker' )
for kvname in $kvnames
do
    
    echo -e "${BLUE}Collecting hdinsight and kafka secrets from keyvault${NOCOLOR}"
    vault_name=$kvname

    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep gateway-username)
    ambari_user=$(az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv)
    ambari_user="${ambari_user}"
    echo "::add-mask::${ambari_user}"

    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep gateway-password)
    ambari_pwd=$(az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv)
    ambari_pwd="${ambari_pwd}"
    echo "::add-mask::${ambari_pwd}"
    
    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep head-node-username)
    head_user=$(az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv)
    head_user="${head_user}"
    echo "::add-mask::${head_user}"
    
    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep keystore-password)
    keystore_pwd=$(az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv)
    keystore_pwd="${keystore_pwd}"
    echo "::add-mask::${keystore_pwd}"
    
    echo "Base64 input warnings are going are ignored."

    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep head-node-private-ssh-key-base64)
    az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv | base64 --decode > ./head_id     

    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep worker-node-private-ssh-key-base64)
    az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv | base64 --decode > ./worker_id     

    fld=$(az keyvault secret list --vault-name $kvname --query "[].name" --output tsv  | grep zookeeper-node-private-ssh-key-base64)
    az keyvault secret show --vault-name $kvname --name ${fld} --query "value" --output tsv | base64 --decode > ./zookeeper_id     

    # Query HDInsights by keyvault tag to get the Private DNS zone of the KV instance, based on privatedns tag
    dns_zone=$(az hdinsight list --query "[?tags.keyvault=='$kvname']".tags."privatedns" --output tsv)

    # copy private keys to cluster and execute script
    chmod +x ./headnode.sh
    chmod 600 ./*_id

    # get cluster name based on keyvault tag 
    cluster_name=$(az hdinsight list --query "[?tags.keyvault=='$kvname'].name" --output tsv)
    echo "Cluster name: $cluster_name"
    
    cluster_rg=$(az hdinsight list --query "[?tags.keyvault=='$kvname'].resourceGroup" --output tsv)
    echo "Cluster RG: $cluster_rg"
    
    # get the vnet associated to hdinsight
    vnet_id=$(az hdinsight show --name $cluster_name --resource-group $cluster_rg --query 'properties.computeProfile.roles[0].virtualNetworkProfile.subnet' --output tsv)
    vnet_id="$(echo "$vnet_id" | tr -d '\r' | sed -e 's/[[:space:]]*$//')"
    
    #query ip of headnode for the cluster in context
    cluster_ssh=$(az network nic list --query "[?contains(ipConfigurations[].subnet.id, '$vnet_id')] | [?contains(name, 'headnode')]".ipConfigurations[0].privateIPAddress --output tsv | head -n 1)
    
    echo -e "\n${BLUE}Kafka cluster ssh endpoint retrieved: $cluster_ssh${NOCOLOR}"
    echo -e "${BLUE}Retrieving list of worker nodes from cluster...${NOCOLOR}"

    cluster_nodes=$(az hdinsight host list  --cluster-name $cluster_name --resource-group $cluster_rg --query '[].name' --output tsv | grep wn)

    echo -e "${BLUE}Worker nodes found:${NOCOLOR}"
    tmp=''
    for worker in $cluster_nodes
    do
        tmp="$tmp${worker}@"
        echo " - $worker"
    done
    workernodes="${tmp}"


    echo -e "\n\n${BLUE}Copying private keys to cluster for internal communication...${NOCOLOR}"
    scp -o StrictHostKeyChecking=no -i ./head_id  ./head_id  $head_user@$cluster_ssh:~/.ssh/head_id 
    scp -o StrictHostKeyChecking=no -i ./head_id  ./worker_id  $head_user@$cluster_ssh:~/.ssh/worker_id 
    scp -o StrictHostKeyChecking=no -i ./head_id  ./zookeeper_id $head_user@$cluster_ssh:~/.ssh/zookeeper_id


    echo -e "\n${BLUE}Executing configuration script on remote host${NOCOLOR}"
    echo "--------------------------------------------------------------------------------"
    ssh -o StrictHostKeyChecking=no -i ./head_id $head_user@$cluster_ssh 'bash -s '  < ./headnode.sh $ambari_user $ambari_pwd $keystore_pwd $workernodes $cluster_name $dns_zone $regenerate_certs


    echo -e "\n\n${BLUE}Storing Kakfa private key + public cert in keyvault${NOCOLOR}"
    scp -o StrictHostKeyChecking=no -i ./head_id  $head_user@$cluster_ssh:~/ssl/client-pkcs12.pfx  ./client-pkcs12.pfx
    scp -o StrictHostKeyChecking=no -i ./head_id  $head_user@$cluster_ssh:~/ssl/ca-cert  ./ca-cert

    echo " - storing client certificate bundle"
    az keyvault certificate import --vault-name $vault_name --name kafka-client --file ./client-pkcs12.pfx --output none
    #az keyvault secret set --vault-name $vault_name --name kafka-ca-key-base64 --value "$pk" --output none
    echo " - storing CA public certificate"
    az keyvault secret set --vault-name $vault_name --name kafka-ca-cert --file ./ca-cert --output none

    unset pk
    unset cert

    # # force deletion of key files
    echo -e "\n${BLUE}Removing key files from host${NOCOLOR}"
    rm -f ./client-pkcs12.pfx
    rm -f ./ca-cert
    rm -f ./head_id
    rm -f ./worker_id
    rm -f ./zookeeper_id

    echo -e "\n\n${YELLOW}Kafka cluster configuration completed!${NOCOLOR}"

done
