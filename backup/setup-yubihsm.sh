read -p "Do you want to reinitialize your YubiHSM2 (Do only once for each device)? (y/n): " confirm_setup

if [ $confirm_setup == "y" ] || [ $confirm_setup == "Y" ]; then
  read -p "This will erase all keys on your YubiHSM2! Continue? (y/n): " confirm_continue

  if [ $confirm_continue == "y" ] || [ $confirm_continue == "Y" ]; then
    cd tmkms-config

    read -p "Please enter old admin password (Default: password): " yubihsm_password
    yubihsm_password=${yubihsm_password:-password}

    cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "$yubihsm_password" }
EOF

    tmkms yubihsm detect

    echo ""

    read -p "Please enter serial: " serial

    cat << EOF > tmkms.toml
[[providers.yubihsm]]
adapter = { type = "usb" }
auth = { key = 1, password = "$yubihsm_password" }
serial_number = "$serial"
EOF

    echo "Please enter new admin password"
    tmkms yubihsm setup -r

    cd ..
  fi
fi