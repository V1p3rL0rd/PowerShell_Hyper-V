# Script Parameters
param(
    [Parameter(Mandatory=$true)]
    [string]$VMName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('Start', 'Stop', 'Pause', 'Resume', 'Restart')]
    [string]$Action
)

# Function to check if VM exists
function Test-VMExists {
    param([string]$Name)
    return Get-VM -Name $Name -ErrorAction SilentlyContinue
}

# Check if VM exists
if (-not (Test-VMExists -Name $VMName)) {
    Write-Error "Virtual machine $VMName not found!"
    exit 1
}

# Execute requested action
switch ($Action) {
    'Start' {
        Start-VM -Name $VMName
        Write-Host "Virtual machine $VMName has been started."
    }
    
    'Stop' {
        Stop-VM -Name $VMName -Force
        Write-Host "Virtual machine $VMName has been stopped."
    }
    
    'Pause' {
        Suspend-VM -Name $VMName
        Write-Host "Virtual machine $VMName has been paused."
    }
    
    'Resume' {
        Resume-VM -Name $VMName
        Write-Host "Virtual machine $VMName has been resumed."
    }
    
    'Restart' {
        Restart-VM -Name $VMName -Force
        Write-Host "Virtual machine $VMName has been restarted."
    }
}

# Get and display current VM state
$vmState = Get-VM -Name $VMName | Select-Object -ExpandProperty State
Write-Host "Current state of VM $VMName: $vmState" 