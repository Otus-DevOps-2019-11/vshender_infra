variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used for ssh access for provisioning"
}

variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit DB"
  default = "reddit-db-base"
}
