#!/bin/bash

username=$0

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