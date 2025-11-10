-- =============================================================================
-- Fix RLS Infinite Recursion
-- =============================================================================
-- Creates helper functions that bypass RLS to prevent circular dependencies
-- =============================================================================

-- Drop existing problematic policies
DROP POLICY IF EXISTS "Users can view own organization" ON public.organizations;
DROP POLICY IF EXISTS "Admins can update organization" ON public.organizations;
DROP POLICY IF EXISTS "Users can view organization users" ON public.users;
DROP POLICY IF EXISTS "Admins can update org users" ON public.users;
DROP POLICY IF EXISTS "Admins can view org audit logs" ON public.audit_logs;
DROP POLICY IF EXISTS "Users can view org profiles" ON app_web.profiles;
DROP POLICY IF EXISTS "Users can view org published posts" ON app_web.posts;
DROP POLICY IF EXISTS "Users can create posts" ON app_web.posts;
DROP POLICY IF EXISTS "Moderators can moderate org posts" ON app_web.posts;

-- =============================================================================
-- Helper Functions (SECURITY DEFINER to bypass RLS)
-- =============================================================================

-- Get current user's organization_id
CREATE OR REPLACE FUNCTION public.current_user_organization_id()
RETURNS UUID
LANGUAGE SQL
SECURITY DEFINER
STABLE
AS $$
    SELECT organization_id FROM public.users WHERE user_id = auth.uid() LIMIT 1;
$$;

-- Get current user's role
CREATE OR REPLACE FUNCTION public.current_user_role()
RETURNS TEXT
LANGUAGE SQL
SECURITY DEFINER
STABLE
AS $$
    SELECT role FROM public.users WHERE user_id = auth.uid() LIMIT 1;
$$;

-- Check if current user is admin
CREATE OR REPLACE FUNCTION public.current_user_is_admin()
RETURNS BOOLEAN
LANGUAGE SQL
SECURITY DEFINER
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.users
        WHERE user_id = auth.uid()
        AND role IN ('admin', 'super_admin')
    );
$$;

-- =============================================================================
-- Recreate Policies with Helper Functions
-- =============================================================================

-- Organizations Policies
-- ----------------------------------------------------------------------------

CREATE POLICY "Users can view own organization"
    ON public.organizations FOR SELECT
    USING (organization_id = public.current_user_organization_id());

CREATE POLICY "Admins can update organization"
    ON public.organizations FOR UPDATE
    USING (
        organization_id = public.current_user_organization_id()
        AND public.current_user_is_admin()
    );

-- Users Policies
-- ----------------------------------------------------------------------------

CREATE POLICY "Users can view organization users"
    ON public.users FOR SELECT
    USING (organization_id = public.current_user_organization_id());

CREATE POLICY "Admins can update org users"
    ON public.users FOR UPDATE
    USING (
        organization_id = public.current_user_organization_id()
        AND public.current_user_is_admin()
    );

-- Audit Logs Policies
-- ----------------------------------------------------------------------------

CREATE POLICY "Admins can view org audit logs"
    ON public.audit_logs FOR SELECT
    USING (
        organization_id = public.current_user_organization_id()
        AND public.current_user_is_admin()
    );

-- Profiles Policies
-- ----------------------------------------------------------------------------

CREATE POLICY "Users can view org profiles"
    ON app_web.profiles FOR SELECT
    USING (
        user_id IN (
            SELECT user_id FROM public.users
            WHERE organization_id = public.current_user_organization_id()
        )
    );

-- Posts Policies
-- ----------------------------------------------------------------------------

CREATE POLICY "Users can view org published posts"
    ON app_web.posts FOR SELECT
    USING (
        (status = 'published' AND organization_id = public.current_user_organization_id())
        OR user_id = auth.uid()
    );

CREATE POLICY "Users can create posts"
    ON app_web.posts FOR INSERT
    WITH CHECK (
        user_id = auth.uid()
        AND organization_id = public.current_user_organization_id()
    );

CREATE POLICY "Moderators can moderate org posts"
    ON app_web.posts FOR UPDATE
    USING (
        organization_id = public.current_user_organization_id()
        AND public.current_user_role() IN ('moderator', 'admin', 'super_admin')
    );
