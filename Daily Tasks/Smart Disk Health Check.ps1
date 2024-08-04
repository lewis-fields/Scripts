#Parameters
$logFile = "{OUTPUT_DIRECTORY/FILE.txt}"

#Get Disk drives
$drives = Get-CimInstance -ClassName Win32_DiskDrive

#Initialize result and log variables
$result = ""
$log = ""

foreach ($drive in $drives) {
    $smartStatus = $drive.Status
    $driveInfo = "Drive $($drive.DeviceID) - $($drive.MediaType) - $($drive.InterfaceType) - $($drive.Model): $smartStatus"
    $log += $driveInfo + "`n"
    if ($smartStatus -ne "OK") {
        $result += $driveInfo + "`n"
    }
}

# Append log data with timestamp to file
$logWithTimestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + "`n" + $log + "`n`n"
Add-Content $logFile $logWithTimestamp
