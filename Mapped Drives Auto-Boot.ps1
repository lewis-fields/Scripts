# PowerShell Script to Connect to Network Locations

# Map the network drives
New-PSDrive -Name "E" -PSProvider FileSystem -Root "{DRIVE_LOCATION}" -Persist
New-PSDrive -Name "D" -PSProvider FileSystem -Root "{DRIVE_LOCATION}" -Persist
New-PSDrive -Name "G" -PSProvider FileSystem -Root "{DRIVE_LOCATION}" -Persist
New-PSDrive -Name "K" -PSProvider FileSystem -Root "{DRIVE_LOCATION}" -Persist
