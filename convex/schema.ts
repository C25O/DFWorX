import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

/**
 * Convex Schema for DFWorX Chat System
 *
 * Handles:
 * - Global workspace chat
 * - Per-blog-post chat threads
 * - Message tagging and categorization
 * - File attachments
 * - Message threading (replies)
 */

export default defineSchema({
  // Threads - Chat conversations (global or post-specific)
  threads: defineTable({
    type: v.union(v.literal("global"), v.literal("post")),
    title: v.string(),
    postId: v.optional(v.string()), // Reference to Supabase post UUID
    description: v.optional(v.string()),
    organizationId: v.string(), // Multi-tenancy support
    createdBy: v.string(), // User UUID from Supabase
    isArchived: v.boolean(),
    metadata: v.optional(v.any()), // Flexible JSONB-like field
  })
    .index("by_type", ["type"])
    .index("by_post", ["postId"])
    .index("by_organization", ["organizationId"])
    .index("by_created_by", ["createdBy"]),

  // Messages - Individual chat messages
  messages: defineTable({
    threadId: v.id("threads"),
    content: v.string(),
    userId: v.string(), // User UUID from Supabase
    userName: v.string(), // Denormalized for performance
    userEmail: v.string(), // Denormalized for performance

    // Threading support
    parentMessageId: v.optional(v.id("messages")), // For replies/threads

    // Metadata
    isEdited: v.boolean(),
    isDeleted: v.boolean(),
    organizationId: v.string(), // Multi-tenancy

    // Rich content
    mentions: v.optional(v.array(v.string())), // User IDs mentioned
    metadata: v.optional(v.any()), // Flexible field for custom data
  })
    .index("by_thread", ["threadId"])
    .index("by_user", ["userId"])
    .index("by_parent", ["parentMessageId"])
    .index("by_organization", ["organizationId"])
    .index("by_thread_and_time", ["threadId", "_creationTime"]),

  // Tags - Categorization for messages and threads
  tags: defineTable({
    name: v.string(),
    slug: v.string(), // URL-friendly version
    color: v.string(), // Hex color code
    category: v.union(
      v.literal("app"), // App-specific tags (e.g., "web-app", "admin-app")
      v.literal("topic"), // Topic tags (e.g., "architecture", "bug")
      v.literal("decision"), // Decision tags (e.g., "tech-choice", "design-pattern")
      v.literal("status"), // Status tags (e.g., "in-progress", "resolved")
      v.literal("priority") // Priority tags (e.g., "urgent", "low-priority")
    ),
    description: v.optional(v.string()),
    organizationId: v.string(),
    createdBy: v.string(),
    isActive: v.boolean(),
  })
    .index("by_slug", ["slug"])
    .index("by_category", ["category"])
    .index("by_organization", ["organizationId"]),

  // Message Tags - Many-to-many relationship
  messageTags: defineTable({
    messageId: v.id("messages"),
    tagId: v.id("tags"),
    organizationId: v.string(),
  })
    .index("by_message", ["messageId"])
    .index("by_tag", ["tagId"])
    .index("by_organization", ["organizationId"]),

  // Thread Tags - Many-to-many relationship
  threadTags: defineTable({
    threadId: v.id("threads"),
    tagId: v.id("tags"),
    organizationId: v.string(),
  })
    .index("by_thread", ["threadId"])
    .index("by_tag", ["tagId"])
    .index("by_organization", ["organizationId"]),

  // Attachments - File uploads
  attachments: defineTable({
    messageId: v.id("messages"),

    // File info
    storageId: v.id("_storage"), // Convex file storage ID
    filename: v.string(),
    fileType: v.string(), // MIME type
    fileSize: v.number(), // Size in bytes

    // Metadata
    uploadedBy: v.string(), // User UUID
    organizationId: v.string(),

    // Optional processing info
    thumbnailStorageId: v.optional(v.id("_storage")), // For images
    metadata: v.optional(v.any()),
  })
    .index("by_message", ["messageId"])
    .index("by_uploader", ["uploadedBy"])
    .index("by_organization", ["organizationId"]),

  // Reactions - Emoji reactions to messages
  reactions: defineTable({
    messageId: v.id("messages"),
    userId: v.string(), // User UUID from Supabase
    emoji: v.string(), // Emoji character or code
    organizationId: v.string(),
  })
    .index("by_message", ["messageId"])
    .index("by_user", ["userId"])
    .index("by_message_and_user", ["messageId", "userId"])
    .index("by_organization", ["organizationId"]),
});
