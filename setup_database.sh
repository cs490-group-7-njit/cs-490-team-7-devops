#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status, treat unset variables as errors, and fail pipelines on the first error.
set -euo pipefail

# Function to display usage information and exit
usage() {
  cat <<'EOF'
Usage: setup_database.sh [-u USER] [-d DATABASE] [-h HOST] [-P PORT] [-p PASSWORD]

Runs SCHEMA.sql followed by DATA.sql against the specified MySQL database.
  -h HOST       MySQL host (default: localhost)
  -P PORT       MySQL port (default: 3306)
  -u USER       MySQL user (default: root)
  -d DATABASE   Target database name (auto-detected from SCHEMA.sql or defaults to salonhub)
  -p PASSWORD   MySQL password (optional; prompts if omitted)
EOF
}

HOST="localhost"
PORT="3306"
USER="root"
DATABASE=""
MYSQL_PASSWORD=""

while getopts ":h:P:u:d:p:" opt; do
  case "$opt" in
    h) HOST="$OPTARG" ;;
    P) PORT="$OPTARG" ;;
    u) USER="$OPTARG" ;;
    d) DATABASE="$OPTARG" ;;
    p) MYSQL_PASSWORD="$OPTARG" ;;
    :) echo "Error: Option -$OPTARG requires an argument." >&2; usage >&2; exit 1 ;;
    \?) echo "Error: Invalid option -$OPTARG." >&2; usage >&2; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/SCHEMA.sql"
DATA_FILE="$SCRIPT_DIR/DATA.sql"

for file in "$SCHEMA_FILE" "$DATA_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Error: Required file not found: $file" >&2
    exit 1
  fi
done

if [[ -z "$DATABASE" ]]; then
  schema_use=$(grep -i -E '^\s*use\s+' "$SCHEMA_FILE" | head -n1 || true)
  if [[ -n "$schema_use" ]]; then
    DATABASE=$(echo "$schema_use" | awk '{print $2}' | tr -d '`;')
  fi
fi

if [[ -z "$DATABASE" ]]; then
  schema_create=$(grep -i -E '^\s*create\s+database' "$SCHEMA_FILE" | head -n1 || true)
  if [[ -n "$schema_create" ]]; then
    DATABASE=$(
      echo "$schema_create" | awk '{
        for (i = 1; i <= NF; i++) {
          if (tolower($i) == "database") {
            if (tolower($(i+1)) == "if" && tolower($(i+2)) == "not" && tolower($(i+3)) == "exists") {
              print $(i+4);
            } else {
              print $(i+1);
            }
            break;
          }
        }
      }' | tr -d '`;'
    )
  fi
fi

if [[ -z "$DATABASE" ]]; then
  DATABASE="salonhub"
fi

if ! command -v mysql >/dev/null 2>&1; then
  echo "Error: mysql client not found in PATH." >&2
  exit 1
fi

if [[ -z "$MYSQL_PASSWORD" ]]; then
  read -r -s -p "MySQL password for $USER: " MYSQL_PASSWORD
  echo
fi

mysql_base=(mysql -h "$HOST" -P "$PORT" -u "$USER")

echo "Using database '$DATABASE'."

echo "Applying schema from $(basename "$SCHEMA_FILE")..."
MYSQL_PWD=$MYSQL_PASSWORD "${mysql_base[@]}" < "$SCHEMA_FILE"

echo "Applying data to database '$DATABASE' from $(basename "$DATA_FILE")..."
MYSQL_PWD=$MYSQL_PASSWORD "${mysql_base[@]}" -D "$DATABASE" < "$DATA_FILE"

echo "Database setup complete."
