#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${__dir}/initial-setup.sh
source ${__dir}/user-input.sh

# Import keys
source ${__dir}/import.sh 1
source ${__dir}/import.sh 2

# Install TMKMS
source ${__dir}/install.sh tmkms-blockspacerace-0
source ${__dir}/install.sh tmkms-mocha

source ${__dir}/remove-user-input.sh
