# DevOps Toolkit

Database schema, deployment scripts, and utilities for the SalonHub project.

## Contents

### Database Setup
- `SCHEMA.sql` – Complete DDL for the `salonhub` MySQL database with all 31 tables including salon_images (LONGBLOB-based image storage)
- `DATA.sql` – Comprehensive seed data for development/test environments (106 users, 6 salons, 80 appointments, etc.)
- `setup_database.sh` – Bash script that applies SCHEMA.sql then DATA.sql to initialize the database
- `setup_database.ps1` – PowerShell equivalent for Windows environments
- `restart_database.sh` – Utility to drop and rebuild the database from scratch

### Deployment & Utilities
- `deploy_backend.sh` – CI/CD deployment script for the Flask backend on EC2
- `update_backend.sh` – Quick update script for pulling latest backend changes and restarting the service
- `set_admin_password.py` / `set_admin_password.sh` – Utility to set admin user passwords
- `set_vendor_password.py` – Utility to set vendor user passwords

### Documentation
- `TEST_DOCUMENTATION.md` – Complete test suite documentation for all 21 vendor use cases (UC 1.1-1.22)
- `TEST_QUICK_REFERENCE.md` – Quick reference for common test scenarios

## Prerequisites

### Local Database Setup
- MySQL 8.x server accessible from your machine
- `mysql` CLI client available on `PATH`
- Unix-like shell (macOS/Linux or WSL)

### Production (AWS RDS/EC2)
- RDS MySQL database already provisioned
- EC2 instance with backend deployed and running
- SSH access to EC2 instance with key pair

## Local Database Usage

```bash
cd devops

# Setup fresh database (applies SCHEMA.sql then DATA.sql)
./setup_database.sh -u <mysql_user> -p <password> -h localhost -P 3306

# Or let it prompt for password
./setup_database.sh -u root -h localhost
```

Available flags:
- `-h HOST` – MySQL host (default: localhost)
- `-P PORT` – MySQL port (default: 3306)
- `-u USER` – MySQL user (default: root)
- `-d DATABASE` – Target database name (default: salonhub)
- `-p PASSWORD` – Password (omit to be prompted)

### Windows PowerShell

```powershell
cd .\devops
.\setup_database.ps1 -User root -Password "yourpassword" -Host localhost -Port 3306
```

### Restart Database (Development Only)

```bash
./restart_database.sh -u root -p
```

Drops the `salonhub` database completely and rebuilds it from scratch.

## Production Database Connection

**RDS Endpoint:** `beautiful-hair-prod.cpaca644yqc6.us-east-2.rds.amazonaws.com:3306`
**Database:** `salonhub`
**Credentials:** See EC2 instance `.bashrc` for `MYSQL_HOST`, `MYSQL_USER`, `MYSQL_PASSWORD`

## Deployment

### EC2 Backend Deployment

```bash
# Quick update (pulls latest code and restarts service)
ssh -i cs490-ssh-key ubuntu@3.129.138.4 < update_backend.sh

# Or use the deploy script
./deploy_backend.sh
```

The deployment scripts assume:
- Backend code located at `/home/ubuntu/backend`
- Virtual environment at `/home/ubuntu/backend/.venv`
- Backend service managed by systemd as `backend` service

## Database Schema Notes

The `salonhub` database includes:
- **31 tables** with full relational integrity via foreign keys
- **Salon Images:** Stored as LONGBLOB in RDS (direct binary storage, no S3 dependency)
- **Image Types:** before, after, gallery photos for salon portfolios
- **Audit Trail:** Comprehensive audit_log table for tracking changes
- **Timestamps:** All tables include created_at and updated_at for change tracking
