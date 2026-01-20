```bash
#!/bin/bash

# ============================================================
# Linux Emergency Disk Cleaner
# Author: Sheikh Alamin Santo
# Use Case: Frees up space when Disk Usage is 100%
# ============================================================

# Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}   STARTING EMERGENCY DISK CLEANUP            ${NC}"
echo -e "${GREEN}==============================================${NC}"

# Check current usage
df -h / | grep /

# 1. Clean Package Manager Cache (Safe)
echo -e "${GREEN}[+] Cleaning APT/YUM Cache...${NC}"
apt-get clean 2>/dev/null
yum clean all 2>/dev/null
rm -rf /var/lib/apt/lists/*

# 2. Vacuum Systemd Journals (Keep only last 2 days)
echo -e "${GREEN}[+] Vacuuming Systemd Journal Logs...${NC}"
journalctl --vacuum-time=2d

# 3. Truncate Standard Log Files (Empty them, don't delete)
# This prevents "File descriptor" errors in running services
echo -e "${GREEN}[+] Truncating System Logs (syslog, auth, kern)...${NC}"
truncate -s 0 /var/log/syslog 2>/dev/null
truncate -s 0 /var/log/auth.log 2>/dev/null
truncate -s 0 /var/log/kern.log 2>/dev/null
truncate -s 0 /var/log/mail.log 2>/dev/null
truncate -s 0 /var/log/nginx/*.log 2>/dev/null
truncate -s 0 /var/log/apache2/*.log 2>/dev/null

# 4. Remove Old Compressed Logs (*.gz)
echo -e "${GREEN}[+] Deleting old rotated logs (*.gz)...${NC}"
find /var/log -type f -name "*.gz" -delete
find /var/log -type f -name "*.1" -delete

# 5. Clean Docker (Optional - Unused images)
if command -v docker &> /dev/null; then
    echo -e "${GREEN}[+] Pruning Unused Docker Objects...${NC}"
    docker system prune -f
fi

# 6. Show Top 10 Largest Files (For Manual Review)
echo -e "${RED}[!] TOP 10 LARGEST FILES (Check these manually):${NC}"
find / -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 10

echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}   CLEANUP COMPLETE! CHECK SPACE BELOW:       ${NC}"
echo -e "${GREEN}==============================================${NC}"
df -h / | grep /
