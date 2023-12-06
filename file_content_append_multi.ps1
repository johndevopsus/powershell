# Set the directory where the "config.xml" files are located
$directoryPath = "C:\Path\To\Your\Directory"

# Set the list of strings to search for
$searchStrings = @("String1", "String2", "String3")

# Set the dictionary for string replacement (if needed)
$replacementDictionary = @{
    "String1" = "NewString1"
    "String2" = "NewString2"
    "String3" = "NewString3"
}

# Set the output file path
$outputFilePath = "C:\Path\To\Your\Output\Result.txt"

# Initialize an array to store the results
$results = @()

# Get all "config.xml" files in the directory and its subdirectories
$configFiles = Get-ChildItem -Path $directoryPath -Filter "config.xml" -Recurse

# Iterate through each file
foreach ($file in $configFiles) {
    # Read the content of the file
    $fileContent = Get-Content $file.FullName

    # Iterate through each search string
    foreach ($searchString in $searchStrings) {
        # Search for the string in the file content
        $matchingLines = $fileContent | Select-String -Pattern $searchString

        # Iterate through each matching line
        foreach ($line in $matchingLines) {
            # Get the line number
            $lineNumber = $line.LineNumber

            # Get the line content
            $lineContent = $line.Line

            # Add the replacement string if applicable
            if ($replacementDictionary.ContainsKey($searchString)) {
                $lineContent += $replacementDictionary[$searchString]
            }

            # Add the result to the array
            $result = [PSCustomObject]@{
                Path = $file.FullName
                Line = "$lineNumber: $lineContent"
            }

            $results += $result
        }
    }
}

# Export the results to a text file
$results | Format-Table -AutoSize | Out-File -FilePath $outputFilePath
Write-Host "Results saved to: $outputFilePath"
