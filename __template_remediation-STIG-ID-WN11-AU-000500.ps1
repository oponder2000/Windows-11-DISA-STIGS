<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Oliver Ponder
    LinkedIn        : https://www.linkedin.com/in/oliver-ponder/
    GitHub          : https://github.com/oponder2000
    Date Created    : 2026-04-05
    Last Modified   : 2026-04-05
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500

.TESTED ON
    Date(s) Tested  : 2026-04-05
    Tested By       : Oliver Ponder
    Systems Tested  : Microsoft Windows 11 Pro 10.0.26200 N/A Build 26200
    PowerShell Ver. : 5.1.26100.7920

.USAGE
    Put any usage instructions here.
    Example syntax: 
    PS C:\> .\__remediation_template(STIG-ID-WN11-AU-000500).ps1 
#>

# WN11-AU-000500 - Set Application Event Log max size to 32768 KB or greater
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName    = "MaxSize"
$valueData    = 32768   # 0x00008000 — increase if you want a larger log

# Create the key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the DWORD value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type DWord

# Verify
$result = Get-ItemProperty -Path $registryPath -Name $valueName
Write-Host "MaxSize set to: $($result.MaxSize) KB" -ForegroundColor Green
