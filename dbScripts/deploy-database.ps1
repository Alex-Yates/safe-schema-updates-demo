param (
	$databaseName = "WideWorldImporters",
	$databaseServer =  "",
	$dbUpSchema = "DbUp",
	$dbUpTable = "Journal"
)

$scriptPath = "$PSScriptRoot/Scripts"

Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'

$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, "$databaseServer;database=$databaseName;Connection Timeout=10;")
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
$upgradeResult = $dbUp.Build().PerformUpgrade()