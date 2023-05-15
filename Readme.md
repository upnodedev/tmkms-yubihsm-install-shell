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

Run `./tmkms-install.sh` and follow its instruction (IMPORTANT: Must be run as root)

```
./tmkms-install.sh
```

Note: if you want to import key to YubiHSM, copy your key to a folder and enter its absolute path as key file name

```
Please enter key file name: /root/priv_validator_key.json
```

## Interactive shell example

### Setup YubiHSM

```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 1
This will erase all keys on your YubiHSM2! Continue? (y/n): y
Detected YubiHSM2 USB devices:
- Serial #0020788888 (bus 1)

Please enter serial: 0020788888
Please enter admin password (Default: password): xxx xxx xxx xxx xxx faculty umbrella can skull hold kind sibling bar predict solution caution fun they nasty xxx xxx xxx xxx xxx
Generate new seed (1) or recover (2): (1/2) 1
This process will *ERASE* the configured YubiHSM2 and reinitialize it:

- YubiHSM serial: 0020788888

Authentication keys with the following IDs and passwords will be created:

- key 0x0001: admin:

    xxx xxx xxx xxx xxx plate photo flat hope skin draw dragon
    holiday seek quarter correct surge panda kick xxx xxx xxx xxx xxx

- authkey 0x0002 [operator]:  kms-operator-password-18xxxxxxxxxxxzfa6gvw3zv2p4vz6chu0
- authkey 0x0003 [auditor]:   kms-auditor-password-1rxxxxxxxxxxxsrwdw5t83kjw557gjys0
- authkey 0x0004 [validator]: kms-validator-password-1qxxxxxxxxxxx5xk3kjp0n0xu7svucceu
- wrapkey 0x0001 [primary]:   a2xxxxxxxxxxx0cf74a2ab2455589fe802950d3f42579bc1b08e4bd817b92af4

*** Are you SURE you want erase and reinitialize this HSM? (y/N): y
2023-05-13T19:48:48.235342 WARN yubihsm::client factory resetting HSM device! all data will be lost!    
2023-05-13T19:48:49.351670 INFO yubihsm::client waiting for device reset to complete    
2023-05-13T19:48:50.982417 INFO yubihsm::setup installed temporary setup authentication key into slot 65534    
2023-05-13T19:48:51.003133 WARN yubihsm::setup deleting default authentication key from slot 1    
2023-05-13T19:48:51.030249 INFO yubihsm::setup::profile installing role: admin:2023-05-13T19:48:27Z    
2023-05-13T19:48:51.054618 INFO yubihsm::setup::profile installing role: operator:2023-05-13T19:48:27Z    
2023-05-13T19:48:51.075213 INFO yubihsm::setup::profile installing role: auditor:2023-05-13T19:48:27Z    
2023-05-13T19:48:51.095774 INFO yubihsm::setup::profile installing role: validator:2023-05-13T19:48:27Z    
2023-05-13T19:48:51.116364 INFO yubihsm::setup::profile installing wrap key: primary:2023-05-13T19:48:27Z    
2023-05-13T19:48:51.139654 INFO yubihsm::setup::profile storing provisioning report in opaque object 0xfffe    
2023-05-13T19:48:51.165233 WARN yubihsm::setup deleting temporary setup authentication key from slot 65534    
Success reinitialized YubiHSM (serial: 0020788888)

Please enter the following keys shown above
authkey 0x0002 [operator]: kms-operator-password-18xxxxxxxxxxxzfa6gvw3zv2p4vz6chu0
authkey 0x0004 [validator]: kms-validator-password-1qxxxxxxxxxxx5xk3kjp0n0xu7svucceu

Please take note of other keys in a safe place
```

### Key Management

```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 2
Detected YubiHSM2 USB devices:
- Serial #0020788888 (bus 1)

Please enter serial: 0020788888
Please enter key ID: 1

What you want to do?
1. Import Key
2. Generate Key
3. List Key
Enter the number of your choice: 2

Please enter address prefix (Ex: cosmos): evmos
Generated consensus (ed25519) key 0x0001: evmosvalconspub1zcjduepqwp7ds5j07qzgyxluwlvsnzn3ymn8gx35utz0leqm7ww896pf22fq2lshyc
Wrote backup of key 1 (encrypted under wrap key 1) to /root/yubihsm-backup/0020788888-1.enc
```

```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 2
Detected YubiHSM2 USB devices:
- Serial #0020788888 (bus 1)

Please enter serial: 0020788888
Please enter key ID: 2

What you want to do?
1. Import Key
2. Generate Key
3. List Key
Enter the number of your choice: 1

Please enter key file name: /root/priv_validator_key.json
Imported key 0x0002
Exported key 0x0002 (encrypted under wrap key 0x0001) to /root/yubihsm-backup/0020788888-2.enc
```

```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 2
Detected YubiHSM2 USB devices:
- Serial #0020788888 (bus 1)

Please enter serial: 0020788888
Please enter key ID: 2

What you want to do?
1. Import Key
2. Generate Key
3. List Key
Enter the number of your choice: 3

Listing keys in YubiHSM #0020788888:
0x0001: [cons] 707CD8524FF004821BFC77D9098A7126E6741A34E2C4FFE41BF39C72E8295292
   label: "evmosvalconspub:2023-05-13T19:53:09Z"
0x0002: [cons] BBBBBBB2060987245074D99BB87AC0FF244EF5DDCDB2BD1C80672BBBBBBBBBBB
   label: ""
```

### Install and config TMKMS
```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 3
Enter Chain ID: blockspacerace-0
User tmkms-blockspacerace-0 created and added to group yubihsm.

<Installation log>
...
Installing /home/tmkms-blockspacerace-0/.cargo/bin/tmkms
Installed package `tmkms v0.12.2` (executable `tmkms`)
Creating tmkms-config
Generated KMS configuration: /home/tmkms-blockspacerace-0/tmkms-config/tmkms.toml
Generated Secret Connection key: /home/tmkms-blockspacerace-0/tmkms-config/secrets/kms-identity.key
Detected YubiHSM2 USB devices:
- Serial #0020788888 (bus 1)

Please enter serial: 0020788888
Please enter key ID: 2
Please enter address prefix (Ex: cosmos): celestia
Please enter validator endpoint (Ex: tcp://127.0.0.1:26659): tcp://127.0.0.1:26659

!! You need to start tmkms again manually by running this script again to prevent unexpected situation.
```

### Start TMKMS service
```bash
TMKMS YubiHSM Installtion Tool by Upnode

What you want to do?
1. Setup YubiHSM
2. Key Management
3. Install / Upgrade TMKMS
4. Update TMKMS config
5. Restart / Stop TMKMS
Enter the number of your choice: 5
Enter Chain ID: blockspacerace-0
User tmkms-blockspacerace-0 already exists.

What you want to do?
1. Restart TMKMS
2. Stop TMKMS
Enter the number of your choice: 1

Created symlink /etc/systemd/system/multi-user.target.wants/tmkms-blockspacerace-0.service → /etc/systemd/system/tmkms-blockspacerace-0.service.
```
