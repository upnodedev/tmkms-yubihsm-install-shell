#!/bin/bash

echo "TMKMS YubiHSM Installtion Tool by Upnode"

file_path="$HOME/tmkms-config/tmkms.toml"
group_name="yubihsm"

if [ ! -f "$file_path" ]; then
  if command -v apt-get &> /dev/null then
    # Install build-essential
    sudo apt-get update
    sudo apt-get install -y build-essential
  fi

  # Install cargo
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env

  # Install tmkms
  rm -rf tmkms
  git clone https://github.com/iqlusioninc/tmkms.git
  cd tmkms
  cargo build --release --features=yubihsm
  cargo install tmkms --features=yubihsm
  cd ..

  if [ -d "/etc/udev" ]; then
    # Setup USB allowance for group yubihsm
    sudo cat << EOF > /etc/udev/rules.d/10-yubihsm.rules
SUBSYSTEMS=="usb", ATTRS{product}=="YubiHSM", GROUP="yubihsm"
EOF

    sudo udevadm control --reload-rules && udevadm trigger
  fi

  # Init tmkms
  tmkms init $HOME/tmkms-config

  # Setup key folder
  mkdir -p yubihsm-key
  mkdir -p yubihsm-backup
fi

echo ""

echo "What you want to do?"
echo "1. Setup YubiHSM"
echo "2. Key Management"
echo "3. Install / Upgrade TMKMS"
echo "4. Update TMKMS config"
echo "5. Restart / Stop TMKMS"

read -p "Enter the number of your choice: " action_id

if [ $action_id -eq 1 ]; then
  read -p "This will erase all keys on your YubiHSM2! Continue? (y/n): " confirm_continue

  if [ $confirm_continue == "y" ] || [ $confirm_continue == "Y" ]; then
    cd tmkms-config

    cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "password" }
EOF

    tmkms yubihsm detect

    echo ""

    read -p "Please enter serial: " serial
    read -p "Please enter admin password (Default: password): " yubihsm_password
    yubihsm_password=${yubihsm_password:-password}
    read -p "Generate new seed (1) or recover (2): (1/2) " new_mode

    cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "$yubihsm_password" }
serial_number = "$serial"
EOF

    if [ $new_mode -eq 1 ]; then
      tmkms yubihsm setup
    elif [ $new_mode -eq 2 ]; then
      tmkms yubihsm setup -r
    else
      echo "Please enter only 1 or 2"
      exit
    fi

    echo ""
    echo "Please enter the following keys shown above"
    read -p "authkey 0x0002 [operator]: " operator_key
    read -p "authkey 0x0004 [validator]: " validator_key

    echo $operator_key > $HOME/yubihsm-key/operator-$serial
    echo $validator_key > $HOME/yubihsm-key/validator-$serial

    echo ""
    echo "Please take note of other keys in a safe place"

    cd ..
  fi
fi

if [ $action_id -eq 2 ]; then
  cd tmkms-config

  cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "password" }
EOF

  tmkms yubihsm detect

  echo ""

  read -p "Please enter serial: " serial
  yubihsm_password=$(cat $HOME/yubihsm-key/operator-$serial)

  cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 2, password = "$yubihsm_password" }
serial_number = "$serial"
EOF

  echo ""
  echo "What you want to do?"
  echo "1. Import Key"
  echo "2. Generate Key"
  echo "3. List Key"
  echo "4. Pubkey for create-validator"

  read -p "Enter the number of your choice: " action2_id

  echo ""

  if [ $action2_id -eq 1 ] || [ $action2_id -eq 2 ]; then
    read -p "Please enter key ID: " key_id
  fi

  if [ $action2_id -eq 1 ]; then
    read -p "Please enter key file name: " key_file_name

    tmkms yubihsm keys import -t json -i $key_id $key_file_name
    tmkms yubihsm keys export --id $key_id $HOME/yubihsm-backup/$serial-$key_id.enc
  elif [ $action2_id -eq 2 ]; then
    read -p "Please enter address prefix (Ex: cosmos): " prefix
    valconspub="${prefix}valconspub"

    tmkms yubihsm keys generate $key_id -p $valconspub -b $HOME/yubihsm-backup/$serial-$key_id.enc
  elif [ $action2_id -eq 3 ] || [ $action2_id -eq 4 ]; then
    tmkms yubihsm keys list
  fi

  if [ $action2_id -eq 4 ]; then
    echo ""
    echo "Please enter the string following [cons] for the corresponding key"
    read -p "Key: " hex_string

    decoded_string=$(echo -n $hex_string | xxd -r -p)
    base64_encoded_string=$(echo -n $decoded_string | base64)

    echo ""
    echo '{"@type":"/cosmos.crypto.ed25519.PubKey","key":"'$base64_encoded_string'"}'
    echo ""
  fi
fi

if [ $action_id -eq 3 ] || [ $action_id -eq 4 ] || [ $action_id -eq 5 ]; then
  # Prompt for chain id
  read -p "Enter Chain ID: " chain_id

  # Create username based on chain ID
  username="tmkms-$chain_id"

  # Check if user exists
  if id "$username" >/dev/null 2>&1; then
    echo "User $username already exists."
  else
    # Create user and add to group
    sudo useradd -m -s /bin/bash -G "$group_name" "$username"
    echo "User $username created and added to group $group_name."
  fi
fi

if [ $action_id -eq 3 ]; then
  cd /home/$username

  # Install cargo for the user
  sudo -u "$username" sh -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'

  # Install tmkms for the user
  sudo -u "$username" sh -c 'rm -rf tmkms'
  sudo -u "$username" sh -c 'git clone https://github.com/iqlusioninc/tmkms.git'
  sudo -u "$username" sh -c "cd tmkms && /home/$username/.cargo/bin/cargo build --release --features=yubihsm"
  sudo -u "$username" sh -c "cd tmkms && /home/$username/.cargo/bin/cargo install tmkms --features=yubihsm"

  # Init tmkms
  sudo -u "$username" sh -c "/home/$username/.cargo/bin/tmkms init tmkms-config"

  cd

  # Setup systemd script
  cat << EOF > /etc/systemd/system/$username.service
[Unit]
Description=$username
After=multi-user.target

[Service]
Type=simple
Restart=always
User=$username
ExecStart=/home/$username/.cargo/bin/tmkms start -c /home/$username/tmkms-config/tmkms.toml

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
fi

if [ $action_id -eq 3 ] || [ $action_id -eq 4 ]; then
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
  read -p "Please enter key ID: " key_id
  read -p "Please enter address prefix (Ex: cosmos): " prefix
  read -p "Please enter validator endpoint (Ex: tcp://127.0.0.1:26659): " validator_endpoint
  yubihsm_password=$(cat $HOME/yubihsm-key/validator-$serial)

  systemctl stop $username

  cat << EOF > /home/$username/tmkms-config/tmkms.toml
# Tendermint KMS configuration file

## Chain Configuration

### Cosmos Hub Network

[[chain]]
id = "$chain_id"
key_format = { type = "bech32", account_key_prefix = "${prefix}pub", consensus_key_prefix = "${prefix}valconspub" }
state_file = "/home/$username/tmkms-config/state/$chain_id-consensus.json"

## Signing Provider Configuration

### YubiHSM2 Provider Configuration

[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 4, password = "$yubihsm_password" }
serial_number = "$serial"
keys = [
    { key = $key_id, type = "consensus", chain_ids = ["$chain_id"] },
]

## Validator Configuration

[[validator]]
chain_id = "$chain_id"
addr = "$validator_endpoint"
secret_key = "/home/$username/tmkms-config/secrets/kms-identity.key"
protocol_version = "v0.34"
reconnect = true
EOF

  chown $username:$username /home/$username/tmkms-config/tmkms.toml

  echo ""
  echo "!! You need to start tmkms again manually by running this script again to prevent unexpected situation."
fi

if [ $action_id -eq 5 ]; then
  echo ""
  echo "What you want to do?"
  echo "1. Restart TMKMS"
  echo "2. Stop TMKMS"

  read -p "Enter the number of your choice: " action2_id

  echo ""

  systemctl daemon-reload

  if [ $action2_id -eq 1 ]; then
    systemctl restart $username
    systemctl enable $username
  elif [ $action2_id -eq 2 ]; then
    systemctl stop $username
    systemctl disable $username
  fi
fi

cd
