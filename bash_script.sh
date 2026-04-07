#!/bin/bash
# STIG: UBTU-24-100660
# Ubuntu 24.04 LTS must use the "SSSD" package for multifactor authentication services.

set -e

# Color output for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Checking if sssd is installed and enabled...${NC}"

# Check if sssd is installed
if dpkg -l | grep -q "^ii.*sssd"; then
    echo -e "${GREEN}[✓] sssd package is installed${NC}"
    dpkg -l | grep "^ii.*sssd" | head -1
else
    echo -e "${RED}[✗] sssd package is NOT installed${NC}"
fi

# Check if sssd service is enabled
if systemctl is-enabled sssd > /dev/null 2>&1; then
    echo -e "${GREEN}[✓] sssd service is enabled${NC}"
else
    echo -e "${RED}[✗] sssd service is NOT enabled${NC}"
fi

# Check if sssd service is active
if systemctl is-active --quiet sssd; then
    echo -e "${GREEN}[✓] sssd service is active (running)${NC}"
else
    echo -e "${RED}[✗] sssd service is NOT active${NC}"
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

# Install sssd and related packages
echo -e "${YELLOW}[*] Installing sssd package...${NC}"
apt install -y sssd > /dev/null 2>&1

# Create a minimal SSSD configuration if it doesn't exist or is empty
echo -e "${YELLOW}[*] Configuring sssd service...${NC}"

# Backup existing config if present
if [[ -f /etc/sssd/sssd.conf ]] && [[ -s /etc/sssd/sssd.conf ]]; then
    echo -e "${YELLOW}[*] Backing up existing sssd.conf...${NC}"
    cp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.backup-$(date +%s)
else
    # Create minimal SSSD configuration
    mkdir -p /etc/sssd
    cat > /etc/sssd/sssd.conf << 'SSSD_EOF'
[sssd]
services = nss, pam
domains = LOCAL

[domain/LOCAL]
id_provider = local
auth_provider = local
SSSD_EOF
    echo -e "${GREEN}[✓] Created minimal sssd.conf configuration${NC}"
fi

# Set proper permissions on sssd.conf
chmod 600 /etc/sssd/sssd.conf
chown root:root /etc/sssd/sssd.conf

# Enable sssd service to start on boot
echo -e "${YELLOW}[*] Enabling sssd service...${NC}"
systemctl enable sssd.service > /dev/null 2>&1

# Start sssd service
echo -e "${YELLOW}[*] Starting sssd service...${NC}"
systemctl start sssd.service > /dev/null 2>&1

# Give the service a moment to start
sleep 2

# Verify installation and status
echo -e "${YELLOW}[*] Verifying installation and status...${NC}"

# Check if sssd is installed
if ! dpkg -l | grep -q "^ii.*sssd"; then
    echo -e "${RED}[✗] Failed to install sssd package${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] sssd package is installed${NC}"

# Check if sssd is enabled
if ! systemctl is-enabled sssd > /dev/null 2>&1; then
    echo -e "${RED}[✗] Failed to enable sssd service${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] sssd service is enabled${NC}"

# Check if sssd is active
if ! systemctl is-active --quiet sssd; then
    echo -e "${RED}[✗] sssd service is not running${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] sssd service is active (running)${NC}"

echo ""
echo -e "${GREEN}[✓] STIG check PASSED: SSSD is installed, enabled, and running${NC}"
echo -e "${YELLOW}[*] Note: SSSD configuration files are located in /etc/sssd/${NC}"
echo -e "${YELLOW}[*] Configure SSSD providers and authentication methods as needed${NC}"
exit 0
