param (
	$databaseName = "WideWorldImporters",
	$databaseServer =  "",
	$dbUpSchema = "DbUp",
	$dbUpTable = "Journal"
)

$scriptPath = "$PSScriptRoot/Scripts"

$databaseConnectionString = 'Data Source=kvjk46t9.instances.spawn.cc,32182;User ID=sa;Password=BP27cMYWx6XKWHlN;database=WideWorldImporters;Connection Timeout=10;'

Write-Output "The connection string is: $databaseConnectionString"

Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'

$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, $databaseConnectionString)
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
$upgradeResult = $dbUp.Build().PerformUpgrade()