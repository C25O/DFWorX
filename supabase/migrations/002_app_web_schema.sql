-- =============================================================================
-- Web App Specific Schema
-- =============================================================================
-- This schema contains data specific to the main web application:
-- - User profiles
-- - Posts/Content
-- - User preferences
-- =============================================================================

-- Create schema for web app
CREATE SCHEMA IF NOT EXISTS app_web;

-- =============================================================================
-- Profiles Table
-- =============================================================================
-- Extended user profiles for web app

CREATE TABLE app_web.profiles (
    profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    bio TEXT,
    website VARCHAR(255),
    location VARCHAR(255),
    social_links JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

CREATE UNIQUE INDEX idx_profiles_user ON app_web.profiles(user_id);

COMMENT ON TABLE app_web.profiles IS 'Extended user profiles for web application';

-- =============================================================================
-- Posts Table
-- =============================================================================
-- User-generated content/posts

CREATE TABLE app_web.posts (
    post_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    organization_id UUID REFERENCES public.organizations(organization_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    content TEXT,
    excerpt VARCHAR(500),
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    metadata JSONB DEFAULT '{}',
    published_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_posts_user ON app_web.posts(user_id);
CREATE INDEX idx_posts_org ON app_web.posts(organization_id);
CREATE INDEX idx_posts_status ON app_web.posts(status);
CREATE INDEX idx_posts_published ON app_web.posts(published_at DESC) WHERE status = 'published';
CREATE UNIQUE INDEX idx_posts_slug ON app_web.posts(organization_id, slug);

COMMENT ON TABLE app_web.posts IS 'User-generated content for web application';

-- =============================================================================
-- Comments Table
-- =============================================================================
-- Comments on posts

CREATE TABLE app_web.comments (
    comment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES app_web.posts(post_id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES app_web.comments(comment_id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_edited BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_comments_post ON app_web.comments(post_id, created_at);
CREATE INDEX idx_comments_user ON app_web.comments(user_id);
CREATE INDEX idx_comments_parent ON app_web.comments(parent_comment_id);

COMMENT ON TABLE app_web.comments IS 'Comments on posts';

-- =============================================================================
-- Triggers
-- =============================================================================

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON app_web.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON app_web.posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON app_web.comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- Auto-create profile on user creation
-- =============================================================================

CREATE OR REPLACE FUNCTION app_web.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO app_web.profiles (user_id, preferences)
    VALUES (NEW.user_id, '{"theme": "light", "notifications": true}');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_user_created
    AFTER INSERT ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION app_web.handle_new_user();

COMMENT ON FUNCTION app_web.handle_new_user IS 'Automatically creates web profile for new users';
