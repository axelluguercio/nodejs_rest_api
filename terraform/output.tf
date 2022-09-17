output "enable_workload_identity_on_node_pool" {
  value = var.workload_metadata_enabled ? "N/A - Workload Identity already enabled" : "gcloud container node-pools update ${var.gke_nodepool_name} --cluster ${var.gke_cluster_name} --workload-metadata=GKE_METADATA --zone ${var.zone} --project ${var.project_id}"
}

output "workload_identity_service_account" {
  value = google_service_account.wi_gsa.email
}