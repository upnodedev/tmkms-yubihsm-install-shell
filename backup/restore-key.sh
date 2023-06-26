#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -r -n $__dir/yubihsm-key $HOME/yubihsm-key
cp -r -n $__dir/yubihsm-backup $HOME/yubihsm-backup

