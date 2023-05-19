$csvFile = "C:\Users\Admin\Desktop\plugins.csv"
$baseURL = "https://ftp-chi.osuosl.org/pub/jenkins/"

# Read the CSV file
$data = Import-Csv -Path $csvFile

# Loop through each row in the CSV file
foreach ($row in $data) {
    # Extract the variable value from each row
    $link = $row.link

    # Construct the URL for downloading the file
    $downloadURL = "$baseURL$link/latest/$link.hpi"

    # Specify the path where the file will be saved
    $savePath = "C:\Users\Admin\Desktop\$link.hpi"

    # Download the file using wget
    Write-Host "Downloading file: $link.hpi"
    Invoke-Expression -Command "wget $downloadURL -OutFile '$savePath'"

    # Sleep for a while if needed before the next iteration
    Start-Sleep -Seconds 1
}
