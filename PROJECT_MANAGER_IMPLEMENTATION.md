# Project Manager Implementation - OneFlow

## Overview
This document describes the implementation of the Project Manager module with role-based access control (RBAC) and Kanban-style task board for the OneFlow project management system.

## Features Implemented

### 1. Role-Based Access Control (RBAC)
- **Location**: `/lib/rbac.js`
- **Roles Supported**:
  - `ADMIN`: Full access to all features
  - `PROJECT_MANAGER`: Can create, read, update, and delete projects they manage
  - `TEAM_MEMBER`: Can view assigned projects and update their tasks
  - `SALES`: Can view projects and manage financial documents
  - `FINANCE`: Can view projects and manage financial documents

- **Permissions Matrix**:
  ```javascript
  ADMIN: All permissions
  PROJECT_MANAGER: 
    - Projects: create, read, update, delete (own projects)
    - Tasks: create, read, update, delete
    - Financials: create, read, update
  TEAM_MEMBER:
    - Projects: read (assigned only)
    - Tasks: read, update (assigned only)
  ```

### 2. API Routes

#### Project APIs
- **GET /api/projects** - List all projects (filtered by role)
- **POST /api/projects** - Create new project
- **GET /api/projects/[id]** - Get project details
- **PATCH /api/projects/[id]** - Update project
- **DELETE /api/projects/[id]** - Delete project

#### Task APIs
- **GET /api/tasks** - List tasks (filtered by project/user)
- **POST /api/tasks** - Create new task
- **GET /api/tasks/[id]** - Get task details
- **PATCH /api/tasks/[id]** - Update task
- **DELETE /api/tasks/[id]** - Delete task
- **POST /api/tasks/reorder** - Reorder tasks (for drag-and-drop)

#### User APIs
- **GET /api/users** - Get all users (for assignment)

### 3. UI Components

#### Pages
1. **Projects Dashboard** (`/dashboard/projects`)
   - Grid view of all projects as cards
   - Filter by status (All, Planned, In Progress, On Hold, Completed)
   - KPI cards showing project statistics
   - Project cards display:
     - Status badge
     - Progress bar
     - Task statistics (total, completed, in progress, blocked)
     - Financial summary (budget, revenue, cost, profit)
     - Team members with avatars
     - Timeline dates

2. **New Project** (`/dashboard/projects/new`)
   - Form to create new project
   - Fields: name, code, description, manager, status, dates, budget
   - Team member selection with checkboxes
   - Validation and error handling

3. **Project Detail** (`/dashboard/projects/[id]`)
   - Three tabs: Project, Tasks, Settings
   - **Project Tab**:
     - Project details card
     - Team members list
     - Quick stats (budget, revenue, cost, profit)
   - **Tasks Tab**:
     - Kanban board with drag-and-drop
     - Create new task button
   - **Settings Tab**:
     - Links to financial documents
     - Danger zone for project deletion

#### Components

1. **KanbanBoard** (`/components/KanbanBoard.jsx`)
   - Uses `@dnd-kit` library for drag-and-drop
   - Four columns: New, In Progress, Blocked, Done
   - Task cards with:
     - Cover image (optional)
     - Priority badge
     - Title and description
     - Deadline
     - Comments, attachments, and hours count
     - Assignee avatar
   - Drag tasks between columns to update status
   - Automatic reordering with API sync

2. **CreateTaskDialog** (`/components/CreateTaskDialog.jsx`)
   - Modal dialog for creating new tasks
   - Fields: title, description, status, priority, assignee, deadline, estimated hours, cover URL
   - User selection dropdown
   - Form validation

3. **UI Components** (shadcn/ui based)
   - Card, Button, Badge, Avatar
   - Tabs, Dialog, Select
   - Input, Label, Textarea

### 4. Database Schema
The implementation uses the existing Prisma schema with:
- `Project` model with status, dates, budget, revenue, cost
- `Task` model with status, priority, orderIndex for drag-and-drop
- `ProjectMember` for team assignments
- `User` model with role-based access

### 5. Key Features

#### Drag-and-Drop Task Board
- Smooth drag-and-drop using `@dnd-kit/core` and `@dnd-kit/sortable`
- Visual feedback during drag
- Optimistic UI updates
- Server-side persistence
- Automatic reordering within columns

#### Role-Based Filtering
- Project Managers see only their projects
- Team Members see only assigned projects
- Admins see all projects
- API-level enforcement of permissions

#### Real-time Updates
- Tasks update immediately on drag
- API sync in background
- Error handling with rollback

#### Responsive Design
- Mobile-friendly layout
- Grid adapts to screen size
- Horizontal scroll for Kanban board on mobile

## Installation & Setup

### 1. Install Dependencies
```bash
npm install @dnd-kit/core @dnd-kit/sortable @dnd-kit/utilities
npm install @radix-ui/react-select @radix-ui/react-dialog
```

### 2. Database Setup
```bash
npx prisma generate
npx prisma db push
```

### 3. Environment Variables
Ensure `.env` has:
```
DATABASE_URL="your-database-url"
NEXTAUTH_SECRET="your-secret"
```

## Usage

### For Project Managers

1. **Create a Project**:
   - Navigate to `/dashboard/projects`
   - Click "New Project"
   - Fill in project details
   - Select team members
   - Click "Create Project"

2. **Manage Tasks**:
   - Open a project
   - Go to "Tasks" tab
   - Click "New Task" to create
   - Drag tasks between columns to update status
   - Click on a task card for details

3. **View Progress**:
   - Project cards show completion percentage
   - Task statistics visible on cards
   - Financial summary shows budget vs actual

### For Team Members

1. **View Assigned Projects**:
   - Navigate to `/dashboard/projects`
   - See only projects you're assigned to

2. **Update Tasks**:
   - Open a project
   - View tasks in Kanban board
   - Drag your tasks to update status

## API Authentication

All API routes are protected with NextAuth:
- Session-based authentication
- JWT tokens with role information
- Middleware checks permissions before allowing operations

## Future Enhancements

1. **Task Details Modal**: Click task card to view/edit full details
2. **Bulk Operations**: Select multiple tasks for batch updates
3. **Task Comments**: Add comments directly from Kanban board
4. **Time Tracking**: Log hours from task cards
5. **Notifications**: Real-time updates when tasks change
6. **Search & Filter**: Advanced filtering on task board
7. **Custom Columns**: Allow custom task statuses
8. **Task Dependencies**: Link tasks with dependencies
9. **Gantt Chart**: Timeline view of tasks
10. **Export**: Export projects and tasks to CSV/PDF

## Technical Stack

- **Framework**: Next.js 16 (App Router)
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: NextAuth.js
- **UI Library**: Radix UI + Tailwind CSS
- **Drag & Drop**: @dnd-kit
- **State Management**: React Hooks
- **API**: Next.js API Routes

## File Structure

```
OneFlow/
├── app/
│   ├── api/
│   │   ├── projects/
│   │   │   ├── route.js
│   │   │   └── [id]/route.js
│   │   ├── tasks/
│   │   │   ├── route.js
│   │   │   ├── [id]/route.js
│   │   │   └── reorder/route.js
│   │   └── users/route.js
│   └── dashboard/
│       └── projects/
│           ├── page.js
│           ├── new/page.js
│           └── [id]/page.js
├── components/
│   ├── KanbanBoard.jsx
│   ├── CreateTaskDialog.jsx
│   └── ui/
│       ├── card.jsx
│       ├── button.jsx
│       ├── dialog.jsx
│       ├── select.jsx
│       └── ...
├── lib/
│   ├── rbac.js
│   ├── prisma.js
│   └── auth.js
└── prisma/
    └── schema.prisma
```

## Testing

### Manual Testing Checklist

- [ ] Create project as Project Manager
- [ ] View projects list with filters
- [ ] Create tasks in project
- [ ] Drag tasks between columns
- [ ] Verify task order persists after refresh
- [ ] Test role-based access (try accessing as Team Member)
- [ ] Update project details
- [ ] Add/remove team members
- [ ] View financial summary
- [ ] Delete project

## Troubleshooting

### Tasks not reordering
- Check browser console for API errors
- Verify `orderIndex` field exists in database
- Check network tab for failed requests

### Permission denied errors
- Verify user role in session
- Check RBAC permissions in `/lib/rbac.js`
- Ensure user is project manager or admin

### Drag and drop not working
- Verify `@dnd-kit` packages are installed
- Check for JavaScript errors in console
- Ensure task IDs are unique

## Support

For issues or questions:
1. Check the console for error messages
2. Review API responses in Network tab
3. Verify database schema matches Prisma schema
4. Check authentication session

---

**Implementation Date**: November 2024
**Version**: 1.0.0
**Status**: ✅ Complete
