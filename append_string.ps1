# Set the directory path
$directoryPath = "C:\Path\To\Your\Directory"

# Set the search string
$searchString = "YourSearchString"

# Set the new string to add after the searched string
$newString = "NewStringToAdd"

# Set the output file path
$outputFilePath = "C:\Path\To\Your\Output\File\output.txt"

# Find all "*.xml" files in the directory and subdirectories
$xmlFiles = Get-ChildItem -Path $directoryPath -Filter *.xml -Recurse

# Initialize an array to store results
$results = @()

# Iterate through each XML file
foreach ($xmlFile in $xmlFiles) {
    # Read the content of the XML file
    $content = Get-Content $xmlFile.FullName

    # Iterate through each line in the content
    for ($i = 0; $i -lt $content.Count; $i++) {
        # Check if the line contains the search string
        if ($content[$i] -like "*$searchString*") {
            # Add the result to the array
            $result = [PSCustomObject]@{
                Path = $xmlFile.FullName
                Line = $content[$i]
            }
            $results += $result

            # Add the new string after the searched string
            $content[$i] = $content[$i] -replace $searchString, "$searchString$newString"
        }
    }

    # Save the modified content back to the file
    $content | Set-Content $xmlFile.FullName
}

# Output the results to the specified text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath -Encoding UTF8

# Display a message indicating the completion of the script
Write-Host "Script completed. Results are saved in $outputFilePath."
