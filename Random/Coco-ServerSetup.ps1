

if(!test-path "C:\ProgramData\chocolatey\choco.exe"){
    Write-Output "Chocolatey Needs to be installed"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Output "Chocolatey install has been completed"
}
else {
    Write-Output "Chocolatey is already installed"
}

choco install googlechrome git -y
