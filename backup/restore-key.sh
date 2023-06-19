#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read -p "Restoring may interupt working instance! Continue (y/n): " confirm_continue

if [ $confirm_continue == "y" ] || [ $confirm_continue == "Y" ]; then
  cp -r -n $__dir/yubihsm-key/* ./yubihsm-key/* 
  cp -r -n $__dir/yubihsm-backup/* ./yubihsm-backup/*
else
  exit
fi
