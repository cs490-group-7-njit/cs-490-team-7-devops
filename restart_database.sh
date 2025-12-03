#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status, treat unset variables as errors, and fail pipelines on the first error.
set -euo pipefail

# Function to display usage information and exit
usage() {
  cat <<'EOF'
Usage: restart_database.sh [-u USER] [-h HOST] [-P PORT] [-p PASSWORD]

Drops the salonhub database and rebuilds it using SCHEMA.sql and DATA.sql.

Options:
  -h HOST       MySQL host (default: localhost)
  -P PORT       MySQL port (default: 3306)
  -u USER       MySQL user (default: root)
  -p PASSWORD   MySQL password (optional; prompts if omitted)

Environment Variables (override defaults, but command-line options take precedence):
  MYSQL_HOST     MySQL host
  MYSQL_PORT     MySQL port
  MYSQL_USER     MySQL user
  MYSQL_PASSWORD MySQL password
EOF
}

# Read from environment variables or use defaults
HOST="${MYSQL_HOST:-localhost}"
PORT="${MYSQL_PORT:-3306}"
USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"

while getopts ":h:P:u:p:" opt; do
  case "$opt" in
    h) HOST="$OPTARG" ;;
    P) PORT="$OPTARG" ;;
    u) USER="$OPTARG" ;;
    p) MYSQL_PASSWORD="$OPTARG" ;;
    :) echo "Error: Option -$OPTARG requires an argument." >&2; usage >&2; exit 1 ;;
    \?) echo "Error: Invalid option -$OPTARG." >&2; usage >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/SCHEMA.sql"
DATA_FILE="$SCRIPT_DIR/DATA.sql"

# Verify required files exist
for file in "$SCHEMA_FILE" "$DATA_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Error: Required file not found: $file" >&2
    exit 1
  fi
done

# Prompt for password if not provided
if [[ -z "$MYSQL_PASSWORD" ]]; then
  read -sp "Enter MySQL password for user '$USER': " MYSQL_PASSWORD
  echo
fi

# Build MySQL connection command
MYSQL_CMD="mysql -h $HOST -P $PORT -u $USER -p$MYSQL_PASSWORD"

echo "Dropping salonhub database..."
$MYSQL_CMD -e "DROP DATABASE IF EXISTS salonhub;" || {
  echo "Error: Failed to drop database." >&2
  exit 1
}

echo "Rebuilding salonhub database from schema..."
$MYSQL_CMD < "$SCHEMA_FILE" || {
  echo "Error: Failed to load schema." >&2
  exit 1
}

echo "Loading sample data..."
$MYSQL_CMD salonhub < "$DATA_FILE" || {
  echo "Error: Failed to load data." >&2
  exit 1
}

echo "✓ Database restart complete!"
