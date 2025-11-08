# Authentication & Role-Based Access Updates

## Overview
Updated the authentication system to support role selection for both OAuth (Google) and manual signup/login, plus added role-based navigation at the top of dashboard pages.

## Changes Made

### 1. OAuth Role Selection Flow

#### New Page: `/auth/role-setup`
- **Purpose**: Allows OAuth users (Google login) to select their role after first login
- **Flow**:
  1. User signs in with Google
  2. If user is new or has default role, redirect to `/auth/role-setup`
  3. User selects role from modal
  4. Role is saved to database and session is updated
  5. User is redirected to dashboard

#### Updated Files:
- **`/app/auth/role-setup/page.js`** (NEW)
  - Checks if user needs to select role
  - Shows RoleSelectionModal
  - Redirects to dashboard after role selection

- **`/lib/auth.js`**
  - Added `newUser: "/auth/role-setup"` to pages config
  - OAuth users are redirected here on first login

- **`/app/login/page.js`**
  - Updated Google sign-in callback URL to `/auth/role-setup`
  - OAuth users will go through role selection

### 2. Manual Login/Signup with Role Selection

#### Updated Login Page
- **Signup Form** now includes role selection dropdown
- **Roles Available**:
  - Team Member (default)
  - Project Manager
  - Sales
  - Finance
  - Admin

#### Features:
- Role dropdown with icon
- Helper text explaining role selection
- Role is saved during signup
- Manual login works with any role

### 3. Role-Based Navigation Component

#### New Component: `RoleBasedNav`
- **Location**: `/components/RoleBasedNav.jsx`
- **Purpose**: Shows navigation links based on user's role
- **Position**: Sticky at top of dashboard pages (below main menu)

#### Navigation by Role:

**ADMIN**
- Dashboard
- Projects
- Users
- Sales Orders
- Invoices
- Analytics
- Settings

**PROJECT_MANAGER**
- Dashboard
- Projects
- My Tasks
- Analytics

**TEAM_MEMBER**
- Dashboard
- My Projects
- My Tasks

**SALES**
- Dashboard
- Projects
- Sales Orders
- Invoices
- Analytics

**FINANCE**
- Dashboard
- Projects
- Invoices
- Vendor Bills
- Expenses
- Analytics

#### Features:
- Active link highlighting
- Role badge display
- Responsive design (icons on mobile, text on desktop)
- Smooth hover effects
- Color-coded role badges

### 4. Updated Dashboard Layout

#### Changes to `/app/dashboard/layout.js`:
- Added `RoleBasedNav` component
- Positioned below main menu (sticky)
- Available on all dashboard pages

### 5. Updated RoleSelectionModal

#### Improvements:
- Now updates session after role selection
- Uses NextAuth `update()` function
- Properly refreshes user data
- Better error handling

## User Flows

### Flow 1: New User - Manual Signup
1. Go to `/login`
2. Click "Sign up"
3. Enter name, email, password
4. **Select role from dropdown**
5. Click "Create Account"
6. Automatically logged in
7. Redirected to dashboard with role-based navigation

### Flow 2: New User - Google OAuth
1. Go to `/login`
2. Click "Continue with Google"
3. Authenticate with Google
4. **Redirected to `/auth/role-setup`**
5. **Select role from modal**
6. Click "Continue with [Role]"
7. Redirected to dashboard with role-based navigation

### Flow 3: Existing User - Login
1. Go to `/login`
2. Enter email and password
3. Click "Sign In"
4. Redirected to dashboard
5. See role-based navigation based on existing role

### Flow 4: Existing User - Google OAuth
1. Go to `/login`
2. Click "Continue with Google"
3. Authenticate with Google
4. If role already set, go directly to dashboard
5. If no role, go to role-setup page
6. See role-based navigation

## Testing Checklist

### Manual Signup
- [ ] Create account with Team Member role
- [ ] Create account with Project Manager role
- [ ] Create account with Admin role
- [ ] Verify role is saved in database
- [ ] Verify correct navigation appears

### Manual Login
- [ ] Login with Team Member account
- [ ] Login with Project Manager account
- [ ] Login with Admin account
- [ ] Verify correct navigation for each role

### OAuth (Google)
- [ ] Sign up with new Google account
- [ ] Verify redirect to role-setup page
- [ ] Select role and continue
- [ ] Verify role is saved
- [ ] Login again with same Google account
- [ ] Verify direct redirect to dashboard (no role-setup)

### Role-Based Navigation
- [ ] Verify Admin sees all navigation items
- [ ] Verify Project Manager sees limited items
- [ ] Verify Team Member sees minimal items
- [ ] Verify active link highlighting works
- [ ] Verify role badge displays correctly
- [ ] Test responsive behavior on mobile

## Database Schema

No changes needed - existing schema already supports roles:

```prisma
model User {
  id    String @id @default(uuid())
  email String @unique
  name  String?
  role  Role   @default(TEAM_MEMBER)
  // ... other fields
}

enum Role {
  ADMIN
  PROJECT_MANAGER
  TEAM_MEMBER
  SALES
  FINANCE
}
```

## API Endpoints Used

### `/api/user/profile` (PUT)
- Updates user profile including role
- Used by RoleSelectionModal
- Validates role before saving

### `/api/auth/signup` (POST)
- Creates new user with role
- Accepts role parameter
- Defaults to TEAM_MEMBER if not provided

## Security Considerations

1. **Role Validation**: API validates role against enum before saving
2. **Session Updates**: Role changes update JWT token immediately
3. **Authorization**: RBAC middleware checks permissions on all protected routes
4. **Default Role**: New users default to TEAM_MEMBER (least privilege)

## UI/UX Improvements

1. **Visual Feedback**: Role badge always visible in navigation
2. **Clear Hierarchy**: Navigation items ordered by importance
3. **Responsive**: Works on all screen sizes
4. **Accessible**: Proper ARIA labels and keyboard navigation
5. **Consistent**: Same design language across all pages

## Files Created/Modified

### New Files:
- `/app/auth/role-setup/page.js`
- `/components/RoleBasedNav.jsx`
- `AUTH_UPDATES.md` (this file)

### Modified Files:
- `/lib/auth.js` - Added newUser page config
- `/app/login/page.js` - Updated OAuth callback, added role dropdown
- `/app/dashboard/layout.js` - Added RoleBasedNav component
- `/components/RoleSelectionModal.jsx` - Added session update

## Environment Variables

No new environment variables needed. Existing OAuth setup works:

```env
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
NEXTAUTH_SECRET=your_secret
NEXTAUTH_URL=http://localhost:3000
```

## Troubleshooting

### OAuth users not seeing role-setup
- Check `newUser` page is set in auth config
- Verify callback URL in Google Console includes `/auth/role-setup`

### Role not updating after selection
- Check session update is called in RoleSelectionModal
- Verify API endpoint returns success
- Check browser console for errors

### Navigation not showing correct items
- Verify session contains role
- Check role matches enum values exactly
- Refresh page to reload session

### Manual login not working
- Verify password is at least 6 characters
- Check email format is valid
- Verify user exists in database
- Check browser console for errors

## Next Steps

1. **Test with real Google OAuth** - Set up Google Console project
2. **Add role change** - Allow admins to change user roles
3. **Add permissions UI** - Show what each role can do
4. **Add audit log** - Track role changes
5. **Add role-based redirects** - Different landing pages per role

---

**Implementation Date**: November 2024
**Version**: 1.1.0
**Status**: ✅ Complete
