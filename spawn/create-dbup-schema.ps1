$sqlInstance = $OctopusParameters["Octopus.Action[Spawn new data container].Output.sqlInstance"]

$plaintextPassword = $OctopusParameters["Octopus.Action[Spawn new data container].Output.saPassword"]
$plaintextPassword = $plaintextPassword -replace '\s','' # removing spaces

$encryptedPassword = $plaintextPassword | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sa", $encryptedPassword

$createFacebook = @"
CREATE DATABASE [Facebook]
GO
USE [Facebook]
GO
CREATE SCHEMA DbUp
GO
"@

$createToggles = @"
CREATE DATABASE [Toggles]
GO
USE [Toggles]
GO
CREATE SCHEMA DbUp
GO
"@

Write-Output "Importing module dbatools"
import-module dbatools

Write-Output "Creating Facebook database"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Query $createFacebook -SqlCredential $cred
Write-Output $result

Write-Output "Creating Toggles database"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Query $createToggles -SqlCredential $cred
Write-Output $result