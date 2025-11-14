# DiskMaintenance.ps1
# Author: Emin Alakbarli
# Purpose: Automate disk cleanup and generate maintenance report

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ComputerName = $env:COMPUTERNAME
$Report = "Disk Maintenance Report - $Date`nComputer: $ComputerName`n`n"

# Check all drives
$Drives = Get-PSDrive -PSProvider FileSystem

foreach ($Drive in $Drives) {
    $FreeSpaceGB = [math]::round($Drive.Free/1GB,2)
    $TotalSpaceGB = [math]::round($Drive.Used/1GB + $Drive.Free/1GB,2)
    $Report += "$($Drive.Name): $FreeSpaceGB GB free of $TotalSpaceGB GB`n"
    
    if (($FreeSpaceGB / $TotalSpaceGB) -lt 0.10) {
        $Report += "WARNING: Low disk space on $($Drive.Name)`n"
    }
}

# Clean temp folders
$TempPaths = @(
    "$env:LOCALAPPDATA\Temp",
    "$env:SystemRoot\Temp"
)

foreach ($Path in $TempPaths) {
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        $Report += "Cleaned: $Path`n"
    }
}

# Empty Recycle Bin
$Shell = New-Object -ComObject Shell.Application
$RecycleBin = $Shell.Namespace(0xA)
$RecycleBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Force -ErrorAction SilentlyContinue }
$Report += "Emptied Recycle Bin`n"

# Save report
$ReportPath = "$env:USERPROFILE\Desktop\DiskMaintenanceReport.txt"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host $Report
Write-Host "Report saved to $ReportPath"
