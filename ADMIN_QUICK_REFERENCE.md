# Admin Panel Quick Reference Card

## 🚀 Quick Access URLs

| Feature | URL | Description |
|---------|-----|-------------|
| Main Dashboard | `/dashboard` | Comprehensive admin overview |
| Database Management | `/dashboard/admin/database/[table]` | View and manage any table |
| Project Comparison | `/dashboard/admin/comparison` | Compare multiple projects |
| Analytics API | `/api/admin/analytics` | Get analytics data |
| Database API | `/api/admin/database` | Get database info |
| Bulk Operations | `/api/admin/bulk` | Perform bulk actions |

## 📊 Dashboard Tabs

| Tab | Key Features |
|-----|--------------|
| **Overview** | KPIs, Project/Task distribution, Utilization metrics |
| **Financial** | Revenue vs Cost, Cash flow, Document comparison |
| **Projects** | Top 10 projects, Revenue ranking, Performance metrics |
| **Performance** | Team productivity, User performance, Task efficiency |
| **Database** | Health status, Table statistics, Record counts |

## 🎯 Key Metrics at a Glance

### Financial
- **Total Revenue**: Sum of all project revenue
- **Net Profit**: Revenue - Cost
- **Profit Margin**: (Profit / Revenue) × 100
- **Cash Flow**: Invoices - Vendor Bills

### Projects
- **Total Projects**: All projects count
- **Active Projects**: IN_PROGRESS status
- **Completion Rate**: (Completed tasks / Total tasks) × 100
- **Budget Utilization**: (Cost / Budget) × 100

### Team
- **Total Users**: All system users
- **Hours Logged**: Sum of timesheet hours
- **Utilization Rate**: (Logged / Estimated) × 100
- **Productivity**: Timesheets / Tasks per user

## ⚡ Quick Actions

### From Main Dashboard
```
1. Manage Users → /dashboard/users
2. View Projects → /dashboard/projects
3. Detailed Analytics → /dashboard/analytics
4. Compare Projects → /dashboard/admin/comparison
5. System Settings → /dashboard/settings
```

### From Database Tab
```
1. Click table → View records
2. Search → Filter records
3. View → See details
4. Delete → Remove record
5. Export → Download JSON
```

## 🔧 Common Operations

### View Analytics
```
1. Login as admin
2. Go to /dashboard
3. Select time range (7/30/90/365 days)
4. Switch between tabs
5. Click Export to download
```

### Compare Projects
```
1. Go to /dashboard/admin/comparison
2. Click project badges to select (max 10)
3. Switch between comparison views
4. Export comparison data
```

### Manage Database
```
1. Go to Database tab
2. Click on table name
3. Search/filter records
4. Click View or Delete
5. Export table data
```

### Bulk Operations (API)
```bash
curl -X POST /api/admin/bulk \
  -H "Content-Type: application/json" \
  -d '{
    "operation": "export",
    "table": "projects"
  }'
```

## 📈 Chart Types Reference

| Chart Type | Used For | Location |
|------------|----------|----------|
| Pie Chart | Status distribution | Overview tab |
| Bar Chart | Comparative metrics | Multiple tabs |
| Line Chart | Trends over time | Financial tab |
| Area Chart | Cumulative data | Comparison |
| Composed Chart | Multi-metric | Financial tab |
| Radar Chart | Performance analysis | Comparison |

## 🎨 Color Coding

| Color | Meaning | Usage |
|-------|---------|-------|
| 🟢 Green | Success/Profit/Completed | Revenue, Profit, Done tasks |
| 🔵 Blue | Info/In Progress | Active projects, Ongoing tasks |
| 🟡 Yellow | Warning/Pending | Planned projects, Pending items |
| 🔴 Red | Danger/Cost/Blocked | Expenses, Blocked tasks |
| 🟣 Purple | Special/Performance | Performance metrics |

## ⚙️ Configuration Quick Reference

### Cache Settings
```javascript
// Default: 5 minutes
cache.set(key, value, 300);

// Clear cache
cache.clear();

// Invalidate pattern
invalidateCache('admin-analytics-.*');
```

### Time Ranges
- **7 days**: Recent activity
- **30 days**: Default, monthly view
- **90 days**: Quarterly analysis
- **365 days**: Annual overview

### Query Limits
- **Database tables**: 100 records
- **Analytics**: No limit (aggregated)
- **Bulk export**: 10,000 records max

## 🔐 Access Control

| Role | Access Level |
|------|--------------|
| ADMIN | Full access to all features |
| PROJECT_MANAGER | Limited analytics, no database management |
| TEAM_MEMBER | No admin panel access |
| SALES | No admin panel access |
| FINANCE | No admin panel access |

## 🐛 Troubleshooting Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| Analytics not loading | Click Refresh button |
| Slow performance | Reduce time range to 7 days |
| Charts not showing | Clear browser cache |
| Unauthorized error | Verify admin role in database |
| Data outdated | Click Refresh to clear cache |

## 📱 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Refresh | F5 or Ctrl+R |
| Export | Ctrl+E (when focused) |
| Search | Ctrl+F |
| Close dialog | Esc |

## 💡 Pro Tips

1. **Use cache wisely**: Refresh only when needed
2. **Export regularly**: Keep backups of analytics
3. **Monitor trends**: Check dashboard daily
4. **Compare projects**: Identify best practices
5. **Clean data**: Remove old records periodically
6. **Optimize queries**: Use shorter time ranges
7. **Check performance**: Monitor database tab
8. **Secure access**: Review user roles regularly

## 📞 Emergency Contacts

### Critical Issues
1. Check console logs
2. Verify database connection
3. Review error messages
4. Check API responses
5. Contact system administrator

### Performance Issues
1. Clear cache (Refresh button)
2. Reduce time range
3. Check database indexes
4. Monitor server resources
5. Review query execution times

## 📚 Documentation Links

- **Full Documentation**: `ADMIN_PANEL_DOCUMENTATION.md`
- **Setup Guide**: `ADMIN_SETUP_GUIDE.md`
- **Implementation Summary**: `ADMIN_IMPLEMENTATION_SUMMARY.md`

## 🎓 Learning Path

### Beginner
1. Explore main dashboard
2. View different tabs
3. Try time range selector
4. Export analytics data

### Intermediate
1. Use database management
2. Compare projects
3. Understand metrics
4. Analyze trends

### Advanced
1. Use bulk operations API
2. Optimize performance
3. Custom configurations
4. Advanced analytics

---

**Keep this card handy for quick reference! 📌**

Print or bookmark this page for instant access to admin panel features.
