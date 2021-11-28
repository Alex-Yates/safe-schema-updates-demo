param (
	$databaseName = "WideWorldImporters",
	$databaseServer =  "",
	$dbUpSchema = "DbUp",
	$dbUpTable = "Journal"
)

$scriptPath = "$PSScriptRoot/Scripts"

$databaseServer = "Data Source=kvjk46t9.instances.spawn.cc,30614;User ID=sa;Password=PhLZGK9EJ4dWJ2dd"

Write-Output "DatabaseServer is: $databaseServer"

Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'

$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, "$databaseServer;database=$databaseName;Connection Timeout=10;")
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
$upgradeResult = $dbUp.Build().PerformUpgrade()