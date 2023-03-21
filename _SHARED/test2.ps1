
# A powershell script to update the IIS web server settings to add User Agent header and the X-Forwarded-For header to the logs in multiple webservers if there is no any.

# define an array of server names
$servers = @("server1", "server2", "server3")

# iterate through the servers in the array
foreach ($server in $servers) {
    # create a new session to the server
    $session = New-PSSession -ComputerName $server

    # define the name of the IIS site you want to configure
    $siteName = "Default Web Site"

    # get the IIS site object
    $site = Invoke-Command -Session $session -ScriptBlock { Import-Module WebAdministration; Get-Item "IIS:\Sites\$using:siteName" }

    # check if the site has the User Agent and X-Forwarded-For headers configured
    $logConfig = $site.logFile
    $hasUserAgent = $logConfig.customFields.UserAgent
    $hasXForwardedFor = $logConfig.customFields.XForwardedFor

    # if either of the headers is missing, add it to the log configuration
    if (!$hasUserAgent) {
        $logConfig.customFields.Add("UserAgent", "{User-Agent}")
    }
    if (!$hasXForwardedFor) {
        $logConfig.customFields.Add("XForwardedFor", "{X-Forwarded-For}")
    }

    # save the changes to the IIS site object
    Invoke-Command -Session $session -ScriptBlock { 
        Import-Module WebAdministration; 
        Set-ItemProperty "IIS:\Sites\$using:siteName" -Name logFile -Value $using:logConfig 
    }

    # close the session to the server
    Remove-PSSession $session
}

# To use this script, you would need to replace the names of the servers in the $servers array with the names of your own servers. 
# You may also need to modify the $siteName variable if the name of the IIS site you want to configure is different.

# The script uses PowerShell remoting to create a session to each server in the array, 
# then uses the Import-Module WebAdministration cmdlet to load the IIS PowerShell module. 
# It then checks if the IIS site has the User Agent and X-Forwarded-For headers configured in the log file settings. 
# If either header is missing, the script adds it to the log configuration using the customFields.Add() method. 
# Finally, the script saves the changes to the IIS site object and closes the session to the server.


# Note that this script assumes that you have administrative access to the servers and that the necessary PowerShell modules are installed. 
# It also assumes that you have already enabled logging for the IIS site in question.
