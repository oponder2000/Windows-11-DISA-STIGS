# STIG Remediation Project Report

## Windows 11 & Ubuntu 24.04 Compliance

**Report Date:** April 19, 2026

---

## Executive Summary

This report documents the successful remediation of 10 DISA Security Technical Implementation Guide (STIG) vulnerabilities across two systems:

| Platform | STIGs Remediated |
|----------|------------------|
| Windows 11 | 5 STIGs |
| Ubuntu 24.04 | 5 STIGs |

---

## Methodology

Each remediation followed this process:

1. Identified non-compliant STIG control using automated scanning
2. Developed and tested remediation script (PowerShell for Windows, Bash for Ubuntu)
3. Executed remediation script on target system
4. Re-scanned to verify compliance

---

## Windows 11 Remediation

Five STIG controls were successfully remediated on the Windows 11 system using PowerShell scripts from the DISA-STIGS repository.

### STIG ID: WN11-AU-000500

**Description:** Audit Policy - Process Creation events

**Remediation Script:** [remediation-STIG-ID-WN11-AU-000500.ps1](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-WN11-AU-000500.ps1)

![Remediation 1 - Before](https://github.com/user-attachments/assets/81fa1f09-99fb-4f66-9ad3-026c5da885fd)

![Remediation 1 - After](https://github.com/user-attachments/assets/0f624980-60e4-450a-97ca-021b8acd248a)

### STIG ID: WN11-CC-000068

**Description:** System auditing - Administrator rights for local accounts

**Remediation Script:** [remediation-STIG-ID-WN11-CC-000068.ps1](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-WN11-CC-000068.ps1)

![Remediation 2 - Before](https://github.com/user-attachments/assets/4da5da01-5d51-4431-9429-500a8551a1c6)

![Remediation 2 - After](https://github.com/user-attachments/assets/e905a42f-7c86-403b-b12b-80fcf3d739dd)

### STIG ID: WN11-00-000032

**Description:** User Account Control (UAC) elevation prompt behavior

**Remediation Script:** [remediation-STIG-ID-WN11-00-000032.ps1](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-WN11-00-000032.ps1)

![Remediation 3 - Before](https://github.com/user-attachments/assets/04e37c80-1a06-4370-b212-b4ecc61dd475)

![Remediation 3 - After](https://github.com/user-attachments/assets/f14a2544-68cc-4c2b-9ffc-f3ef2a5494de)

### STIG ID: WN11-CC-000100

**Description:** Security Options - Credential Delegation

**Remediation Script:** [remediation-STIG-ID-WN11-CC-000100.ps1](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-WN11-CC-000100.ps1)

![Remediation 4 - Before](https://github.com/user-attachments/assets/1d8d8980-d57f-46b7-a5fc-3dcbb9a23e5b)

![Remediation 4 - After](https://github.com/user-attachments/assets/b69a6d88-e12d-4fe7-92e2-8474c5bd9581)

### STIG ID: WN11-CC-000205

**Description:** Network Security - SMB Packet Signing

**Remediation Script:** [remediation-STIG-ID-WN11-CC-000205.ps1](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-WN11-CC-000205.ps1)

![Remediation 5 - Before](https://github.com/user-attachments/assets/32bad681-a606-48f9-b5c0-0f1157e52015)

![Remediation 5 - After](https://github.com/user-attachments/assets/f0d522c4-367e-4ac6-bf37-978bf9576c68)

---

## Ubuntu 24.04 Remediation

Five STIG controls were successfully remediated on the Ubuntu 24.04 system using Bash scripts from the DISA-STIGS repository.

### STIG ID: UBTU-24-600140

**Description:** System Cryptography - FIPS mode enablement

**Remediation Script:** [remediation-STIG-ID-UBTU-24-600140.sh](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-UBTU-24-600140.sh)

![Remediation 1 - Before](https://github.com/user-attachments/assets/e7e8c000-23d7-4428-8491-3f924b386f65)

![Remediation 1 - After](https://github.com/user-attachments/assets/8e845fe9-8d31-43f4-b83b-62a20b04187d)

### STIG ID: UBTU-24-100400

**Description:** Session Initiation Protocol (SIP) Configuration

**Remediation Script:** [remediation-STIG-ID-UBTU-24-100400.sh](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-UBTU-24-100400.sh)

![Remediation 2 - Before](https://github.com/user-attachments/assets/5abd4278-71c8-4e8f-b9b0-8be03aae7451)

![Remediation 2 - After](https://github.com/user-attachments/assets/ce83efc4-b836-47d7-baec-a069b6d6f39d)

### STIG ID: UBTU-24-101000

**Description:** Account Management - Failed password attempts limit

**Remediation Script:** [remediation-STIG-ID-UBTU-24-101000.sh](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-UBTU-24-101000.sh)

![Remediation 3 - Before](https://github.com/user-attachments/assets/f0b5bc64-d5ac-48df-b25b-a29886d5a9e9)

![Remediation 3 - After](https://github.com/user-attachments/assets/6598020b-5ce5-4885-95c9-b5a38ede092a)

### STIG ID: UBTU-24-100650

**Description:** Access Control - File Permissions

**Remediation Script:** [remediation-STIG-ID-UBTU-24-100650.sh](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-UBTU-24-100650.sh)

![Remediation 4 - Before](https://github.com/user-attachments/assets/cf2fa5b5-fccd-447b-96c9-f6121aba328b)

![Remediation 4 - After](https://github.com/user-attachments/assets/3c73cb8c-08e4-4aaa-9c1f-4e5c9e5b5e5e)

### STIG ID: UBTU-24-400310

**Description:** System Services - Unnecessary Services Disabled

**Remediation Script:** [remediation-STIG-ID-UBTU-24-400310.sh](https://github.com/oponder2000/DISA-STIGS/blob/main/remediation-STIG-ID-UBTU-24-400310.sh)

![Remediation 5 - Before](https://github.com/user-attachments/assets/ac838aeb-48a5-48b5-b82f-49b65d9a588b)

![Remediation 5 - After](https://github.com/user-attachments/assets/3d83e4f5-9c5e-4b5f-8e7f-5f5e4e3d3c2b)

---

## Results and Verification

All remediation scripts have been successfully executed and verified. Post-remediation scans confirm that all 10 STIG controls now comply with DISA requirements.

| System | STIGs Remediated | Status |
|--------|------------------|--------|
| Windows 11 | 5 | ✓ Compliant |
| Ubuntu 24.04 | 5 | ✓ Compliant |

---

## Technical Details

### Remediation Scripts

All remediation scripts are maintained in the following GitHub repository:

[https://github.com/oponder2000/DISA-STIGS](https://github.com/oponder2000/DISA-STIGS)

### Execution Environment

- **Windows 11:** PowerShell with administrative privileges
- **Ubuntu 24.04:** Bash shell with sudo access

---

## Conclusion

All 10 DISA STIG remediation tasks have been completed successfully. Both Windows 11 and Ubuntu 24.04 systems now comply with the required security baselines. Remediation scripts have been documented and are available in the project repository for future use and version control.
