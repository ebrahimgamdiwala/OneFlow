# Setup Guide - OneFlow Project Manager

## Prerequisites

- Node.js 20.9.0 or higher
- PostgreSQL database
- npm 10.0.0 or higher

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Setup Environment Variables

Create a `.env` file in the root directory:

```env
# Database
DATABASE_URL="postgresql://username:password@localhost:5432/oneflow"

# NextAuth
NEXTAUTH_SECRET="your-secret-key-here"
NEXTAUTH_URL="http://localhost:3000"

# Google OAuth (Optional)
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
```

**Generate NEXTAUTH_SECRET:**
```bash
openssl rand -base64 32
```

### 3. Initialize Database

```bash
# Generate Prisma Client
npx prisma generate

# Push schema to database
npx prisma db push

# Optional: Seed database with test data
# npx prisma db seed
```

### 4. Start Development Server

```bash
npm run dev
```

Visit: `http://localhost:3000`

## Detailed Setup

### Database Setup (PostgreSQL)

#### Option 1: Local PostgreSQL

1. **Install PostgreSQL**
   - Windows: Download from [postgresql.org](https://www.postgresql.org/download/windows/)
   - Mac: `brew install postgresql`
   - Linux: `sudo apt-get install postgresql`

2. **Create Database**
   ```bash
   # Login to PostgreSQL
   psql -U postgres
   
   # Create database
   CREATE DATABASE oneflow;
   
   # Create user (optional)
   CREATE USER oneflow_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE oneflow TO oneflow_user;
   
   # Exit
   \q
   ```

3. **Update .env**
   ```env
   DATABASE_URL="postgresql://oneflow_user:your_password@localhost:5432/oneflow"
   ```

#### Option 2: Cloud Database (Recommended for Production)

**Neon (Free Tier)**
1. Go to [neon.tech](https://neon.tech)
2. Create account and project
3. Copy connection string
4. Update `.env` with connection string

**Supabase (Free Tier)**
1. Go to [supabase.com](https://supabase.com)
2. Create project
3. Get connection string from Settings → Database
4. Update `.env`

### Google OAuth Setup (Optional)

1. **Go to Google Cloud Console**
   - Visit: [console.cloud.google.com](https://console.cloud.google.com)

2. **Create Project**
   - Click "New Project"
   - Name it "OneFlow"

3. **Enable APIs**
   - Go to "APIs & Services" → "Library"
   - Search for "Google+ API"
   - Click "Enable"

4. **Create OAuth Credentials**
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth 2.0 Client ID"
   - Application type: "Web application"
   - Name: "OneFlow Web"

5. **Add Authorized Redirect URIs**
   ```
   http://localhost:3000/api/auth/callback/google
   https://yourdomain.com/api/auth/callback/google
   ```

6. **Copy Credentials**
   - Copy Client ID and Client Secret
   - Add to `.env` file

### First User Setup

#### Option 1: Manual Signup
1. Go to `http://localhost:3000/login`
2. Click "Sign up"
3. Fill in details
4. **Select role** (Admin, Project Manager, etc.)
5. Create account

#### Option 2: Direct Database Insert
```sql
-- Connect to database
psql -U postgres -d oneflow

-- Insert admin user (password: admin123)
INSERT INTO "User" (id, email, name, role, password, "createdAt", "updatedAt")
VALUES (
  gen_random_uuid(),
  'admin@example.com',
  'Admin User',
  'ADMIN',
  '$2a$10$YourHashedPasswordHere',
  NOW(),
  NOW()
);
```

**Generate hashed password:**
```javascript
// Run in Node.js
const bcrypt = require('bcryptjs');
const hash = await bcrypt.hash('admin123', 10);
console.log(hash);
```

## Verification Steps

### 1. Check Database Connection
```bash
npx prisma studio
```
This opens a GUI to view your database.

### 2. Test API Endpoints
```bash
# Health check
curl http://localhost:3000/api/health

# Database test
curl http://localhost:3000/api/db-test
```

### 3. Test Authentication
1. Go to `/login`
2. Try signing up
3. Try logging in
4. Check if dashboard loads

### 4. Test Role-Based Access
1. Create users with different roles
2. Login as each user
3. Verify navigation shows correct items
4. Test project creation (Project Manager)
5. Test task viewing (Team Member)

## Project Structure

```
OneFlow/
├── app/
│   ├── api/              # API routes
│   │   ├── auth/         # Authentication
│   │   ├── projects/     # Project CRUD
│   │   ├── tasks/        # Task CRUD
│   │   └── users/        # User management
│   ├── dashboard/        # Dashboard pages
│   │   ├── projects/     # Projects UI
│   │   └── layout.js     # Dashboard layout
│   ├── auth/
│   │   └── role-setup/   # OAuth role selection
│   └── login/            # Login/Signup page
├── components/
│   ├── ui/               # UI components
│   ├── KanbanBoard.jsx   # Task board
│   ├── RoleBasedNav.jsx  # Navigation
│   └── CreateTaskDialog.jsx
├── lib/
│   ├── auth.js           # NextAuth config
│   ├── rbac.js           # Role-based access
│   └── prisma.js         # Prisma client
├── prisma/
│   └── schema.prisma     # Database schema
└── .env                  # Environment variables
```

## Features Overview

### For Project Managers
- Create and manage projects
- Assign team members
- Create and organize tasks
- View project analytics
- Manage budgets and timelines

### For Team Members
- View assigned projects
- Update task status
- Log work hours
- View project details

### For Admins
- Full system access
- User management
- System settings
- All project access

## Common Commands

```bash
# Development
npm run dev              # Start dev server
npm run build           # Build for production
npm start               # Start production server

# Database
npx prisma studio       # Open database GUI
npx prisma generate     # Generate Prisma client
npx prisma db push      # Push schema to database
npx prisma migrate dev  # Create migration
npx prisma db pull      # Pull schema from database

# Prisma Studio
npx prisma studio       # Visual database editor

# Linting
npm run lint            # Run ESLint
```

## Troubleshooting

If you encounter errors, see `TROUBLESHOOTING.md` for detailed solutions.

### Quick Fixes

**500 Error on Login:**
```bash
npx prisma generate
npx prisma db push
# Restart server
```

**Database Connection Error:**
- Check PostgreSQL is running
- Verify DATABASE_URL in .env
- Test connection: `npx prisma db pull`

**OAuth Not Working:**
- Verify Google credentials in .env
- Check redirect URIs in Google Console
- Clear browser cookies

## Production Deployment

### Environment Variables
Set these in your hosting platform:
```env
DATABASE_URL="your-production-database-url"
NEXTAUTH_SECRET="your-production-secret"
NEXTAUTH_URL="https://yourdomain.com"
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
```

### Build Command
```bash
npm run build
```

### Start Command
```bash
npm start
```

### Recommended Platforms
- **Vercel** (Recommended for Next.js)
- **Netlify**
- **Railway**
- **Render**

## Support

- Check `TROUBLESHOOTING.md` for common issues
- Check `PROJECT_MANAGER_IMPLEMENTATION.md` for feature docs
- Check `AUTH_UPDATES.md` for authentication details

## Next Steps

1. ✅ Complete setup steps above
2. ✅ Create your first admin user
3. ✅ Login and explore dashboard
4. ✅ Create a test project
5. ✅ Add team members
6. ✅ Create tasks and test Kanban board
7. ✅ Test role-based access with different users

---

**Version**: 1.0.0
**Last Updated**: November 2024
