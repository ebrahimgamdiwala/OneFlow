# Redis Caching Setup for OneFlow

## 🚀 Quick Setup Guide

### Step 1: Run the Setup Script

```bash
# Make script executable
chmod +x setup-redis.sh

# Run the setup script
./setup-redis.sh
```

This will:
- Enable Redis API on GCP
- Create a Redis instance (1GB, Basic tier)
- Output connection details

---

## 📦 Step 2: Install Redis Client

```bash
npm install ioredis
```

---

## 🔐 Step 3: Add Environment Variables

### Local Development (.env)
```bash
# Redis Configuration
REDIS_HOST="your-redis-host-from-script"
REDIS_PORT="6379"
```

### GitHub Secrets
Add these secrets to your GitHub repository:
1. Go to: Settings → Secrets and variables → Actions
2. Add:
   - `REDIS_HOST` - Your Redis host from the setup script
   - `REDIS_PORT` - Usually `6379`

---

## 🔧 Step 4: Update CI/CD Workflow

The workflow already injects secrets. Just ensure Redis secrets are added:

```yaml
--set-env-vars="REDIS_HOST=${{ secrets.REDIS_HOST }},REDIS_PORT=${{ secrets.REDIS_PORT }}"
```

---

## 💻 Usage Examples

### Example 1: Cache Projects List

```javascript
// app/api/projects/route.js
import { NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import cache from '@/lib/redis';

export async function GET(req) {
  try {
    const { searchParams } = new URL(req.url);
    const status = searchParams.get('status');
    
    // Create cache key
    const cacheKey = `projects:list:${status || 'all'}`;
    
    // Try to get from cache (5 minutes TTL)
    const projects = await cache.getOrSet(
      cacheKey,
      async () => {
        // This only runs if cache miss
        return await prisma.project.findMany({
          where: status ? { status } : undefined,
          include: {
            manager: {
              select: { id: true, name: true, email: true }
            },
            members: {
              include: {
                user: {
                  select: { id: true, name: true, email: true }
                }
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        });
      },
      300 // 5 minutes
    );
    
    return NextResponse.json(projects);
  } catch (error) {
    console.error('Error fetching projects:', error);
    return NextResponse.json(
      { error: 'Failed to fetch projects' },
      { status: 500 }
    );
  }
}
```

### Example 2: Cache User Dashboard Data

```javascript
// app/api/dashboard/stats/route.js
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import prisma from '@/lib/prisma';
import cache from '@/lib/redis';

export async function GET(req) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.id) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const userId = session.user.id;
    const cacheKey = `dashboard:stats:${userId}`;

    // Cache for 2 minutes
    const stats = await cache.getOrSet(
      cacheKey,
      async () => {
        const [projectCount, taskCount, activeProjects] = await Promise.all([
          prisma.project.count({
            where: { managerId: userId }
          }),
          prisma.task.count({
            where: { assigneeId: userId, status: { not: 'DONE' } }
          }),
          prisma.project.findMany({
            where: {
              managerId: userId,
              status: 'IN_PROGRESS'
            },
            take: 5,
            orderBy: { updatedAt: 'desc' }
          })
        ]);

        return {
          projectCount,
          taskCount,
          activeProjects
        };
      },
      120 // 2 minutes
    );

    return NextResponse.json(stats);
  } catch (error) {
    console.error('Error fetching dashboard stats:', error);
    return NextResponse.json(
      { error: 'Failed to fetch stats' },
      { status: 500 }
    );
  }
}
```

### Example 3: Invalidate Cache on Update

```javascript
// app/api/projects/[id]/route.js
import { NextResponse } from 'next/server';
import prisma from '@/lib/prisma';
import cache from '@/lib/redis';

export async function PUT(req, { params }) {
  try {
    const { id } = params;
    const body = await req.json();

    // Update project
    const project = await prisma.project.update({
      where: { id },
      data: body
    });

    // Invalidate related caches
    await cache.delPattern('projects:*');
    await cache.del(`project:${id}`);
    await cache.delPattern('dashboard:*');

    return NextResponse.json(project);
  } catch (error) {
    console.error('Error updating project:', error);
    return NextResponse.json(
      { error: 'Failed to update project' },
      { status: 500 }
    );
  }
}
```

---

## 🎯 Caching Strategy

### What to Cache:
- ✅ **Lists** - Projects, tasks, users (TTL: 5 minutes)
- ✅ **Dashboard stats** - Counts, summaries (TTL: 2 minutes)
- ✅ **User profiles** - User data (TTL: 10 minutes)
- ✅ **Dropdown data** - Partners, products (TTL: 15 minutes)
- ✅ **Reports** - Expensive queries (TTL: 10 minutes)

### What NOT to Cache:
- ❌ **Real-time data** - Live updates, notifications
- ❌ **User-specific sensitive data** - Passwords, tokens
- ❌ **Frequently changing data** - Active task status

### Cache Keys Pattern:
```
{resource}:{operation}:{identifier}

Examples:
- projects:list:all
- projects:list:IN_PROGRESS
- project:123e4567-e89b-12d3-a456-426614174000
- dashboard:stats:user-id
- tasks:list:project-id
```

---

## 🔄 Cache Invalidation

### On Create:
```javascript
await cache.delPattern('projects:list:*');
await cache.delPattern('dashboard:*');
```

### On Update:
```javascript
await cache.del(`project:${id}`);
await cache.delPattern('projects:list:*');
```

### On Delete:
```javascript
await cache.del(`project:${id}`);
await cache.delPattern('projects:*');
await cache.delPattern('dashboard:*');
```

---

## 📊 Monitoring Redis

### Check Redis Status:
```bash
gcloud redis instances describe oneflow-cache --region=us-central1
```

### View Redis Metrics:
```bash
gcloud redis instances describe oneflow-cache \
  --region=us-central1 \
  --format="table(name,host,port,memorySizeGb,currentLocationId,state)"
```

### Connect to Redis (for debugging):
```bash
# Get Redis host
REDIS_HOST=$(gcloud redis instances describe oneflow-cache --region=us-central1 --format="get(host)")

# Connect from Cloud Shell or a VM in the same VPC
redis-cli -h $REDIS_HOST
```

---

## 🚨 Troubleshooting

### Redis Not Connecting:
1. Check if Redis instance is running:
   ```bash
   gcloud redis instances list --region=us-central1
   ```

2. Verify environment variables are set:
   ```bash
   echo $REDIS_HOST
   echo $REDIS_PORT
   ```

3. Check Cloud Run logs:
   ```bash
   gcloud run services logs read oneflow --region=us-central1
   ```

### Cache Not Working:
1. Check if Redis client is initialized:
   - Look for "✅ Redis connected" in logs

2. Test cache manually:
   ```javascript
   import cache from '@/lib/redis';
   
   // Test set
   await cache.set('test', { hello: 'world' }, 60);
   
   // Test get
   const value = await cache.get('test');
   console.log(value); // Should print: { hello: 'world' }
   ```

---

## 💰 Cost Estimation

### Basic Tier (1GB):
- **Cost**: ~$40/month
- **Use case**: Development, small production

### Standard HA (1GB):
- **Cost**: ~$80/month
- **Use case**: Production with high availability

### Scaling:
- Can scale up to 300GB
- Pay only for what you use

---

## 🎯 Performance Improvements

### Expected Results:
- **Before Redis**: 500ms - 2s page load
- **After Redis**: 50ms - 200ms page load
- **Cache Hit Rate**: 80-90% for frequently accessed data

### Metrics to Track:
1. Cache hit rate
2. Average response time
3. Database query count
4. Redis memory usage

---

## 📝 Next Steps

1. ✅ Run `./setup-redis.sh`
2. ✅ Install `ioredis`: `npm install ioredis`
3. ✅ Add environment variables
4. ✅ Update API routes with caching
5. ✅ Deploy and test
6. ✅ Monitor performance

---

## 🔗 Useful Commands

```bash
# List Redis instances
gcloud redis instances list --region=us-central1

# Describe instance
gcloud redis instances describe oneflow-cache --region=us-central1

# Delete instance (if needed)
gcloud redis instances delete oneflow-cache --region=us-central1

# Update instance size
gcloud redis instances update oneflow-cache --size=2 --region=us-central1
```

---

**Your Redis caching is now ready! Deploy and enjoy faster page loads! 🚀**
