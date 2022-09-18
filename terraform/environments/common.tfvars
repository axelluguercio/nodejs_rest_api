app_name="rest-api"
project_id            = "devops-test-362819"
region                = "us-central1"
zone                  = "us-central1-a"
credentials_file_path = "./terraform-sa-key.json"

primary_ip_cidr          = "192.168.0.0/26" # max node IPs = 15 (max nodes = 11 (2 required); 4 IPs reservered in every VPC)
max_pods_per_node        = "32"             # max pods per node <= half of max node IPs
cluster_ipv4_cidr_block  = "10.0.0.0/18"    # max pod IPs = 15360 (60 * 256), CIDR must be able to cover for all the potential IPs
services_ipv4_cidr_block = "10.1.0.0/20"

channel      = "REGULAR"
auto_upgrade = "true"

gke_cluster_name             = "rest-api"
dataplane_v2_enabled         = "false"
filestore_csi_driver_enabled = "true"

oauth_scopes = [
  "https://www.googleapis.com/auth/cloud-platform",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring",
]

workload_metadata_enabled = "true"

# custom node taints
taint = [
  {
    key    = "node.cilium.io/agent-not-ready"
    value  = "true"
    effect = "NO_SCHEDULE"
  }
]