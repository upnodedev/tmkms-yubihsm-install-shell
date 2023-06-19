#!/bin/bash

file_path="$HOME/tmkms-config/tmkms.toml"
group_name="yubihsm"

if [ ! -f "tmkms-install.sh" ]; then
  wget https://raw.githubusercontent.com/upnodedev/tmkms-yubihsm-install-shell/main/tmkms-install.sh
  chmod +x tmkms-install.sh
fi

if [ ! -f "$file_path" ]; then
  echo "Setting up initial TMKMS"

  if command -v usermod &> /dev/null; then
    sudo usermod -a -G yubihsm $(whoami)
  fi

  if command -v apt-get &> /dev/null; then
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

  echo "====================================================="
  echo "NOTE: If you aren't using root, you may need to restart your shell session or your machine before proceed"
  echo "====================================================="
  echo

  exit
fi