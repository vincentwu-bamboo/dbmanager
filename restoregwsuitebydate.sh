#!/bin/bash

# Check if a username, date, and backup folder are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <username> <date> <backup_folder>"
  exit 1
fi

# Assign the arguments to variables
username=$1
backup_date=$2
backup_folder=$3

# Function to drop, create, and restore a database
restore_database() {
  local dbname=$1
  local backup_file="${backup_folder}/${backup_date}_${dbname}.sql"

  if [ ! -f "$backup_file" ]; then
    echo "Backup file $backup_file not found!"
    return
  fi

  echo "Restoring $dbname from $backup_file..."

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