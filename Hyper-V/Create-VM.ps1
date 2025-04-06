 
Enter-PSSession <ServerName>

$VMName = "VMName"
$VMDescription = "VM Description"
$VmGen = 2
$VHDSize = 100GB
$VHDDataDrive = 125GB

$StartUpRam = 8Gb
$vCPU = 8
$SwitchName = "vSwitch"
$DynamicRamMin = 1024MB
$DynamicRamMax = 10GB

$VlanId = 110

$OsType = "Windows" # "Linux"

$Folders = @("Snapshots", "Virtual Machines", "Virtual Hard Disks")
$RootPath = "d:\HyperV\" 
$VMRootPath =  $RootPath + $VMName


Write-Host "Create folder structure for virtual machine" -f Green
ForEach ($Folder in $Folders) {
    $FolderPath = "$VMRootPath\$Folder"
    if(!(Test-Path -Path $FolderPath))
    {
        New-Item -ItemType Directory -Path $FolderPath
        Write-Host "New folder created successfully!" -f Green
    }
    else
    {
      Write-Host "Folder already exists! - " + $FolderPath  -f Yellow
    }
}

Write-Host "Create virtual machine" -f Green
New-VM -Name $VMName -MemoryStartupBytes $StartUpRam `
    -Generation $VmGen `
    -NoVHD `
    -Path $RootPath `
    -SwitchName $SwitchName

Set-VM -Name $VMName -Notes $VMDescription

## Add VHD Boot
Write-Host "Create OS VHD" -f Green
$VHDPath = ($VMRootPath + "\Virtual Hard Disks\$($VMName).vhdx")
New-VHD -Path $VHDPath -SizeBytes $VHDSize -Dynamic
Add-VMHardDiskDrive -VMName $VMName -Path $VHDPath -ControllerType SCSI

## Data Drive
#$VHDPath = ($VMRootPath + "\Virtual Hard Disks\$($VMName)-data0.vhdx")
#New-VHD -Path $VHDPath -SizeBytes $VHDDataDrive
#Add-VMHardDiskDrive -VMName $VMName -Path $VHDPath -ControllerType SCSI

Write-Host "Add VHD DVD Drive & Set Boot Order" -f Green
Add-VMDvdDrive -VMName $VMName # -Path "C:\ISOs\Windows10.iso"
$NewVM = Get-Vm $VMName | select * 
Set-VMFirmware $VMName -FirstBootDevice $NewVM.DVDDrives[0] #only Gen 2

Write-Host "Configure Snapshots" -f Green
Set-VM -name $VMName -CheckpointType Production -SnapshotFileLocation ($VMRootPath + "\Snapshots") -SmartPagingFilePath ($VMRootPath)

## Set VM RAM/VCPU
#Set-VMMemory $VMName -DynamicMemoryEnabled $true `
#   -MinimumBytes $DynamicRamMin `
#    -MaximumBytes $DynamicRamMax
Set-VMProcessor $VMName -Count $vCPU
Set-VMProcessor $VMName -CompatibilityForMigrationEnabled $true

## Enable Integration Services
Enable-VMIntegrationService -VMName $VMName -Name "Guest Service Interface"

## Set VLAN for Network Adaptor
Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $VlanId


if ($OsType -eq "Windows") {
    Write-Host "Enable Secure boot for Windows" -f Green
    Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows
} elseif ($OsType -eq "Linux") {
    Write-Host "Disable Secure boot for Linux" -f Green
    Set-VMFirmware -VMName $VMName -EnableSecureBoot Off
    # Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftUEFISecureBoot
}

## Set Nested Virtualization
Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true 

exit