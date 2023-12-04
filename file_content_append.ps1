# Specify the directory path and the string to search for
$directoryPath = "C:\Path\To\Your\Directory"
$searchString = "YourSearchString"

# Specify the output file path
$outputFilePath = "C:\Path\To\Your\Output\Result.txt"

# Find all "*.xml" files in the directory and subdirectories
$xmlFiles = Get-ChildItem -Path $directoryPath -Filter *.xml -Recurse

# Initialize an array to store the results
$results = @()

# Iterate through each XML file
foreach ($xmlFile in $xmlFiles) {
    # Get the lines that contain the search string
    $matchingLines = Get-Content $xmlFile.FullName | Select-String -Pattern $searchString

    # Iterate through each matching line
    foreach ($line in $matchingLines) {
        # Add the result to the array
        $result = [PSCustomObject]@{
            Path = $xmlFile.FullName
            Line = $line.Line
        }
        $results += $result
    }
}

# Export the results to a text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath

# Display a message indicating the completion
Write-Host "Search complete. Results saved to: $outputFilePath"



-------------------
      APPEND NEW STRING

# Set the directory where the *.xml files are located
$directoryPath = "C:\Path\To\Your\Directory"

# Set the search string
$searchString = "YourSearchString"

# Set the string to append after the matched string
$newString = "AppendedString"

# Set the output file path
$outputFilePath = "C:\Path\To\Your\Output\File.txt"

# Find *.xml files in the directory and its subdirectories
$xmlFiles = Get-ChildItem -Path $directoryPath -Filter *.xml -Recurse

# Initialize an array to store results
$results = @()

# Iterate through each *.xml file
foreach ($file in $xmlFiles) {
    # Read the content of the file
    $content = Get-Content $file.FullName

    # Find lines that contain the search string
    $matchingLines = $content | Where-Object { $_ -match $searchString }

    # Iterate through each matching line
    foreach ($line in $matchingLines) {
        # Get the line number
        $lineNumber = ($content | Measure-Object | ForEach-Object { $_.LineNumber }) + 1

        # Append the new string after the searched string
        $modifiedLine = $line -replace $searchString, "$searchString$newString"

        # Save the results in the array
        $results += [PSCustomObject]@{
            PATH = $file.FullName
            LINE = "$lineNumber: $modifiedLine"
        }
    }
}

# Export the results to a text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath

Write-Host "Results exported to $outputFilePath"




-------


# Set the directory path
$directoryPath = "C:\Path\To\Your\Directory"

# Set the search string and the new string to update
$searchString = "YourSearchString"
$newString = "YourNewString"

# Set the output file path
$outputFilePath = "C:\Path\To\Your\Output\Result.txt"

# Get all *.xml files in the directory and subdirectories
$xmlFiles = Get-ChildItem -Path $directoryPath -Filter *.xml -Recurse

# Initialize an array to store the results
$results = @()

# Iterate through each XML file
foreach ($xmlFile in $xmlFiles) {
    # Read the content of the file
    $content = Get-Content -Path $xmlFile.FullName

    # Search for the string in each line
    $matchingLines = $content | Where-Object { $_ -like "*$searchString*" }

    # Iterate through matching lines and update the file
    foreach ($line in $matchingLines) {
        $lineNumber = $content.IndexOf($line) + 1
        $updatedLine = $line -replace [regex]::Escape($searchString), $newString

        # Update the content of the file
        $content[$lineNumber - 1] = $updatedLine

        # Add the result to the array
        $results += [PSCustomObject]@{
            Path = $xmlFile.FullName
            Line = $line
        }
    }

    # Save the updated content back to the file
    $content | Set-Content -Path $xmlFile.FullName
}

# Export the results to a text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath
