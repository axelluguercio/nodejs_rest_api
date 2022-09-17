terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.29.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-sa-key.json") # terraform sa json key
  project = var.project_id
  region  = var.region
  zone    = var.zone
}