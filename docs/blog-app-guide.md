# Blog Application User Guide

**Application**: DFWorX Blog + Chat
**Version**: 1.0.0 (In Development)
**Last Updated**: November 8, 2025

---

## Overview

The DFWorX Blog is a markdown-based blogging platform integrated with real-time chat, designed specifically for documenting and organizing knowledge about applications in the DFWorX monorepo.

### Key Features

- **Markdown-First**: Write posts in pure markdown with frontmatter support
- **Real-time Chat**: Every post has its own chat thread for discussions
- **Global Workspace Chat**: Central chat for cross-app discussions
- **Tag System**: Organize content by app, topic, decision, status, and priority
- **Full-Text Search**: Search across blog posts and chat messages
- **Export Capabilities**: Convert chat threads to blog posts
- **Multi-tenancy**: Organization-based isolation for teams

---

## Getting Started

### Prerequisites

1. **Supabase Account**: Create a project at [supabase.com](https://supabase.com)
2. **ConvexDB Account**: Create a project at [convex.dev](https://convex.dev)
3. **Environment Setup**: Configure environment variables

### Environment Configuration

Create `apps/web/.env.local`:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

# ConvexDB Configuration
NEXT_PUBLIC_CONVEX_URL=https://your-project.convex.cloud

# Optional: API Configuration
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Database Setup

1. **Run Supabase Migrations**:
   ```bash
   # Navigate to infrastructure directory
   cd infrastructure/supabase

   # Apply migrations in order
   supabase db push migrations/001_shared_schema.sql
   supabase db push migrations/002_app_web_schema.sql
   supabase db push migrations/003_rls_policies.sql
   ```

2. **Initialize ConvexDB**:
   ```bash
   # From workspace root
   npx convex dev

   # This will:
   # - Deploy schema to Convex
   # - Start local development server
   # - Watch for schema changes
   ```

### Starting the Application

```bash
# Install dependencies
pnpm install

# Start development server
pnpm dev

# Or use the script
./scripts/dev.sh
```

Access the app at: `http://localhost:3000`

---

## Writing Blog Posts

### Markdown Basics

Blog posts are written in Markdown with YAML frontmatter for metadata.

**Basic Structure**:
```markdown
---
title: My First Blog Post
excerpt: A short description of the post
tags: [app, architecture, decision]
category: technical
---

# Main Heading

Your content goes here...

## Subheading

More content...
```

### Frontmatter Options

```yaml
---
# Required
title: Post Title

# Optional
excerpt: Short description (auto-generated if omitted)
tags: [tag1, tag2, tag3]
category: technical | decision | tutorial | guide
coverImage: /images/cover.jpg
author: Your Name
publishedAt: 2025-11-08
---
```

### Supported Markdown Features

1. **Headers**: `# H1` through `###### H6`
2. **Emphasis**: `*italic*`, `**bold**`, `***bold italic***`
3. **Lists**:
   ```markdown
   - Unordered item
   - Another item

   1. Ordered item
   2. Second item
   ```
4. **Links**: `[Link Text](https://example.com)`
5. **Images**: `![Alt Text](https://example.com/image.jpg)`
6. **Code Blocks**:
   ````markdown
   ```python
   def hello():
       print("Hello, World!")
   ```
   ````
7. **Inline Code**: `` `code` ``
8. **Blockquotes**: `> Quote text`
9. **Tables** (GitHub Flavored Markdown):
   ```markdown
   | Header 1 | Header 2 |
   |----------|----------|
   | Cell 1   | Cell 2   |
   ```

### Creating a Post

1. **Navigate to Create Page**: `/blog/new`
2. **Write Content**: Use the markdown editor
3. **Preview**: Toggle preview pane to see rendered output
4. **Add Metadata**: Fill in frontmatter fields
5. **Save as Draft** or **Publish**

### Editing a Post

1. **Navigate to Post**: `/blog/[slug]`
2. **Click "Edit"**: Opens editor with existing content
3. **Make Changes**: Modify markdown
4. **Update**: Save changes (preserves slug)

### Post Status

Posts can have three statuses:
- **draft**: Not visible to others, editable
- **published**: Visible to organization members, editable
- **archived**: Hidden from main listing, read-only

---

## Using the Search

### Blog Post Search

**Search Bar**: Located at `/blog` or global header

**Search Syntax**:
```
General search: "authentication"
Tag filter: tag:app tag:decision
Author filter: author:john
Status filter: status:published
Date range: after:2025-01-01 before:2025-12-31
```

**Sort Options**:
- Newest first (default)
- Oldest first
- Alphabetical (A-Z)
- Alphabetical (Z-A)
- Most commented

### Advanced Search

Navigate to `/search` for advanced search:
- Filter by tags (multi-select)
- Filter by date range
- Filter by author
- Filter by status
- Search across blog + chat simultaneously

---

## Blog Post Organization

### Slugs

- Auto-generated from title
- URL-friendly (lowercase, hyphenated)
- Unique per organization
- Example: "My Post Title" → `my-post-title`

### Categories

Suggested categories for monorepo documentation:
- **app**: App-specific documentation
- **architecture**: System design decisions
- **api**: API documentation
- **tutorial**: How-to guides
- **decision**: Decision records (ADRs)
- **guide**: General guides
- **changelog**: Version changes

### Tags

Recommended tag structure:
- **App Tags**: `web-app`, `admin-app`, `mobile-app`
- **Tech Tags**: `fastapi`, `nextjs`, `supabase`, `convex`
- **Type Tags**: `bug`, `feature`, `refactor`
- **Status Tags**: `in-progress`, `completed`, `blocked`
- **Priority Tags**: `urgent`, `high`, `medium`, `low`

---

## Markdown Best Practices

### 1. Use Clear Headers

```markdown
# Main Title (H1) - Use only once at top

## Major Sections (H2)

### Subsections (H3)

#### Details (H4)
```

### 2. Code Blocks with Language

Always specify language for syntax highlighting:

````markdown
```typescript
const example: string = "Hello";
```

```python
def example():
    return "Hello"
```
````

### 3. Link Best Practices

```markdown
<!-- External links -->
[Convex Docs](https://docs.convex.dev)

<!-- Internal links (use relative paths) -->
[Related Post](/blog/related-post-slug)

<!-- Reference-style links (for cleaner markdown) -->
[Link Text][1]

[1]: https://example.com
```

### 4. Image Optimization

```markdown
<!-- Use descriptive alt text -->
![Database schema diagram showing relationships](./images/schema.png)

<!-- Include width when possible -->
<img src="./image.png" alt="Description" width="600" />
```

### 5. Tables

```markdown
| Feature | Status | Priority |
|---------|--------|----------|
| Auth    | ✅     | High     |
| Chat    | 🔄     | High     |
| Search  | ⏳     | Medium   |
```

---

## Integration with Chat

### Per-Post Chat Threads

Every blog post automatically gets a dedicated chat thread:
- Discuss post content
- Ask questions
- Share updates
- Link related threads

**Access**: Chat panel appears on post detail pages

### Chat-to-Blog Export

Convert valuable chat discussions into blog posts:

1. **Select Thread**: Choose chat thread to export
2. **Filter Messages** (optional): Select specific messages or tags
3. **Generate Post**: Creates draft blog post
4. **Edit & Publish**: Refine exported content

**Use Cases**:
- Document decisions made in chat
- Create FAQs from discussions
- Capture troubleshooting solutions
- Preserve brainstorming sessions

### Cross-Referencing

Link between blog posts and chat threads:
- Mention posts in chat: `@post/post-slug`
- Link to threads from posts: Use "Discuss in Chat" button

---

## Keyboard Shortcuts

**Editor**:
- `Cmd/Ctrl + B`: Bold
- `Cmd/Ctrl + I`: Italic
- `Cmd/Ctrl + K`: Insert link
- `Cmd/Ctrl + Shift + C`: Code block
- `Cmd/Ctrl + S`: Save draft
- `Cmd/Ctrl + Enter`: Publish

**Navigation**:
- `/` : Focus search
- `N` : New post
- `E` : Edit current post
- `Esc` : Close modals

---

## Common Use Cases

### 1. Architecture Decision Record (ADR)

```markdown
---
title: ADR-001: Choice of ConvexDB for Real-time Chat
tags: [decision, architecture, chat]
category: decision
---

# Context

We needed a real-time database for the chat feature...

# Decision

We will use ConvexDB because...

# Consequences

Positive:
- Excellent real-time performance
- Great developer experience

Negative:
- Additional service to manage
```

### 2. Feature Documentation

```markdown
---
title: User Authentication Flow
tags: [auth, feature, web-app]
category: technical
---

# Overview

This document describes the authentication flow...

## Implementation

[Code examples and diagrams]

## Usage

[How to use the feature]
```

### 3. Weekly Updates

```markdown
---
title: Week 45 Progress Update
tags: [status, changelog]
category: changelog
---

# Completed This Week

- ✅ Authentication system
- ✅ Blog CRUD operations

# In Progress

- 🔄 Chat frontend components

# Next Week

- ⏳ File attachments
- ⏳ Search implementation
```

---

## Troubleshooting

### Post Not Saving

**Issue**: Changes not persisting
**Solution**:
1. Check browser console for errors
2. Verify network connectivity
3. Ensure session is active (re-login if needed)
4. Check database connection

### Markdown Not Rendering

**Issue**: Markdown shows as plain text
**Solution**:
1. Verify frontmatter is properly formatted (YAML syntax)
2. Check for unclosed code blocks
3. Ensure markdown preview is enabled
4. Clear browser cache

### Slug Already Exists

**Issue**: Cannot create post with duplicate slug
**Solution**:
1. Change the title slightly
2. Manually edit slug in frontmatter
3. Check for archived posts with same slug

### Search Not Working

**Issue**: Search returns no results
**Solution**:
1. Check search index is up to date
2. Verify post status is "published"
3. Try simpler search query
4. Check organization context

---

## Tips & Tricks

### 1. Draft Workflow

- Save early, save often as draft
- Use preview frequently
- Share draft links for feedback (optional feature)
- Publish only when ready

### 2. Content Organization

- Use consistent tag naming
- Create a tagging convention document
- Review tags periodically and consolidate
- Archive old/outdated posts

### 3. Performance

- Keep posts under 10,000 words for best performance
- Optimize images before uploading
- Use external links for large files
- Consider splitting very long posts

### 4. Collaboration

- Use post chat for feedback
- Tag relevant team members
- Create "living documents" that are updated
- Link related posts

---

## API Reference

For developers integrating with the blog:

### Endpoints

```
GET    /api/posts              # List posts
GET    /api/posts/:id          # Get post
POST   /api/posts              # Create post
PUT    /api/posts/:id          # Update post
DELETE /api/posts/:id          # Delete post
GET    /api/posts/search       # Search posts
```

### TypeScript Usage

```typescript
import { api } from '@/lib/api/client';
import type { Post, CreatePostDTO } from '@dfworx/types';

// Create post
const newPost = await api.post<Post>('/api/posts', {
  title: 'My Post',
  content: '# Hello\n\nContent here...',
  status: 'draft'
} as CreatePostDTO);

// Get posts
const posts = await api.get<Post[]>('/api/posts', {
  params: { status: 'published', limit: 10 }
});
```

---

## Future Features

**Planned Enhancements**:
- [ ] Rich text editor (WYSIWYG) option
- [ ] Image upload and management
- [ ] Post versioning and history
- [ ] Collaborative editing
- [ ] Email notifications
- [ ] RSS feed
- [ ] PDF export
- [ ] Analytics and insights

---

## Support

For issues or feature requests:
- **GitHub Issues**: [DFWorX Repository](https://github.com/yourusername/DFWorX)
- **Chat**: Use the global workspace chat
- **Documentation**: See [docs/](../docs/) directory

---

## Appendix: Markdown Cheat Sheet

```markdown
# Headers
# H1
## H2
### H3

# Emphasis
*italic* or _italic_
**bold** or __bold__
***bold italic***

# Lists
- Unordered
- Items

1. Ordered
2. Items

# Links & Images
[Link](https://example.com)
![Image](https://example.com/img.jpg)

# Code
Inline `code`

```language
code block
```

# Quotes
> Blockquote

# Tables
| A | B |
|---|---|
| 1 | 2 |

# Horizontal Rule
---

# Task Lists
- [x] Done
- [ ] Todo
```

---

**Happy Blogging! 📝**
