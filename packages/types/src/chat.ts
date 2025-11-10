/**
 * Chat-specific types for Convex integration
 */

// =============================================================================
// Convex ID Type (local definition to avoid import issues)
// =============================================================================

/**
 * Convex ID type - branded string for type safety
 * This mirrors the Id type from convex/_generated/dataModel
 */
export type Id<TableName extends string = string> = string & { __tableName: TableName };

// =============================================================================
// Base Chat Types (matching Convex schema)
// =============================================================================

export type ThreadType = "global" | "post";

export type TagCategory = "app" | "topic" | "decision" | "status" | "priority";

export interface Thread {
  _id: Id<"threads">;
  _creationTime: number;
  type: ThreadType;
  title: string;
  postId?: string; // Supabase post UUID
  description?: string;
  organizationId: string;
  createdBy: string; // User UUID from Supabase
  isArchived: boolean;
  metadata?: Record<string, any>;
}

export interface Message {
  _id: Id<"messages">;
  _creationTime: number;
  threadId: Id<"threads">;
  content: string;
  userId: string; // User UUID from Supabase
  userName: string;
  userEmail: string;
  parentMessageId?: Id<"messages">; // For threading
  isEdited: boolean;
  isDeleted: boolean;
  organizationId: string;
  mentions?: string[]; // User IDs
  metadata?: Record<string, any>;
}

export interface Tag {
  _id: Id<"tags">;
  _creationTime: number;
  name: string;
  slug: string;
  color: string; // Hex color
  category: TagCategory;
  description?: string;
  organizationId: string;
  createdBy: string;
  isActive: boolean;
}

export interface MessageTag {
  _id: Id<"messageTags">;
  messageId: Id<"messages">;
  tagId: Id<"tags">;
  organizationId: string;
}

export interface ThreadTag {
  _id: Id<"threadTags">;
  threadId: Id<"threads">;
  tagId: Id<"tags">;
  organizationId: string;
}

export interface Attachment {
  _id: Id<"attachments">;
  _creationTime: number;
  messageId: Id<"messages">;
  storageId: Id<"_storage">;
  filename: string;
  fileType: string; // MIME type
  fileSize: number; // Bytes
  uploadedBy: string; // User UUID
  organizationId: string;
  thumbnailStorageId?: Id<"_storage">;
  metadata?: Record<string, any>;
}

export interface Reaction {
  _id: Id<"reactions">;
  messageId: Id<"messages">;
  userId: string; // User UUID from Supabase
  emoji: string;
  organizationId: string;
}

// =============================================================================
// Extended Types with Relations
// =============================================================================

export interface MessageWithTags extends Message {
  tags: Tag[];
}

export interface MessageWithAttachments extends Message {
  attachments: Attachment[];
}

export interface MessageWithReplies extends Message {
  replies: Message[];
  replyCount: number;
}

export interface MessageComplete extends Message {
  tags: Tag[];
  attachments: Attachment[];
  reactions: Reaction[];
  replies: Message[];
  replyCount: number;
}

export interface ThreadWithTags extends Thread {
  tags: Tag[];
}

export interface ThreadWithMessages extends Thread {
  messages: Message[];
  messageCount: number;
  lastMessage?: Message;
}

// =============================================================================
// Chat DTOs
// =============================================================================

export interface CreateThreadDTO {
  type: ThreadType;
  title: string;
  postId?: string;
  description?: string;
  tags?: Id<"tags">[];
  metadata?: Record<string, any>;
}

export interface SendMessageDTO {
  threadId: Id<"threads">;
  content: string;
  parentMessageId?: Id<"messages">;
  tags?: Id<"tags">[];
  mentions?: string[];
  metadata?: Record<string, any>;
}

export interface EditMessageDTO {
  messageId: Id<"messages">;
  content: string;
}

export interface DeleteMessageDTO {
  messageId: Id<"messages">;
}

export interface AddReactionDTO {
  messageId: Id<"messages">;
  emoji: string;
}

export interface CreateTagDTO {
  name: string;
  color: string;
  category: TagCategory;
  description?: string;
}

export interface UploadFileDTO {
  file: File;
  messageId: Id<"messages">;
}

// =============================================================================
// Chat Queries & Filters
// =============================================================================

export interface MessageFilters {
  threadId?: Id<"threads">;
  userId?: string;
  tagIds?: Id<"tags">[];
  searchQuery?: string;
  dateFrom?: number; // Unix timestamp
  dateTo?: number; // Unix timestamp
  limit?: number;
  offset?: number;
}

export interface ThreadFilters {
  type?: ThreadType;
  postId?: string;
  tagIds?: Id<"tags">[];
  isArchived?: boolean;
  createdBy?: string;
  searchQuery?: string;
  limit?: number;
  offset?: number;
}

export interface TagFilters {
  category?: TagCategory;
  isActive?: boolean;
  searchQuery?: string;
}

// =============================================================================
// Export & Integration Types
// =============================================================================

export interface ChatExportOptions {
  threadId: Id<"threads">;
  includeAttachments: boolean;
  includeTags: boolean;
  filterByTags?: Id<"tags">[];
  dateFrom?: number;
  dateTo?: number;
  format: "markdown" | "json";
}

export interface ExportedThread {
  thread: Thread;
  messages: MessageComplete[];
  tags: Tag[];
  markdown?: string;
  json?: Record<string, any>;
}

export interface ChatToBlogDTO {
  threadId: Id<"threads">;
  title?: string;
  excerpt?: string;
  includeTags: boolean;
  selectedMessages?: Id<"messages">[];
  filterByTags?: Id<"tags">[];
}

// =============================================================================
// Real-time Updates
// =============================================================================

export interface ChatEvent {
  type:
    | "message_created"
    | "message_updated"
    | "message_deleted"
    | "reaction_added"
    | "reaction_removed"
    | "thread_created"
    | "thread_updated";
  timestamp: number;
  organizationId: string;
  userId: string;
  data: any;
}

// =============================================================================
// Search Results
// =============================================================================

export interface MessageSearchResult {
  message: MessageWithTags;
  thread: Thread;
  matchSnippet: string;
  relevanceScore: number;
}

export interface ChatSearchResults {
  messages: MessageSearchResult[];
  total: number;
  page: number;
  pageSize: number;
}
