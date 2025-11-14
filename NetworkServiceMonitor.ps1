# NetworkServiceMonitor.ps1
# Author: Emin Alakbarli
# Purpose: Monitor network connectivity and key Windows services

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ComputerName = $env:COMPUTERNAME

# Hosts to ping
$Hosts = @("google.com", "8.8.8.8")  # Add internal servers if needed

# Services to monitor
$Services = @("Spooler", "wuauserv") # Print Spooler, Windows Update

$Report = "Network & Service Report - $Date`nComputer: $ComputerName`n`n"

# Check network connectivity
$Report += "Network Connectivity:`n"
foreach ($host in $Hosts) {
    $Status = if (Test-Connection -ComputerName $host -Count 2 -Quiet) {"Online"} else {"Offline"}
    $Report += "$host : $Status`n"
}

# Check service status
$Report += "`nService Status:`n"
foreach ($service in $Services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        $Report += "$($svc.DisplayName) : $($svc.Status)`n"
    } else {
        $Report += "$service : Not Found`n"
    }
}

# Output report to console
Write-Host $Report

# Save report to Desktop
$ReportPath = "$env:USERPROFILE\Desktop\NetworkServiceReport.txt"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Report saved to $ReportPath"
