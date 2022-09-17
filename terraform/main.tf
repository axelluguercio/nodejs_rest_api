# bucket to store backend service for terraform
terraform {
  backend "gcs" {
    bucket = "devops-test-rest-api-terraform"
    prefix = "/state/devops-test"
  }
}