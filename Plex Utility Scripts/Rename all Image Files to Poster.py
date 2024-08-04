import os
import re

def rename_image_files(root_dir):
    # Define the file extensions we are looking for
    extensions = ('.jpg', '.jpeg', '.png')

    # Walk through all folders and files in the root directory
    for subdir, _, files in os.walk(root_dir):
        for file in files:
            # Check if the file is an image
            if file.lower().endswith(extensions):
                # Construct the full file path
                file_path = os.path.join(subdir, file)
                # Define the new file name
                new_file_path = os.path.join(subdir, 'poster' + os.path.splitext(file)[1])
                
                try:
                    # Rename the file
                    os.rename(file_path, new_file_path)
                    print(f"Renamed: {file_path} to {new_file_path}")
                except Exception as e:
                    print(f"Failed to rename: {file_path}. Error: {e}")

if __name__ == "__main__":
    root_directory = r"{INSERT DRIVE DIRECTORY HERE}"
    rename_image_files(root_directory)
