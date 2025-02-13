#!/bin/bash
# -------------------------------------------------------------------------------------
# This script is run on the head node (parameters: ambari_user ambari_pwd keystore_pwd worker_nodes cluer_name)
# -------------------------------------------------------------------------------------
ORANGE='\033[0;33m'
PURPLE='\033[1;35m'
NOCOLOR='\033[0m'


echo -e "${ORANGE}Running on head node in cluster${NOCOLOR}"

aUid="$1"
aPwd="$2"
pwd="$3"
tmp="$4"
cluster_name="$5"
dns_zone="$6"
regenerate_certs="$7"

#Get a list of worker nodes passed in using parameters (seperator '@'').
IFS='@' read -ra workers <<< "$tmp"

# The keys are valid for 1825 days which is 5 years. I know this is serious long, but we want to prevent the solution from crashing.
# sampleorg SRE / Ops needs to remediate this part by rotating certificates ans keys. The password is stored in the keyvault for future reference 
days=1825
headNode="$(hostname -f)"
currentUser=$(whoami)

# Create a new directory 'ssl' and change into it
mkdir -p ssl
cd ssl

echo -e "\n\n${ORANGE}Do we need to generate CA Cert and store it in the keystore?${NOCOLOR}"
# Create CA cert and key
if [[ ("${regenerate_certs}" == "true") || (! -f ca-cert) ]]; then
  echo "- Generating CA Cert"
	openssl req -new -newkey rsa:4096 -days $days -x509 -subj "/CN=Kafka-Security-CA" -keyout ca-key -out ca-cert -nodes
else
  echo "- CA Cert already exists"
fi

# STORE CA in TRUSTSTORE
if [[ ("${regenerate_certs}" == "true") || (! -f kafka.server.truststore.jks) ]]; then
  echo "- Importing CA Cert in trust store"
  keytool -delete -noprompt -alias "CARoot" -keystore kafka.server.truststore.jks -storepass "$pwd"
	keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "$pwd" -keypass "$pwd" -noprompt
else
  echo "- Trust store already exists"
fi

# GENERATE CLIENT AUTHENTICATION CERTIFICATE
echo -e "\n\n${ORANGE}Do we need to generate client authentication certificate?${NOCOLOR}"
if [[ ("${regenerate_certs}" == "true") || (! -f client.cert.pem) ]]; then
  echo "- Generating client authentication certificate"
  openssl req -new -newkey rsa:4096 -subj "/CN=Kafka Client" -keyout client.key.pem -out client.req.pem -nodes
  openssl x509 -req -CA ca-cert -CAkey ca-key -in client.req.pem -out client.cert.pem -days $days -CAcreateserial -passin pass:"$pwd"-sha256
  openssl pkcs12 -export -in client.cert.pem -inkey client.key.pem -out client-pkcs12.pfx -certfile ca-cert -passout pass:
else
  echo "- Client authentication certificate already exists"
fi

# GENERATE SCRIPT FILE TO RUN ON WORKERS (SETUP THE KEYSTORE AND GENERATE KEYS)
echo -e "\n\n${PURPLE}Generate script to set up keystore for worker nodes${NOCOLOR}"
workerscriptfile="/tmp/workernode.sh"
script_content='#!/bin/bash
# Create a new directory 'ssl' and change into it
mkdir -p ssl
cd ssl
 
# capture parameters
pwd=$1
days=$2
headNode=$3
dns_zone=$4
regenerate_certs="$5"
currentUser=$(whoami)

echo "dns_zone value: $dns_zone"
HOST_NAME="$(hostname).$dns_zone"
echo "HOST_NAME value: $HOST_NAME"

# Copy trust store from head node 0
if [[ ("${regenerate_certs}" == "true") || (! -f kafka.server.truststore.jks) ]]; then
	scp -o StrictHostKeyChecking=no -i ~/.ssh/head_id $currentUser@$headNode:~/ssl/kafka.server.truststore.jks ./
fi
# Create a keystore and populate it with a new private key
# The -ext "SAN=dns:$(hostname -f),ip:$(hostname -i) parameter is optional (our simple CA wont actually include these when signing)
# but if you are using an AD certificate authority this is where you would specify additional names 
if [[ ("${regenerate_certs}" == "true") || (! -f kafka.server.keystore.jks) ]]; then
  keytool -delete -noprompt -alias "mykey" -keystore kafka.server.keystore.jks -storepass $pwd
	keytool -genkey -keystore kafka.server.keystore.jks -validity $days -storepass "$pwd" -keypass "$pwd" -dname "CN=$(hostname -f)" -ext "SAN=dns:$HOST_NAME,dns:$(hostname -f),ip:$(hostname -i)" -storetype pkcs12 -keyalg RSA
	keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "$pwd" -keypass "$pwd" -ext "SAN=dns:$HOST_NAME,dns:$(hostname -f),ip:$(hostname -i)"
  echo "subjectAltName = DNS:$HOST_NAME, DNS:$(hostname -f), IP:$(hostname -i)" >> cert-extensions
fi 
exit
'

echo "$script_content" > $workerscriptfile

chmod +x $workerscriptfile


# THEN RUN SCRIPT ON ALL WORKERS THEN DELETE IT (parameters: pwd, days)
for worker in "${workers[@]}"
do
    workerNode="${headNode/$(hostname)/$worker}"
    echo -e "- ${PURPLE}Processing worker-node: $workerNode${NOCOLOR}"

    # copy the private key from the head to be used on the worker
    scp -o StrictHostKeyChecking=no -i ~/.ssh/worker_id  ~/.ssh/head_id  $currentUser@$worker:~/.ssh/head_id 

    # create the csr on the worker and copy it back to the head node
    ssh -i ~/.ssh/worker_id -o StrictHostKeyChecking=no $currentUser@$worker 'bash -s ' < $workerscriptfile $pwd $days $headNode $dns_zone $regenerate_certs
    scp -o StrictHostKeyChecking=no -i ~/.ssh/worker_id  $currentUser@$workerNode:~/ssl/cert-file ~/ssl/$worker-csr
    scp -o StrictHostKeyChecking=no -i ~/.ssh/worker_id $currentUser@$workerNode:~/ssl/cert-extensions ~/ssl/$worker-csr-ext
done
rm $workerscriptfile

# Sign requests
echo -e "\n${ORANGE}Signing certificates on head node${NOCOLOR}"
for f in *-csr
do
 name=$(echo $f | awk -F '-csr' '{print $1}')
 if [[ ("${regenerate_certs}" == "true") || (! -f $name-cert-signed) ]]; then
   echo "- signing certificate: $name-cert-signed"
   # This assumes that there is also a file named $name-csr-ext
   openssl x509 -req -CA ca-cert -CAkey ca-key -in $f -extfile $name-csr-ext -out $name-cert-signed -days $days -CAcreateserial -passin pass:"$pwd"
 fi
done

# GENERATE SCRIPT 2 FOR THE WORKERS AND RUN IT
echo -e "\n${PURPLE}Generate script to import signed certificates into worker nodes${NOCOLOR}"
script_content='#!/bin/bash
cd ~/ssl

# capture parameters
pwd=$1

keytool -delete -noprompt -alias "CARoot" -keystore kafka.server.truststore.jks -storepass "$pwd"
keytool -delete -noprompt -alias "CARoot" -keystore kafka.server.keystore.jks -storepass "$pwd"
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "$pwd" -keypass "$pwd" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "$pwd" -keypass "$pwd" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "$pwd" -keypass "$pwd" -noprompt

# Remove the head_id from the worker. Lock it down
rm -f ~/.ssh/head_id

exit
'
echo "$script_content" > $workerscriptfile
chmod +x $workerscriptfile

# RUN SCRIPT ON ALL WORKERS THEN DELETE IT (param: pwd)
for worker in "${workers[@]}"
do
    workerNode="${headNode/$(hostname)/$worker}"
    echo -e "- ${PURPLE}Processing worker-node: $workerNode${NOCOLOR}"

    scp -o StrictHostKeyChecking=no -i ~/.ssh/worker_id  ~/ssl/ca-cert $surrentUser@$workerNode:~/ssl/ca-cert
    scp -o StrictHostKeyChecking=no -i ~/.ssh/worker_id  ~/ssl/$worker-cert-signed $surrentUser@$workerNode:~/ssl/cert-signed

    ssh -i ~/.ssh/worker_id -o StrictHostKeyChecking=no $currentUser@$worker 'bash -s ' < $workerscriptfile $pwd 
done
rm $workerscriptfile

# remove the head id from the head node as well
rm ~/.ssh/head_id


# SET AMBARI CONFIGURATION
echo -e "\n\n\n${ORANGE}Configuring Ambari${NOCOLOR}"
# Get the kafka configuration, determine what the active headnode is 
hn=$(ping -c 1 headnodehost | head -1)
hn=${hn/PING /}
IFS=' '
read -a aHost <<< $hn 

# SET kafka-env template config
kafkaEnvTemplate="$(cat << EOF
#!/bin/bash

# Set KAFKA specific environment variables here.
# test 4

# The java implementation to use.
export JAVA_HOME={{java64_home}}
export PATH=\$PATH:\$JAVA_HOME/bin
export PID_DIR={{kafka_pid_dir}}
export LOG_DIR={{kafka_log_dir}}
export KAFKA_KERBEROS_PARAMS={{kafka_kerberos_params}}
export JMX_PORT=\${JMX_PORT:-9999}
export MAX_WAIT_TIME=600

# Add kafka sink to classpath and related depenencies
if [ -e "/usr/lib/ambari-metrics-kafka-sink/ambari-metrics-kafka-sink.jar" ]; then
  export CLASSPATH=\$CLASSPATH:/usr/lib/ambari-metrics-kafka-sink/ambari-metrics-kafka-sink.jar
  export CLASSPATH=\$CLASSPATH:/usr/lib/ambari-metrics-kafka-sink/lib/*
fi
if [ -f /etc/kafka/conf/kafka-ranger-env.sh ]; then
. /etc/kafka/conf/kafka-ranger-env.sh
fi

export KAFKA_HEAP_OPTS="-Xmx7168m -Xms7168m"
export KAFKA_JVM_PERFORMANCE_OPTS="-XX:MetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:G1HeapRegionSize=16M -XX:MinMetaspaceFreeRatio=50 -XX:MaxMetaspaceFreeRatio=80"

TIMESTAMP=`date +'%Y%m%d%H%M'`
# GC log location/name prior to .n addition by log rotation
GC_LOG_NAME="{{kafka_log_dir}}/server-gc.log-\$TIMESTAMP"

GC_LOG_ENABLE_OPTS="-verbose:gc -Xloggc:\$GC_LOG_NAME"

# Rotate the file and set max log size to 100M. A maximum of 10 files will be created per broker.
GC_LOG_ROTATION_OPTS="-XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M"
GC_LOG_FORMAT_OPTS="-XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps"
export KAFKA_GC_LOG_OPTS="\$GC_LOG_ENABLE_OPTS \$GC_LOG_ROTATION_OPTS \$GC_LOG_FORMAT_OPTS"

#Configure Kafka to advertise host name based on Private DNS Zone
HOST_NAME="\$(hostname).$dns_zone"
echo advertised.listeners=\$HOST_NAME 
sed -i.bak -e '/advertised/{/advertised@/!d;}' /usr/hdp/current/kafka-broker/conf/server.properties
echo "advertised.listeners=PLAINTEXT://\$HOST_NAME:9092,SSL://\$HOST_NAME:9093" >> /usr/hdp/current/kafka-broker/conf/server.properties

EOF
)"

# Change the ambari kafka configuration
cd /var/lib/ambari-server/resources/scripts
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "auto.create.topics.enable" -v "true"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "num.partitions" -v "10"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "default.replication.factor" -v "3"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "min.insync.replicas" -v "2"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "log.retention.hours" -v "360"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "security.inter.broker.protocol" -v "SSL"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "listeners" -v "PLAINTEXT://localhost:9092, SSL://localhost:9093"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.key.password" -v "$pwd"  
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.keystore.location" -v "/home/$currentUser/ssl/kafka.server.keystore.jks" 
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.keystore.password" -v "$pwd"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.truststore.location" -v "/home/$currentUser/ssl/kafka.server.truststore.jks"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.truststore.password" -v "$pwd"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-broker -k  "ssl.client.auth" -v "none"
sudo ./configs.py --user=$aUid --password=$aPwd --port=8080 --action=set --host=$aHost --cluster=$cluster_name --config-type=kafka-env -k "content" -v  "$kafkaEnvTemplate"

# Get list of affected worker nodes
echo -e "\n\n${ORANGE}Fetching list of worker nodes that need to be restarted...${NOCOLOR}"
affected_nodes=$(curl -u ${aUid}:${aPwd} -H "X-Requested-By: ambari" -X GET http://${aHost}:8080/api/v1/clusters/${cluster_name}/services/KAFKA/components/KAFKA_BROKER | grep -Po '(?<=host_name" : ")[^"]*')

# Restart the Kafka broker component on the affected worker nodes
for affected_node in ${affected_nodes[@]}
do
  echo "- Restarting Kafka broker on $affected_node"
  # Make the API call and store the response in a variable
  echo "Sending Kafka stop command request"
  response=$(curl -u ${aUid}:${aPwd} -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Stopping Kafka broker"'"}, "Body":{"ServiceComponentInfo":{"state":"INSTALLED"}}}' http://${aHost}:8080/api/v1/clusters/${cluster_name}/services/KAFKA/components/KAFKA_BROKER 2>&1)

  # Extract the id from the response payload
  request_id=$(echo "$response" | grep -o '"id" : [0-9]*' | sed 's/"id" : //')

  # Print the request_id
  echo "Checking status - (Stop Request) with id: $request_id"

  #variable to avoid infinite loop
  iteration=0

  while true; do
    # query the status for stop command
    response=$(curl -u ${aUid}:${aPwd} -i -H 'X-Requested-By: ambari' -X GET http://${aHost}:8080/api/v1/clusters/${cluster_name}/requests/$request_id)

    #extracts the value of the request_status field from response payload and assigns it to the variable $status
    status=$(echo "$response" | grep -o '"request_status" : "[^"]*"' | cut -d'"' -f4)

    echo $status
    if [ "$status" = "COMPLETED" ]; then
      echo "STOP command completed"
      echo "Sending Kafka start command request"
      response=$(curl -u ${aUid}:${aPwd} -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"'"Starting Kafka broker"'"}, "Body":{"ServiceComponentInfo":{"state":"STARTED"}}}' http://${aHost}:8080/api/v1/clusters/${cluster_name}/services/KAFKA/components/KAFKA_BROKER)
      
      # Extract the id from the response payload
      request_id=$(echo "$response" | grep -o '"id" : [0-9]*' | sed 's/"id" : //')
      echo "Checking status - (Start Request) with id: $request_id"
            
      while true; do
        # query the status for start command
        response=$(curl -u ${aUid}:${aPwd} -i -H 'X-Requested-By: ambari' -X GET http://${aHost}:8080/api/v1/clusters/${cluster_name}/requests/$request_id)
        
        #extracts the value of the request_status field from response payload and assigns it to the variable $status
        status=$(echo "$response" | grep -o '"request_status" : "[^"]*"' | cut -d'"' -f4)
        echo $status
	
	sleep 5
	((iteration++))
	
	if ((iteration > 20)); then
	  echo "ERROR - STOP COMMAND DIDN'T WORK AS EXPECTED"
	  exit
	fi
          
        if [ "$status" = "COMPLETED" ]; then
          echo -e "\n- Kafka worker nodes restarted successfully."
          exit
        fi
      done
    fi

    # Increment the iteration variable
    ((iteration++))
  
    # Check if the iteration variable is greater than 50, means that something went wrong during the restart
    if ((iteration > 20)); then
      echo "ERROR - STOP COMMAND DIDN'T WORK AS EXPECTED"
      break
    fi
    sleep 5
  done
done
