# 🧹 Linux Disk Full Emergency Cleaner

![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20Debian%20%7C%20CentOS-orange)
![Type](https://img.shields.io/badge/Type-Maintenance-blue)
![Safety](https://img.shields.io/badge/Safety-Non--Destructive-green)

## 🆘 The Problem
Server services (MySQL, Nginx, Docker) stop working when the disk hits **100% Usage**.
> `Error: No space left on device`

Manually finding and deleting files takes time. Deleting the wrong log file (using `rm`) can cause services to crash because the file descriptor is lost.

## 🛠️ The Solution
This repository contains a **Safe Cleaning Script** that frees up space immediately by:
1.  **Truncating Logs:** Empties log files (syslog, nginx) without deleting them (keeping the service connected).
2.  **Vacuuming Journal:** Removes systemd logs older than 2 days.
3.  **Cleaning Cache:** Removes downloaded apt/yum packages.
4.  **Finding Culprits:** Lists the Top 10 largest files consuming space.

## 🚀 Usage Guide

### Step 1: Download & Run
When you are in an emergency, run this one-liner:
```bash
wget [https://raw.githubusercontent.com/devalaminbro/linux-disk-full-emergency-cleaner/main/clean_disk.sh](https://raw.githubusercontent.com/devalaminbro/linux-disk-full-emergency-cleaner/main/clean_disk.sh)
chmod +x clean_disk.sh
sudo ./clean_disk.sh

Step 2: Review
The script will print how much space was recovered. It will also show you the largest files remaining, so you can decide if you want to delete them manually (e.g., old backups).

⚠️ What it Does NOT Delete
It does NOT delete your Database data.

It does NOT delete website files.

It only targets system junk and logs.

Author: Sheikh Alamin Santo
Linux System Administrator
