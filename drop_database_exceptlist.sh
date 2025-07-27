#!/bin/bash

# Variables
USERNAME="vincentwu"
EXCLUDE_DBS="vincentwu template1 postgres"

# Get the list of databases
DBS=$(psql -U $USERNAME -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# Drop each database
for DB in $DBS; do
  if [[ ! " ${EXCLUDE_DBS[@]} " =~ " ${DB} " ]]; then
    echo "Dropping database: $DB"
    psql -U $USERNAME -c "DROP DATABASE $DB;"
  fi
done
