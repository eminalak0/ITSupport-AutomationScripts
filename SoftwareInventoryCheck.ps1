# ITSupport-Automation.ps1
# Author: Emin Alakbarli
# Purpose: Comprehensive IT Support automation script

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ComputerName = $env:COMPUTERNAME

# Initialize report
$Report = "<html><head><title>IT Support Report - $ComputerName</title></head><body>"
$Report += "<h2>IT Support Report</h2>"
$Report += "<p>Date: $Date<br>Computer: $ComputerName</p>"

# -----------------------------
# SYSTEM HEALTH
# -----------------------------
$CPU = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
$Memory = Get-WmiObject Win32_OperatingSystem
$TotalRAM = [math]::round($Memory.TotalVisibleMemorySize/1MB,2)
$FreeRAM = [math]::round($Memory.FreePhysicalMemory/1MB,2)
$UsedRAM = [math]::round($TotalRAM - $FreeRAM,2)

$Report += "<h3>System Health</h3>"
$Report += "<ul>"
$Report += "<li>CPU Usage: $CPU%</li>"
$Report += "<li>RAM Usage: $UsedRAM GB / $TotalRAM GB</li>"

$Drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
foreach ($Drive in $Drives) {
    $FreeGB = [math]::round($Drive.FreeSpace/1GB,2)
    $TotalGB = [math]::round($Drive.Size/1GB,2)
    $Status = if (($FreeGB/$TotalGB) -lt 0.10) { "<span style='color:red'>Low Space</span>" } else { "OK" }
    $Report += "<li>Drive $($Drive.DeviceID): $FreeGB GB free of $TotalGB GB - $Status</li>"
}
$Report += "</ul>"

# -----------------------------
# NETWORK CHECK
# -----------------------------
$Hosts = @("google.com", "8.8.8.8")
$Report += "<h3>Network Connectivity</h3><ul>"
foreach ($host in $Hosts) {
    $Status = if (Test-Connection -ComputerName $host -Count 2 -Quiet) {"Online"} else {"Offline"}
    $Report += "<li>$host : $Status</li>"
}
$Report += "</ul>"

# -----------------------------
# SERVICE CHECK
# -----------------------------
$Services = @("Spooler", "wuauserv") # Print Spooler & Windows Update
$Report += "<h3>Service Status</h3><ul>"
foreach ($service in $Services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        $color = if ($svc.Status -eq "Running") {"green"} else {"red"}
        $Report += "<li>$($svc.DisplayName): <span style='color:$color'>$($svc.Status)</span></li>"
    } else {
        $Report += "<li>$service: Not Found</li>"
    }
}
$Report += "</ul>"

# -----------------------------
# DISK CLEANUP
# -----------------------------
$TempPaths = @("$env:LOCALAPPDATA\Temp", "$env:SystemRoot\Temp")
foreach ($Path in $TempPaths) {
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}
# Empty Recycle Bin
$Shell = New-Object -ComObject Shell.Application
$RecycleBin = $Shell.Namespace(0xA)
$RecycleBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Force -ErrorAction SilentlyContinue }

$Report += "<h3>Maintenance</h3><p>Temporary files and Recycle Bin cleaned.</p>"

# -----------------------------
# SAVE REPORT
# -----------------------------
$Report += "</body></html>"
$ReportPath = "$env:USERPROFILE\Desktop\ITSupportReport.html"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "IT Support report saved to $ReportPath"
