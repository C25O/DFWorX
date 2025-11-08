/**
 * Blog-specific types and DTOs
 */

import type { Post, PostStatus, PostWithAuthor, CommentWithAuthor } from "./database";

// =============================================================================
// Post DTOs (Data Transfer Objects)
// =============================================================================

export interface CreatePostDTO {
  title: string;
  content: string;
  excerpt?: string;
  status?: PostStatus;
  metadata?: Record<string, any>;
}

export interface UpdatePostDTO {
  title?: string;
  content?: string;
  excerpt?: string;
  status?: PostStatus;
  metadata?: Record<string, any>;
}

export interface PublishPostDTO {
  postId: string;
  publishedAt?: string; // ISO timestamp, defaults to now
}

// =============================================================================
// Comment DTOs
// =============================================================================

export interface CreateCommentDTO {
  postId: string;
  content: string;
  parentCommentId?: string;
}

export interface UpdateCommentDTO {
  content: string;
}

// =============================================================================
// Post View Models (for frontend)
// =============================================================================

export interface PostListItem {
  post_id: string;
  title: string;
  slug: string;
  excerpt: string | null;
  status: PostStatus;
  published_at: string | null;
  created_at: string;
  updated_at: string;
  author: {
    user_id: string;
    name: string;
    avatar_url: string | null;
  };
  commentCount?: number;
  readTime?: number; // Estimated read time in minutes
}

export interface PostDetail extends PostWithAuthor {
  commentCount: number;
  readTime: number;
  tags?: string[]; // From metadata
  relatedPosts?: PostListItem[];
}

// =============================================================================
// Search & Filter
// =============================================================================

export interface PostSearchParams {
  query?: string;
  status?: PostStatus;
  authorId?: string;
  organizationId?: string;
  tags?: string[];
  dateFrom?: string; // ISO timestamp
  dateTo?: string; // ISO timestamp
  sortBy?: "created_at" | "updated_at" | "published_at" | "title";
  sortOrder?: "asc" | "desc";
  page?: number;
  pageSize?: number;
}

export interface PostSearchResult {
  posts: PostListItem[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

// =============================================================================
// Markdown Processing
// =============================================================================

export interface MarkdownMetadata {
  title?: string;
  excerpt?: string;
  tags?: string[];
  category?: string;
  coverImage?: string;
  [key: string]: any;
}

export interface ProcessedMarkdown {
  frontmatter: MarkdownMetadata;
  content: string;
  html?: string;
  readTime: number; // Minutes
  wordCount: number;
}

// =============================================================================
// Export Types
// =============================================================================

export interface ExportOptions {
  format: "markdown" | "html" | "json";
  includeMetadata: boolean;
  includeComments?: boolean;
}

export interface ExportedPost {
  post: Post;
  markdown?: string;
  html?: string;
  json?: Record<string, any>;
  comments?: CommentWithAuthor[];
}
