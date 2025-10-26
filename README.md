# DevOps Toolkit

Database schema and provisioning scripts for the SalonHub project.

## Contents
- `SCHEMA.sql` – DDL for creating the `salonhub` MySQL database and tables.
- `DATA.sql` – Seed data for development/test environments.
- `setup_database.sh` – Bash helper that applies the schema, then seeds the database.
- `setup_database.ps1` – PowerShell equivalent for native Windows environments.

## Prerequisites
- MySQL 8.x server accessible from your machine
- `mysql` CLI client available on `PATH`
- Unix-like shell (macOS/Linux or WSL)

## Usage
```bash
cd devops
./setup_database.sh -u <mysql_user> -p
```
The script prompts for the password if `-p` is omitted. Override host, port, or database name via the available flags (`-h`, `-P`, `-d`).

On Windows PowerShell:
```powershell
cd .\devops
.\setup_database.ps1 -User <mysql_user> -Host localhost
```
The script prompts for the password when `-Password` is left out. Supply `-Port` or `-Database` if you need non-default values.

After provisioning, update the Flask backend configuration to point at the new database and add connection logic under `app/`.
