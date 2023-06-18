#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${__dir}/remove-user-input.sh

cd tmkms-config

cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "password" }
EOF

tmkms yubihsm detect

echo ""

cd ..

read -p "Please enter serial: " serial
read -p "Please enter operator key: " operator_key

echo $serial > RESTORE_SERIAL
echo $operator_key > RESTORE_OPERATOR_KEY
