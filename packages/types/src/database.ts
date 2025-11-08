/**
 * Database Types - Generated from Supabase Schema
 * Based on migrations: 001_shared_schema.sql, 002_app_web_schema.sql
 */

// =============================================================================
// Shared Schema (public.*)
// =============================================================================

export type UserRole = "user" | "moderator" | "admin" | "super_admin";

export interface Organization {
  organization_id: string; // UUID
  name: string;
  slug: string;
  settings: Record<string, any>;
  is_active: boolean;
  created_at: string; // ISO timestamp
  updated_at: string; // ISO timestamp
}

export interface User {
  user_id: string; // UUID
  organization_id: string; // UUID
  email: string;
  name: string;
  avatar_url: string | null;
  role: UserRole;
  metadata: Record<string, any>;
  is_active: boolean;
  is_verified: boolean;
  last_login_at: string | null; // ISO timestamp
  created_at: string; // ISO timestamp
  updated_at: string; // ISO timestamp
}

export interface Notification {
  notification_id: string; // UUID
  user_id: string; // UUID
  type: string;
  title: string;
  message: string | null;
  data: Record<string, any>;
  is_read: boolean;
  read_at: string | null; // ISO timestamp
  created_at: string; // ISO timestamp
}

export interface AuditLog {
  log_id: string; // UUID
  user_id: string | null; // UUID
  organization_id: string; // UUID
  action: string;
  resource_type: string;
  resource_id: string | null; // UUID
  metadata: Record<string, any>;
  ip_address: string | null;
  user_agent: string | null;
  created_at: string; // ISO timestamp
}

// =============================================================================
// Web App Schema (app_web.*)
// =============================================================================

export interface Profile {
  profile_id: string; // UUID
  user_id: string; // UUID
  bio: string | null;
  website: string | null;
  location: string | null;
  social_links: Record<string, string>;
  preferences: Record<string, any>;
  created_at: string; // ISO timestamp
  updated_at: string; // ISO timestamp
}

export type PostStatus = "draft" | "published" | "archived";

export interface Post {
  post_id: string; // UUID
  user_id: string; // UUID
  organization_id: string; // UUID
  title: string;
  slug: string;
  content: string | null;
  excerpt: string | null;
  status: PostStatus;
  metadata: Record<string, any>;
  published_at: string | null; // ISO timestamp
  created_at: string; // ISO timestamp
  updated_at: string; // ISO timestamp
}

export interface Comment {
  comment_id: string; // UUID
  post_id: string; // UUID
  user_id: string; // UUID
  parent_comment_id: string | null; // UUID
  content: string;
  is_edited: boolean;
  created_at: string; // ISO timestamp
  updated_at: string; // ISO timestamp
}

// =============================================================================
// Extended Types with Relations
// =============================================================================

export interface PostWithAuthor extends Post {
  author: Pick<User, "user_id" | "name" | "email" | "avatar_url">;
}

export interface PostWithAuthorAndOrg extends PostWithAuthor {
  organization: Pick<Organization, "organization_id" | "name" | "slug">;
}

export interface CommentWithAuthor extends Comment {
  author: Pick<User, "user_id" | "name" | "email" | "avatar_url">;
}

export interface CommentWithReplies extends CommentWithAuthor {
  replies: CommentWithAuthor[];
}

export interface UserWithProfile extends User {
  profile: Profile;
}

export interface UserWithOrganization extends User {
  organization: Organization;
}

// =============================================================================
// Database Query Filters
// =============================================================================

export interface PostFilters {
  status?: PostStatus;
  userId?: string;
  organizationId?: string;
  searchQuery?: string;
  limit?: number;
  offset?: number;
}

export interface CommentFilters {
  postId?: string;
  userId?: string;
  parentCommentId?: string | null;
  limit?: number;
  offset?: number;
}

export interface UserFilters {
  organizationId?: string;
  role?: UserRole;
  isActive?: boolean;
  isVerified?: boolean;
  searchQuery?: string;
  limit?: number;
  offset?: number;
}
