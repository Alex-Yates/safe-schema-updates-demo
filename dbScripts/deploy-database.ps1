$dbUpSchema = "DbUp"
$dbUpTable = "Journal"
$scriptPath = "$PSScriptRoot/Scripts"

Write-Output "Database scripts directory: $scriptPath"
Write-Output "connectionString: $connectionString"

Write-Output "Loading DbUp DLLs"

# You need to download these in advance
Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'       # https://www.nuget.org/packages/dbup-core/
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'  # https://www.nuget.org/packages/dbup-sqlserver/

Write-Output "Preparing DbUp migration"
$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, $connectionString)
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
Write-Output "Performing DbUp migration"
$upgradeResult = $dbUp.Build().PerformUpgrade()