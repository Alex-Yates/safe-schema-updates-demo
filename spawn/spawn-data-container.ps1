$containerName = $OctopusParameters["Octopus.Project.Name"] + "-" + $OctopusParameters["Octopus.Environment.Name"] + "-" + $OctopusParameters["Octopus.RunbookRun.Id"]

Write-output "SPAWN: Creating data-container"
spawnctl create data-container --image mssql-wideworldimporters --lifetime 1h --name $containerName | out-null

Write-output "SPAWN: Getting data-container info"
$info = spawnctl get data-container $containerName -o yaml

Write-output $info 

$connectionStringRow = $info | Where-Object {$_ -like "connectionstring: *"}
$rawConnectionString = $connectionStringRow -split "connectionstring: "
$WideWorldImportersConnString = $rawConnectionString -replace ("master;","WideWorldImporters;")
$connectionString = $WideWorldImportersConnString + ";Connection Timeout=10;"

$saPasswordRow = $info | Where-Object {$_ -like "connectionstring: *"}
$saPasswordwithSpaces = $saPasswordRow -split "password: "
$saPassword = $saPasswordwithSpaces.trim()

$hostRow = $info | Where-Object {$_ -like "host: *"}
$sqlHostWithSpaces = $hostRow -split "host: "
$sqlhost = $sqlHostWithSpaces.trim()

$portRow = $info | Where-Object {$_ -like "port: *"}
$portWithSpaces = $portRow -split "port: "
$port = $portWithSpaces.trim()

$sqlInstance = "$sqlhost,$port"

Set-OctopusVariable -name "DataContainerConnectionString" -value $connectionString
Set-OctopusVariable -name "saPassword" -value $saPassword 
Set-OctopusVariable -name "sqlInstance" -value $sqlInstance