# =====================================================
# RESET DATABASE AND REGENERATE PRISMA CLIENT
# =====================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OneFlow Database Reset & Regeneration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Stop any running dev server
Write-Host "Step 1: Checking for running dev server..." -ForegroundColor Yellow
$nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    Write-Host "Found running Node processes. Please stop your dev server (Ctrl+C) before continuing." -ForegroundColor Red
    Write-Host "Press any key to continue after stopping the server..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Step 2: Delete Prisma client
Write-Host ""
Write-Host "Step 2: Cleaning Prisma client..." -ForegroundColor Yellow
if (Test-Path "node_modules\.prisma") {
    Remove-Item -Path "node_modules\.prisma" -Recurse -Force
    Write-Host "✓ Deleted old Prisma client" -ForegroundColor Green
}

if (Test-Path "node_modules\@prisma\client") {
    Remove-Item -Path "node_modules\@prisma\client" -Recurse -Force
    Write-Host "✓ Deleted old Prisma client package" -ForegroundColor Green
}

# Step 3: Generate fresh Prisma client
Write-Host ""
Write-Host "Step 3: Generating fresh Prisma client..." -ForegroundColor Yellow
npx prisma generate
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Prisma client generated successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to generate Prisma client" -ForegroundColor Red
    exit 1
}

# Step 4: Ask about database reset
Write-Host ""
Write-Host "Step 4: Database Reset" -ForegroundColor Yellow
Write-Host "Do you want to reset the database (delete all data)? (Y/N)" -ForegroundColor Yellow
$response = Read-Host

if ($response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "Resetting database..." -ForegroundColor Yellow
    
    # Run the SQL script
    Write-Host "Please run the following SQL script in your PostgreSQL database:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "File: reset-database.sql" -ForegroundColor White
    Write-Host ""
    Write-Host "Or run this command:" -ForegroundColor Cyan
    Write-Host "psql -h 34.70.200.23 -U your_username -d postgres -f reset-database.sql" -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key after running the SQL script..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    Write-Host "✓ Database reset complete" -ForegroundColor Green
} else {
    Write-Host "Skipping database reset" -ForegroundColor Yellow
}

# Step 5: Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Start your dev server: npm run dev" -ForegroundColor White
Write-Host "2. Create a new admin user at /login" -ForegroundColor White
Write-Host "3. Set the user role to ADMIN in database" -ForegroundColor White
Write-Host ""
Write-Host "To set admin role, run in PostgreSQL:" -ForegroundColor Cyan
Write-Host "UPDATE ""User"" SET role = 'ADMIN' WHERE email = 'your-email@example.com';" -ForegroundColor White
Write-Host ""
