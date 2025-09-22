#!/bin/bash

# Check if a username and combined date/backup folder are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <username> <backup_folder/date>"
  exit 1
fi

# Assign the arguments to variables
username=$1
combined_path=$2

# Extract the date and backup folder from the combined path
backup_date=$(basename "$combined_path")
backup_folder=$(dirname "$combined_path")

echo "Username: $username"
echo "Backup folder: $backup_folder"
echo "Backup date: $backup_date"

# Function to drop, create, and restore a database
restore_database() {
  local dbname=$1
  local backup_file="${backup_folder}/${backup_date}_${dbname}.sql"

  if [ ! -f "$backup_file" ]; then
    echo "Backup file $backup_file not found!"
    return
  fi

  echo "Restoring $dbname from $backup_file..."

    # Terminate any active connections to the database
  psql -U "$username" -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$dbname';" >/dev/null 2>&1

  # Drop the existing database
  dropdb -U "$username" "$dbname" 2>/dev/null

  # Create a new database
  createdb -U "$username" "$dbname"

  # Restore the database from the backup file
  psql -U "$username" -d "$dbname" -f "$backup_file"
}

# Restore each database
restore_database pcdb
restore_database bcdb
restore_database cmdb

echo "Restore completed:"
echo "- pcdb restored from ${backup_folder}/${backup_date}_pcdb.sql"
echo "- bcdb restored from ${backup_folder}/${backup_date}_bcdb.sql"
echo "- cmdb restored from ${backup_folder}/${backup_date}_cmdb.sql"