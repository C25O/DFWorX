-- =============================================================================
-- Row Level Security (RLS) Policies
-- =============================================================================
-- Implements fine-grained access control for all tables
-- =============================================================================

-- =============================================================================
-- Public Schema Policies
-- =============================================================================

-- Enable RLS
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Organizations Policies
-- ----------------------------------------------------------------------------

-- Users can view their own organization
CREATE POLICY "Users can view own organization"
    ON public.organizations FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid()
        )
    );

-- Only admins can update organizations
CREATE POLICY "Admins can update organization"
    ON public.organizations FOR UPDATE
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid() AND role IN ('admin', 'super_admin')
        )
    );

-- Users Policies
-- ----------------------------------------------------------------------------

-- Users can view users in their organization
CREATE POLICY "Users can view organization users"
    ON public.users FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid()
        )
    );

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON public.users FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Admins can update any user in their organization
CREATE POLICY "Admins can update org users"
    ON public.users FOR UPDATE
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid() AND role IN ('admin', 'super_admin')
        )
    );

-- Notifications Policies
-- ----------------------------------------------------------------------------

-- Users can view their own notifications
CREATE POLICY "Users can view own notifications"
    ON public.notifications FOR SELECT
    USING (user_id = auth.uid());

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications"
    ON public.notifications FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Users can delete their own notifications
CREATE POLICY "Users can delete own notifications"
    ON public.notifications FOR DELETE
    USING (user_id = auth.uid());

-- Audit Logs Policies
-- ----------------------------------------------------------------------------

-- Admins can view org audit logs
CREATE POLICY "Admins can view org audit logs"
    ON public.audit_logs FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid() AND role IN ('admin', 'super_admin')
        )
    );

-- =============================================================================
-- App Web Schema Policies
-- =============================================================================

-- Enable RLS
ALTER TABLE app_web.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_web.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_web.comments ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
-- ----------------------------------------------------------------------------

-- Users can view profiles in their organization
CREATE POLICY "Users can view org profiles"
    ON app_web.profiles FOR SELECT
    USING (
        user_id IN (
            SELECT user_id FROM public.users
            WHERE organization_id = (
                SELECT organization_id FROM public.users WHERE user_id = auth.uid()
            )
        )
    );

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON app_web.profiles FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Posts Policies
-- ----------------------------------------------------------------------------

-- Users can view published posts in their organization
CREATE POLICY "Users can view org published posts"
    ON app_web.posts FOR SELECT
    USING (
        (status = 'published' AND organization_id = (
            SELECT organization_id FROM public.users WHERE user_id = auth.uid()
        ))
        OR user_id = auth.uid()
    );

-- Users can create posts in their organization
CREATE POLICY "Users can create posts"
    ON app_web.posts FOR INSERT
    WITH CHECK (
        user_id = auth.uid()
        AND organization_id = (
            SELECT organization_id FROM public.users WHERE user_id = auth.uid()
        )
    );

-- Users can update their own posts
CREATE POLICY "Users can update own posts"
    ON app_web.posts FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts"
    ON app_web.posts FOR DELETE
    USING (user_id = auth.uid());

-- Moderators can moderate posts in their org
CREATE POLICY "Moderators can moderate org posts"
    ON app_web.posts FOR UPDATE
    USING (
        organization_id = (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid() AND role IN ('moderator', 'admin', 'super_admin')
        )
    );

-- Comments Policies
-- ----------------------------------------------------------------------------

-- Users can view comments on posts they can see
CREATE POLICY "Users can view post comments"
    ON app_web.comments FOR SELECT
    USING (
        post_id IN (
            SELECT post_id FROM app_web.posts
            WHERE status = 'published' OR user_id = auth.uid()
        )
    );

-- Users can create comments
CREATE POLICY "Users can create comments"
    ON app_web.comments FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- Users can update their own comments
CREATE POLICY "Users can update own comments"
    ON app_web.comments FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Users can delete their own comments
CREATE POLICY "Users can delete own comments"
    ON app_web.comments FOR DELETE
    USING (user_id = auth.uid());

-- =============================================================================
-- Service Role Bypass
-- =============================================================================

-- Service role can bypass RLS (for backend services)
-- Configured in Supabase dashboard or via environment variables
