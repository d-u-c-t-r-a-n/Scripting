# Verify current policy
Get-ExecutionPolicy

# Set policy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass

Install-Module -Name Microsoft.Graph

# Connect to MS Graph
Connect-MgGraph

# Get available MS Graph permissions in the tenant
(Get-MgContext).Scopes | Format-List * 