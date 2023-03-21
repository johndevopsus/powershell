Import-Module WebAdministration

# Get all IIS web servers
$servers = Get-WebBinding | Select-Object -ExpandProperty ItemXPath | Select-String '\/bindingInformation="([^:]+):' | ForEach-Object { $_.Matches.Groups[1].Value } | Sort-Object -Unique

# Loop through each server
foreach ($server in $servers) {
    Write-Output "Processing server $server"
    Set-WebConfigurationProperty -Filter "//system.webServer/httpProtocol/customHeaders/add[@name='User-Agent' and @value='']" -PSPath "IIS:\Sites\*" -Location $server -Name "value" -Value "{User-Agent}"
    Set-WebConfigurationProperty -Filter "//system.webServer/httpProtocol/customHeaders/add[@name='X-Forwarded-For' and @value='']" -PSPath "IIS:\Sites\*" -Location $server -Name "value" -Value "{REMOTE_ADDR}"
}



# Here is a PowerShell script that you can use to update IIS web server settings to add User Agent header and the X-Forwarded-For header to the logs in webservers if there is no any:

# Import the WebAdministration module
Import-Module WebAdministration

# Get the list of all websites hosted on the server
$websites = Get-ChildItem IIS:\Sites

# Loop through each website
foreach ($website in $websites) {
    # Get the current log file format for the website
    $logFormat = Get-WebConfigurationProperty "/system.applicationHost/sites/site[@name='$($website.Name)']/logFile" "logFormat"

    # If the log format does not contain the User Agent header or the X-Forwarded-For header, update the log format
    if ($logFormat.IndexOf("User-Agent") -eq -1 -or $logFormat.IndexOf("X-Forwarded-For") -eq -1) {
        $newLogFormat = $logFormat

        # Add the User Agent header to the log format if it is missing
        if ($logFormat.IndexOf("User-Agent") -eq -1) {
            $newLogFormat += ",User-Agent"
        }

        # Add the X-Forwarded-For header to the log format if it is missing
        if ($logFormat.IndexOf("X-Forwarded-For") -eq -1) {
            $newLogFormat += ",X-Forwarded-For"
        }

        # Set the new log format for the website
        Set-WebConfigurationProperty "/system.applicationHost/sites/site[@name='$($website.Name)']/logFile" -Name logFormat -Value $newLogFormat
    }
}


# This script first imports the WebAdministration module, which is required for managing IIS settings using PowerShell. 
# It then gets a list of all websites hosted on the server and loops through each website.

# For each website, it gets the current log file format and checks if it contains the User Agent header and the X-Forwarded-For header. 
# If either header is missing, the script updates the log format to include it and sets the new log format for the website.

# Note that this script assumes that the IIS logging feature is already enabled and configured to write logs to disk. 
# If logging is not enabled, you will need to enable it before running this script.