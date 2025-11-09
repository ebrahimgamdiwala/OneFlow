#!/bin/bash

# =====================================================
# QUICK RESET - ONE COMMAND SOLUTION
# =====================================================

echo ""
echo "=========================================="
echo "  OneFlow Database Reset"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will DELETE ALL DATA!"
echo ""
read -p "Are you sure you want to continue? (Y/N): " confirm
echo ""

if [ "$confirm" != "Y" ] && [ "$confirm" != "y" ]; then
    echo "Reset cancelled."
    exit 0
fi

echo "Connecting to database..."
echo ""

# Database credentials from .env
export PGPASSWORD='CC$H5^H:0m2vN:lj'

# SQL to reset database
SQL="
SET session_replication_role = 'replica';
TRUNCATE TABLE \"VerificationToken\" CASCADE;
TRUNCATE TABLE \"Session\" CASCADE;
TRUNCATE TABLE \"Account\" CASCADE;
TRUNCATE TABLE \"PurchaseOrderActivity\" CASCADE;
TRUNCATE TABLE \"VendorBillLine\" CASCADE;
TRUNCATE TABLE \"InvoiceLine\" CASCADE;
TRUNCATE TABLE \"PurchaseOrderLine\" CASCADE;
TRUNCATE TABLE \"SalesOrderLine\" CASCADE;
TRUNCATE TABLE \"Payment\" CASCADE;
TRUNCATE TABLE \"Attachment\" CASCADE;
TRUNCATE TABLE \"TaskComment\" CASCADE;
TRUNCATE TABLE \"Timesheet\" CASCADE;
TRUNCATE TABLE \"Task\" CASCADE;
TRUNCATE TABLE \"ProjectMember\" CASCADE;
TRUNCATE TABLE \"ProjectManager\" CASCADE;
TRUNCATE TABLE \"Expense\" CASCADE;
TRUNCATE TABLE \"VendorBill\" CASCADE;
TRUNCATE TABLE \"CustomerInvoice\" CASCADE;
TRUNCATE TABLE \"PurchaseOrder\" CASCADE;
TRUNCATE TABLE \"SalesOrder\" CASCADE;
TRUNCATE TABLE \"Project\" CASCADE;
TRUNCATE TABLE \"Product\" CASCADE;
TRUNCATE TABLE \"Partner\" CASCADE;
TRUNCATE TABLE \"User\" CASCADE;
SET session_replication_role = 'origin';
SELECT 'Database reset complete!' as status;
"

# Execute
echo "$SQL" | psql -h 34.70.200.23 -p 5432 -U postgres -d postgres

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ SUCCESS! Database reset complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. npm run dev"
    echo "2. Sign up at http://localhost:3000/login"
    echo "3. Run this to make yourself admin:"
    echo ""
    echo "   UPDATE \"User\" SET role = 'ADMIN' WHERE email = 'your@email.com';"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "X Failed to reset database"
    echo "=========================================="
    echo ""
    echo "Make sure psql is installed:"
    echo "Download from: https://www.postgresql.org/download/"
    echo ""
fi

unset PGPASSWORD
echo ""
