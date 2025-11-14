# IT Support Automation Scripts

## SystemHealthCheck.ps1
This PowerShell script performs an automated health check of a Windows system, including CPU, RAM, disk usage, and network connectivity.  

**Skills Demonstrated:**  
- Windows system administration  
- Scripting and automation with PowerShell  
- Troubleshooting and reporting  

**Usage:**  
1. Open PowerShell.  
2. Navigate to the script folder.  
3. Run `.\SystemHealthCheck.ps1`.  
4. Report will be saved to Desktop as `SystemHealthReport.txt`.



## NetworkServiceMonitor.ps1
Monitors network connectivity to key hosts and checks important Windows services.

**Usage:**
1. Open PowerShell.
2. Navigate to the folder where `NetworkServiceMonitor.ps1` is saved.
3. Run the script:
   ```powershell
   .\NetworkServiceMonitor.ps1



## DiskMaintenance.ps1
Automates routine disk cleanup tasks and generates a report.

**What it does:**
- Checks all drives for free space and alerts if low
- Cleans temporary folders
- Empties the Recycle Bin
- Generates a report saved to Desktop

**Usage:**
1. Open PowerShell.
2. Navigate to the folder containing the script.
3. Run the script:
   ```powershell
   .\DiskMaintenance.ps1





## SoftwareInventoryCheck.ps1
Generates a detailed software inventory and flags outdated applications.

**What it does:**
- Scans all installed software on a Windows system
- Lists version numbers and install dates
- Flags software that may be outdated
- Generates an HTML report on Desktop

**Usage:**
1. Open PowerShell.
2. Navigate to the `Scripts/` folder.
3. Run:
```powershell
.\SoftwareInventoryCheck.ps1




