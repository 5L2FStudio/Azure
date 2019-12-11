# Script to define regional settings on Azure Virtual Machines deployed from the market place
# Author: Alexandre Verkinderen
# Modifier : James Fu
#
######################################33

#variables
$regionalsettingsURL = "https://raw.githubusercontent.com/5L2FStudio/Azure/master/101-ServerBuild/TWRegion.xml"
$RegionalSettings = "D:\TWRegion.xml"

$languagepackURL = "https://a1cdnpoint.azureedge.net/tools/x64fre_Server_zh-tw_lp.cab"
$LanguagePack = "D:\x64fre_Server_zh-tw_lp.cab"

#downdload regional settings file
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($regionalsettingsURL,$RegionalSettings)
$webclient.DownloadFile($languagepackURL,$LanguagePack)

# Install Language Pack
Dism /online /Add-Package /PackagePath:$LanguagePack

# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionalSettings`""

# Set languages/culture. Not needed perse.
Set-WinSystemLocale zh-TW
Set-WinUserLanguageList -LanguageList zh-TW -Force
Set-Culture -CultureInfo zh-TW
Set-WinHomeLocation -GeoId 12
Set-TimeZone -Name "Taipei Standard Time"


# cscript c:\windows\system32\slmgr.vbs /ipk CB7KF-BWN84-R7R2Y-793K2-8XDDG

# restart virtual machine to apply regional settings to current user. You could also do a logoff and login.
Start-sleep -Seconds 40
Restart-Computer
