# Install the ImportExcel module if not already installed
# Run this command in an elevated PowerShell window
# Install-Module -Name ImportExcel

$excelFile = "C:\path\to\your\excel.xlsx"
$sheetName = "Sheet1"  # Replace with the actual sheet name
$columnHeader = "Variable"  # Replace with the actual column header

# Import the Excel file using Import-Excel cmdlet
$excelData = Import-Excel -Path $excelFile -WorksheetName $sheetName

# Extract the values from the specified column
$variableList = $excelData.$columnHeader

# Loop through each variable in the list
foreach ($variable in $variableList) {
    # Run your desired command using the variable
    Write-Host "Running command with variable: $variable"
    # Example: Invoke-Expression -Command "your-command-here $variable"

    # Add your command here using the $variable

    # Sleep for a while if needed before the next iteration
    Start-Sleep -Seconds 1
}
