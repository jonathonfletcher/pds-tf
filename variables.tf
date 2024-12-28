variable "region" {
  default = "us-east-1"
}

variable "az" {
  default = "us-east-1a"
}

variable "ssh_key_name" {
  default = ""
}

variable "public_key" {
  default = ""
}

variable "pds_hostname" {
  default = ""
}

variable "pds_admin_email" {
  default = ""
}

variable "ebs_volume_type" {
    default = "gp2"
}

variable "ebs_volume_size" {
    default = "30"
}
