# Define the log file
$logFile = "web_logs_2024_01_24.log"

# Define patterns for the main three OWASP vulnerabilities
$patternInjection = "UNION|SELECT|INSERT|UPDATE|DELETE|DROP|--|/\*"
$patternBrokenAuth = "/login|PHPSESSID"
$patternXSS = "(?i)<script|<img src|onerror=|alert\(|<iframe|<body onload=|<a href=|<div style=|javascript:|<svg onload=|<embed|<object|<link|<meta|<style|document\.cookie|document\.write|window\.location|eval\(|expression\(|src=|onload=|onmouseover=|onclick="

# Count occurrences of each pattern in the log file
$a1Count = (Select-String -Pattern $patternInjection -Path $logFile).Count
$a2Count = (Select-String -Pattern $patternBrokenAuth -Path $logFile).Count
$a3Count = (Select-String -Pattern $patternXSS -Path $logFile).Count

# Define examples and recommendations
$injectionExample = "Example: SELECT * FROM users WHERE username='admin' -- and password='password'"
$injectionRecommendation = "Recommendation: Use parameterized queries and prepared statements to prevent injection attacks."

$brokenAuthExample = "Example: Attacker uses a stolen session ID (PHPSESSID) to gain unauthorized access."
$brokenAuthRecommendation = "Recommendation: Implement multi-factor authentication and secure session management practices."

$xssExample = "Example: <script>alert('XSS')</script>"
$xssRecommendation = "Recommendation: Validate and escape all user inputs, and use Content Security Policy (CSP) headers."

# Output the results with additional information
Write-Output "==========================================="
Write-Output "OWASP Vulnerabilities Found in Log File:"
Write-Output "==========================================="
Write-Output "Injection - $a1Count"
Write-Output "-------------------------------------------"
Write-Output "$injectionExample"
Write-Output "$injectionRecommendation"
Write-Output ""
Write-Output "Broken Authentication - $a2Count"
Write-Output "-------------------------------------------"
Write-Output "$brokenAuthExample"
Write-Output "$brokenAuthRecommendation"
Write-Output ""
Write-Output "Cross-Site Scripting (XSS) - $a3Count"
Write-Output "-------------------------------------------"
Write-Output "$xssExample"
Write-Output "$xssRecommendation"
Write-Output "==========================================="
