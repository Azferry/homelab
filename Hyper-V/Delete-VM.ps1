$VMName = "VMName"  
$RootStoragePath = "D:\Hyper-V\Virtual Machines"
$VM = Get-VM -Name $VMName
$Vhd = $VM | Select-Object -ExpandProperty HardDrives | Select-Object Path


if ($VM.State -eq 'Running') {
    Write-Host "Turning off VM {$($VM.VMName)} on host {$($VM.ComputerName)}"
    $VM | Stop-VM -Force
    Start-Sleep -Seconds 10
}

Write-Host "Removing VM {$($VM.VMName)} from host {$($VM.ComputerName)}"
Remove-VM -Name $VM.VMName -Force

## Delete Config Files
Write-Host "Removing VM files {$($VM.VMName)} from path {$($VM.Path)}"
Get-ChildItem -Path $VM.Path -Recurse | Where-Object {$_.Name -match $VM.Id } | Remove-Item

## Delete VHD
Write-Host "Removing VM VHD {$($VM.VMName)} from path {$($VM.Path)}"
Remove-Item -Path $Vhd.Path


Remove-Item -Path $($RootStoragePath+"\"+$VMName) -Recurse