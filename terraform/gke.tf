resource "google_container_cluster" "primary" {

  name     = "${var.gke_cluster_name}-${terraform.workspace}-cluster"
  location = var.zone

  node_locations = var.node_locations

  confidential_nodes {
      enabled = var.confidential_nodes_enabled
  }
  node_config {
    machine_type = var.machine_type
  }

  enable_shielded_nodes = var.enable_shielded_nodes
  enable_tpu            = var.enable_tpu

  network    = google_compute_network.k8s_vpc.id
  subnetwork = google_compute_subnetwork.k8s_subnet.id

  # ip_allocation_policy left empty here to let GCP pick
  # otherwise you will have to define your own secondary CIDR ranges
  # which I will probably look to add at a later date
  networking_mode = var.networking_mode
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  default_max_pods_per_node = var.max_pods_per_node

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master_authorized_network_cidr
      display_name = "allowed-cidr"
    }
  }

  network_policy {
    enabled = "false"
  }

  datapath_provider = var.dataplane_v2_enabled ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  release_channel {
    channel = var.channel
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  binary_authorization {
    evaluation_mode = var.binary_auth_enabled ? "PROJECT_SINGLETON_POLICY_ENFORCE" : "DISABLED"
  }

  addons_config {
    gcp_filestore_csi_driver_config {
      enabled = var.filestore_csi_driver_enabled
    }

    horizontal_pod_autoscaling {
      disabled = var.horizontal_pod_autoscaling_disabled
    }

    http_load_balancing {
      disabled = var.http_lb_disabled
    }
  }
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = var.gke_nodepool_name
  location = var.regional ? var.region : var.zone
  cluster  = google_container_cluster.primary.name

  initial_node_count = var.initial_node_count
  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    image_type   = var.image_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    service_account = google_service_account.gke_sa.email
    oauth_scopes    = var.oauth_scopes

    dynamic "taint" {
      for_each = var.taint
      content {
        key    = taint.value["key"]
        value  = taint.value["value"]
        effect = taint.value["effect"]
      }
    }

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#mode
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#option_2_node_pool_modification
    workload_metadata_config {
      mode = var.workload_metadata_enabled ? "GKE_METADATA" : "GCE_METADATA"
    }

  }
}