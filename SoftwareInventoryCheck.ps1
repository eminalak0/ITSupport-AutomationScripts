# SoftwareInventoryCheck.ps1
# Author: Emin Alakbarli
# Purpose: Generate a detailed inventory of installed software and check for updates

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ComputerName = $env:COMPUTERNAME
$ReportPath = "$env:USERPROFILE\Desktop\SoftwareInventoryReport.html"

# Initialize HTML report
$Report = "<html><head><title>Software Inventory - $ComputerName</title></head><body>"
$Report += "<h2>Software Inventory Report</h2>"
$Report += "<p>Date: $Date<br>Computer: $ComputerName</p>"
$Report += "<table border='1' cellspacing='0' cellpadding='5'><tr><th>Software Name</th><th>Version</th><th>Install Date</th><th>Status</th></tr>"

# Query installed software from registry
$SoftwarePaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Path in $SoftwarePaths) {
    Get-ItemProperty $Path -ErrorAction SilentlyContinue | ForEach-Object {
        $Name = $_.DisplayName
        $Version = $_.DisplayVersion
        $InstallDate = $_.InstallDate

        if ($Name) {
            # Simple version check example: mark if version < 1.0.0 as outdated (placeholder logic)
            $Status = if ($Version -and $Version -lt "1.0.0") {"<span style='color:red'>Outdated</span>"} else {"Up-to-date"}
            
            $Report += "<tr><td>$Name</td><td>$Version</td><td>$InstallDate</td><td>$Status</td></tr>"
        }
    }
}

$Report += "</table>"
$Report += "</body></html>"

# Save HTML report
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host "Software inventory report saved to $ReportPath"
