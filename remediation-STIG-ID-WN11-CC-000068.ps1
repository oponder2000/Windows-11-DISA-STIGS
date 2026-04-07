<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11 is configured to enable Remote host allows delegation of non-exportable credentials.

.NOTES
    Author          : Oliver Ponder
    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
    GitHub          : https://github.com/oponder2000
    Date Created    : 2026-04-06
    Last Modified   : 2026-04-06
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000068

.TESTED ON
    Date(s) Tested  : 2026-04-06
    Tested By       : Oliver Ponder
    Systems Tested  : Microsoft Windows 11 Pro 10.0.26200 N/A Build 26200
    PowerShell Ver. : 5.1.26100.7920

.USAGE
    Put any usage instructions here.
    Example syntax: 
    PS C:\> .\remediation-STIG-ID-WN11-CC-000068.ps1
#>

# Run as Administrator
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
$ValueName = "AllowProtectedCreds"
$ValueData = 1

# Create the registry path if it doesn't exist
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $RegistryPath -Name $ValueName -Value $ValueData -PropertyType DWord -Force | Out-Null

Write-Host "Registry value set successfully: AllowProtectedCreds = 1"
