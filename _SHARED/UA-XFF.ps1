# Load the WebAdministration module
Import-Module WebAdministration

# Set the IIS log format to include User-Agent and X-Forwarded-For headers
Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile/customFields -Name collection -Value @{logFieldName='User-Agent'; sourceName='User-Agent'}
Set-WebConfigurationProperty -Filter /system.applicationHost/sites/siteDefaults/logFile/customFields -Name collection -Value @{logFieldName='X-Forwarded-For'; sourceName='X-Forwarded-For'}

# Apply the changes to all IIS sites
$Sites = Get-ChildItem IIS:\Sites
foreach ($Site in $Sites) {
    $LogConfig = Get-WebConfigurationProperty -Filter /system.applicationHost/sites/site[@name='$($Site.name)']/logFile/customFields -Name collection
    $Fields = $LogConfig + @{logFieldName='User-Agent'; sourceName='User-Agent'}, @{logFieldName='X-Forwarded-For'; sourceName='X-Forwarded-For'}
    Set-WebConfigurationProperty -Filter /system.applicationHost/sites/site[@name='$($Site.name)']/logFile/customFields -Name collection -Value $Fields
}


# This script first loads the WebAdministration module, which allows us to interact with IIS using PowerShell. 
# It then sets the IIS log format to include the User-Agent and X-Forwarded-For headers using the Set-WebConfigurationProperty cmdlet. 
# Finally, it applies these changes to all IIS sites using a foreach loop that iterates through each site and updates its log configuration.