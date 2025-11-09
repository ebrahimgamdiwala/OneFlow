# =====================================================
# QUICK RESET - ONE COMMAND SOLUTION
# =====================================================
# This script resets your GCP database in one command
# No password prompt needed - uses credentials from .env

Write-Host ""
Write-Host "=========================================="
Write-Host "  OneFlow Database Reset" -ForegroundColor Cyan
Write-Host "=========================================="
Write-Host ""
Write-Host "⚠️  WARNING: This will DELETE ALL DATA!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Are you sure you want to continue? (Y/N)" -ForegroundColor Yellow
$confirm = Read-Host

if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host ""
    Write-Host "Reset cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Connecting to database..." -ForegroundColor Cyan

# Database credentials from .env
$env:PGPASSWORD = "CC`$H5^H:0m2vN:lj"

# SQL to reset database
$SQL = @"
SET session_replication_role = 'replica';
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
SET session_replication_role = 'origin';
SELECT 'Database reset complete!' as status;
"@

# Execute
try {
    $result = $SQL | psql -h 34.70.200.23 -p 5432 -U postgres -d postgres 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓ SUCCESS! Database reset complete!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. npm run dev" -ForegroundColor White
        Write-Host "2. Sign up at http://localhost:3000/login" -ForegroundColor White
        Write-Host "3. Run this to make yourself admin:" -ForegroundColor White
        Write-Host ""
        Write-Host '   UPDATE "User" SET role = ' + "'ADMIN'" + ' WHERE email = ' + "'your@email.com'" + ';' -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "X Failed to reset database" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error: $result" -ForegroundColor Red
        Write-Host ""
        Write-Host "Make sure psql is installed:" -ForegroundColor Yellow
        Write-Host "Download from: https://www.postgresql.org/download/" -ForegroundColor Cyan
    }
} catch {
    Write-Host ""
    Write-Host "X Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install PostgreSQL client (psql):" -ForegroundColor Yellow
    Write-Host "Download from: https://www.postgresql.org/download/" -ForegroundColor Cyan
}

$env:PGPASSWORD = $null
Write-Host ""
