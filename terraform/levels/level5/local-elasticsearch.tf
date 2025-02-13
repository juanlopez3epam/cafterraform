locals {

  elasticsearch_security_roles = {
    sample_application_role = {
        name    = "sample_application_role"
        cluster = ["monitor"]
        indices = {
        all_sample_access = {
            names = [
            "notification_threads",
            "accounts",
            "account_groups",
            "applications",
            "app_inventory",
            "certificates",
            "contents",
            "devices",
            "reviews",
            "unmanaged_tunnels",
            "dep_devices",
            "device_snapshots",
            "device_snapshots-*",
            "device_snapshots_*",
            "audit_trails",
            "audit_trails-*",
            "audit_trails_*",
            "device_logs",
            "device_logs-*",
            "device_logs_*",
            "policies",
            "device_app_feedbacks",
            "scripts",
            "user_provided_certificate_store",
            "device_installed_apps",
            "device_installed_apps-*",
            "device_installed_apps_*",
            "installed_apps",
            "installed_apps-*",
            "installed_apps_*",
            "predicates",
            "predicates-*",
            "predicates_*",
            "windows_updates",
            "windows_updates-*",
            "windows_updates_*"
            ]
            privileges = ["all"]
        }
        }
    }
    }

    elasticsearch_security_users = {
    sample_application_user = {
        username     = "sample_application_user"
        password_key = "elasticsearch_sample_application_user_password"
        roles        = ["sample_application_role"]
    }
    }

}