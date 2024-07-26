# Using this script, 
# - install all given plugins from a .csv list to jenkins controller.


$excelFile = "C:\PATH\TO\FILE.csv"
$jenkinsURL = "http://JENKINS_URL:PORT"  # Replace with the URL of your Jenkins controller
$sheetName = "Sheet1"  # Replace with the actual sheet name
$columnHeader = "PLUGIN_ID"  # Replace with the actual column header

# Import the Excel file using Import-Excel cmdlet
$excelData = Import-csv -Path $excelFile -WorksheetName $sheetName

# Extract the values from the specified column
$plugins = $excelData.$columnHeader

# Loop through each variable in the list
foreach ($plugin in $plugins) { 

    #Write-Host "Installing plugin: $plugin"
    # Build the command to install the plugin using Jenkins CLI
    $installCommand = "java -jar jenkins-cli.jar -s $jenkinsURL -auth '@creds' install-plugin $plugin"
    Write-Host $installCommand
    Invoke-Expression -Command $installCommand
    
    # Sleep for a while if needed before the next iteration
    Start-Sleep -Seconds 1

}


