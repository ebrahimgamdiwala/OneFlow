# Database Reset Instructions

## Quick Fix for Prisma Error

The error occurs because Prisma client is out of sync with your schema. Here's how to fix it:

### Option 1: Quick Fix (Recommended)

1. **Stop your dev server** (Press Ctrl+C)

2. **Delete Prisma client folders**:
   ```powershell
   Remove-Item -Path "node_modules\.prisma" -Recurse -Force
   Remove-Item -Path "node_modules\@prisma\client" -Recurse -Force
   ```

3. **Regenerate Prisma client**:
   ```bash
   npx prisma generate
   ```

4. **Restart dev server**:
   ```bash
   npm run dev
   ```

### Option 2: Use PowerShell Script

Run the automated script:
```powershell
.\reset-and-regenerate.ps1
```

## Reset Database (Delete All Data)

If you want to start fresh with empty tables:

### Method 1: Using SQL Script (Recommended)

1. **Connect to your PostgreSQL database**:
   ```bash
   psql -h 34.70.200.23 -U your_username -d postgres
   ```

2. **Run the reset script**:
   ```sql
   \i reset-database.sql
   ```

   Or copy-paste the contents of `reset-database.sql` into your PostgreSQL client.

### Method 2: Using Prisma Studio

1. **Open Prisma Studio**:
   ```bash
   npx prisma studio
   ```

2. **Manually delete records** from each table (tedious but works)

### Method 3: Using pgAdmin or Database GUI

1. Open your database in pgAdmin or any PostgreSQL GUI
2. Run the SQL from `reset-database.sql`

## After Reset: Create Admin User

1. **Start your server**:
   ```bash
   npm run dev
   ```

2. **Sign up at** `http://localhost:3000/login`

3. **Set admin role in database**:
   ```sql
   UPDATE "User" SET role = 'ADMIN' WHERE email = 'your-email@example.com';
   ```

4. **Logout and login again**

## Troubleshooting

### Issue: "Unknown field `manager`"
**Solution**: Prisma client not regenerated. Run:
```bash
npx prisma generate
```

### Issue: "EPERM: operation not permitted"
**Solution**: Close VS Code, run command in external terminal

### Issue: Database connection error
**Solution**: Check `.env` file has correct `DATABASE_URL`

### Issue: Still getting errors after regenerate
**Solution**: 
1. Delete `node_modules` and reinstall:
   ```bash
   Remove-Item -Path "node_modules" -Recurse -Force
   npm install
   ```
2. Regenerate Prisma:
   ```bash
   npx prisma generate
   ```

## SQL Script Details

The `reset-database.sql` script:
- ✅ Deletes all data from all tables
- ✅ Preserves table structure (schema)
- ✅ Preserves indexes and constraints
- ✅ Handles foreign key dependencies correctly
- ✅ Safe to run multiple times

Tables cleared (in order):
1. Auth tables (Session, Account, VerificationToken)
2. Junction tables (ProjectManager, ProjectMember)
3. Dependent tables (Task, Timesheet, Expense, etc.)
4. Document tables (SalesOrder, PurchaseOrder, Invoice, VendorBill)
5. Core tables (Project, User, Partner, Product)

## Quick Command Reference

```bash
# Fix Prisma error
npx prisma generate

# Reset database (in psql)
\i reset-database.sql

# Create admin user (in psql)
UPDATE "User" SET role = 'ADMIN' WHERE email = 'your@email.com';

# Restart server
npm run dev
```

## What NOT to Do

❌ Don't run `npx prisma db push` unless you know what you're doing
❌ Don't manually edit the database schema
❌ Don't delete the `prisma` folder
❌ Don't run `DROP DATABASE` (this deletes the schema too)

## What TO Do

✅ Always regenerate Prisma after schema changes
✅ Use the provided SQL script to reset data
✅ Keep backups before major changes
✅ Test in development before production

---

**Need help?** Check the error message carefully and follow the steps above.
