#!/bin/bash

# Setup script for Finance-UI GCP deployment
# Run this script to configure Google Cloud Platform for CI/CD

set -e

echo "🚀 Finance-UI - GCP Setup Script"
echo "================================="
echo ""

# Configuration
PROJECT_ID="xenon-notch-477511-g5"
SA_EMAIL="github-actions@xenon-notch-477511-g5.iam.gserviceaccount.com"
SERVICE_NAME="finance-ui"
REGION="us-central1"

# Set project
echo "📌 Setting GCP project..."
gcloud config set project ${PROJECT_ID}

# Enable APIs
echo ""
echo "🔧 Enabling required APIs..."
gcloud services enable \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  secretmanager.googleapis.com

echo "✅ APIs enabled successfully!"

# Create Artifact Registry
echo ""
echo "📦 Creating Artifact Registry repository..."
if gcloud artifacts repositories describe ${SERVICE_NAME} --location=${REGION} &>/dev/null; then
  echo "Repository already exists, skipping..."
else
  gcloud artifacts repositories create ${SERVICE_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker repository for Finance-UI"
  echo "✅ Artifact Registry created!"
fi

# Create DATABASE_URL secret (if not exists)
echo ""
echo "🔐 Setting up DATABASE_URL secret..."
if gcloud secrets describe DATABASE_URL &>/dev/null; then
  echo "⚠️  DATABASE_URL secret already exists."
  read -p "Do you want to update it? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -sp "Enter your DATABASE_URL: " DB_URL
    echo
    echo -n "${DB_URL}" | gcloud secrets versions add DATABASE_URL --data-file=-
    echo "✅ DATABASE_URL updated!"
  fi
else
  read -sp "Enter your DATABASE_URL: " DB_URL
  echo
  echo -n "${DB_URL}" | gcloud secrets create DATABASE_URL \
    --data-file=- \
    --replication-policy="automatic"
  echo "✅ DATABASE_URL secret created!"
fi

# Grant GitHub Actions service account permissions
echo ""
echo "👤 Granting permissions to GitHub Actions service account..."

echo "  → Cloud Run Admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/run.admin" \
  --condition=None

echo "  → Artifact Registry Writer"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.writer" \
  --condition=None

echo "  → Service Account User"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/iam.serviceAccountUser" \
  --condition=None

echo "  → Secret Manager Accessor"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/secretmanager.secretAccessor" \
  --condition=None

echo "✅ Service account permissions granted!"

# Grant Cloud Run service access to secrets
echo ""
echo "🔑 Granting Cloud Run service access to secrets..."
CLOUD_RUN_SA="${PROJECT_ID}@appspot.gserviceaccount.com"

gcloud secrets add-iam-policy-binding DATABASE_URL \
  --member="serviceAccount:${CLOUD_RUN_SA}" \
  --role="roles/secretmanager.secretAccessor"

echo "✅ Secret access granted!"

# Summary
echo ""
echo "================================="
echo "🎉 Setup Complete!"
echo "================================="
echo ""
echo "Next steps:"
echo "1. Add GCP_SA_KEY secret to GitHub:"
echo "   https://github.com/YOUR_USERNAME/Finance-UI/settings/secrets/actions"
echo ""
echo "2. Install dependencies:"
echo "   npm install"
echo ""
echo "3. Run tests:"
echo "   npm test"
echo ""
echo "4. Push to main branch to trigger deployment:"
echo "   git push origin main"
echo ""
echo "📚 Documentation:"
echo "   - CICD-SETUP.md    (Quick start guide)"
echo "   - DEPLOYMENT.md    (Full deployment guide)"
echo "   - ENVIRONMENT.md   (Environment variables)"
echo ""
