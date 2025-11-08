# Troubleshooting Guide - OneFlow

## Common Errors and Solutions

### 1. "500 Internal Server Error" on Login/Signup

**Error Message:**
```
Failed to load resource: the server responded with a status of 500
Auth error: SyntaxError: Unexpected token '<', "<!DOCTYPE "... is not valid JSON
```

**Cause:** The server is returning an HTML error page instead of JSON, usually due to:
- Database not initialized
- Missing environment variables
- Prisma client not generated

**Solutions:**

#### Step 1: Check Database Connection
1. Verify `.env` file exists with `DATABASE_URL`
2. Check if database is running (PostgreSQL)
3. Test connection:
```bash
npx prisma db push
```

#### Step 2: Generate Prisma Client
```bash
npx prisma generate
```

#### Step 3: Initialize Database
```bash
# Push schema to database
npx prisma db push

# Or run migrations
npx prisma migrate dev --name init
```

#### Step 4: Verify Environment Variables
Check `.env` file has:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/oneflow"
NEXTAUTH_SECRET="your-secret-key-here"
NEXTAUTH_URL="http://localhost:3000"

# Optional for OAuth
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
```

#### Step 5: Restart Dev Server
```bash
# Stop the server (Ctrl+C)
npm run dev
```

### 2. OAuth (Google) Login Not Working

**Symptoms:**
- Redirect loop
- "Configuration error"
- 500 error after Google authentication

**Solutions:**

#### Check Google OAuth Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Google+ API
3. Create OAuth 2.0 credentials
4. Add authorized redirect URIs:
   - `http://localhost:3000/api/auth/callback/google`
   - `https://yourdomain.com/api/auth/callback/google`

#### Verify Environment Variables
```env
GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET="your-client-secret"
```

#### Test OAuth Flow
1. Clear browser cookies
2. Try login in incognito mode
3. Check browser console for errors

### 3. Role Selection Not Saving

**Symptoms:**
- Role modal appears every time
- Role not persisting after selection
- Session not updating

**Solutions:**

#### Check API Endpoint
Test the profile update endpoint:
```bash
# Using curl or Postman
POST http://localhost:3000/api/user/profile
Content-Type: application/json
Authorization: Bearer <your-token>

{
  "name": "John Doe",
  "role": "PROJECT_MANAGER"
}
```

#### Verify Session Update
Check if session is being updated in `RoleSelectionModal.jsx`:
```javascript
await update({
  user: {
    role: selectedRole,
    name: userName,
  },
});
```

#### Clear Session and Try Again
1. Logout
2. Clear browser cookies
3. Login again
4. Select role

### 4. Database Connection Errors

**Error Messages:**
- "Can't reach database server"
- "Connection timeout"
- "Authentication failed"

**Solutions:**

#### Check PostgreSQL is Running
```bash
# Windows
Get-Service postgresql*

# Linux/Mac
sudo systemctl status postgresql
```

#### Verify Database Exists
```bash
psql -U postgres
\l  # List databases
CREATE DATABASE oneflow;  # If not exists
\q
```

#### Test Connection String
```bash
# Test connection
npx prisma db pull
```

### 5. Prisma Client Errors

**Error Messages:**
- "PrismaClient is unable to run in the browser"
- "@prisma/client did not initialize yet"
- "Unknown field" errors

**Solutions:**

#### Regenerate Prisma Client
```bash
npx prisma generate
```

#### Clear Node Modules
```bash
rm -rf node_modules
rm package-lock.json
npm install
npx prisma generate
```

#### Check Prisma Schema
Verify `prisma/schema.prisma` is valid:
```bash
npx prisma validate
```

### 6. NextAuth Configuration Errors

**Error Messages:**
- "Please define a `secret` in production"
- "Invalid `callbackUrl`"
- "Configuration error"

**Solutions:**

#### Generate Secret
```bash
# Generate a secure secret
openssl rand -base64 32
```

Add to `.env`:
```env
NEXTAUTH_SECRET="generated-secret-here"
```

#### Verify NextAuth URL
```env
# Development
NEXTAUTH_URL="http://localhost:3000"

# Production
NEXTAUTH_URL="https://yourdomain.com"
```

### 7. Role-Based Navigation Not Showing

**Symptoms:**
- Navigation bar is empty
- Wrong navigation items for role
- Navigation not updating after role change

**Solutions:**

#### Check Session
Verify session contains role:
```javascript
// In any client component
const { data: session } = useSession();
console.log(session?.user?.role);
```

#### Force Session Refresh
```javascript
import { useSession } from "next-auth/react";

const { update } = useSession();
await update(); // Force refresh
```

#### Clear Cache
1. Hard refresh browser (Ctrl+Shift+R)
2. Clear browser cache
3. Restart dev server

### 8. Manual Login Not Working

**Symptoms:**
- "Invalid credentials" error
- Password not matching
- User not found

**Solutions:**

#### Verify User Exists
```bash
npx prisma studio
# Check Users table
```

#### Check Password Hashing
Verify password is being hashed in signup:
```javascript
// In /api/auth/signup/route.js
const hashedPassword = await hashPassword(password);
```

#### Test Credentials Provider
Check `/lib/auth.js` has CredentialsProvider configured

### 9. Build Errors

**Error Messages:**
- "Module not found"
- "Cannot find module '@/components/...'"
- "Unexpected token"

**Solutions:**

#### Check Imports
Verify all imports use correct paths:
```javascript
import Component from "@/components/Component"
// Not: import Component from "../components/Component"
```

#### Verify jsconfig.json
```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

#### Clean Build
```bash
rm -rf .next
npm run build
```

## Quick Fixes Checklist

When something goes wrong, try these in order:

1. **Restart Dev Server**
   ```bash
   # Ctrl+C to stop
   npm run dev
   ```

2. **Regenerate Prisma**
   ```bash
   npx prisma generate
   npx prisma db push
   ```

3. **Clear Browser**
   - Clear cookies
   - Clear cache
   - Try incognito mode

4. **Check Logs**
   - Browser console
   - Terminal output
   - Network tab in DevTools

5. **Verify Environment**
   - Check `.env` file exists
   - Verify all required variables
   - Check database is running

6. **Reinstall Dependencies**
   ```bash
   rm -rf node_modules
   npm install
   ```

## Getting Help

### Check Console Logs
1. Open browser DevTools (F12)
2. Check Console tab for errors
3. Check Network tab for failed requests

### Check Server Logs
Look at terminal where `npm run dev` is running

### Database Issues
```bash
# Check database status
npx prisma studio

# View database logs
# Check PostgreSQL logs in data directory
```

### Still Stuck?

1. Check the error message carefully
2. Search for the specific error in this guide
3. Check browser console for more details
4. Verify all environment variables are set
5. Try the Quick Fixes Checklist above

## Prevention Tips

1. **Always run Prisma generate after schema changes**
   ```bash
   npx prisma generate
   ```

2. **Keep dependencies updated**
   ```bash
   npm update
   ```

3. **Use environment variables for secrets**
   - Never commit `.env` file
   - Use `.env.example` as template

4. **Test in incognito mode**
   - Avoids cookie/cache issues
   - Clean slate for testing

5. **Check database regularly**
   ```bash
   npx prisma studio
   ```

---

**Last Updated**: November 2024
**Version**: 1.0.0
