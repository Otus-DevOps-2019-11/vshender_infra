terraform {
  # Terraform version
  required_version = "~>0.12.0"
}

provider "google" {
  # Provider version
  version = "2.15"

  # Project ID
  project = var.project

  region = var.region
}
