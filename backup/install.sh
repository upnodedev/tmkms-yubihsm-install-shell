#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
username=$1

backup_serial=$(cat $__dir/BACKUP_SERIAL)
serial=$(cat $HOME/RESTORE_SERIAL)

# Check if user exists
if id "$username" >/dev/null 2>&1; then
  echo "User $username already exists."
else
  if command -v useradd &> /dev/null; then
    # Create user and add to group
    sudo useradd -m -s /bin/bash -G "$group_name" "$username"
    echo "User $username created and added to group $group_name."
  else
    echo "ERROR: Cannot create user automatically, please manually create user $username"
  fi
fi

# Install TMKMS and copy the config folder
if sudo -u "$username" test -f "/home/$username/tmkms-config/tmkms.toml"; then
  echo "User $username has already configured! Skipping..."
else
  echo "Installing TMKMS for user $username..."

  # Install cargo for the user
  sudo -u "$username" sh -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'

  # Install tmkms for the user
  sudo -u "$username" sh -c "rm -rf /home/$username/tmkms"
  sudo -u "$username" sh -c "git clone https://github.com/iqlusioninc/tmkms.git /home/$username/tmkms"
  sudo -u "$username" sh -c "cd /home/$username/tmkms && /home/$username/.cargo/bin/cargo build --release --features=yubihsm"
  sudo -u "$username" sh -c "cd /home/$username/tmkms && /home/$username/.cargo/bin/cargo install tmkms --features=yubihsm"

  # Copy TMKMS to the home folder
  sudo cp -r ${__dir}/tmkms-config/$username /home/$username/tmkms-config
  sudo chown -R $username:$username -- /home/$username/tmkms-config

  # Replace serial
  sudo sed -i "s/$backup_serial/$serial/g" "/home/$username/tmkms-config/tmkms.toml"

  cd

  # Setup systemd script
  sudo sh -c "cat > /etc/systemd/system/$username.service" <<-EOF
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

  sudo systemctl daemon-reload
fi