variable "region" {
  default = "us-west-2"
}

variable "az" {
  default = "us-west-2a"
}

variable "ssh_key_name" {
  default = "pds"
}

variable "public_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPigY9mOhxDODxqLqrq67VYBM5sxp2Cwpmk2300rQ8Rw jonathon@jf.chophaus.lan"
}

variable "pds_hostname" {
  default = "pds.jonfle.net"
}

variable "pds_admin_email" {
  default = "me@jonfle.net"
}

variable "ebs_volume_type" {
    default = "gp2"
}

variable "ebs_volume_size" {
    default = "30"
}
