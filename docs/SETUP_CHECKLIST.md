# Backend Services Setup Checklist

**Date**: November 8, 2025
**Status**: In Progress

---

## 🎯 Quick Setup Steps

### 1. ConvexDB Setup 🔄

**Status**: Initializing...

**Your Action Required**:
1. Browser window should open for Convex authentication
2. Sign in with GitHub (recommended) or email
3. Authorize the DFWorX project
4. Copy the deployment URL once shown

**What I need from you**:
- [ ] Deployment URL: `https://________.convex.cloud`

---

### 2. Supabase Setup ⏳

**Your Action Required**:
1. Visit https://supabase.com
2. Create new project named "DFWorX"
3. Choose region closest to you
4. Generate and SAVE database password
5. Wait 2-3 minutes for project creation

**What I need from you**:
- [ ] Project URL: `https://________.supabase.co`
- [ ] Anon/Public Key: `eyJ...`
- [ ] Service Role Key: `eyJ...` (keep secret!)
- [ ] Database Password: `________` (for CLI)

**Where to find these**:
- Go to Settings > API in Supabase Dashboard
- Project URL and keys are listed there

---

### 3. Coolify Setup (Optional - For Later) ⏳

**Status**: Can be done after development is working

**Your Action**:
- [ ] Do you have a server/VPS for Coolify?
  - Yes → I can help set it up
  - No → Skip for now, use Vercel/Railway for deployment

---

## 🔑 Environment Variables Needed

Once you provide the credentials above, I'll automatically create:

**apps/web/.env.local**:
```env
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
NEXT_PUBLIC_CONVEX_URL=...
NEXT_PUBLIC_API_URL=http://localhost:8000
```

**services/auth-service/.env**:
```env
DATABASE_URL=...
SUPABASE_URL=...
SUPABASE_KEY=... # service role
JWT_SECRET_KEY=... # I'll generate this
JWT_ALGORITHM=HS256
JWT_EXPIRATION_MINUTES=60
CORS_ORIGINS=http://localhost:3000
```

---

## 📋 Progress Tracker

### Phase: Backend Services Setup

- [x] GitHub repository created and pushed
- [x] shadcn MCP configured
- [🔄] ConvexDB project initializing
- [ ] ConvexDB schema deployed
- [ ] ConvexDB credentials configured
- [ ] Supabase project created
- [ ] Supabase migrations applied
- [ ] Supabase credentials configured
- [ ] Environment files created
- [ ] Connection tests passed
- [ ] Ready for Phase 2: Authentication

---

## 🚀 Next Actions

**Immediate** (waiting on you):
1. Complete Convex browser authentication
2. Create Supabase project
3. Provide credentials (listed above)

**Then I will**:
1. Deploy Convex schema
2. Configure environment variables
3. Run Supabase migrations
4. Test all connections
5. Create initial test data
6. Verify everything works

**Finally**:
- Commit and push configuration changes
- Update documentation
- Proceed to Phase 2: Authentication

---

## 💡 Tips

**Saving Credentials**:
- Use a password manager (1Password, Bitwarden, etc.)
- Save as "DFWorX - Supabase Production"
- Include both project URL and all keys

**Security**:
- NEVER commit .env.local or .env files
- Service role keys are for server-side only
- Anon keys are safe to expose (they're rate-limited)

---

## ❓ Need Help?

**If Convex authentication fails**:
- Check popup blocker
- Try incognito/private window
- Use `npx convex dev --show-token` to get manual auth link

**If Supabase project creation hangs**:
- Refresh page
- Try different browser
- Check Supabase status page

**If you have questions**:
- Just ask! I'm here to help.

---

**Status**: ⏸️ Waiting for your credentials to proceed
