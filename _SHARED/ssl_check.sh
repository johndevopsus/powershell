$websites = @(
    "example1.com",
    "example2.com",
    "example3.com"
)

foreach ($website in $websites) {
    $request = [System.Net.WebRequest]::Create("https://$website")
    try {
        $response = $request.GetResponse()
        $certificate = $response.GetResponseStream().GetResponseCertificate()
        $expirationDate = $certificate.GetExpirationDateString()
        Write-Output "Website: $website"
        Write-Output "SSL Certificate Expiration Date: $expirationDate"
        Write-Output ""
        $response.Close()
    }
    catch {
        Write-Output "Failed to retrieve SSL certificate for website: $website"
        Write-Output ""
    }
}
