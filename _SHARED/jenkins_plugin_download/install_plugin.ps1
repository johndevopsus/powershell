$jenkinsURL = "http://localhost:8080"  # Replace with the URL of your Jenkins controller
$pluginsDir = "C:\path\to\your\plugins\directory"  # Replace with the path to your plugin files directory

# Get a list of plugin files in the directory
$pluginFiles = Get-ChildItem -Path $pluginsDir -Filter "*.hpi"

# Loop through each plugin file
foreach ($pluginFile in $pluginFiles) {
    $pluginName = $pluginFile.Name

    # Build the command to install the plugin using Jenkins CLI
    $installCommand = "java -jar jenkins-cli.jar -s $jenkinsURL install-plugin '$pluginName'"

    # Run the command to install the plugin
    Write-Host "Installing plugin: $pluginName"
    Invoke-Expression -Command $installCommand

    # Sleep for a while if needed before the next iteration
    Start-Sleep -Seconds 1
}
