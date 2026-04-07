#.SYNOPSIS
#    This Bash script configures a 60-day maximum password lifetime restriction. Passwords for new users must have a 60-day maximum password lifetime restriction.
#
#.NOTES
#    Author          : Oliver Ponder
#    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
#    GitHub          : https://github.com/oponder2000
#    Date Created    : 2026-04-07
#    Last Modified   : 2026-04-07
#    Version         : 1.0
#    CVEs            : N/A
#    Plugin IDs      : N/A
#    STIG-ID         : UBTU-24-400310
#
#.TESTED ON
#    Date(s) Tested  : 2026-04-07
#    Tested By       : Oliver Ponder
#    Systems Tested  : Ubuntu 24.04.4 LTS
#    Bash Ver. : version 5.2.21(1)-release (x86_64-pc-linux-gnu)
#
#.USAGE
#    Put any usage instructions here.
#    Example syntax: 
#    chmod +x remediation-STIG-ID-UBTU-24-400310.sh
#    ./remediation-STIG-ID-UBTU-24-400310.sh

#!/bin/bash
# STIG: UBTU-24-400310
# Ubuntu 24.04 LTS must enforce a 60-day maximum password lifetime restriction.
# Passwords for new users must have a 60-day maximum password lifetime restriction.

set -e

# Color output for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS_MAX_DAYS=60
LOGIN_DEFS="/etc/login.defs"

echo -e "${YELLOW}[*] Checking password maximum lifetime setting...${NC}"

# Check current setting
CURRENT_VALUE=$(grep -i "^PASS_MAX_DAYS" "$LOGIN_DEFS" 2>/dev/null || echo "NOT_SET")

if [[ "$CURRENT_VALUE" == *"$PASS_MAX_DAYS"* ]]; then
    echo -e "${GREEN}[✓] PASS_MAX_DAYS is already set to $PASS_MAX_DAYS${NC}"
    echo "    $CURRENT_VALUE"
    exit 0
else
    if [[ "$CURRENT_VALUE" == "NOT_SET" ]]; then
        echo -e "${RED}[✗] PASS_MAX_DAYS is not set in $LOGIN_DEFS${NC}"
    else
        echo -e "${RED}[✗] Current setting: $CURRENT_VALUE${NC}"
        echo -e "${RED}[✗] Should be: PASS_MAX_DAYS $PASS_MAX_DAYS${NC}"
    fi
fi

# ============ FIX SECTION ============

echo -e "${YELLOW}[*] Applying fix...${NC}"

# Check if we have sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[✗] This script must be run as root (use sudo)${NC}"
    exit 1
fi

# Backup the original file
echo -e "${YELLOW}[*] Backing up $LOGIN_DEFS...${NC}"
cp "$LOGIN_DEFS" "${LOGIN_DEFS}.backup-$(date +%s)"

# Check if PASS_MAX_DAYS line exists (commented or uncommented)
if grep -qi "^#*PASS_MAX_DAYS" "$LOGIN_DEFS"; then
    # Line exists - replace it (handles both commented and uncommented)
    echo -e "${YELLOW}[*] Updating existing PASS_MAX_DAYS entry...${NC}"
    sed -i "s/^#*PASS_MAX_DAYS.*/PASS_MAX_DAYS $PASS_MAX_DAYS/" "$LOGIN_DEFS"
else
    # Line doesn't exist - add it after the PASS_MIN_DAYS line or at the end
    echo -e "${YELLOW}[*] Adding PASS_MAX_DAYS entry...${NC}"
    if grep -q "^PASS_MIN_DAYS" "$LOGIN_DEFS"; then
        # Insert after PASS_MIN_DAYS
        sed -i "/^PASS_MIN_DAYS/a PASS_MAX_DAYS $PASS_MAX_DAYS" "$LOGIN_DEFS"
    else
        # Append to file
        echo "PASS_MAX_DAYS $PASS_MAX_DAYS" >> "$LOGIN_DEFS"
    fi
fi

echo -e "${GREEN}[✓] Updated $LOGIN_DEFS${NC}"

# Verify the fix
echo -e "${YELLOW}[*] Verifying configuration...${NC}"

UPDATED_VALUE=$(grep -i "^PASS_MAX_DAYS" "$LOGIN_DEFS" 2>/dev/null)

if [[ "$UPDATED_VALUE" == *"$PASS_MAX_DAYS"* ]]; then
    echo -e "${GREEN}[✓] STIG check PASSED: PASS_MAX_DAYS is set to $PASS_MAX_DAYS${NC}"
    echo "    $UPDATED_VALUE"
    echo ""
    echo -e "${YELLOW}[*] Note: This applies to NEW user accounts created after this change.${NC}"
    echo -e "${YELLOW}[*] For existing user accounts, use chage command:${NC}"
    echo -e "${YELLOW}[*]   sudo chage -M 60 <username>${NC}"
    echo -e "${YELLOW}[*] To check all users: sudo chage -l <username>${NC}"
    exit 0
else
    echo -e "${RED}[✗] STIG check FAILED: Could not verify PASS_MAX_DAYS setting${NC}"
    echo -e "${RED}[✗] Current value: $UPDATED_VALUE${NC}"
    exit 1
fi
