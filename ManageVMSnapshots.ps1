# Script Parameters
param(
    [Parameter(Mandatory=$true)]
    [string]$VMName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('Create', 'Apply', 'Remove', 'List')]
    [string]$Action,
    
    [Parameter(Mandatory=$false)]
    [string]$SnapshotName
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
    'Create' {
        if (-not $SnapshotName) {
            $SnapshotName = "$VMName-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        }
        Checkpoint-VM -Name $VMName -SnapshotName $SnapshotName
        Write-Host "Snapshot '$SnapshotName' has been created for VM $VMName"
    }
    
    'Apply' {
        if (-not $SnapshotName) {
            Write-Error "Snapshot name must be specified for applying!"
            exit 1
        }
        Restore-VMSnapshot -VMName $VMName -Name $SnapshotName -Confirm:$false
        Write-Host "Snapshot '$SnapshotName' has been applied to VM $VMName"
    }
    
    'Remove' {
        if (-not $SnapshotName) {
            Write-Error "Snapshot name must be specified for removal!"
            exit 1
        }
        Remove-VMSnapshot -VMName $VMName -Name $SnapshotName -Confirm:$false
        Write-Host "Snapshot '$SnapshotName' has been removed from VM $VMName"
    }
    
    'List' {
        $snapshots = Get-VMSnapshot -VMName $VMName
        if ($snapshots) {
            Write-Host "Snapshots for VM $VMName:"
            $snapshots | Format-Table Name, CreationTime, ParentSnapshotName
        } else {
            Write-Host "No snapshots found for VM $VMName."
        }
    }
} 