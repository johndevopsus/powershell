# Set the directory path where you want to search for config.xml files
$directoryPath = "C:\Path\To\Your\Directory"

# Define a list of strings to search for in the config.xml files
$searchStrings = @("String1", "String2", "String3")

# Define a dictionary of strings to append after the searched string
$appendStrings = @{
    "String1" = "AppendedText1"
    "String2" = "AppendedText2"
    "String3" = "AppendedText3"
}

# Specify the output file path for the results
$outputFilePath = "C:\Path\To\Your\OutputFile.txt"

# Initialize an array to store the results
$results = @()

# Iterate through each search string
foreach ($searchString in $searchStrings) {
    # Find all config.xml files containing the current search string
    $files = Get-ChildItem -Path $directoryPath -Filter "config.xml" -Recurse | 
             Select-String -Pattern $searchString | 
             Select-Object Path, Line

    # Iterate through each result and update the file
    foreach ($file in $files) {
        # Get the content of the file
        $content = Get-Content -Path $file.Path

        # Find the line number in the content
        $lineNumber = $file.LineNumber

        # Append the new string after the searched string
        $content[$lineNumber - 1] += " $($appendStrings[$searchString])"

        # Update the file with the modified content
        Set-Content -Path $file.Path -Value $content

        # Add the result to the array
        $results += [PSCustomObject]@{
            Path = $file.Path
            Line = $file.Line
        }
    }
}

# Export the results to a text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath

# Display a message indicating the script has completed
Write-Host "Script completed. Results saved to: $outputFilePath"
