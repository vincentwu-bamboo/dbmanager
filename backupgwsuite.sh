#!/bin/bash

# Check if a username is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <username> [backup_folder]"
  exit 1
fi

# Assign the first argument to the username variable
username=$1

# Check if a backup folder is provided, otherwise use current directory
backup_folder="."
if [ ! -z "$2" ]; then
  # Ensure the backup folder is relative to current directory
  backup_folder="${PWD}/$2"
  
  # Create the backup folder if it doesn't exist
  if [ ! -d "$backup_folder" ]; then
    mkdir -p "$backup_folder"
    if [ $? -ne 0 ]; then
      echo "Error: Could not create backup folder $backup_folder"
      exit 1
    fi
    echo "Created backup folder: $backup_folder"
  fi
fi

# Get the current date in MM-DD format
current_date=$(date +%m-%d)

# Define the backup file names with the date and path
backup_file_pcdb="${backup_folder}/${current_date}_pcdb.sql"
backup_file_bcdb="${backup_folder}/${current_date}_bcdb.sql"
backup_file_cmdb="${backup_folder}/${current_date}_cmdb.sql"

# Perform the backup for each database
pg_dump -U "$username" -d pcdb -f "$backup_file_pcdb"
pg_dump -U "$username" -d bcdb -f "$backup_file_bcdb"
pg_dump -U "$username" -d cmdb -f "$backup_file_cmdb"

# Check if any of the backups failed
if [ $? -ne 0 ]; then
  echo "Warning: One or more backups may have failed."
fi

# Get the absolute paths for better user information
abs_path_pcdb=$(realpath "$backup_file_pcdb")
abs_path_bcdb=$(realpath "$backup_file_bcdb")
abs_path_cmdb=$(realpath "$backup_file_cmdb")

echo "Backup completed for pcdb, bcdb, and cmdb."
echo "Files saved as $backup_file_pcdb, $backup_file_bcdb, and $backup_file_cmdb."