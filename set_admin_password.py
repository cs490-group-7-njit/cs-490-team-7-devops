#!/usr/bin/env python3
"""
Simple script to reset Ada Admin password to 'password'
Usage: python3 set_admin_password.py
Or with options: python3 set_admin_password.py -h localhost -u root -P 3306 -p password
"""

import argparse
import os
import sys
import subprocess
import venv

# Set up venv if not already in one
script_dir = os.path.dirname(os.path.abspath(__file__))
venv_dir = os.path.join(script_dir, "venv")

# Check if we're in a venv
in_venv = hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix)

if not in_venv:
    print(f"Setting up virtual environment in {venv_dir}...")
    if not os.path.exists(venv_dir):
        venv.create(venv_dir, with_pip=True)
    
    # Re-run this script in the venv
    venv_python = os.path.join(venv_dir, "bin", "python")
    print(f"Re-running script in venv...")
    os.execv(venv_python, [venv_python] + sys.argv)

# Install required packages in venv
try:
    from werkzeug.security import generate_password_hash
except ImportError:
    print("Installing werkzeug...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "werkzeug"])
    from werkzeug.security import generate_password_hash

try:
    import mysql.connector
except ImportError:
    print("Installing mysql-connector-python...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "mysql-connector-python"])
    import mysql.connector


def main():
    parser = argparse.ArgumentParser(
        description="Reset Ada Admin password to 'password' for testing"
    )
    parser.add_argument(
        "-h", "--host",
        default=os.getenv("MYSQL_HOST", "localhost"),
        help="MySQL host (default: localhost)"
    )
    parser.add_argument(
        "-P", "--port",
        type=int,
        default=int(os.getenv("MYSQL_PORT", 3306)),
        help="MySQL port (default: 3306)"
    )
    parser.add_argument(
        "-u", "--user",
        default=os.getenv("MYSQL_USER", "root"),
        help="MySQL user (default: root)"
    )
    parser.add_argument(
        "-p", "--password",
        default=os.getenv("MYSQL_PASSWORD", ""),
        help="MySQL password (optional)"
    )

    args = parser.parse_args()

    # Constants
    db_name = "salonhub"
    new_password = "password"
    user_id = 1
    user_email = "ada.admin@example.com"

    print(f"Setting password for Ada Admin (user_id: {user_id}, email: {user_email})")
    print(f"Connecting to: {args.user}@{args.host}:{args.port}/{db_name}")
    print()

    # Generate password hash
    password_hash = generate_password_hash(new_password)

    try:
        # Connect to database
        conn = mysql.connector.connect(
            host=args.host,
            port=args.port,
            user=args.user,
            password=args.password,
            database=db_name
        )
        cursor = conn.cursor()

        # Update password
        sql = "UPDATE auth_accounts SET password_hash = %s, updated_at = NOW() WHERE user_id = %s"
        cursor.execute(sql, (password_hash, user_id))
        conn.commit()

        print()
        print("✓ Ada Admin password updated successfully!")
        print()
        print("Login credentials:")
        print(f"  Email: {user_email}")
        print(f"  Password: {new_password}")

        cursor.close()
        conn.close()

    except mysql.connector.Error as err:
        print()
        print(f"✗ Database error: {err}")
        print("Make sure MySQL is running and credentials are correct.")
        sys.exit(1)
    except Exception as err:
        print()
        print(f"✗ Error: {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
