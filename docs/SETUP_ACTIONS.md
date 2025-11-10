# Setup Actions - Do These Now

**Status**: 🟡 Action Required
**Created**: November 8, 2025

---

## ✅ What's Already Done

1. ✅ `.secrets` file secured in `.gitignore`
2. ✅ Convex schema fixed (removed `_creationTime` from indexes)
3. ✅ Environment files created:
   - `apps/web/.env.local` ✅ (Supabase configured, Convex URL pending)
   - `services/auth-service/.env` ⚠️ (needs service role key + DB password)

---

## 🎯 Actions You Need to Complete

### 1. Deploy Convex Schema (CRITICAL)

**Run this command**:
```bash
cd /Users/tmg/Developer/00-Claude/DFWorx
npx convex dev
```

**What will happen**:
1. Browser opens for authentication
2. Select/create project "DFWorX"
3. Schema deploys successfully (the error is now fixed!)
4. You'll see: `Deployment URL: https://________.convex.cloud`

**Copy the URL and provide it to me**

---

### 2. Get Supabase Service Role Key (CRITICAL)

**Steps**:
1. Go to https://nbrcnduomfdfubwinmja.supabase.co
2. Click Settings (bottom left) → API
3. Find **`service_role`** key (NOT the anon key)
4. Click "Reveal" and copy the key
5. It starts with `eyJ...` (very long)

**Copy the key and provide it to me**

---

### 3. Login to Supabase CLI

**Run this command**:
```bash
supabase login
```

**What will happen**:
1. Browser opens
2. Authorize the CLI
3. Returns to terminal

---

### 4. Link Supabase Project

**Run this command**:
```bash
cd /Users/tmg/Developer/00-Claude/DFWorx
supabase link --project-ref nbrcnduomfdfubwinmja
```

**When prompted for database password**:
- Enter the password you set when creating the project
- If you forgot it, reset it in: Supabase Dashboard → Settings → Database

---

## 📝 What I Need From You

Please provide these values:

```
1. Convex Deployment URL: https://________.convex.cloud
2. Supabase Service Role Key: eyJ________...
3. Database Password (for migrations): ________
```

---

## 🤖 What I'll Do Next

Once you provide the above:

1. ✅ Update `apps/web/.env.local` with Convex URL
2. ✅ Update `services/auth-service/.env` with service role key and DB password
3. ✅ Run Supabase migrations (all 3 migration files)
4. ✅ Verify database schema is created correctly
5. ✅ Test Convex connection
6. ✅ Test Supabase connection
7. ✅ Create initial test organization and user
8. ✅ Commit and push all configuration
9. ✅ Update documentation

---

## 🚨 Common Issues & Solutions

### Convex: "Failed to authenticate"
- Check popup blocker
- Try incognito window
- Run: `npx convex dev --show-token` for manual auth

### Supabase: "Project not found"
- Double-check project ref: `nbrcnduomfdfubwinmja`
- Ensure you're logged in: `supabase login`
- Check project exists in dashboard

### Supabase: "Password incorrect"
- Reset password in: Dashboard → Settings → Database → Reset Database Password
- Wait 2 minutes after reset before retrying

---

## ⏱️ Time Estimate

- Convex setup: 2-3 minutes
- Supabase service role key: 30 seconds
- Supabase CLI login: 1 minute
- Link project: 30 seconds

**Total**: ~5 minutes

---

## 📞 Questions?

If you hit any blockers, let me know:
- Copy/paste the exact error message
- Screenshot is helpful
- I'll help troubleshoot immediately

---

**Status**: ⏸️ Waiting for your input to proceed
