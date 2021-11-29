param (
	$databaseName = "WideWorldImporters",
	$databaseConnectionString =  "",
	$dbUpSchema = "DbUp",
	$dbUpTable = "Journal"
)

$scriptPath = "$PSScriptRoot/Scripts"

Write-Output "Database scripts directory: $databaseConnectionString"
Write-Output "Database connection string: $databaseConnectionString"

Write-Output "Loading DbUp DLLs"

# You need to download these in advance
Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'       # https://www.nuget.org/packages/dbup-core/
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'  # https://www.nuget.org/packages/dbup-sqlserver/

Write-Output "Performing DbUp migration"

$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, $databaseConnectionString)
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
$upgradeResult = $dbUp.Build().PerformUpgrade()