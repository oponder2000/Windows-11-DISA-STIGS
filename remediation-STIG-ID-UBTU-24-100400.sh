<#
.SYNOPSIS
    This Bash script configures the audit service to produce audit records containing the information needed to establish when (date and time) an event occurred.

.NOTES
    Author          : Oliver Ponder
    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
    GitHub          : https://github.com/oponder2000
    Date Created    : 2026-04-07
    Last Modified   : 2026-04-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-24-100400

.TESTED ON
    Date(s) Tested  : 2026-04-07
    Tested By       : Oliver Ponder
    Systems Tested  : Ubuntu 24.04.4 LTS
    Bash Ver. : version 5.2.21(1)-release (x86_64-pc-linux-gnu)

.USAGE
    Put any usage instructions here.
    Example syntax: 
    chmod +x remediation-STIG-ID-UBTU-24-100400.sh
    ./remediation-STIG-ID-UBTU-24-100400.sh
#>

#!/bin/bash
# STIG: UBTU-24-100400
# Ubuntu 24.04 LTS must have the "auditd" package installed.

set -e

# Color output for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Checking if auditd is installed...${NC}"

# Check if auditd is installed
if dpkg -l | grep -q "^ii.*auditd"; then
    echo -e "${GREEN}[✓] auditd is already installed${NC}"
    dpkg -l | grep auditd | head -1
    exit 0
else
    echo -e "${RED}[✗] auditd is NOT installed${NC}"
fi

# ============ FIX SECTION ============

echo -e "${YELLOW}[*] Applying fix...${NC}"

# Check if we have sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[✗] This script must be run as root (use sudo)${NC}"
    exit 1
fi

# Update package lists
echo -e "${YELLOW}[*] Updating package lists...${NC}"
apt update > /dev/null 2>&1

# Install auditd
echo -e "${YELLOW}[*] Installing auditd package...${NC}"
apt install -y auditd > /dev/null 2>&1

# Enable and start auditd service
echo -e "${YELLOW}[*] Enabling auditd service...${NC}"
systemctl enable auditd > /dev/null 2>&1
systemctl start auditd > /dev/null 2>&1

# Verify the installation
echo -e "${YELLOW}[*] Verifying installation...${NC}"

if dpkg -l | grep -q "^ii.*auditd"; then
    echo -e "${GREEN}[✓] auditd package installed successfully${NC}"
    dpkg -l | grep auditd | head -1
else
    echo -e "${RED}[✗] Failed to install auditd${NC}"
    exit 1
fi

# Check if auditd service is running
if systemctl is-active --quiet auditd; then
    echo -e "${GREEN}[✓] auditd service is running${NC}"
else
    echo -e "${YELLOW}[!] auditd service is not running, attempting to start...${NC}"
    systemctl start auditd
fi

echo -e "${GREEN}[✓] STIG check PASSED: auditd is installed and running${NC}"
exit 0
