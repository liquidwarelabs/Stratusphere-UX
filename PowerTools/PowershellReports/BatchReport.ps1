### Set Cert Trust ###

if ("TrustAllCertsPolicy" -as [type]) {} else {
        add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@

$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12,Tls13'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}

###


#Main Script# 

$Reportlistpath = "c:\UXTestURLsv2.csv"
$Reports = import-csv $Reportlistpath
$ReportOutputFolder = "C:\Temp\Reports"

#GetCSV Download Time#

foreach ($url in $reports){
$reportname = $url.ReportName + ".csv"
Invoke-WebRequest $url.urls -OutFile $ReportOutputFolder\$reportname
}