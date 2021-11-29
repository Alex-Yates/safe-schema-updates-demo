# Config
$scriptPath = "$PSScriptRoot/FacebookScripts"
$dbConnectionString = $FacebookConnString
$dbUpSchema = "DbUp"
$dbUpTable = "Journal"

# Just logging
Write-Output "Database scripts directory: $scriptPath"
Write-Output "dbConnectionString: $dbConnectionString"
Write-Output "connectionString: $dbConnectionString"
Write-Output "FacebookConnString: $FacebookConnString"
Write-Output "OctopusParameters["FacebookConnString"]: $OctopusParameters["FacebookConnString"]"


# You need to download these to the tentacle in advance
Write-Output "Loading DbUp DLLs"
Add-Type -Path 'C:\Program Files\DbUp\dbup-core.dll'       # https://www.nuget.org/packages/dbup-core/
Add-Type -Path 'C:\Program Files\DbUp\dbup-sqlserver.dll'  # https://www.nuget.org/packages/dbup-sqlserver/

# Performing DB update
Write-Output "Preparing DbUp migration"
$dbUp = [DbUp.DeployChanges]::To
$dbUp = [SqlServerExtensions]::SqlDatabase($dbUp, $dbConnectionString)
$dbUp = [StandardExtensions]::WithScriptsFromFileSystem($dbUp, $scriptPath)
$dbUp = [SqlServerExtensions]::JournalToSqlTable($dbUp, $dbUpSchema, $dbUpTable)
$dbUp = [StandardExtensions]::LogToConsole($dbUp)
Write-Output "Performing DbUp migration"
$upgradeResult = $dbUp.Build().PerformUpgrade()