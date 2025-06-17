

param($minutes = 9999)
 
$myShell = New-Object -com "Wscript.Shell"
 
for ($i = 0; $i -lt $minutes; $i++) {
    $SleepTime = Get-Random -Maximum 290 -Minimum 100
    Start-Sleep -Seconds $SleepTime
    $myShell.sendkeys("{F13}")
}