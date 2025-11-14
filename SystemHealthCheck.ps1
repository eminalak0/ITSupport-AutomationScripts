# SystemHealthCheck.ps1
# Author: Emin Alakbarli
# Purpose: Automated system health check for IT Support demo

# Get system info
$ComputerName = $env:COMPUTERNAME
$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# CPU usage
$CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average

# RAM usage
$Memory = Get-WmiObject Win32_OperatingSystem
$TotalRAM = [math]::round($Memory.TotalVisibleMemorySize/1MB,2)
$FreeRAM = [math]::round($Memory.FreePhysicalMemory/1MB,2)
$UsedRAM = [math]::round($TotalRAM - $FreeRAM,2)

# Disk usage
$Disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, 
    @{Name='FreeGB';Expression={[math]::round($_.FreeSpace/1GB,2)}}, 
    @{Name='TotalGB';Expression={[math]::round($_.Size/1GB,2)}}

# Network connectivity check
$PingTest = Test-Connection -ComputerName google.com -Count 2 -Quiet

# Build report
$Report = @"
System Health Report - $Date
Computer Name: $ComputerName

CPU Usage: $CPU%
RAM Usage: $UsedRAM GB / $TotalRAM GB
Disk Usage:
$( $Disks | ForEach-Object { "$($_.DeviceID): $($_.FreeGB) GB free of $($_.TotalGB) GB" } )
Network Connectivity: $(if ($PingTest) {"Online"} else {"Offline"})
"@

# Output report to console
Write-Host $Report

# Save report to file
$ReportPath = "$env:USERPROFILE\Desktop\SystemHealthReport.txt"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Report saved to $ReportPath"
