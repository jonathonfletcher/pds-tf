#!/bin/bash
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /pds
sudo mount /dev/nvme1n1 /pds
export PDS_HOSTNAME="pds.jaronoff.com"
export PDS_ADMIN_EMAIL="me@jaronoff.com"
sudo export PDS_HOSTNAME="pds.jaronoff.com"
sudo export PDS_ADMIN_EMAIL="me@jaronoff.com"
wget https://raw.githubusercontent.com/bluesky-social/pds/main/installer.sh
sudo bash installer.sh /pds $PDS_HOSTNAME $PDS_ADMIN_EMAIL
