Write-host \"Kill OneDrive Process\"
taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

Write-Host "Copy all OneDrive to Root UserProfile"
Start-Process -FilePath robocopy -ArgumentList \"$env:USERPROFILE\\OneDrive $env:USERPROFILE /e /xj\" -NoNewWindow -Wait
Write-Host "Remove OneDrive"
Start-Process -FilePath winget -ArgumentList "uninstall -e --purge --force --silent Microsoft.OneDrive " -NoNewWindow -Wait

Write-Host "Removing OneDrive leftovers"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:localappdata\\Microsoft\\OneDrive\"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:programdata\\Microsoft OneDrive\"
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:systemdrive\\OneDriveTemp\"
If ((Get-ChildItem "$env:userprofile\OneDrive" -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:userprofile\OneDrive"
}
Write-Host "Remove Onedrive from explorer sidebar"
# Define the registry path
$registryPath = "HKCU:\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"

# Define the registry paths for both keys
$registryPath1 = "HKCU:\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
$registryPath2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"

# Function to set a registry property or display an error message if the key doesn't exist
function Set-RegistryProperty {
    param (
        [string]$Path,
        [string]$Name,
        [object]$Value
    )

    if (Test-Path $Path) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value
    } else {
        Write-Host "Registry key not found: $Path"
    }
}

# Set properties for both registry keys
Set-RegistryProperty -Path $registryPath1 -Name "System.IsPinnedToNameSpaceTree" -Value 0
Set-RegistryProperty -Path $registryPath2 -Name "System.IsPinnedToNameSpaceTree" -Value 0

Write-Host "Removing run hook for new users"
reg load "HKU\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "HKU\Default"

Write-Host "Removing startmenu entry"
Remove-Item -Force -ErrorAction SilentlyContinue \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive.lnk\"

Write-Host "Removing scheduled task"
Get-ScheduledTask -TaskPath '\\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

# Add Shell folders restoring default locations
Write-Host "Shell Fixing"
# Define user shell folder paths
$envVar = "$env:userprofile"

$shellFolders = @{
    "AppData" = "$envVar\AppData\Roaming"
    "Cache" = "$envVar\AppData\Local\Microsoft\Windows\INetCache"
    "Cookies" = "$envVar\AppData\Local\Microsoft\Windows\INetCookies"
    "Favorites" = "$envVar\Favorites"
    "History" = "$envVar\AppData\Local\Microsoft\Windows\History"
    "Local AppData" = "$envVar\AppData\Local"
    "My Music" = "$envVar\Music"
    "My Video" = "$envVar\Videos"
    "NetHood" = "$envVar\AppData\Roaming\Microsoft\Windows\Network Shortcuts"
    "PrintHood" = "$envVar\AppData\Roaming\Microsoft\Windows\Printer Shortcuts"
    "Programs" = "$envVar\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
    "Recent" = "$envVar\AppData\Roaming\Microsoft\Windows\Recent"
    "SendTo" = "$envVar\AppData\Roaming\Microsoft\Windows\SendTo"
    "Start Menu" = "$envVar\AppData\Roaming\Microsoft\Windows\Start Menu"
    "Startup" = "$envVar\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    "Templates" = "$envVar\AppData\Roaming\Microsoft\Windows\Templates"
    "{374DE290-123F-4565-9164-39C4925E467B}" = "$envVar\Downloads"
    "Desktop" = "$envVar\Desktop"
    "My Pictures" = "$envVar\Pictures"
    "Personal" = "$envVar\Documents"
    "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" = "$envVar\Documents"
    "{0DDD015D-B06C-45D5-8C4C-F59713854639}" = "$envVar\Pictures"
}

# Loop through the shell folder paths and set them in the registry
foreach ($key in $shellFolders.Keys) {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $key -Value $shellFolders[$key] -Type ExpandString
}
Write-Host "Restarting explorer"
Start-Process "explorer.exe"

Write-Host "Waiting for explorer to complete loading"
Write-Host "Please Note - OneDrive folder may still have items in it. You must manually delete it, but all the files should already be copied to the base user folder."
Start-Sleep 5