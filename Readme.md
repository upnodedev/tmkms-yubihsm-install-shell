# TMKMS YubiHSM Installer Interactive Shell by Upnode

Install TMKMS with YubiHSM 2.0 in the easiest way exists on the earth by using our interactive shell

## Features

1. Setup YubiHSM
2. Key Management
    1. Import Key (priv_validator_key.json)
    2. Generate Key
    3. List Key
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS

## Setup

1. Change user to root and change home to /root

```
sudo su
cd
```

2. Update and upgrade your machine to the latest version

```
apt update && apt upgrade -y
```

3. Download tmkms-install.sh

```
wget ... && chmod +x tmkms-install.sh
```

## How to use

Run `./tmkms-install.sh` and follow its instruction

```
./tmkms-install.sh
```


