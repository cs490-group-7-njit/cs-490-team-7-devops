#!/bin/bash

# Script to set Ada Admin password to 'password'
# Uses Python to generate proper werkzeug password hash
# Usage: ./set_admin_password.sh
# Or with options: ./set_admin_password.sh -h localhost -u root -P 3306 -p password

# Function to display usage information
usage() {
  cat <<'EOF'
Usage: set_admin_password.sh [-u USER] [-h HOST] [-P PORT] [-p PASSWORD]

Sets Ada Admin (user_id=1) password to 'password' for easy testing.

Options:
  -h HOST       MySQL host (default: localhost)
  -P PORT       MySQL port (default: 3306)
  -u USER       MySQL user (default: root)
  -p PASSWORD   MySQL password (optional)

Environment Variables (override defaults, but command-line options take precedence):
  MYSQL_HOST     MySQL host
  MYSQL_PORT     MySQL port
  MYSQL_USER     MySQL user
  MYSQL_PASSWORD MySQL password
EOF
}

# Get MySQL credentials from environment or use defaults
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

DB_NAME="salonhub"
NEW_PASSWORD="password"
USER_ID=1
USER_EMAIL="ada.admin@example.com"

echo "Setting password for Ada Admin (user_id: $USER_ID, email: $USER_EMAIL)"
echo "Connecting to: $USER@$HOST:$PORT/$DB_NAME"
echo ""

# Generate werkzeug password hash using Python
PASSWORD_HASH=$(python3 -c "from werkzeug.security import generate_password_hash; print(generate_password_hash('$NEW_PASSWORD'))")

if [ $? -ne 0 ]; then
  echo "✗ Failed to generate password hash. Make sure werkzeug is installed."
  exit 1
fi

# Build MySQL command
MYSQL_CMD="mysql -h $HOST -P $PORT -u $USER -p$MYSQL_PASSWORD"

# Update the password hash in database
$MYSQL_CMD "$DB_NAME" -e "UPDATE auth_accounts SET password_hash = '$PASSWORD_HASH', updated_at = NOW() WHERE user_id = $USER_ID;"

if [ $? -eq 0 ]; then
  echo ""
  echo "✓ Ada Admin password updated successfully!"
  echo ""
  echo "Login credentials:"
  echo "  Email: $USER_EMAIL"
  echo "  Password: $NEW_PASSWORD"
else
  echo ""
  echo "✗ Failed to update password."
  echo "Make sure MySQL is running and credentials are correct."
  exit 1
fi

