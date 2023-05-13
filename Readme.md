# TMKMS YubiHSM Installer Interactive Shell by Upnode

Install TMKMS with YubiHSM 2.0 in the easiest way exists on the earth by using our interactive shell

If you are looking for a solution to run multiple TMKMS in a single machine or using multiple YubiHSM in a single machine, here is your answer.

![Upnode](https://user-images.githubusercontent.com/4103490/238152858-a22f38ef-e8e5-4f82-8e3e-abf528cb3812.png)

https://upnode.org

[Stake with Upnode or let Upnode validate your chain](https://upnode.org)

## Features

1. Setup YubiHSM
2. Key Management
    1. Import Key (priv_validator_key.json)
    2. Generate Key
    3. List Key
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS

Support multiple TMKMS and YubiHSM in a single machine

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

3. Reboot your PC

```
reboot
```

4. Download tmkms-install.sh

```
wget https://raw.githubusercontent.com/upnodedev/tmkms-yubihsm-install-shell/main/tmkms-install.sh && chmod +x tmkms-install.sh
```

## How to use

Run `./tmkms-install.sh` and follow its instruction

```
./tmkms-install.sh
```

Note: if you want to import key to YubiHSM, copy your key to a folder and enter its absolute path as key file name

```
Please enter key file name: /root/priv_validator_key.json
```

