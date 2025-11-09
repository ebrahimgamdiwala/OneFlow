# 🚀 Quick Start - Reset Database & Fix Errors

## Your Database Info
- **Host**: 34.70.200.23
- **Database**: postgres
- **User**: postgres
- **Password**: Already configured in scripts ✓

## 🎯 ONE COMMAND RESET

Just run this in PowerShell:
```powershell
.\RESET_NOW.ps1
```

That's it! It will:
1. Ask for confirmation
2. Connect to your GCP database
3. Delete all data
4. Show success message

## 🔧 Fix Prisma Error

After reset, regenerate Prisma:
```bash
npx prisma generate
npm run dev
```

## 📝 Create Admin User

1. **Sign up** at `http://localhost:3000/login`

2. **Set admin role** - Run in any PostgreSQL client:
   ```sql
   UPDATE "User" SET role = 'ADMIN' WHERE email = 'your@email.com';
   ```

3. **Logout and login** again

## 🛠️ Alternative Methods

### Method 1: Full PowerShell Script
```powershell
.\reset-gcp-database.ps1
```

### Method 2: Direct psql Command
```powershell
$env:PGPASSWORD="CC`$H5^H:0m2vN:lj"
psql -h 34.70.200.23 -U postgres -d postgres -f reset-database.sql
```

### Method 3: Copy-Paste SQL
Open any PostgreSQL client and run `reset-database.sql`

## 📋 Complete Workflow

```powershell
# 1. Reset database
.\RESET_NOW.ps1

# 2. Fix Prisma
npx prisma generate

# 3. Start server
npm run dev

# 4. Sign up at http://localhost:3000/login

# 5. Set admin role (in PostgreSQL)
# UPDATE "User" SET role = 'ADMIN' WHERE email = 'your@email.com';

# 6. Logout and login again

# Done! ✓
```

## 🎬 What Gets Reset

✅ All users deleted
✅ All projects deleted
✅ All tasks deleted
✅ All timesheets deleted
✅ All financial documents deleted
✅ All partners and products deleted

**Schema stays intact** - only data is deleted

## ⚡ Quick Commands Reference

```powershell
# Reset database (easiest)
.\RESET_NOW.ps1

# Fix Prisma error
npx prisma generate

# Start server
npm run dev

# Make yourself admin (in psql)
UPDATE "User" SET role = 'ADMIN' WHERE email = 'your@email.com';
```

## 🆘 Troubleshooting

### "psql: command not found"
Install PostgreSQL client: https://www.postgresql.org/download/

### "connection refused"
Check GCP firewall allows your IP

### "password authentication failed"
Password is already in the script, should work automatically

### Still getting Prisma errors?
```bash
# Delete and regenerate
Remove-Item -Path "node_modules\.prisma" -Recurse -Force
npx prisma generate
npm run dev
```

## 📁 Files Available

1. **`RESET_NOW.ps1`** ⭐ - One command solution (USE THIS)
2. **`reset-gcp-database.ps1`** - Full featured script
3. **`reset-gcp-database.sh`** - Bash version
4. **`reset-database.sql`** - Raw SQL script
5. **`QUICK_START.md`** - This guide

---

**Start here: `.\RESET_NOW.ps1`** 🚀
