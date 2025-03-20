# Script Parameters
param(
    [Parameter(Mandatory=$false)]
    [string]$VMName,
    
    [Parameter(Mandatory=$false)]
    [int]$Interval = 5,
    
    [Parameter(Mandatory=$false)]
    [int]$Duration = 60
)

# Function to get VM resource information
function Get-VMResourceInfo {
    param([string]$Name)
    
    $vm = Get-VM -Name $Name
    $metrics = Get-VM -Name $Name | Get-VMResourceMetering
    
    return [PSCustomObject]@{
        Name = $vm.Name
        State = $vm.State
        CPUUsage = $metrics.AverageProcessorUsage
        MemoryUsage = [math]::Round($metrics.AverageMemoryUsage / 1GB, 2)
        MemoryAssigned = [math]::Round($vm.MemoryAssigned / 1GB, 2)
        DiskIO = $metrics.AverageDiskIO
        NetworkIO = $metrics.AverageNetworkIO
        Uptime = $vm.Uptime
    }
}

# Function to display information in table format
function Show-VMResourceTable {
    param([array]$VMs)
    
    Clear-Host
    Write-Host "`nVirtual Machine Resource Monitoring"
    Write-Host "====================================="
    Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "`n"
    
    $VMs | Format-Table -AutoSize
}

# Main monitoring loop
$startTime = Get-Date
$endTime = $startTime.AddSeconds($Duration)

if ($VMName) {
    # Monitor specific VM
    while ((Get-Date) -lt $endTime) {
        $vmInfo = Get-VMResourceInfo -Name $VMName
        Show-VMResourceTable -VMs @($vmInfo)
        Start-Sleep -Seconds $Interval
    }
} else {
    # Monitor all VMs
    while ((Get-Date) -lt $endTime) {
        $allVMs = Get-VM | ForEach-Object { Get-VMResourceInfo -Name $_.Name }
        Show-VMResourceTable -VMs $allVMs
        Start-Sleep -Seconds $Interval
    }
}

Write-Host "`nMonitoring completed." 