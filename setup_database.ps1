Param(
    [string]$Host = "localhost",
    [int]$Port = 3306,
    [string]$User = "root",
    [string]$Database,
    [string]$Password
)

$ErrorActionPreference = "Stop"

function ConvertTo-PlainText {
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]$SecureString
    )

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$schemaFile = Join-Path $scriptDir "SCHEMA.sql"
$dataFile = Join-Path $scriptDir "DATA.sql"

foreach ($file in @($schemaFile, $dataFile)) {
    if (-not (Test-Path $file)) {
        throw "Required file not found: $file"
    }
}

if (-not $Database) {
    $useMatch = Select-String -Path $schemaFile -Pattern '(?i)^\s*USE\s+`?([A-Za-z0-9_]+)`?' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($useMatch -and $useMatch.Matches.Count -gt 0) {
        $Database = $useMatch.Matches[0].Groups[1].Value
    }
}

if (-not $Database) {
    $createMatch = Select-String -Path $schemaFile -Pattern '(?i)^\s*CREATE\s+DATABASE(?:\s+IF\s+NOT\s+EXISTS)?\s+`?([A-Za-z0-9_]+)`?' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($createMatch -and $createMatch.Matches.Count -gt 0) {
        $Database = $createMatch.Matches[0].Groups[1].Value
    }
}

if (-not $Database) {
    $Database = "salonhub"
}

if (-not (Get-Command mysql -ErrorAction SilentlyContinue)) {
    throw "mysql client not found in PATH. Install MySQL or ensure mysql.exe is accessible."
}

$plainPassword = $null
if ($Password) {
    $plainPassword = $Password
}
else {
    $securePassword = Read-Host -AsSecureString "MySQL password for $User"
    $plainPassword = ConvertTo-PlainText -SecureString $securePassword
}

$mysqlPath = (Get-Command mysql).Source

$env:MYSQL_PWD = $plainPassword
try {
    Write-Host "Using database '$Database'."

    Write-Host "Applying schema from $(Split-Path -Leaf $schemaFile)..."
    Get-Content -Path $schemaFile -Raw | & $mysqlPath -h $Host -P $Port -u $User

    Write-Host "Seeding data from $(Split-Path -Leaf $dataFile)..."
    Get-Content -Path $dataFile -Raw | & $mysqlPath -h $Host -P $Port -u $User -D $Database

    Write-Host "Database setup complete."
}
finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
    $plainPassword = $null
}
