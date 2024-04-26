#!/bin/bash
export PDS_HOSTNAME="pds.jaronoff.com"
export PDS_ADMIN_EMAIL="me@jaronoff.com"
sudo export PDS_HOSTNAME="pds.jaronoff.com"
sudo export PDS_ADMIN_EMAIL="me@jaronoff.com"
wget https://raw.githubusercontent.com/bluesky-social/pds/main/installer.sh
sudo bash installer.sh /pds $PDS_HOSTNAME $PDS_ADMIN_EMAIL
