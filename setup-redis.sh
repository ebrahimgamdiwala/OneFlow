#!/bin/bash

# OneFlow Redis Setup Script for GCP
# This script sets up Redis on Google Cloud Memorystore

set -e

echo "🚀 Setting up Redis for OneFlow on GCP..."

# Configuration
PROJECT_ID="xenon-notch-477511-g5"
REGION="us-central1"
REDIS_INSTANCE_NAME="oneflow-cache"
REDIS_TIER="BASIC"  # Use STANDARD_HA for production high availability
REDIS_MEMORY_SIZE="1"  # 1GB - adjust based on needs
REDIS_VERSION="redis_7_0"

echo "📋 Configuration:"
echo "  Project: $PROJECT_ID"
echo "  Region: $REGION"
echo "  Instance: $REDIS_INSTANCE_NAME"
echo "  Tier: $REDIS_TIER"
echo "  Memory: ${REDIS_MEMORY_SIZE}GB"
echo ""

# Set project
echo "🔧 Setting GCP project..."
gcloud config set project $PROJECT_ID

# Enable Redis API
echo "🔌 Enabling Redis API..."
gcloud services enable redis.googleapis.com

# Create Redis instance
echo "🎯 Creating Redis instance (this may take 5-10 minutes)..."
gcloud redis instances create $REDIS_INSTANCE_NAME \
  --size=$REDIS_MEMORY_SIZE \
  --region=$REGION \
  --redis-version=$REDIS_VERSION \
  --tier=$REDIS_TIER \
  --network=default

echo "✅ Redis instance created!"

# Get Redis connection details
echo "📊 Getting Redis connection details..."
REDIS_HOST=$(gcloud redis instances describe $REDIS_INSTANCE_NAME --region=$REGION --format="get(host)")
REDIS_PORT=$(gcloud redis instances describe $REDIS_INSTANCE_NAME --region=$REGION --format="get(port)")

echo ""
echo "✅ Redis Setup Complete!"
echo ""
echo "📝 Connection Details:"
echo "  Host: $REDIS_HOST"
echo "  Port: $REDIS_PORT"
echo ""
echo "🔐 Add these to your GitHub Secrets:"
echo "  REDIS_HOST=$REDIS_HOST"
echo "  REDIS_PORT=$REDIS_PORT"
echo ""
echo "💡 Next steps:"
echo "  1. Add REDIS_HOST and REDIS_PORT to GitHub Secrets"
echo "  2. Add REDIS_HOST and REDIS_PORT to your .env file"
echo "  3. Run: npm install ioredis"
echo "  4. Deploy your application"
echo ""
