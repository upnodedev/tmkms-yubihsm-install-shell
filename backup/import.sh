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

if [ ! -f "$__dir/yubihsm-backup/$backup_serial-$1.enc" -a -f "$HOME/yubihsm-backup/$backup_serial-$1.enc" ]; then
  cp $HOME/yubihsm-backup/$backup_serial-$1.enc $__dir/yubihsm-backup/$backup_serial-$1.enc
fi

if [ -f "$__dir/yubihsm-backup/$backup_serial-$1.enc" ]; then
  backup_file=$__dir/yubihsm-backup/$backup_serial-$1.enc
  length=$(wc -c < $backup_file)
  if [ "$length" -ne 0 ] && [ -z "$(tail -c -1 < $backup_file)" ]; then
    # The file ends with a newline or null
    dd if=/dev/null of=$backup_file obs="$((length-1))" seek=1
  fi

  tmkms yubihsm keys import "$backup_file" || true
  tmkms yubihsm keys export --id $1 $HOME/yubihsm-backup/$serial-$1.enc || true

  echo $(cat $__dir/yubihsm-backup/$backup_serial-$1.enc) > $HOME/yubihsm-backup/$serial-$1.enc
else
  echo "Key not found for ID $1"

  read -p "Please enter path to your priv_validator_key.json for key ID $1: " key_file_name

  if [ ! -z "${key_file_name}" ]; then
    tmkms yubihsm keys import -t json -i $1 $key_file_name || true
    rm -f $HOME/yubihsm-backup/$serial-$1.enc
    tmkms yubihsm keys export --id $1 $HOME/yubihsm-backup/$serial-$1.enc || true
  else
    echo "Skipping..."
  fi
fi

cd
