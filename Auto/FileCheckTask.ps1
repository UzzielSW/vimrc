# File Check and Creation Task Template
# This script checks if a file exists and creates it if it doesn't

# Configuration - Modify these variables as needed
$FilePath = "C:\Users\braya\Videos\edit.md"
$FileContent = @"
This file was created automatically on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

# Log file path (optional - for tracking script execution)
$LogPath = "C:\Users\braya\FileCheckTask.log"

try {
    # Write to log (optional)
    $LogMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - Checking file: $FilePath"
    Add-Content -Path $LogPath -Value $LogMessage

    # Check if file exists
    if (-Not (Test-Path -Path $FilePath)) {
        # File doesn't exist, create it
        New-Item -Path $FilePath -ItemType File -Force
        Set-Content -Path $FilePath -Value $FileContent
        
        $SuccessMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - File created successfully: $FilePath"
        Add-Content -Path $LogPath -Value $SuccessMessage
        Write-Host "File created: $FilePath" -ForegroundColor Green
    } else {
        # File exists
        $ExistsMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - File already exists: $FilePath"
        Add-Content -Path $LogPath -Value $ExistsMessage
        Write-Host "File already exists: $FilePath" -ForegroundColor Yellow
    }
} catch {
    # Handle errors
    $ErrorMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - Error: $($_.Exception.Message)"
    Add-Content -Path $LogPath -Value $ErrorMessage
    Write-Error "An error occurred: $($_.Exception.Message)"
}