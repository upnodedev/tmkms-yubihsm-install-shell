#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read -p "This will replace your existing key and backup! Continue (y/n): " confirm_continue

if [ $confirm_continue == "y" ] || [ $confirm_continue == "Y" ]; then
  cp -r $__dir/yubihsm-key/* ./yubihsm-key/* 
  cp -r $__dir/yubihsm-backup/* ./yubihsm-backup/*
else
  exit
fi
