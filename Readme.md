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


## Supported Operating System

Recommended Ubuntu Server 22.04

Supported most linux and Mac OS

## Note for Mac OS

Enable root user as per the instructions in this [Apple Support document](https://support.apple.com/en-us/HT204012). This is done to bypass udev permission config, which is not present on Mac.

Login as root in the terminal and change the directory to home by running the following commands:

```bash
sudo su
cd $HOME
```

For Mac OS, $HOME is likely be `/var/root`

If you have error while installing tmkms, search google on how to install build-essential for your OS

## Setup

1. Ensure that your user has sudo permission and in `yubihsm` group. However, if you don't want to set it up, you can switch user to root by using the following commands

```bash
sudo su
cd $HOME
```

2. Update and upgrade your machine to the latest version

```bash
apt update && apt upgrade -y
```

3. Reboot your PC

```bash
reboot
```

4. Download tmkms-install.sh

```bash
wget https://raw.githubusercontent.com/upnodedev/tmkms-yubihsm-install-shell/main/tmkms-install.sh && chmod +x tmkms-install.sh
```

## How to use

Run `./tmkms-install.sh` command in your terminal to install the necessary software.

```bash
./tmkms-install.sh
```

After setup, check if `tmkms`, `tmkms-config`, `yubihsm-key` and `yubihsm-backup` are populated. If not, it's likely you haven't completed setup correctly.

Note: if you want to import key to YubiHSM, copy your key to a folder and enter its absolute path as key file name

```
Please enter key file name: /root/priv_validator_key.json
```

### Setup YubiHSM

Please follow the instructions detailed below:

1. Launch your terminal and execute the following command: `./tmkms-install.sh`.
2. During the setup process, please select '1' to proceed with YubiHSM setup.
3. You will be prompted to input your serial number and administrative password. If this is your initial setup, you should provide "password" as the required password when asked. If not, please enter your current admin password. 
4. For your initial YubiHSM, we advise generating a new seed (Option 1). Conversely, for a backup YubiHSM, we recommend employing the administrative key from the first YubiHSM for recovery purposes (Option 2).
5. Be aware that this process will completely erase your YubiHSM data and generate a new set of keys. It is crucial that you record these keys for future reference.
6. You will be prompted to input your operator and validator passwords. Please input the operator and validator passwords that were generated earlier.
7. If you import keys on a machine other than the validator signer server, it will be necessary to duplicate the `yubihsm-key` folder to your validator signer server.

In case you have forgot your admin password, you should perform a hardware reset by pressing top of YubiHSM for at least 10 seconds after plug it in. Please see demonstration at https://www.youtube.com/watch?v=EjOXIzaCmcI&ab_channel=J

### Importing Key

Please follow the instructions detailed below:

1. Transfer the `priv_validator_key.json` file to your local computer.
2. Open your terminal and navigate to the directory containing the aforementioned file. Use the `pwd` command to ascertain the current directory path. For instance, if `pwd` outputs `/home/xxx`, the complete path to your file will be `/home/xxx/priv_validator_key.json`.
3. Copy the file path of `priv_validator_key.json`, derived in the previous step, to your clipboard.
4. In your terminal, initiate the command: `./tmkms-install.sh`.
5. As the setup process commences, choose '2' to progress with the Key Management configuration.
6. Subsequently, select '1' to advance with the key importation procedure.
7. Please input numeric values starting from 1 in the Key ID field, such as 1, 2, 3, and so on. Kindly make note of the relation between the Key ID, serial number, and chain ID.
8. Paste the `priv_validator_key.json` file path, which was copied to the clipboard in step 3.
9. Your key will now be imported into your YubiHSM, and an encrypted backup of the key will be stored in the `yubihsm-backup` folder.

### Generating Key

Please follow the instructions detailed below:

1. In your terminal, initiate the command: `./tmkms-install.sh`.
2. As the setup process commences, choose '2' to progress with the Key Management configuration.
3. Subsequently, select '2' to advance with the key generation procedure.
7. Please input numeric values starting from 1 in the Key ID field, such as 1, 2, 3, and so on. Kindly make note of the relation between the Key ID, serial number, and chain ID.
8. Paste the `priv_validator_key.json` file path, which was copied to the clipboard in step 3.
9. Your key will now be imported into your YubiHSM, and an encrypted backup of the key will be stored in the `yubihsm-backup` folder.

### Installing or Upgrading TMKMS

Follow these steps to install or upgrade TMKMS:

1. Run the TMKMS YubiHSM Installation Tool.
2. When prompted with the question "What do you want to do?", enter `3` to select "Install / Upgrade TMKMS".
3. When prompted for the Chain ID, enter your desired Chain ID. For example, `blockspacerace-0`.
4. When prompted for the Chain Alias, leave blank if this is the only validator in the chain. Otherwise, enter any name you want to label this particular validator.
5. Wait for the process to complete. It will install TMKMS, create a user and group with the name of your Chain ID, and generate the necessary configuration.

You need to do this only once per validator per chain. Except there is critical patch upgrade.

Next time, you want to update your TMKMS configuration, just use option 4 to update your TMKMS configuration.

Next, it will automatically enter the configuration flow described in the next section (Skip 1, 2, 3, 4)

### Updating TMKMS Configuration

Follow these steps to update your TMKMS configuration:

1. Run the TMKMS YubiHSM Installation Tool.
2. When prompted with the question "What do you want to do?", enter `4` to select "Update TMKMS config".
3. When prompted for the Chain ID, enter your desired Chain ID. For example, `blockspacerace-0`.
4. When prompted for the Chain Alias, leave blank if this is the only validator in the chain. Otherwise, enter any name you want to label this particular validator.
5. When prompted for the serial, enter the serial number of your YubiHSM device.
6. When prompted for the key ID, enter your key ID. For example, `2`.
7. When prompted for the address prefix, enter your address prefix. For example, `celestia`.
8. When prompted for the validator endpoint, enter your validator endpoint, which is priv_validator_laddr in the validator daemon config. For example, `tcp://127.0.0.1:26659`.
9. Please note that after the installation or configuration, you need to manually start the TMKMS service.

### Restarting or Stopping TMKMS

Follow these steps to restart or stop TMKMS:

1. Run the TMKMS YubiHSM Installation Tool.
2. When prompted with the question "What do you want to do?", enter `5` to select "Restart / Stop TMKMS".
3. When prompted for the Chain ID, enter the same Chain ID you used during installation. For example, `blockspacerace-0`.
4. You'll now have the options to either "Restart TMKMS" or "Stop TMKMS". To restart, enter `1`.
5. The system will create a symlink for the TMKMS service and restart it.

Please refer to this manual whenever you need to install, configure, or manage TMKMS using the TMKMS YubiHSM Installation Tool by Upnode.

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

What you want to do?
1. Import Key
2. Generate Key
3. List Key
Enter the number of your choice: 2

Please enter key ID: 1
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

What you want to do?
1. Import Key
2. Generate Key
3. List Key
Enter the number of your choice: 1

Please enter key ID: 2
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
