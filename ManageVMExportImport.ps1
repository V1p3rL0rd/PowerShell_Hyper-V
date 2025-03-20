# Script Parameters
param(
    [Parameter(Mandatory=$true)]
    [string]$VMName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('Export', 'Import')]
    [string]$Action,
    
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Function to check if VM exists
function Test-VMExists {
    param([string]$Name)
    return Get-VM -Name $Name -ErrorAction SilentlyContinue
}

# Check if VM exists for export
if ($Action -eq 'Export' -and -not (Test-VMExists -Name $VMName)) {
    Write-Error "Virtual machine $VMName not found!"
    exit 1
}

# Check if VM exists for import
if ($Action -eq 'Import' -and (Test-VMExists -Name $VMName)) {
    Write-Error "Virtual machine $VMName already exists!"
    exit 1
}

# Create directory for export/import if it doesn't exist
if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

# Execute requested action
switch ($Action) {
    'Export' {
        # Stop VM before export
        Stop-VM -Name $VMName -Force
        
        # Export VM
        Export-VM -Name $VMName -Path $Path
        Write-Host "Virtual machine $VMName has been successfully exported to $Path"
        
        # Start VM back
        Start-VM -Name $VMName
    }
    
    'Import' {
        # Check for export files
        $exportPath = Join-Path $Path $VMName
        if (-not (Test-Path $exportPath)) {
            Write-Error "Export files not found in $exportPath"
            exit 1
        }
        
        # Import VM
        Import-VM -Path $exportPath -Copy -GenerateNewId
        Write-Host "Virtual machine $VMName has been successfully imported from $exportPath"
    }
}

# Display result information
if ($Action -eq 'Import') {
    $vm = Get-VM -Name $VMName
    Write-Host "`nImported VM Information:"
    Write-Host "Name: $($vm.Name)"
    Write-Host "State: $($vm.State)"
    Write-Host "Memory: $($vm.MemoryAssigned/1GB) GB"
    Write-Host "Processors: $($vm.ProcessorCount)"
} 