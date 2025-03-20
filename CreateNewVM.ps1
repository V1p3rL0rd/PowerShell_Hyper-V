# Virtual Machine Parameters
$vmName = "dc01" # VM name
$vmGeneration = 1 # VM generation
$vmPath = "D:\VMs" # Path to your VM's
$vmMemory = 4GB # RAM settings
$vmProcessorCount = 2 # CPU cores settings
$vmVHDPath = "$vmPath\$vmName\Virtual Hard Disks\$vmName.vhdx" # Path to your VM's disks
$vmVHDSize = 80GB # VM HDD size
$isoPath = "D:\Images\ws2k19.iso" # Path to Installation ISO image
$switchName = "vswitch-srv" # Virtual switch

# Create a folder for the virtual machine
New-Item -ItemType Directory -Path "$vmPath\$vmName" -Force

# Create a virtual machine
New-VM -Name $vmName -Generation $vmGeneration -Path $vmPath -MemoryStartupBytes $vmMemory -NoVHD

# Processor setup
Set-VMProcessor -VMName $vmName -Count $vmProcessorCount

# Create and connect a virtual hard disk
New-VHD -Path $vmVHDPath -SizeBytes $vmVHDSize -Dynamic
Add-VMHardDiskDrive -VMName $vmName -Path $vmVHDPath

# Connecting ISO image
Add-VMDvdDrive -VMName $vmName -Path $isoPath

# Connecting a network switch
Get-VMNetworkAdapter -VMName $vmName | Connect-VMNetworkAdapter -SwitchName $switchName

# Starting a virtual machine
Start-VM -Name $vmName

Write-Host "Virtual machine $vmName was successfully created and started."
