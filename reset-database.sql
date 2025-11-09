-- =====================================================
-- RESET DATABASE - DELETE ALL DATA, KEEP SCHEMA
-- =====================================================
-- This script deletes all data from all tables while preserving the schema
-- Run this in your PostgreSQL database

-- Disable triggers temporarily to avoid foreign key issues
SET session_replication_role = 'replica';

-- Delete data from all tables (order matters due to foreign keys)
-- Start with tables that have no dependencies

-- Auth tables
TRUNCATE TABLE "VerificationToken" CASCADE;
TRUNCATE TABLE "Session" CASCADE;
TRUNCATE TABLE "Account" CASCADE;

-- Junction and dependent tables
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

-- Document tables
TRUNCATE TABLE "VendorBill" CASCADE;
TRUNCATE TABLE "CustomerInvoice" CASCADE;
TRUNCATE TABLE "PurchaseOrder" CASCADE;
TRUNCATE TABLE "SalesOrder" CASCADE;

-- Core tables
TRUNCATE TABLE "Project" CASCADE;
TRUNCATE TABLE "Product" CASCADE;
TRUNCATE TABLE "Partner" CASCADE;
TRUNCATE TABLE "User" CASCADE;

-- Re-enable triggers
SET session_replication_role = 'origin';

-- Verify all tables are empty
SELECT 
    schemaname,
    tablename,
    (SELECT COUNT(*) FROM pg_catalog.pg_class c WHERE c.relname = tablename) as row_count
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Success message
SELECT 'Database reset complete! All data deleted, schema preserved.' as status;
