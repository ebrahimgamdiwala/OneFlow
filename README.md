# Finance-UI 💰

A modern finance management application built with Next.js 16, featuring real-time analytics, transaction tracking, and beautiful data visualizations.

## 🚀 CI/CD Pipeline

This project includes a complete CI/CD pipeline that automatically deploys to Google Cloud Platform.

**Quick Start:** See [`CICD-SETUP.md`](./CICD-SETUP.md) for 5-minute setup guide.

### Pipeline Features

- ✅ Automated testing with Jest
- ✅ Docker containerization
- ✅ Deploy to Google Cloud Run
- ✅ Zero-downtime deployments
- ✅ Automatic health checks

### Documentation

- 📘 **[CICD-SETUP.md](./CICD-SETUP.md)** - Quick setup guide (Start here!)
- 📗 **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Complete deployment documentation
- 📙 **[ENVIRONMENT.md](./ENVIRONMENT.md)** - Environment variables guide

## 🛠️ Tech Stack

- **Framework:** Next.js 16 (App Router)
- **Styling:** TailwindCSS 4
- **UI Components:** Radix UI + shadcn/ui
- **Database:** PostgreSQL with Prisma ORM
- **3D Graphics:** Three.js with React Three Fiber
- **Charts:** Recharts
- **Animations:** GSAP

## 🏃 Getting Started

### Prerequisites

- Node.js 18+
- PostgreSQL database
- npm or yarn

### Local Development

First, install dependencies and set up the database:

```bash
# Install dependencies
npm install

# Set up environment variables
cp ENVIRONMENT.md .env
# Edit .env with your DATABASE_URL

# Generate Prisma client
npm run prisma:generate

# Run database migrations (optional)
npm run prisma:migrate

# Start development server
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser.

### Available Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm test             # Run tests
npm run test:watch   # Run tests in watch mode
npm run lint         # Run ESLint
```

### Prisma Commands

```bash
npm run prisma:generate  # Generate Prisma client
npm run prisma:studio    # Open Prisma Studio
npm run prisma:migrate   # Run migrations (dev)
npm run prisma:push      # Push schema to database
npm run prisma:pull      # Pull schema from database
```

## 🧪 Testing

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Watch mode
npm run test:watch
```

## 🐳 Docker

Build and run with Docker:

```bash
# Build image
docker build -t finance-ui .

# Run container
docker run -p 8080:8080 \
  -e DATABASE_URL="your-database-url" \
  -e NODE_ENV=production \
  finance-ui
```

## 🌐 Deployment

### Automated Deployment (Recommended)

Push to `main` branch to automatically deploy to Google Cloud Run:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

See [`CICD-SETUP.md`](./CICD-SETUP.md) for setup instructions.

### Manual Deployment

See [`DEPLOYMENT.md`](./DEPLOYMENT.md) for manual deployment steps.

## 📁 Project Structure

```
Finance-UI/
├── app/                # Next.js App Router pages
│   ├── api/           # API routes
│   ├── dashboard/     # Dashboard pages
│   └── ...
├── components/         # React components
├── lib/               # Utility functions
├── prisma/            # Database schema
├── public/            # Static assets
├── __tests__/         # Test files
├── .github/           # GitHub Actions workflows
└── Dockerfile         # Docker configuration
```

## 🔐 Environment Variables

Required environment variables:

- `DATABASE_URL` - PostgreSQL connection string
- `NODE_ENV` - Environment mode (development/production)

See [`ENVIRONMENT.md`](./ENVIRONMENT.md) for details.

## 📚 Learn More

### Next.js Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Learn Next.js](https://nextjs.org/learn)
- [Next.js GitHub](https://github.com/vercel/next.js)

### Other Resources

- [Prisma Documentation](https://www.prisma.io/docs)
- [TailwindCSS](https://tailwindcss.com/docs)
- [Radix UI](https://www.radix-ui.com)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is private and proprietary.

## 🆘 Support

For deployment issues, see:
- [`CICD-SETUP.md`](./CICD-SETUP.md) - Setup guide
- [`DEPLOYMENT.md`](./DEPLOYMENT.md) - Troubleshooting section
