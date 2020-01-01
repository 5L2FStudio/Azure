## rem E used by cdrom
Get-Partition -DiskNumber 1 | Set-Partition -NewDriveLetter F

##
Get-Disk|where {$_.PartitionStyle -eq "RAW"} `
|Initialize-Disk -PartitionStyle MBR -PassThru `
|New-Partition -UseMaximumSize `
|Format-Volume -FileSystem NTFS -NewFileSystemLabel "sql" -Force

Get-Partition -DiskNumber 2 | Set-Partition -NewDriveLetter D

$sqlisoURL = 'https://a1cdnfile.blob.core.windows.net/tools/sql2019/SQLServer2019-x64-CHT-Dev.iso'
$sqlisoFile= 'C:\Temp\SQLServer2019-x64-CHT-Dev.iso'

$sqliniURL = 'https://a1cdnfile.blob.core.windows.net/tools/sql2019/ConfigurationFile.ini'
$sqliniFile= 'C:\Temp\ConfigurationFile.ini'

$ssmsURL = 'https://go.microsoft.com/fwlink/?linkid=2108895&clcid=0x404'
$ssmsFile= 'C:\Temp\SSMS-Setup-CHT.exe'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($sqlisoURL,$sqlisoFile)
$webclient.DownloadFile($sqliniURL,$sqliniFile)
$webclient.DownloadFile($ssmsURL  ,$ssmsFile)

Mount-DiskImage -ImagePath $sqlisoFile

Start-Process -FilePath 'Setup.exe'  -WorkingDirectory 'G:\' -Wait -ArgumentList "/ConfigurationFile=$sqliniFile"
Start-Process -FilePath 'SSMS-Setup-CHT.exe'  -WorkingDirectory 'C:\Temp' -Wait -ArgumentList "/install /quiet /passive /norestart"
