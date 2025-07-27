#!/bin/bash

# Check if a username, a file name, and a database name are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Usage: $0 <username> <backup_file> <dbname>"
  exit 1
fi

# Assign the arguments to variables
username=$1
backup_file=$2
dbname=$3

# Check if the backup file exists
if [ ! -f "$backup_file" ]; then
  echo "Error: File '$backup_file' not found!"
  exit 1
fi

# Drop the existing database
dropdb -U "$username" "$dbname" 2>/dev/null

# Create a new database
createdb -U "$username" "$dbname"

# Execute the SQL commands from the specified backup file using psql
psql -U "$username" -d "$dbname" -f "$backup_file"

echo "Database restoration completed from $backup_file"