[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName
)

try {
    # Get all websites in the resource group
    $websites = Get-AzureRmWebApp -ResourceGroupName $ResourceGroupName

    if (-not $websites) {
        Write-Warning "No web apps found in resource group '$ResourceGroupName'."
        return
    }

    Write-Output "Starting the restart process for web apps in '$ResourceGroupName'."

    foreach ($website in $websites) {
        Write-Output "Stopping web app: $($website.Name)..."
        try {
            Stop-AzureRmWebApp -Name $website.Name -ResourceGroupName $ResourceGroupName -ErrorAction Stop
            Write-Output "Successfully stopped $($website.Name)."
        } catch {
            Write-Warning "Failed to stop $($website.Name): $_"
        }
    }

    Write-Output "Restart process completed."
} catch {
    Write-Error "An error occurred while retrieving web apps: $_"
}
