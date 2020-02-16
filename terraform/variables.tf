variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Default value
  default = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable instance_count {
  description = "Number of app instances to create"
  type        = number
  default     = 1
}

variable users {
  description = "Users to create on the instances"
  type        = list(string)
  default     = ["appuser"]
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access for provisioning"
}

variable disk_image {
  description = "Disk image"
}
