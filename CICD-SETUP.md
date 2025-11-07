# 🚀 CI/CD Pipeline Setup - Quick Start Guide

This is a step-by-step guide to set up the complete CI/CD pipeline for Finance-UI.

## ⚡ Quick Setup (5 minutes)

### Step 1: Enable GCP APIs

```bash
gcloud config set project xenon-notch-477511-g5

gcloud services enable \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com
```

### Step 2: Create Artifact Registry

```bash
gcloud artifacts repositories create finance-ui \
  --repository-format=docker \
  --location=us-central1 \
  --description="Docker repository for Finance-UI"
```

### Step 3: Create Database Secret

```bash
# Replace with your actual DATABASE_URL
echo -n "postgresql://user:password@host:5432/database" | \
  gcloud secrets create DATABASE_URL \
    --data-file=- \
    --replication-policy="automatic"
```

### Step 4: Grant Permissions

```bash
PROJECT_ID="xenon-notch-477511-g5"
SA_EMAIL="github-actions@xenon-notch-477511-g5.iam.gserviceaccount.com"

# Grant roles to GitHub Actions service account
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

# Grant Cloud Run service access to secrets
CLOUD_RUN_SA="${PROJECT_ID}@appspot.gserviceaccount.com"

gcloud secrets add-iam-policy-binding DATABASE_URL \
  --member="serviceAccount:${CLOUD_RUN_SA}" \
  --role="roles/secretmanager.secretAccessor"
```

### Step 5: Add GitHub Secret

1. Go to: https://github.com/YOUR_USERNAME/Finance-UI/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `GCP_SA_KEY`
4. Value: Paste your complete service account JSON (the one you provided)
5. Click **"Add secret"**

### Step 6: Install Dependencies & Test

```bash
npm install
npm test
```

### Step 7: Deploy! 🚀

```bash
git add .
git commit -m "feat: setup CI/CD pipeline"
git push origin main
```

## ✅ Verification

After pushing, check:

1. **GitHub Actions:**  
   https://github.com/YOUR_USERNAME/Finance-UI/actions

2. **Cloud Run Console:**  
   https://console.cloud.google.com/run?project=xenon-notch-477511-g5

3. **Your App:**  
   URL will be shown in GitHub Actions output

## 🔥 Pipeline Flow

```
Push to main
    ↓
┌─────────────┐
│  Run Tests  │ ← Installs deps, runs Jest tests
└──────┬──────┘
       ↓ (tests pass)
┌─────────────┐
│Build Docker │ ← Creates optimized image
└──────┬──────┘
       ↓ (build success)
┌─────────────┐
│Deploy to GCP│ ← Deploys to Cloud Run
└──────┬──────┘
       ↓
   ✅ Live!
```

## 📋 Checklist

- [ ] GCP APIs enabled
- [ ] Artifact Registry created
- [ ] DATABASE_URL secret created
- [ ] Service account permissions granted
- [ ] GitHub secret `GCP_SA_KEY` added
- [ ] Dependencies installed (`npm install`)
- [ ] Tests passing (`npm test`)
- [ ] Code pushed to `main` branch

## 🎯 What Happens on Each Push

1. **Tests run first** - If tests fail, pipeline stops
2. **Docker image builds** - Multi-stage optimized build
3. **Image pushed** - To Google Artifact Registry
4. **Deploy to Cloud Run** - Zero-downtime deployment
5. **Health check** - Verifies deployment success

## 🛠️ Local Testing

Before pushing, test locally:

```bash
# Run tests
npm test

# Build production
npm run build

# Test Docker build
docker build -t finance-ui:test .
docker run -p 8080:8080 -e DATABASE_URL="your-db-url" finance-ui:test
```

## 🚨 If Something Goes Wrong

### Tests Fail
```bash
npm test -- --verbose
```

### Build Fails
```bash
npm run build
# Check the error output
```

### Deployment Fails
```bash
# Check Cloud Run logs
gcloud run services logs read finance-ui --region=us-central1 --limit=100
```

### Permission Errors
- Verify service account has all roles
- Check Secret Manager access
- Confirm GitHub secret is set correctly

## 📚 Additional Documentation

- **Full Deployment Guide:** See `DEPLOYMENT.md`
- **Environment Variables:** See `ENVIRONMENT.md`
- **Troubleshooting:** See `DEPLOYMENT.md` → Troubleshooting section

## 🎉 You're Done!

Your CI/CD pipeline is now fully automated. Every push to `main` will:
- ✅ Run tests
- ✅ Build Docker image
- ✅ Deploy to production
- ✅ Verify deployment

Happy coding! 🚀
