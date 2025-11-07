# Environment Variables

This document lists all required environment variables for the Finance-UI application.

## Required Variables

### DATABASE_URL
PostgreSQL database connection string.

**Format:**
```
postgresql://USERNAME:PASSWORD@HOST:PORT/DATABASE?schema=public
```

**Example:**
```
postgresql://postgres:mypassword@localhost:5432/financedb?schema=public
```

**Production:** Set this as a secret in Google Cloud Secret Manager

## Optional Variables

### NODE_ENV
Application environment mode.

**Values:** `development`, `production`, `test`

**Default:** `production` (in Docker/Cloud Run)

## Local Development

Create a `.env` file in the root directory (already gitignored):

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/financedb?schema=public"
NODE_ENV="development"
```

## Production (Cloud Run)

Environment variables are set automatically by the CI/CD pipeline:
- `NODE_ENV=production` (set in workflow)
- `DATABASE_URL` (fetched from Secret Manager)

## GitHub Actions

The following secrets must be set in GitHub repository settings:

### GCP_SA_KEY
Complete service account JSON key for authentication.

**Setup:**
1. Go to: Repository Settings → Secrets and variables → Actions
2. Create new secret: `GCP_SA_KEY`
3. Paste the entire service account JSON

## Security Notes

- ⚠️ Never commit `.env` files to git
- ⚠️ Never expose database credentials in logs
- ⚠️ Use Secret Manager for production secrets
- ⚠️ Rotate service account keys periodically
