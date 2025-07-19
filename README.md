# 🔐 LUKS2-Nuke: Auto-Wipe After 5 Failed Attempts 

![License](https://img.shields.io/badge/license-MIT-green) 
![Last Commit](https://img.shields.io/github/last-commit/your-username/LUKS2-nuke) 

## Overview 

**LUKS2-Nuke** is a security-focused enhancement for systems using LUKS2 disk encryption. This script automatically **modifies sensitive data** and **securely wipes the encrypted partition** after **five consecutive failed decryption attempts**, offering an extra layer of protection in case of brute-force attacks or unauthorized access attempts. 

> ⚠️ **Warning**: There is no way to recover your data after 5 incorrect password attempts. Use with extreme caution. **No backups. No recovery.** 

--- 

## 🧠 Features 

- 🚫 **Auto-nuke** on 5 failed decryption attempts 
- 🔄 **Data modification** prior to destruction 
- 🔐 **Enhanced LUKS2 Security** using cryptsetup hooks 
- 🧹 **Secure wipe** using `shred` or `dd` 
- 🛡️ **Tamper-proof mechanism** for privacy-critical devices 

--- 

## 📦 Requirements 

- Linux (Debian, Arch, Fedora, etc.) 
- LUKS2 encryption enabled 
- `cryptsetup` 2.1+  
- Root privileges 

--- 

## ⚙️ How It Works 

1. Monitors incorrect decryption attempts at boot. 
2. After **5 failed attempts**, triggers a custom `cryptsetup` hook. 
3. The hook executes a secure wipe of the LUKS2 partition. 
4. The system is rendered unrecoverable with **zero chance of data recovery**. 

--- 

## 🚀 Installation 

> **Note**: This modifies boot and initramfs behavior. Proceed only if you're experienced with Linux boot internals. 


```bash 
git clone https://github.com/Pushpenderrathore/LUKS2-nuke.git 
cd LUKS2-nuke 
sudo ./install.sh 
