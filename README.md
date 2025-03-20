# PowerShell Hyper-V Automation Scripts

A collection of PowerShell scripts for automating Hyper-V management tasks.

## Scripts Overview

1. `CreateNewVM.ps1` - Creates a new virtual machine with specified parameters
2. `ManageVMState.ps1` - Manages VM state (start, stop, pause, resume, restart)
3. `ManageVMSnapshots.ps1` - Manages VM snapshots (create, apply, remove, list)
4. `ManageVMExportImport.ps1` - Exports and imports VMs
5. `MonitorVMResources.ps1` - Monitors VM resource usage

## Requirements

- Windows Server 2012 R2 or later
- PowerShell 5.1 or later
- Hyper-V role installed
- Administrative privileges

## Usage Examples

### Create New VM
```powershell
.\CreateNewVM.ps1
```

### Manage VM State
```powershell
.\ManageVMState.ps1 -VMName "dc01" -Action "Start"
.\ManageVMState.ps1 -VMName "dc01" -Action "Stop"
```

### Manage Snapshots
```powershell
.\ManageVMSnapshots.ps1 -VMName "dc01" -Action "Create" -SnapshotName "BeforeUpdate"
.\ManageVMSnapshots.ps1 -VMName "dc01" -Action "List"
```

### Export/Import VM
```powershell
.\ManageVMExportImport.ps1 -VMName "dc01" -Action "Export" -Path "D:\Backup"
.\ManageVMExportImport.ps1 -VMName "dc01" -Action "Import" -Path "D:\Backup"
```

### Monitor Resources
```powershell
.\MonitorVMResources.ps1 -VMName "dc01" -Interval 10 -Duration 300
.\MonitorVMResources.ps1 -Interval 5 -Duration 60
```

## License

MIT License - see LICENSE file for details

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request 
