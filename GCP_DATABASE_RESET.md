# GCP PostgreSQL Database Reset Guide

## Your GCP Database
- **Host**: `34.70.200.23`
- **Port**: `5432`
- **Database**: `postgres`
- **User**: `postgres` (or your username)

## Method 1: Using PowerShell Script (Easiest)

Run this in PowerShell:
```powershell
.\reset-gcp-database.ps1
```

It will:
1. Prompt for your password
2. Connect to GCP PostgreSQL
3. Delete all data
4. Show success message

## Method 2: Using psql Command Line

```bash
# Windows (PowerShell)
$env:PGPASSWORD="your_password"; psql -h 34.70.200.23 -p 5432 -U postgres -d postgres -f reset-database.sql

# Linux/Mac
PGPASSWORD=your_password psql -h 34.70.200.23 -p 5432 -U postgres -d postgres -f reset-database.sql
```

## Method 3: Using GCP Cloud Shell

1. Go to [GCP Console](https://console.cloud.google.com/)
2. Open Cloud Shell (top right icon)
3. Connect to your database:
   ```bash
   gcloud sql connect your-instance-name --user=postgres
   ```
4. Copy-paste the SQL from `reset-database.sql`

## Method 4: Using pgAdmin (GUI)

1. **Download pgAdmin**: https://www.pgadmin.org/download/
2. **Add Server**:
   - Name: OneFlow GCP
   - Host: 34.70.200.23
   - Port: 5432
   - Database: postgres
   - Username: postgres
   - Password: [your password]
3. **Run Query**:
   - Right-click database → Query Tool
   - Open `reset-database.sql`
   - Click Execute (F5)

## Method 5: Using DBeaver (GUI)

1. **Download DBeaver**: https://dbeaver.io/download/
2. **New Connection**:
   - Database: PostgreSQL
   - Host: 34.70.200.23
   - Port: 5432
   - Database: postgres
   - Username: postgres
   - Password: [your password]
3. **Execute SQL**:
   - SQL Editor → Open `reset-database.sql`
   - Execute (Ctrl+Enter)

## Method 6: Direct SQL (Copy-Paste)

If you have any PostgreSQL client connected, just copy-paste this:

```sql
-- Disable triggers
SET session_replication_role = 'replica';

-- Delete all data
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

-- Done!
SELECT 'All data deleted!' as status;
```

## After Reset: Create Admin User

### Step 1: Sign Up
Go to `http://localhost:3000/login` and create a new account

### Step 2: Set Admin Role
Run this in your PostgreSQL client:
```sql
UPDATE "User" SET role = 'ADMIN' WHERE email = 'your-email@example.com';
```

### Step 3: Logout and Login
Refresh your session to get admin permissions

## Troubleshooting

### Error: "psql: command not found"
**Solution**: Install PostgreSQL client
- Windows: https://www.postgresql.org/download/windows/
- Mac: `brew install postgresql`
- Linux: `sudo apt-get install postgresql-client`

### Error: "connection refused"
**Solution**: Check GCP firewall rules
1. Go to GCP Console → SQL → your instance
2. Connections → Add network
3. Add your IP address

### Error: "password authentication failed"
**Solution**: 
1. Check your password
2. Check username (might be different from 'postgres')
3. Reset password in GCP Console if needed

### Error: "SSL connection required"
**Solution**: Add `sslmode=require` to connection:
```bash
psql "host=34.70.200.23 port=5432 dbname=postgres user=postgres sslmode=require"
```

## Files Created for You

1. **`reset-gcp-database.ps1`** - PowerShell script (Windows)
2. **`reset-gcp-database.sh`** - Bash script (Linux/Mac)
3. **`reset-database.sql`** - SQL script (any client)
4. **`GCP_DATABASE_RESET.md`** - This guide

## Quick Commands

```powershell
# PowerShell (Windows) - Easiest
.\reset-gcp-database.ps1

# Or direct psql
$env:PGPASSWORD="your_password"
psql -h 34.70.200.23 -U postgres -d postgres -f reset-database.sql

# Create admin after reset
psql -h 34.70.200.23 -U postgres -d postgres -c "UPDATE \"User\" SET role = 'ADMIN' WHERE email = 'your@email.com';"
```

## What Gets Deleted

✅ All user accounts
✅ All projects and tasks
✅ All timesheets and expenses
✅ All sales orders and invoices
✅ All purchase orders and bills
✅ All partners and products
✅ All sessions and auth data

## What Stays

✅ Database schema (tables)
✅ Indexes
✅ Constraints
✅ Enums
✅ Functions and triggers

---

**Choose the method that works best for you!** 

Recommended: **Method 1** (PowerShell script) or **Method 4** (pgAdmin GUI)
