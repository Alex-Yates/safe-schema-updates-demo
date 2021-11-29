$containerName = $OctopusParameters["Octopus.Project.Name"] + "-" + $OctopusParameters["Octopus.Environment.Name"] + "-" + $OctopusParameters["Octopus.RunbookRun.Id"]

Write-output "SPAWN: Creating data-container"
spawnctl create data-container --image mssql-empty --lifetime 1h --name $containerName | out-null

Write-output "SPAWN: Getting data-container info"
$info = spawnctl get data-container $containerName -o yaml

Write-output $info 

$connectionStringRow = $info | Where-Object {$_ -like "connectionstring: *"}
$rawConnectionString = $connectionStringRow -split "connectionstring: "
$rawConnectionStringWithTimeout = $rawConnectionString + ";Connection Timeout=10;"

$FacebookConnString = $rawConnectionStringWithTimeout -replace ("master;","Facebook;")
$TogglesConnString = $rawConnectionStringWithTimeout -replace ("master;","Toggles;")


$saPasswordRow = $info | Where-Object {$_ -like "password: *"}
$saPassword = $saPasswordRow -split "password: "
$saPassword = $saPassword -replace '\s','' # removing spaces

$hostRow = $info | Where-Object {$_ -like "host: *"}
$sqlHost = $hostRow -split "host: "
$sqlHost = $sqlHost -replace '\s','' # removing spaces

$portRow = $info | Where-Object {$_ -like "port: *"}
$port = $portRow -split "port: "
$port = $port -replace '\s','' # removing spaces

$sqlInstance = "$sqlhost,$port"
$sqlInstance = $sqlInstance -replace '\s','' # removing spaces

Set-OctopusVariable -name "FacebookConnString" -value $FacebookConnString
Set-OctopusVariable -name "TogglesConnString" -value $TogglesConnString
Set-OctopusVariable -name "saPassword" -value $saPassword 
Set-OctopusVariable -name "sqlInstance" -value $sqlInstance