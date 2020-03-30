terraform {
  # Terraform version
  required_version = "~>0.12.19"
}

provider "google" {
  # Provider version
  version = "2.15"

  # Project ID
  project = var.project

  region = var.region
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  zone             = var.zone
  app_disk_image   = var.app_disk_image
  db_ip            = module.db.db_ip
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  zone             = var.zone
  db_disk_image    = var.db_disk_image
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["178.122.113.195/32", "178.120.7.186/32"]
}
