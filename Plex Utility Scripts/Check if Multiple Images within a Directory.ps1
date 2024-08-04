# Define the path to the main directory
$mainPath = "{INSERT DIRECTORY}"

# Get all the subdirectories in the main directory
$subDirectories = Get-ChildItem -Path $mainPath -Directory

# Initialize an array to hold the directories with more than one image file
$directoriesWithMultipleImages = @()

# Define a list of image file extensions
$imageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".ico")

# Iterate through each subdirectory
foreach ($dir in $subDirectories) {
    # Get all the files in the subdirectory
    $files = Get-ChildItem -Path $dir.FullName

    # Filter the files to include only images
    $imageFiles = $files | Where-Object { $imageExtensions -contains $_.Extension.ToLower() }

    # Check if the number of image files is greater than one
    if ($imageFiles.Count -gt 1) {
        # Add the directory to the list
        $directoriesWithMultipleImages += $dir.FullName
    }
}

# Output the directories with more than one image file
if ($directoriesWithMultipleImages.Count -gt 0) {
    Write-Output "Directories with more than one image file:"
    $directoriesWithMultipleImages | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "No directories found with more than one image file."
}
