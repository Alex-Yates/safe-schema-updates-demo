$sqlInstance = $OctopusParameters["Octopus.Action[Spawn new data container].Output.server"]

$plaintextPassword = $OctopusParameters["Octopus.Action[Spawn new data container].Output.saPassword"]
$encryptedPassword = $plaintextPassword | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sa", $encryptedPassword

$query = "CREATE SCHEMA DbUp"

Write-Output "Importing module dbatools"
import-module dbatools

Write-Output "Creating DbUp schema"
invoke-dbaquery -SqlInstance $sqlInstance -Query $query -SqlCredential $cred