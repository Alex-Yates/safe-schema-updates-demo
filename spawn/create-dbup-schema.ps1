$sqlInstance = $OctopusParameters["Octopus.Action[Spawn new data container].Output.sqlInstance"]

$plaintextPassword = $OctopusParameters["Octopus.Action[Spawn new data container].Output.saPassword"]

Write-Output "Plaintext database password is _$plaintextPassword,_"

$encryptedPassword = $plaintextPassword | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sa", $encryptedPassword

$query = "CREATE SCHEMA DbUp"

Write-Output "Importing module dbatools"
import-module dbatools

Write-Output "Creating DbUp schema"
Write-Output "Executing the following command: invoke-dbaquery -SqlInstance $sqlInstance -Database WideWorldImporters -Query $query"
$result = invoke-dbaquery -SqlInstance $sqlInstance -Database WideWorldImporters -Query $query -SqlCredential $cred
Write-Output $result