$sqlInstance = $OctopusParameters["Octopus.Action[Spawn new data container].Output.server"]
$plaintextPassword = $OctopusParameters["Octopus.Action[Spawn new data container].Output.saPassword"]
$encryptedPassword = $saPassword | ConvertTo-SecureString -AsPlainText -Force
$query = "CREATE SCHEMA DbUp"

Write-Output "Importing module dbatools"
import-module dbatools

Write-Output "Creating DbUp schema"
invoke-dbaquery -SqlInstance $sqlInstance -Query $query 