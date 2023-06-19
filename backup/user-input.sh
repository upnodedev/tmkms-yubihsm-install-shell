#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_serial=$(cat $__dir/BACKUP_SERIAL)

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

echo $(cat $__dir/yubihsm-key/validator-$backup_serial) > $HOME/yubihsm-key/validator-$serial

if [ -f "$__dir/yubihsm-key/operator-$backup_serial" ]; then
  operator_key=`cat $__dir/yubihsm-key/operator-$backup_serial`
  echo $operator_key > $HOME/yubihsm-key/operator-$serial
else
  read -p "Please enter operator key: " operator_key
fi

echo $serial > $HOME/RESTORE_SERIAL
echo $operator_key > $HOME/RESTORE_OPERATOR_KEY
