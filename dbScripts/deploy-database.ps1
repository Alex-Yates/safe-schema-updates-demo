param (
	$connectionString = "",
	$journalSchemaName = "dbup",
	$journalTableName = "Journal",
	$databaseName = "WideWorldImporters"
)

$pathToDbUp = "C:\Program Files\DbUp\DbUpDemo.exe"
Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'
$scriptPath = "$PSScriptRoot\Scripts"

Write-Output "scriptPath: $scriptPath"
Write-Output "connectionString: $connectionString"

$pathToDbUp = [DbUp.DeployChanges]::To
$pathToDbUp = [SqlServerExtensions]::SqlDatabase($dbUp, "$connectionString;database=$databaseName;Connection Timeout=120;")   
$pathToDbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$pathToDbUp = [SqlServerExtensions]::JournalToSqlTable($pathToDbUp, $journalSchemaName, $journalTableName)
$pathToDbUp = [StandardExtensions]::LogToConsole($dbUp)
$upgradeResult = $pathToDbUp.Build().PerformUpgrade()