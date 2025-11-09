# =====================================================
# RESET GCP POSTGRESQL DATABASE (PowerShell)
# =====================================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "OneFlow GCP Database Reset" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# GCP Database Configuration (from your .env)
$GCP_HOST = "34.70.200.23"
$GCP_PORT = "5432"
$GCP_DATABASE = "postgres"
$GCP_USER = "postgres"
$GCP_PASSWORD = "CC`$H5^H:0m2vN:lj"  # Your actual password (decoded from URL encoding)

Write-Host "Database: $GCP_DATABASE" -ForegroundColor White
Write-Host "Host: $GCP_HOST" -ForegroundColor White
Write-Host "User: $GCP_USER" -ForegroundColor White
Write-Host ""
Write-Host "Using password from .env file..." -ForegroundColor Yellow
Write-Host ""

$PlainPassword = $GCP_PASSWORD

# SQL Script
$SQL_SCRIPT = @"
-- =====================================================
-- RESET DATABASE - DELETE ALL DATA, KEEP SCHEMA
-- =====================================================

-- Disable triggers temporarily
SET session_replication_role = 'replica';

-- Delete data from all tables (order matters due to foreign keys)
TRUNCATE TABLE "VerificationToken" CASCADE;
TRUNCATE TABLE "Session" CASCADE;
TRUNCATE TABLE "Account" CASCADE;
TRUNCATE TABLE "PurchaseOrderActivity" CASCADE;
TRUNCATE TABLE "VendorBillLine" CASCADE;
TRUNCATE TABLE "InvoiceLine" CASCADE;
TRUNCATE TABLE "PurchaseOrderLine" CASCADE;
TRUNCATE TABLE "SalesOrderLine" CASCADE;
TRUNCATE TABLE "Payment" CASCADE;
TRUNCATE TABLE "Attachment" CASCADE;
TRUNCATE TABLE "TaskComment" CASCADE;
TRUNCATE TABLE "Timesheet" CASCADE;
TRUNCATE TABLE "Task" CASCADE;
TRUNCATE TABLE "ProjectMember" CASCADE;
TRUNCATE TABLE "ProjectManager" CASCADE;
TRUNCATE TABLE "Expense" CASCADE;
TRUNCATE TABLE "VendorBill" CASCADE;
TRUNCATE TABLE "CustomerInvoice" CASCADE;
TRUNCATE TABLE "PurchaseOrder" CASCADE;
TRUNCATE TABLE "SalesOrder" CASCADE;
TRUNCATE TABLE "Project" CASCADE;
TRUNCATE TABLE "Product" CASCADE;
TRUNCATE TABLE "Partner" CASCADE;
TRUNCATE TABLE "User" CASCADE;

-- Re-enable triggers
SET session_replication_role = 'origin';

-- Verify
SELECT 'Database reset complete! All data deleted.' as status;
"@

# Save SQL to temp file
$TempFile = [System.IO.Path]::GetTempFileName() + ".sql"
$SQL_SCRIPT | Out-File -FilePath $TempFile -Encoding UTF8

Write-Host "Connecting to GCP PostgreSQL..." -ForegroundColor Yellow
Write-Host ""

# Set environment variable for password
$env:PGPASSWORD = $PlainPassword

# Execute using psql
try {
    $result = psql -h $GCP_HOST -p $GCP_PORT -U $GCP_USER -d $GCP_DATABASE -f $TempFile 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host "✓ Database reset successful!" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Start your dev server: npm run dev" -ForegroundColor White
        Write-Host "2. Sign up at http://localhost:3000/login" -ForegroundColor White
        Write-Host "3. Set admin role with:" -ForegroundColor White
        Write-Host '   UPDATE "User" SET role = ' + "'ADMIN'" + ' WHERE email = ' + "'your-email@example.com'" + ';' -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Red
        Write-Host "✗ Database reset failed!" -ForegroundColor Red
        Write-Host "==========================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error output:" -ForegroundColor Yellow
        Write-Host $result -ForegroundColor Red
        Write-Host ""
        Write-Host "Please check:" -ForegroundColor Yellow
        Write-Host "- Database credentials are correct" -ForegroundColor White
        Write-Host "- GCP firewall allows your IP" -ForegroundColor White
        Write-Host "- psql is installed (PostgreSQL client)" -ForegroundColor White
        Write-Host ""
        Write-Host "Install psql: https://www.postgresql.org/download/" -ForegroundColor Cyan
    }
} catch {
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure psql is installed and in your PATH" -ForegroundColor Yellow
    Write-Host "Download from: https://www.postgresql.org/download/" -ForegroundColor Cyan
}

# Clean up
Remove-Item $TempFile -ErrorAction SilentlyContinue
$env:PGPASSWORD = $null

Write-Host ""
