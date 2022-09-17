terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file_path) # terraform sa json key
  project = var.project_id
  region  = var.region
  zone    = var.zone
}