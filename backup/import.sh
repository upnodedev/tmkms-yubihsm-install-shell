#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd tmkms-config

backup_serial=$(cat $__dir/BACKUP_SERIAL)
serial=$(cat $HOME/RESTORE_SERIAL)
yubihsm_password=$(cat $HOME/RESTORE_OPERATOR_KEY)

cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 2, password = "$yubihsm_password" }
serial_number = "$serial"
EOF

if [ -f "$__dir/yubihsm-backup/$backup_serial-$0.enc" ]; then
  tmkms yubihsm keys import "$__dir/yubihsm-backup/$backup_serial-$0.enc" || true

  echo $(cat $__dir/yubihsm-backup/$backup_serial-$0.enc) > $HOME/yubihsm-backup/$serial-$0.enc
else
  echo "Key not found for ID $1 Skipping..."
fi

cd
