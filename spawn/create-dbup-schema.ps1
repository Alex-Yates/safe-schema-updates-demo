$sqlInstance = $OctopusParameters["Octopus.Action[Spawn new data container].Output.sqlInstance"]

$plaintextPassword = $OctopusParameters["Octopus.Action[Spawn new data container].Output.saPassword"]
$plaintextPassword = $plaintextPassword -replace '\s','' # removing spaces

$encryptedPassword = $plaintextPassword | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sa", $encryptedPassword

Write-Output "Importing module dbatools"
import-module dbatools

Write-Output "Creating Facebook database"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Query "CREATE DATABASE [Facebook]" -SqlCredential $cred
Write-Output $result

Write-Output "Creating Facebook DbUp schema"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Database Facebook -Query "CREATE SCHEMA DbUp" -SqlCredential $cred
Write-Output $result

Write-Output "Creating Toggles database"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Query "CREATE DATABASE [Toggles]" -SqlCredential $cred
Write-Output $result

Write-Output "Creating Toggles DbUp schema"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Database Toggles -Query "CREATE SCHEMA DbUp" -SqlCredential $cred
Write-Output $result