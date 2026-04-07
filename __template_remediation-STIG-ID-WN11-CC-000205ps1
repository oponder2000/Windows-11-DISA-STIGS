<#
.SYNOPSIS
    This PowerShell script configures Windows Telemetry as Basic.

.NOTES
    Author          : Oliver Ponder
    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
    GitHub          : https://github.com/oponder2000
    Date Created    : 2026-04-06
    Last Modified   : 2026-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000205

.TESTED ON
    Date(s) Tested  : 2026-04-06
    Tested By       : Oliver Ponder
    Systems Tested  : Microsoft Windows 11 Pro 10.0.26200 N/A Build 26200
    PowerShell Ver. : 5.1.26100.7920

.USAGE
    Put any usage instructions here.
    Example syntax: 
    PS C:\> .\__remediation_template(STIG-ID-WN11-CC-000205).ps1 
#>


#Requires -RunAsAdministrator

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$ValueName = "AllowTelemetry"
$ValueData = 0  # 0 = Security (most restrictive), 1 = Basic

# Create the registry path if it doesn't exist
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the value to 0 (Security - recommended for STIG compliance)
New-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -PropertyType DWord -Force | Out-Null

# Verify
$CurrentValue = (Get-ItemProperty -Path $RegistryPath -Name $ValueName).$ValueName

if ($CurrentValue -eq $ValueData) {
    Write-Host "✓ AllowTelemetry = $CurrentValue (Security/Minimal)" -ForegroundColor Green
    Write-Host "Registry path: $RegistryPath" -ForegroundColor Green
} else {
    Write-Host "✗ Failed: Expected $ValueData, got $CurrentValue" -ForegroundColor Red
}

# Refresh Group Policy
gpupdate /force
