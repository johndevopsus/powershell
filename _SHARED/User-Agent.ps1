# Set variables
$logPath = "C:\inetpub\logs\LogFiles\W3SVC1\u_ex*.log"
$headerUA = "User-Agent"
$headerXFF = "X-Forwarded-For"

# Get log files
$logFiles = Get-ChildItem $logPath

# Loop through log files
foreach ($logFile in $logFiles) {

    # Read log file
    $logData = Get-Content $logFile.FullName

    # Loop through log data
    for ($i=0; $i -lt $logData.Count; $i++) {

        # Check if line is a header
        if ($logData[$i] -match "^#Fields:") {

            # Check if headers already contain User-Agent and X-Forwarded-For
            $headers = $logData[$i].split(" ")
            if ($headers -contains $headerUA -and $headers -contains $headerXFF) {
                Write-Host "Headers already exist in $($logFile.Name)"
            }
            else {
                # Add User-Agent and X-Forwarded-For headers
                $headers += $headerUA, $headerXFF
                $logData[$i] = "#Fields: " + $headers.join(" ")
