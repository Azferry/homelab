
$vSwitchName = 'vSwitch'
$vSwitchEthName = 'Ethernet 2'
$rootPath= "D:\HyperV"
$Folders = @("DefaultVM", "DefaultVHD")

Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

$vSwitch = Get-VMSwitch -Name $vSwitchName -erroraction 'silentlycontinue'
if($vSwitch) {
    Write-Host 'Virtual Switch Exists'
}
else {
    Write-Host 'Create - Virtual Switch'
    $net = Get-NetAdapter -Name $vSwitchEthName
    New-VMSwitch -Name $vSwitchName -AllowManagementOS $True -NetAdapterName $net.Name
}

ForEach ($Folder in $Folders) {
    $FolderPath = "$rootPath\$Folder"
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

Set-VMHost -VirtualHardDiskPath ($rootPath + '\DefaultVHD') -VirtualMachinePath ($rootPath + '\DefaultVM')
