# Prerequisite:
## System Managed Identity needs to be configured on the Automation account.
## An hourly schedule needs to be created in the Automation account to trigger this runbook.

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$VMName
)

# Authenticate to Azure using the managed identity
Connect-AzAccount -Identity

# Get the VM status
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status

# Extract the power state
$vmState = ($vm.Statuses | Where-Object { $_.Code -match "PowerState/" }).DisplayStatus

Write-Output "Current state of VM '$VMName': $vmState"

# Check if the VM is already running
if ($vmState -eq "VM running") {
    Write-Output "The VM '$VMName' is already running. No action required."
} elseif ($vmState -eq "VM stopped" -or $vmState -eq "VM deallocated") {
    Write-Output "Starting VM '$VMName'..."
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
    Write-Output "VM '$VMName' has been started successfully."
} else {
    Write-Output "VM '$VMName' is in an unknown state: $vmState. No action taken."
}

