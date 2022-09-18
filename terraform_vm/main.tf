terraform {
  backend "gcs" {
    bucket = "devops-test-362819-terraform"
    prefix = "/state/devops-test"
  }
}