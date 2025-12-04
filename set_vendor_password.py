#!/usr/bin/env python3
"""
Script to reset a vendor user's password to 'password'
Usage: python3 set_vendor_password.py [user_email]
Or with options: python3 set_vendor_password.py --email vendor@example.com --password newpass --host localhost --port 3306 --user root --mysql-password pass
"""

import argparse
import os
import subprocess
import sys
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
        description="Reset a vendor user's password for testing",
        add_help=True
    )
    parser.add_argument(
        "email",
        nargs="?",
        default=None,
        help="Email of the vendor user (positional argument)"
    )
    parser.add_argument(
        "--email",
        dest="email_arg",
        default=None,
        help="Email of the vendor user (alternative)"
    )
    parser.add_argument(
        "--password",
        default="password",
        help="New password to set (default: password)"
    )
    parser.add_argument(
        "--host",
        default=os.getenv("MYSQL_HOST", "localhost"),
        help="MySQL host (default: localhost)"
    )
    parser.add_argument(
        "--port",
        type=int,
        default=int(os.getenv("MYSQL_PORT", 3306)),
        help="MySQL port (default: 3306)"
    )
    parser.add_argument(
        "--user",
        default=os.getenv("MYSQL_USER", "root"),
        help="MySQL user (default: root)"
    )
    parser.add_argument(
        "--mysql-password",
        default=os.getenv("MYSQL_PASSWORD", ""),
        help="MySQL password (optional)"
    )

    args = parser.parse_args()

    # Resolve email from positional or --email argument
    user_email = args.email_arg or args.email
    
    if not user_email:
        print("Error: You must provide a vendor email address")
        print("Usage: python3 set_vendor_password.py vendor@example.com")
        print("   or: python3 set_vendor_password.py --email vendor@example.com")
        sys.exit(1)

    # Extract just the hostname if MYSQL_HOST contains connection options
    host = args.host
    
    if "-h" in host:
        # Extract hostname from connection string like "mysql -h beautiful-hair-prod.cpaca644yqc6.us-east-2.rds.amazonaws.com"
        parts = host.split("-h ")
        if len(parts) > 1:
            # Get everything after "-h " - the hostname
            host = parts[1].strip()

    # Constants
    db_name = "salonhub"
    new_password = args.password

    print(f"Setting password for vendor (email: {user_email})")
    print(f"Connecting to: {args.user}@{host}:{args.port}/{db_name}")
    print()

    # Generate password hash
    password_hash = generate_password_hash(new_password)

    try:
        # Connect to database
        conn = mysql.connector.connect(
            host=host,
            port=args.port,
            user=args.user,
            password=args.mysql_password,
            database=db_name
        )
        cursor = conn.cursor()

        # First, get the user_id from the email
        cursor.execute("SELECT user_id FROM users WHERE email = %s AND role = 'vendor'", (user_email,))
        result = cursor.fetchone()
        
        if not result:
            print(f"✗ Vendor user with email '{user_email}' not found")
            cursor.close()
            conn.close()
            sys.exit(1)
        
        user_id = result[0]

        # Update password
        sql = "UPDATE auth_accounts SET password_hash = %s, updated_at = NOW() WHERE user_id = %s"
        cursor.execute(sql, (password_hash, user_id))
        conn.commit()

        print()
        print("✓ Vendor password updated successfully!")
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
