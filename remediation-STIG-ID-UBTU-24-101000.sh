#.SYNOPSIS
#    This Bash script allows users to directly initiate a session lock for all connection types.

#.NOTES
#    Author          : Oliver Ponder
#    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
#    GitHub          : https://github.com/oponder2000
#    Date Created    : 2026-04-07
#    Last Modified   : 2026-04-07
#    Version         : 1.0
#    CVEs            : N/A
#    Plugin IDs      : N/A
#    STIG-ID         : UBTU-24-101000

#.TESTED ON
#    Date(s) Tested  : 2026-04-07
#    Tested By       : Oliver Ponder
#    Systems Tested  : Ubuntu 24.04.4 LTS
#    Bash Ver. : version 5.2.21(1)-release (x86_64-pc-linux-gnu)
#
#.USAGE
#    Put any usage instructions here.
#    Example syntax: 
#    chmod +x remediation-STIG-ID-UBTU-24-101000.sh
#    ./remediation-STIG-ID-UBTU-24-101000.sh


#!/bin/bash
# STIG: UBTU-24-101000
# Ubuntu 24.04 LTS must allow users to directly initiate a session lock for all connection types.
# This is accomplished by installing the "vlock" package.

set -e

# Color output for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Checking if vlock is installed...${NC}"

# Check if vlock is installed
if dpkg -l | grep -q "^ii.*vlock"; then
    echo -e "${GREEN}[✓] vlock is already installed${NC}"
    dpkg -l | grep vlock | head -1
    exit 0
else
    echo -e "${RED}[✗] vlock is NOT installed${NC}"
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

# Install vlock
echo -e "${YELLOW}[*] Installing vlock package...${NC}"
apt install -y vlock > /dev/null 2>&1

# Verify the installation
echo -e "${YELLOW}[*] Verifying installation...${NC}"

if dpkg -l | grep -q "^ii.*vlock"; then
    echo -e "${GREEN}[✓] vlock package installed successfully${NC}"
    dpkg -l | grep vlock | head -1
else
    echo -e "${RED}[✗] Failed to install vlock${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] STIG check PASSED: vlock is installed${NC}"
echo -e "${YELLOW}[*] Users can now lock their session with: vlock${NC}"
exit 0
