# Admin Panel Setup Guide

## Quick Start

### 1. Prerequisites
- Node.js >= 20.9.0
- PostgreSQL database
- Existing OneFlow installation

### 2. Installation

The admin panel is already integrated into OneFlow. No additional installation required.

### 3. Create Admin User

**Option A: Using Prisma Studio**
```bash
npm run prisma:studio
```
1. Open Users table
2. Create or edit a user
3. Set `role` field to `ADMIN`

**Option B: Using Database**
```sql
UPDATE "User" SET role = 'ADMIN' WHERE email = 'your-email@example.com';
```

**Option C: Using Signup**
1. Sign up normally at `/login`
2. After signup, update role in database using Option A or B

### 4. Access Admin Panel

1. Login with admin credentials
2. Navigate to `/dashboard`
3. You'll see the comprehensive admin dashboard

## Features Overview

### Main Dashboard (`/dashboard`)
- **5 Tabs**: Overview, Financial, Projects, Performance, Database
- **Real-time KPIs**: Revenue, Profit, Projects, Users
- **Interactive Charts**: Multiple visualization types
- **Quick Actions**: Fast access to common tasks

### Database Management (`/dashboard/admin/database/[table]`)
- View all database tables
- Search and filter records
- Delete records with confirmation
- Export data to JSON

### Project Comparison (`/dashboard/admin/comparison`)
- Compare up to 10 projects
- Multiple comparison views
- Financial, task, team, and performance analysis
- Interactive radar charts

## Configuration

### Cache Settings
Edit `/lib/cache.js` to adjust cache TTL:
```javascript
// Default: 5 minutes (300 seconds)
cache.set(key, value, 300);
```

### Analytics Time Ranges
Available options in dashboard:
- 7 days
- 30 days (default)
- 90 days
- 365 days

### Query Limits
Edit API routes to adjust limits:
```javascript
// In /app/api/admin/database/route.js
const limit = 100; // Adjust as needed
```

## Performance Tips

### 1. Enable Caching
Caching is enabled by default. Analytics data is cached for 5 minutes.

### 2. Use Appropriate Time Ranges
- Use shorter time ranges (7-30 days) for faster queries
- Use longer ranges (90-365 days) for historical analysis

### 3. Limit Comparison Projects
- Compare 3-5 projects for optimal performance
- Maximum 10 projects supported

### 4. Database Optimization
Ensure these indexes exist:
```sql
CREATE INDEX idx_project_status ON "Project"(status);
CREATE INDEX idx_task_status ON "Task"(status);
CREATE INDEX idx_user_role ON "User"(role);
```

## Security Checklist

- [ ] Admin users have strong passwords
- [ ] NEXTAUTH_SECRET is set in environment
- [ ] Database credentials are secure
- [ ] HTTPS is enabled in production
- [ ] Regular backups are configured
- [ ] Audit logs are monitored

## Troubleshooting

### Issue: "Unauthorized - Admin access required"
**Solution**: Verify user role is set to `ADMIN` in database

### Issue: Analytics not loading
**Solution**: 
1. Check database connection
2. Verify Prisma client is generated: `npm run prisma:generate`
3. Check console for errors

### Issue: Charts not rendering
**Solution**:
1. Verify recharts is installed: `npm install recharts`
2. Clear browser cache
3. Check browser console for errors

### Issue: Slow performance
**Solution**:
1. Reduce time range
2. Clear cache: Refresh button in dashboard
3. Check database performance
4. Consider upgrading server resources

## API Testing

### Test Analytics Endpoint
```bash
curl -X GET http://localhost:3000/api/admin/analytics?timeRange=30 \
  -H "Cookie: your-session-cookie"
```

### Test Database Endpoint
```bash
curl -X GET http://localhost:3000/api/admin/database?table=projects \
  -H "Cookie: your-session-cookie"
```

### Test Bulk Operations
```bash
curl -X POST http://localhost:3000/api/admin/bulk \
  -H "Content-Type: application/json" \
  -H "Cookie: your-session-cookie" \
  -d '{
    "operation": "export",
    "table": "projects"
  }'
```

## Best Practices

### 1. Regular Monitoring
- Check dashboard daily for system health
- Monitor database table sizes
- Review user performance metrics

### 2. Data Management
- Export important data regularly
- Clean up old records periodically
- Archive completed projects

### 3. Performance Monitoring
- Monitor cache hit rates
- Track query execution times
- Optimize slow queries

### 4. Security
- Review user access regularly
- Audit admin actions
- Update dependencies monthly

## Advanced Configuration

### Custom Chart Colors
Edit `/components/dashboards/ComprehensiveAdminDashboard.jsx`:
```javascript
const COLORS = {
  primary: '#10b981',    // Change to your brand color
  secondary: '#3b82f6',
  success: '#22c55e',
  warning: '#f59e0b',
  danger: '#ef4444',
};
```

### Custom KPI Metrics
Add custom metrics in `/app/api/admin/analytics/route.js`:
```javascript
const customMetric = await prisma.yourModel.aggregate({
  _sum: { yourField: true },
});
```

### Custom Database Tables
Add support for custom tables in `/app/api/admin/database/route.js`:
```javascript
case 'yourTable':
  [data, count] = await Promise.all([
    prisma.yourModel.findMany({ /* ... */ }),
    prisma.yourModel.count(),
  ]);
  break;
```

## Maintenance

### Weekly Tasks
- [ ] Review system performance
- [ ] Check error logs
- [ ] Monitor database size
- [ ] Review user activity

### Monthly Tasks
- [ ] Export analytics data
- [ ] Update dependencies
- [ ] Review security settings
- [ ] Optimize database

### Quarterly Tasks
- [ ] Full system audit
- [ ] Performance optimization
- [ ] Feature review
- [ ] User feedback collection

## Support Resources

### Documentation
- Main Documentation: `ADMIN_PANEL_DOCUMENTATION.md`
- Project README: `README.md`
- API Documentation: Check individual route files

### Community
- GitHub Issues: Report bugs and request features
- Discussions: Share ideas and get help

### Development
- Local Development: `npm run dev`
- Production Build: `npm run build`
- Database Studio: `npm run prisma:studio`

## Upgrade Path

### From Basic Admin to Comprehensive Admin
If upgrading from the basic admin dashboard:

1. **Backup Database**
   ```bash
   pg_dump your_database > backup.sql
   ```

2. **Pull Latest Code**
   ```bash
   git pull origin main
   ```

3. **Install Dependencies**
   ```bash
   npm install
   ```

4. **Generate Prisma Client**
   ```bash
   npm run prisma:generate
   ```

5. **Test in Development**
   ```bash
   npm run dev
   ```

6. **Deploy to Production**
   ```bash
   npm run build
   npm start
   ```

## Production Deployment

### Environment Variables
```env
DATABASE_URL="postgresql://..."
NEXTAUTH_SECRET="your-secret-key"
NEXTAUTH_URL="https://your-domain.com"
NODE_ENV="production"
```

### Performance Settings
```javascript
// Increase cache TTL for production
cache.set(key, value, 600); // 10 minutes

// Increase query limits
const limit = 200;

// Enable compression
// Add to next.config.js
compress: true
```

### Monitoring
- Set up error tracking (e.g., Sentry)
- Configure performance monitoring
- Enable database query logging
- Set up uptime monitoring

---

**Ready to use the Admin Panel!**

For detailed feature documentation, see `ADMIN_PANEL_DOCUMENTATION.md`
