#!/bin/bash

# Check if a username is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Assign the first argument to the username variable
username=$1

# Define the databases to be dropped
databases=("pcdb" "bcdb" "cmdb")

# Loop through each database and drop it
for db in "${databases[@]}"; do
  echo "Dropping database: $db"
  psql -U "$username" -c "DROP DATABASE IF EXISTS $db;"
done
