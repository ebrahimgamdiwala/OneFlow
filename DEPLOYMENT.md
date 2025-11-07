# 🚀 Deployment Guide - Finance-UI

This guide explains how to deploy your Finance-UI application to Google Cloud Platform using GitHub Actions CI/CD pipeline.

## 📋 Prerequisites

Before deploying, ensure you have:

1. ✅ Google Cloud Project: `xenon-notch-477511-g5`
2. ✅ Service Account with necessary permissions
3. ✅ GitHub repository with the code
4. ✅ Database (PostgreSQL) set up

## 🔧 Initial Setup

### 1. Enable Required Google Cloud APIs

Run these commands in Google Cloud Shell or your local terminal with `gcloud` CLI:

```bash
gcloud config set project xenon-notch-477511-g5

# Enable required APIs
gcloud services enable \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com
```

### 2. Create Artifact Registry Repository

```bash
gcloud artifacts repositories create finance-ui \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker repository for Finance-UI"
```

### 3. Set Up Database Secret in Secret Manager

Create a secret for your DATABASE_URL:

```bash
# Replace with your actual database connection string
echo -n "postgresql://user:password@host:5432/database?schema=public" | \
  gcloud secrets create DATABASE_URL \
    --data-file=- \
    --replication-policy="automatic"
```

### 4. Grant Service Account Permissions

Grant necessary permissions to your service account:

```bash
# Set variables
PROJECT_ID="xenon-notch-477511-g5"
SA_EMAIL="github-actions@xenon-notch-477511-g5.iam.gserviceaccount.com"

# Grant roles
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/secretmanager.secretAccessor"
```

### 5. Grant Cloud Run Service Access to Secrets

```bash
# Get the default Cloud Run service account
CLOUD_RUN_SA="${PROJECT_ID}@appspot.gserviceaccount.com"

# Grant secret access
gcloud secrets add-iam-policy-binding DATABASE_URL \
  --member="serviceAccount:${CLOUD_RUN_SA}" \
  --role="roles/secretmanager.secretAccessor"
```

## 🔐 GitHub Secrets Setup

### Add Secret to GitHub Repository

1. Go to your GitHub repository
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Create the following secret:

**Secret Name:** `GCP_SA_KEY`

**Secret Value:** Paste the entire JSON content of your service account key:

```json
{
  "type": "service_account",
  "project_id": "xenon-notch-477511-g5",
  "private_key_id": "854067d6cc6721f4e382212fc1974e09b480a5f0",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "github-actions@xenon-notch-477511-g5.iam.gserviceaccount.com",
  "client_id": "113919607679541674156",
  ...
}
```

## 🚀 Deployment Process

### Automated Deployment

The CI/CD pipeline automatically triggers when you push to the `main` or `master` branch:

```bash
git add .
git commit -m "Deploy application"
git push origin main
```

### Pipeline Stages

1. **Test** 🧪
   - Installs dependencies
   - Generates Prisma client
   - Runs linter
   - Executes tests with coverage

2. **Build** 🔨
   - Builds optimized Docker image
   - Tags with commit SHA
   - Pushes to Google Artifact Registry

3. **Deploy** 🚀
   - Deploys to Cloud Run
   - Configures auto-scaling
   - Sets environment variables
   - Verifies deployment health

## 📊 Monitoring & Logs

### View Application Logs

```bash
gcloud run services logs read finance-ui \
  --region=us-central1 \
  --limit=50
```

### Tail Live Logs

```bash
gcloud run services logs tail finance-ui \
  --region=us-central1
```

### Access Cloud Run Dashboard

Visit: https://console.cloud.google.com/run?project=xenon-notch-477511-g5

## 🔍 Troubleshooting

### Common Issues

#### 1. Build Fails - Missing Dependencies
```bash
# Run locally first to verify
npm ci
npm run build
```

#### 2. Database Connection Issues
- Verify DATABASE_URL secret is set correctly
- Ensure Cloud Run service account has secret access
- Check database allows connections from Cloud Run

#### 3. Tests Failing
```bash
# Run tests locally
npm test
npm run test:coverage
```

#### 4. Deployment Permission Errors
- Verify service account has all required roles
- Check IAM permissions in GCP Console

### Debug Deployment

```bash
# Check Cloud Run service status
gcloud run services describe finance-ui \
  --region=us-central1 \
  --format=yaml

# View recent revisions
gcloud run revisions list \
  --service=finance-ui \
  --region=us-central1

# Get service URL
gcloud run services describe finance-ui \
  --region=us-central1 \
  --format='value(status.url)'
```

## 🛠️ Local Development

### Build Docker Image Locally

```bash
# Build
docker build -t finance-ui:local .

# Run with environment variables
docker run -p 8080:8080 \
  -e DATABASE_URL="your-database-url" \
  -e NODE_ENV=production \
  finance-ui:local
```

### Test Production Build

```bash
npm run build
npm start
```

## 🔄 Rollback

If a deployment fails, rollback to previous version:

```bash
# List revisions
gcloud run revisions list \
  --service=finance-ui \
  --region=us-central1

# Rollback to specific revision
gcloud run services update-traffic finance-ui \
  --to-revisions=REVISION_NAME=100 \
  --region=us-central1
```

## 📈 Scaling Configuration

Current configuration in `.github/workflows/ci-cd.yml`:

- **Min Instances:** 0 (scales to zero when idle)
- **Max Instances:** 10
- **Memory:** 512Mi
- **CPU:** 1
- **Concurrency:** 80 requests per instance
- **Timeout:** 300 seconds

To modify scaling:

```bash
gcloud run services update finance-ui \
  --min-instances=1 \
  --max-instances=20 \
  --region=us-central1
```

## 🎯 Next Steps

1. ✅ Set up custom domain (optional)
2. ✅ Configure CDN with Cloud Load Balancer
3. ✅ Set up monitoring alerts
4. ✅ Configure Cloud Armor for security
5. ✅ Set up backup and disaster recovery

## 📞 Support

For issues:
1. Check GitHub Actions logs
2. Review Cloud Run logs
3. Verify all secrets are set correctly
4. Ensure GCP APIs are enabled

---

**Project:** Finance-UI  
**Cloud Platform:** Google Cloud Platform  
**Region:** us-central1  
**Runtime:** Node.js 18 (Alpine Linux)
