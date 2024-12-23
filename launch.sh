#!/bin/bash
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /pds
sudo mount /dev/nvme1n1 /pds
export PDS_HOSTNAME="${pds_hostname}"
export PDS_ADMIN_EMAIL="${pds_admin_email}"
sudo export PDS_HOSTNAME="${pds_hostname}"
sudo export PDS_ADMIN_EMAIL="${pds_admin_email}"
wget https://raw.githubusercontent.com/bluesky-social/pds/main/installer.sh
sudo bash installer.sh /pds $PDS_HOSTNAME $PDS_ADMIN_EMAIL
