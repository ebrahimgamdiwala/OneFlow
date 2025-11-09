# Troubleshooting 403 Forbidden Error

## Issue
Getting 403 (Forbidden) errors when accessing admin endpoints even with ADMIN role set.

## Root Cause
The `PERMISSIONS` object in `/lib/rbac.js` was missing the `analytics` and `database` resources that the admin API endpoints were checking for.

## Solution Applied
Added `analytics` and `database` permissions to the RBAC system:

```javascript
ADMIN: {
  // ... existing permissions
  analytics: ['read'],
  database: ['read', 'update', 'delete'],
}
```

## Verification Steps

### 1. Verify User Role in Database
```sql
SELECT id, email, name, role FROM "User" WHERE email = 'your-email@example.com';
```
Expected: `role` should be `ADMIN`

### 2. Check Session
Add this to your admin dashboard component temporarily:
```javascript
console.log('Session:', session);
console.log('User Role:', session?.user?.role);
```

### 3. Test API Endpoints

**Test Analytics Endpoint:**
Open browser console and run:
```javascript
fetch('/api/admin/analytics?timeRange=30')
  .then(r => r.json())
  .then(d => console.log('Analytics:', d))
  .catch(e => console.error('Error:', e));
```

**Test Database Endpoint:**
```javascript
fetch('/api/admin/database')
  .then(r => r.json())
  .then(d => console.log('Database:', d))
  .catch(e => console.error('Error:', e));
```

### 4. Clear Session and Re-login
Sometimes the session needs to be refreshed:
1. Logout completely
2. Clear browser cookies for localhost:3000
3. Login again
4. Navigate to `/dashboard`

### 5. Restart Development Server
```bash
# Stop the server (Ctrl+C)
# Then restart
npm run dev
```

## Common Issues and Fixes

### Issue: Role is NULL in database
**Fix:**
```sql
UPDATE "User" SET role = 'ADMIN' WHERE email = 'your-email@example.com';
```

### Issue: Session not updating after role change
**Fix:**
1. Logout
2. Clear browser cookies
3. Login again

### Issue: NEXTAUTH_SECRET not set
**Fix:**
Add to `.env.local`:
```env
NEXTAUTH_SECRET="your-secret-key-here"
```

### Issue: Database connection error
**Fix:**
Check `DATABASE_URL` in `.env.local`:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/oneflow"
```

## Debug Mode

### Enable API Logging
Add to admin API routes temporarily:
```javascript
console.log('User:', authResult.user);
console.log('Role:', authResult.user?.role);
console.log('Checking permission:', resource, action);
```

### Check RBAC Permissions
Add to `/lib/rbac.js`:
```javascript
export function hasPermission(role, resource, action) {
  console.log('Checking permission:', { role, resource, action });
  const rolePermissions = PERMISSIONS[role];
  console.log('Role permissions:', rolePermissions);
  // ... rest of function
}
```

## Expected Behavior After Fix

1. **Admin Dashboard** (`/dashboard`):
   - Should load without errors
   - All tabs should be accessible
   - Charts should render with data

2. **API Endpoints**:
   - `/api/admin/analytics` - Returns analytics data
   - `/api/admin/database` - Returns database info
   - `/api/admin/bulk` - Accepts bulk operations

3. **Browser Console**:
   - No 403 errors
   - Successful API responses
   - Data loads correctly

## If Still Getting 403

### Step 1: Verify Permissions Object
Check `/lib/rbac.js` line 9-62 has:
```javascript
ADMIN: {
  analytics: ['read'],
  database: ['read', 'update', 'delete'],
  // ... other permissions
}
```

### Step 2: Check Session User Object
The session user must have:
```javascript
{
  id: "user-id",
  email: "user@example.com",
  name: "User Name",
  role: "ADMIN"  // Must be exactly "ADMIN"
}
```

### Step 3: Verify Auth Configuration
Check `/lib/auth.js` callbacks are setting role:
```javascript
async jwt({ token, user }) {
  if (user) {
    token.role = user.role;  // Must be set
  }
  return token;
}
```

### Step 4: Database Schema Check
Verify User table has role field:
```sql
\d "User"
```
Should show `role` column of type `Role` enum.

## Quick Fix Commands

```bash
# 1. Restart dev server
npm run dev

# 2. Open Prisma Studio
npm run prisma:studio

# 3. Check database
npm run prisma:studio
# Then navigate to User table and verify role is "ADMIN"

# 4. Generate Prisma Client (if schema changed)
npm run prisma:generate
```

## Contact Support

If issue persists after all steps:
1. Check browser console for exact error message
2. Check server terminal for error logs
3. Verify all files were saved
4. Try hard refresh (Ctrl+Shift+R)
5. Clear all browser cache and cookies

## Success Indicators

✅ No 403 errors in console
✅ Dashboard loads with data
✅ All tabs are accessible
✅ Charts render correctly
✅ Export button works
✅ Database tab shows tables

---

**Note**: After fixing RBAC permissions, you MUST logout and login again for the session to update with the correct permissions.
