# Script to define regional settings on Azure Virtual Machines deployed from the market place
# Author: Alexandre Verkinderen
# Blogpost: https://mscloud.be/configure-regional-settings-and-windows-locales-on-azure-virtual-machines/
#
######################################33

#variables
$regionalsettingsURL = "https://raw.githubusercontent.com/5L2FStudio/Azure/master/101-ServerBuild/TWRegion.xml"
$RegionalSettings = "D:\TWRegion.xml"


#downdload regional settings file
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($regionalsettingsURL,$RegionalSettings)


# Set Locale, language etc. 
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionalSettings`""

# Set languages/culture. Not needed perse.
Set-WinSystemLocale zh-TW
Set-WinUserLanguageList -LanguageList zh-TW -Force
Set-Culture -CultureInfo zh-TW
Set-WinHomeLocation -GeoId 12
Set-TimeZone -Name "Taipei Standard Time"

# restart virtual machine to apply regional settings to current user. You could also do a logoff and login.
Start-sleep -Seconds 40
Restart-Computer
