# Coolify Deployment Configuration

Coolify configuration files for deploying DFWorX applications.

## Overview

These JSON files define deployment configurations for Coolify, a self-hosted alternative to Heroku/Vercel.

## Prerequisites

- Coolify instance running
- GitHub repository configured
- Domain names configured
- Environment variables set in Coolify

## Deployment Steps

### 1. Set Up Coolify Project

1. Log in to your Coolify instance
2. Create a new project: "DFWorX"
3. Connect your GitHub repository

### 2. Deploy Web Application

1. Create new application
2. Import configuration from `web.json`
3. Set environment variables in Coolify UI:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4. Configure domain (e.g., `app.yourdomain.com`)
5. Deploy

### 3. Deploy API Service

1. Create new application
2. Import configuration from `api.json`
3. Set environment variables in Coolify UI:
   - `DATABASE_URL`
   - `SUPABASE_URL`
   - `SUPABASE_KEY`
   - `JWT_SECRET_KEY`
4. Configure domain (e.g., `api.yourdomain.com`)
5. Deploy

## Environment Variables

### Web App (web.json)

| Variable | Required | Secret | Description |
|----------|----------|--------|-------------|
| `NODE_ENV` | Yes | No | Environment (production) |
| `NEXT_PUBLIC_API_URL` | Yes | No | API URL |
| `NEXT_PUBLIC_SUPABASE_URL` | Yes | No | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Yes | Yes | Supabase anonymous key |

### API Service (api.json)

| Variable | Required | Secret | Description |
|----------|----------|--------|-------------|
| `ENVIRONMENT` | Yes | No | Environment (production) |
| `DATABASE_URL` | Yes | Yes | PostgreSQL connection string |
| `SUPABASE_URL` | Yes | No | Supabase project URL |
| `SUPABASE_KEY` | Yes | Yes | Supabase service role key |
| `JWT_SECRET_KEY` | Yes | Yes | JWT signing key |
| `CORS_ORIGINS` | Yes | No | Allowed CORS origins |

## Health Checks

Both applications have health checks configured:
- **Web**: `GET /` (port 3000)
- **API**: `GET /health` (port 8000)

Coolify will automatically restart services if health checks fail.

## Continuous Deployment

Configure GitHub webhooks in Coolify to enable automatic deployments on push to main branch.

## Monitoring

Coolify provides built-in monitoring:
- Container logs
- Resource usage
- Deployment history
- Health check status

## Troubleshooting

### Deployment Fails

1. Check build logs in Coolify
2. Verify all environment variables are set
3. Ensure Dockerfile is correct
4. Check resource limits

### Health Check Failures

1. Verify service is running: `docker ps`
2. Check application logs
3. Test health endpoint manually
4. Increase timeout/retries if needed

### Database Connection Issues

1. Verify `DATABASE_URL` is correct
2. Check database is accessible from container
3. Verify Supabase credentials
4. Check firewall rules

## Scaling

To scale services in Coolify:
1. Go to application settings
2. Adjust "Instances" count
3. Redeploy

## Backup Strategy

1. Database: Use Supabase automatic backups
2. Application: Git repository serves as backup
3. Environment variables: Export from Coolify settings

## Cost Optimization

- Use single instance for development
- Scale horizontally for production traffic
- Monitor resource usage
- Consider CDN for static assets

## Support

For Coolify-specific issues, refer to:
- [Coolify Documentation](https://coolify.io/docs)
- [Coolify Discord](https://discord.gg/coolify)
