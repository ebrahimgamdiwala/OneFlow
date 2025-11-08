# Team Member Comment System Implementation

## Overview
Implemented role-based task interaction where TEAM_MEMBER users can only update task status and add comments visible to their manager, not edit critical task details.

## Key Features Implemented

### 1. Comment-Only Access for Team Members
- ✅ Team members can no longer edit critical task fields (title, description, assignee, priority, deadline, estimate)
- ✅ Team members can only update task status
- ✅ Team members can add comments to communicate with their manager
- ✅ Clear visual indicators showing restricted access

### 2. Privacy-Filtered Comments
**Comment Visibility Rules**:
- **TEAM_MEMBER**: Can see only:
  - Their own comments
  - Manager's comments (responses/guidance)
  - **Cannot see other team members' comments**
- **PROJECT_MANAGER**: Can see all comments on tasks in their projects
- **ADMIN**: Can see all comments

### 3. New Components & APIs

#### Created Files:
1. **`components/TaskCommentDialog.jsx`** (353 lines)
   - Dedicated dialog for adding/viewing comments
   - Shows task details in read-only mode
   - Comment form with real-time submission
   - Filtered comment list based on user role
   - Delete own comments functionality
   - Visual indicators (Manager badge, "You" badge, etc.)

2. **`app/api/tasks/[id]/comments/route.js`** (267 lines)
   - **GET**: Fetch comments with role-based filtering
   - **POST**: Add new comment with validation
   - **DELETE**: Remove own comments (with manager override)
   - Access control checks (project membership, task assignment)

#### Modified Files:
3. **`components/EditTaskDialog.jsx`**
   - Added `userRole` prop
   - Team members see restricted form (status only)
   - Alert message explaining limitations
   - Lock icons on read-only fields
   - Encourages use of comments for communication

4. **`app/dashboard/tasks/page.js`**
   - Imported `TaskCommentDialog`
   - Added comment dialog state management
   - Updated `handleTaskClick` to show comment dialog for team members
   - Added `handleAddComment` function
   - Non-team members get "Comment" button on task cards
   - Team members click card to open comment dialog directly

## User Experience

### Team Member Flow:
1. Views list of assigned tasks
2. Clicks on a task → Opens **Comment Dialog** (not edit dialog)
3. Sees task details in read-only format
4. Can add comments visible to manager
5. Can update task status only (if needed, done in edit mode)
6. Sees own comments and manager's responses
7. **Cannot see comments from other team members**

### Project Manager Flow:
1. Views all tasks in managed projects
2. Clicks on a task → Opens **Edit Dialog** (full edit access)
3. Sees "Comment" button on task cards
4. Clicks comment button → Opens **Comment Dialog**
5. Can view all comments from all team members
6. Can respond to team member comments
7. Comments visible to respective team members

### Admin Flow:
1. Full access to edit any task
2. Can view and manage all comments
3. Can delete any comment

## Privacy & Security

### API-Level Enforcement:
```javascript
// GET /api/tasks/[id]/comments
if (user.role === 'TEAM_MEMBER') {
  whereClause.OR = [
    { authorId: user.id },              // Own comments
    { authorId: task.project.managerId } // Manager's comments
  ];
}
// PROJECT_MANAGER & ADMIN see all comments
```

### Access Control Checks:
- ✅ Verify user is project member or task assignee
- ✅ Verify user has permission to view task
- ✅ Filter comments based on role
- ✅ Only author/manager/admin can delete comments

## Visual Indicators

### Comment Dialog Features:
- 📝 "Add a comment for your manager" placeholder for team members
- 🔒 Shield icon: "Only you and your manager can see your comments"
- 👤 "You" badge on own comments
- 👨‍💼 "Manager" badge with shield icon
- ⏰ Relative timestamps (e.g., "2h ago", "5d ago")
- 🗑️ Delete button (only on own comments)

### Edit Dialog Restrictions:
- 🔒 Lock icons on restricted fields for team members
- ⚠️ Alert: "As a team member, you can only update the task status"
- 🔴 Disabled input fields (title, description, assignee, priority, deadline, estimate)
- ✅ Enabled status dropdown

## Database Schema
Uses existing `TaskComment` model:
```prisma
model TaskComment {
  id        String   @id @default(uuid())
  task      Task     @relation(fields: [taskId], references: [id], onDelete: Cascade)
  taskId    String
  author    User?    @relation(fields: [authorId], references: [id], onDelete: SetNull)
  authorId  String?
  content   String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

## Testing Checklist

### Team Member Tests:
- [ ] Login as TEAM_MEMBER
- [ ] Click on assigned task → Comment dialog opens (not edit dialog)
- [ ] Add a comment → Visible in list immediately
- [ ] Verify comment shows "You" badge
- [ ] Verify cannot see other team members' comments
- [ ] Manager adds comment → Verify team member sees it with "Manager" badge
- [ ] Delete own comment → Successful
- [ ] Try to edit task → Only status field enabled
- [ ] All critical fields (title, description, etc.) are disabled/read-only

### Project Manager Tests:
- [ ] Login as PROJECT_MANAGER
- [ ] Click task → Edit dialog opens (full access)
- [ ] Click "Comment" button → Comment dialog opens
- [ ] View comments → See all team member comments
- [ ] Add comment → Visible to respective team member
- [ ] Verify can see comments from multiple team members
- [ ] Delete team member's comment → Should be allowed

### Privacy Verification:
- [ ] Team Member A adds comment on Task X
- [ ] Team Member B (different user) assigned to Task Y
- [ ] Verify Team Member B cannot see Team Member A's comments
- [ ] Manager can see both comments
- [ ] Verify API returns filtered results (check Network tab)

## Benefits

1. **Clear Communication Channels**
   - Team members communicate via comments
   - Managers see all feedback in one place
   - No cross-team comment visibility for privacy

2. **Prevents Accidental Changes**
   - Critical task details protected from team member edits
   - Only authorized users can modify title, assignee, deadline, etc.

3. **Audit Trail**
   - All comments timestamped
   - Author attribution
   - Manager responses visible to relevant team member

4. **Role-Based UX**
   - Different dialogs based on role
   - Clear visual indicators of permissions
   - Intuitive interaction model

## Future Enhancements

1. **Comment Mentions**: @mention users in comments
2. **Comment Notifications**: Email/push notifications for new comments
3. **Rich Text**: Support for formatting, code blocks, links
4. **Comment Threads**: Reply to specific comments
5. **Comment Reactions**: Like/emoji reactions
6. **Comment Attachments**: Upload files with comments
7. **Comment Search**: Full-text search across comments
8. **Comment Analytics**: Track response times, engagement

## API Endpoints Summary

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/api/tasks/[id]/comments` | Fetch filtered comments | All (filtered by role) |
| POST | `/api/tasks/[id]/comments` | Add new comment | All assigned members |
| DELETE | `/api/tasks/[id]/comments?commentId=X` | Delete comment | Author/Manager/Admin |

## Summary

This implementation successfully achieves the goal of restricting team members from editing critical task details while providing a robust comment system for communication with managers. The privacy-filtered comment system ensures team members only see relevant conversations (own + manager), maintaining proper information boundaries while enabling effective collaboration.
