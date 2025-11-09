#!/bin/bash

# =====================================================
# RESET GCP POSTGRESQL DATABASE
# =====================================================
# This script connects to your GCP PostgreSQL and resets all data

echo "=========================================="
echo "OneFlow GCP Database Reset"
echo "=========================================="
echo ""

# GCP Database Configuration (from your .env)
GCP_HOST="34.70.200.23"
GCP_PORT="5432"
GCP_DATABASE="postgres"
GCP_USER="postgres"
GCP_PASSWORD="CC\$H5^H:0m2vN:lj"  # Your actual password (decoded from URL encoding)

echo "Database: $GCP_DATABASE"
echo "Host: $GCP_HOST"
echo "User: $GCP_USER"
echo ""
echo "Using password from .env file..."
echo ""

# Create temporary SQL file
cat > /tmp/reset_oneflow.sql << 'EOF'
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
EOF

# Execute the SQL script
echo "Connecting to GCP PostgreSQL..."
PGPASSWORD=$GCP_PASSWORD psql -h $GCP_HOST -p $GCP_PORT -U $GCP_USER -d $GCP_DATABASE -f /tmp/reset_oneflow.sql

# Check if successful
if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✓ Database reset successful!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Start your dev server: npm run dev"
    echo "2. Sign up at http://localhost:3000/login"
    echo "3. Set admin role with:"
    echo "   UPDATE \"User\" SET role = 'ADMIN' WHERE email = 'your-email@example.com';"
else
    echo ""
    echo "=========================================="
    echo "✗ Database reset failed!"
    echo "=========================================="
    echo ""
    echo "Please check:"
    echo "- Database credentials are correct"
    echo "- GCP firewall allows your IP"
    echo "- Database is accessible"
fi

# Clean up
rm /tmp/reset_oneflow.sql

echo ""
