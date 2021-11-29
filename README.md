# safe-schema-updates-demo

To follow this demo, you need to do the following set-up:

Set up a Windows target and give it the role "sqlJumpbox":
https://octopus.com/docs/infrastructure/deployment-targets/windows-targets

Set up at least one Octopus Deploy Environment:
https://octopus.com/docs/infrastructure/environments

Setup a GitHub repository feed. You can use Anonymous authentication since this repo is public. (This avoids us needing to use packages since you can read the scripts directly from this Git repo):
https://octopus.com/docs/packaging-applications/package-repositories/github-feeds

Create a Spawn.cc account:
https://app.spawn.cc/

Download and install spawnctl.exe on your "sqlJumpbox" target, update your PATH environment variable, and set up the authentication by running > spawnctl auth:
https://docs.spawn.cc/getting-started/installation

Download the DbUp DLLs on your "sqlJumpbox" target and save them in C:\Program Files\DbUp:
dbup-core.dll       # https://www.nuget.org/packages/dbup-core/
dbup-sqlserver.dll  # https://www.nuget.org/packages/dbup-sqlserver/

Create an Octopus Deploy Project:
https://octopus.com/docs/projects

Create an Octopus Depoy API Key and save it as a private project variable called "ApiKey":
Creating API keys: https://octopus.com/docs/octopus-rest-api/how-to-create-an-api-key
Creating project variables: https://octopus.com/docs/projects/variables

Create an Octopus Runbook with three Run a Script steps. Each should reference a script from a package, search the your GitHub feed for packages, and look for packages from this repo. Your three steps should run the following scripts in the following order:
1. spawn/spawn-data-container.ps1
2. spawn/create dbup schema.ps1
3. spawn/update-project-variables.ps1

Run your runbook in your environment. This should provision you a data container (SQL instance) using Spawn. All Spawn data containers are set to auto-delete after 1 hour to avoid any unexpected bills. You should be able to connect to the instance using SSMS. Check the Runbook logs or Octopus Project Variables for all your connection details.

Set up a deployment process with 2 steps to Run a Script. Run the script from a package, selecting your GitHub feed and this repo. Your steps should execute the following scripts to build out the demo databases. Note, if using the Octopus Deploy 'Config as Code' feature, you can find OCL scripts for the deployment process in .\octopus:
1. dbScripts/deploy-facebook.ps1
2. dbScripts/deploy-toggles.ps1
(More infor about Config as Code: https://octopus.com/docs/projects/version-control)
