#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${__dir}/initial-setup.sh
source ${__dir}/restore-key.sh
source ${__dir}/setup-yubihsm.sh
source ${__dir}/user-input.sh

# Import keys
read -p "Do you want to import keys? (y/n): " confirm_import_keys

if [ $confirm_import_keys == "y" ] || [ $confirm_import_keys == "Y" ]; then
  source ${__dir}/import.sh 1
  source ${__dir}/import.sh 2
fi

# Install TMKMS
read -p "Do you want to install TMKMS? (y/n): " confirm_install_tmkms

if [ $confirm_install_tmkms == "y" ] || [ $confirm_install_tmkms == "Y" ]; then
  source ${__dir}/install.sh tmkms-blockspacerace-0
  source ${__dir}/install.sh tmkms-mocha
fi

source ${__dir}/remove-user-input.sh
