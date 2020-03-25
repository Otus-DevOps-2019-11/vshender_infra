terraform {
  required_version = "~>0.12.0"
  backend "gcs" {
    bucket = "infra-265618-tf-state-bucket"
    prefix = "terraform/prod/state"
  }
}
