<#
.SYNOPSIS
    This PowerShell script ensures that a BitLocker PIN with a minimum length of six digits is used for pre-boot authentication.

.NOTES
    Author          : Oliver Ponder
    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
    GitHub          : https://github.com/oponder2000
    Date Created    : 2026-04-06
    Last Modified   : 2026-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000032

.TESTED ON
    Date(s) Tested  : 2026-04-06
    Tested By       : Oliver Ponder
    Systems Tested  : Microsoft Windows 11 Pro 10.0.26200 N/A Build 26200
    PowerShell Ver. : 5.1.26100.7920

.USAGE
    Put any usage instructions here.
    Example syntax: 
    PS C:\> .\__remediation_template(STIG-ID-WN11-00-000032).ps1 
#>

#!/bin/bash
# STIG: UBTU-24-600140
# Restrict access to the kernel message buffer (kernel.dmesg_restrict = 1)

set -e

# Color output for readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Checking kernel.dmesg_restrict setting...${NC}"

# Check current value
CURRENT_VALUE=$(sysctl kernel.dmesg_restrict 2>/dev/null | awk -F= '{print $2}' | xargs)

if [[ "$CURRENT_VALUE" == "1" ]]; then
    echo -e "${GREEN}[✓] kernel.dmesg_restrict is already set to 1${NC}"
else
    echo -e "${RED}[✗] kernel.dmesg_restrict is set to $CURRENT_VALUE (should be 1)${NC}"
fi

# Check for conflicting configurations across all sysctl directories
echo -e "${YELLOW}[*] Scanning for conflicting configurations...${NC}"

SYSCTL_DIRS=(
    "/run/sysctl.d/"
    "/etc/sysctl.d/"
    "/usr/local/lib/sysctl.d/"
    "/usr/lib/sysctl.d/"
    "/lib/sysctl.d/"
)

CONFLICTS_FOUND=0

for dir in "${SYSCTL_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        # Look for kernel.dmesg_restrict set to 0 (uncommented)
        if grep -r "^kernel.dmesg_restrict\s*=\s*0" "$dir" 2>/dev/null; then
            echo -e "${RED}[✗] Found conflicting setting (= 0) in $dir${NC}"
            CONFLICTS_FOUND=1
        fi
    fi
done

# Also check main sysctl.conf
if [[ -f /etc/sysctl.conf ]]; then
    if grep -q "^kernel.dmesg_restrict\s*=\s*0" /etc/sysctl.conf 2>/dev/null; then
        echo -e "${RED}[✗] Found conflicting setting (= 0) in /etc/sysctl.conf${NC}"
        CONFLICTS_FOUND=1
    fi
fi

if [[ $CONFLICTS_FOUND -eq 0 ]]; then
    echo -e "${GREEN}[✓] No conflicting configurations found${NC}"
fi

# ============ FIX SECTION ============
# Uncomment the following to apply the fix

echo -e "${YELLOW}[*] Applying fix...${NC}"

# Remove any conflicting entries (set to 0)
for dir in "${SYSCTL_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        find "$dir" -type f -exec sed -i 's/^kernel.dmesg_restrict\s*=\s*0/#kernel.dmesg_restrict = 0/g' {} \;
    fi
done

# Remove conflicting line from main sysctl.conf
sed -i 's/^kernel.dmesg_restrict\s*=\s*0/#kernel.dmesg_restrict = 0/g' /etc/sysctl.conf

# Add the correct setting to /etc/sysctl.d/99-stig-hardening.conf
STIG_CONF="/etc/sysctl.d/99-stig-hardening.conf"

if ! grep -q "kernel.dmesg_restrict" "$STIG_CONF" 2>/dev/null; then
    echo "kernel.dmesg_restrict = 1" | tee -a "$STIG_CONF" > /dev/null
    echo -e "${GREEN}[✓] Added kernel.dmesg_restrict = 1 to $STIG_CONF${NC}"
else
    sed -i 's/^kernel.dmesg_restrict\s*=.*/kernel.dmesg_restrict = 1/g' "$STIG_CONF"
    echo -e "${GREEN}[✓] Updated kernel.dmesg_restrict in $STIG_CONF${NC}"
fi

# Reload sysctl settings
echo -e "${YELLOW}[*] Reloading sysctl settings...${NC}"
sysctl --system > /dev/null 2>&1

# Verify the fix
FINAL_VALUE=$(sysctl kernel.dmesg_restrict 2>/dev/null | awk -F= '{print $2}' | xargs)

if [[ "$FINAL_VALUE" == "1" ]]; then
    echo -e "${GREEN}[✓] STIG check PASSED: kernel.dmesg_restrict = 1${NC}"
    exit 0
else
    echo -e "${RED}[✗] STIG check FAILED: kernel.dmesg_restrict = $FINAL_VALUE${NC}"
    exit 1
fi
