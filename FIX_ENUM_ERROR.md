# Fix Enum Error - Quick Guide

## Error
```
Value 'APPROVED' not found in enum 'DocumentStatus'
Value 'PENDING_APPROVAL' not found in enum 'DocumentStatus'
```

## Root Cause
Your database enum values are out of sync with the Prisma schema. This happens when:
1. The database was created before the schema was finalized
2. Manual database changes were made
3. Migrations weren't applied properly

## Quick Fix (Recommended)

### Option 1: Use Prisma DB Push (Easiest)
```bash
npx prisma db push
```

This will sync your database schema with your Prisma schema. It's safe and won't lose data.

### Option 2: Generate and Apply Migration
```bash
npx prisma migrate dev --name fix-document-status-enum
```

This creates a proper migration file for version control.

### Option 3: Manual SQL (If above fails)
Run this in your PostgreSQL database:

```sql
-- Check current enum values
SELECT enum_range(NULL::public."DocumentStatus");

-- The enum should have these values:
-- DRAFT, PENDING_APPROVAL, APPROVED, REJECTED, CONFIRMED, 
-- CANCELLED, PAID, PARTIAL, SENT, DONE

-- If any are missing, Prisma db push will add them
```

## After Running the Fix

1. **Restart your dev server**
   ```bash
   # Press Ctrl+C to stop
   npm run dev
   ```

2. **Clear browser cache**
   - Hard refresh: Ctrl+Shift+R (Windows/Linux) or Cmd+Shift+R (Mac)

3. **Test the admin panel**
   - Go to `/dashboard`
   - Should load without 500 errors

## Verification

Test the analytics API:
```bash
curl http://localhost:3000/api/admin/analytics?timeRange=30
```

Should return JSON data without errors.

## If Still Getting Errors

### Check Database Connection
```bash
npx prisma studio
```
This should open without errors if connection is good.

### Regenerate Prisma Client
```bash
npx prisma generate
```

### Check Enum Values in Database
Connect to your PostgreSQL database and run:
```sql
SELECT 
    t.typname as enum_name,
    e.enumlabel as enum_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid  
WHERE t.typname = 'DocumentStatus'
ORDER BY e.enumsortorder;
```

Should show all 10 values from the schema.

## What the Fix Does

The `prisma db push` command:
1. Compares your Prisma schema with the database
2. Adds missing enum values
3. Updates table structures if needed
4. Does NOT delete existing data
5. Syncs everything automatically

## Prevention

To avoid this in the future:
1. Always use Prisma migrations for schema changes
2. Don't manually modify database enums
3. Run `npx prisma db push` after pulling schema changes
4. Keep Prisma schema as single source of truth

## Alternative: Temporary Workaround

If you can't run migrations right now, the analytics API has been updated with error handling. It will:
- Skip the document status distribution charts
- Still show all other analytics
- Log warnings instead of crashing

But you should still fix the enum sync for full functionality.

## Commands Summary

```bash
# Quick fix (recommended)
npx prisma db push

# Or with migration
npx prisma migrate dev --name fix-enums

# Regenerate client
npx prisma generate

# Restart server
npm run dev
```

## Expected Result

After running the fix:
- ✅ No more 500 errors
- ✅ Analytics API returns data
- ✅ Admin dashboard loads completely
- ✅ All charts render correctly
- ✅ Document status distribution works

---

**Run `npx prisma db push` now to fix the issue!**
