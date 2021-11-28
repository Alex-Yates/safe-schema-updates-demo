$containerName = $OctopusParameters["Octopus.Project-Name"] + "-" + $OctopusParameters["Octopus.Environment.Name"] + "-" + $OctopusParameters["Octopus.RunbookRun.Id"]

Write-output "SPAWN: Creating data-container"
spawnctl create data-container --image mssql-wideworldimporters --lifetime 1h --name $containerName | out-null

Write-output "SPAWN: Getting data-container info"
$info = spawnctl get data-container $containerName -o yaml

Write-output $info 

$connectionStringRow = $info | Where-Object {$_ -like "connectionstring: *"}
$connectionString = $connectionStringRow -split "connectionstring: "

Set-OctopusVariable -name "DataContainerConnectionString" -value $connectionString