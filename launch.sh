#!/bin/bash
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /pds
sudo mount /dev/nvme1n1 /pds
export PDS_HOSTNAME="${pds_hostname}"
export PDS_ADMIN_EMAIL="${pds_admin_email}"
wget https://raw.githubusercontent.com/bluesky-social/pds/main/installer.sh
sudo env PDS_HOSTNAME="${pds_hostname}" PDS_ADMIN_EMAIL="${pds_admin_email}" bash installer.sh /pds $PDS_HOSTNAME $PDS_ADMIN_EMAIL
