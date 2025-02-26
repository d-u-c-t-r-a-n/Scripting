# Verify current policy
Get-ExecutionPolicy

# Set policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Install-Module -Name Microsoft.Graph

# Connect to Microsoft Graph
Connect-MgGraph