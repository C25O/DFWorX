# Chat System User Guide

**Application**: DFWorX Real-time Chat
**Version**: 1.0.0 (In Development)
**Last Updated**: November 8, 2025

---

## Overview

The DFWorX Chat System is a real-time communication platform built on ConvexDB, designed for documenting decisions, discussing features, and organizing knowledge across all monorepo applications.

### Key Features

- **Dual Chat Modes**: Global workspace chat + per-post threads
- **Message Threading**: Reply to specific messages
- **Tag System**: 5 categories for organization (app, topic, decision, status, priority)
- **File Attachments**: Upload and share files
- **Emoji Reactions**: Quick responses to messages
- **Real-time Updates**: Instant message delivery
- **Search & Filter**: Find messages by tags, content, or date
- **Export to Blog**: Convert discussions into blog posts

---

## Getting Started

### Accessing Chat

**Global Chat**:
- Click chat icon in header/sidebar
- Keyboard shortcut: `Cmd/Ctrl + K`
- Available on all pages

**Per-Post Chat**:
- Navigate to any blog post
- Chat panel appears on right side (desktop) or bottom (mobile)
- Automatically creates thread for new posts

### First Steps

1. **Join Organization**: Ensure you're part of an organization
2. **Set Up Profile**: Add name and avatar
3. **Explore Threads**: Browse existing conversations
4. **Send First Message**: Introduce yourself in global chat

---

## Chat Modes

### 1. Global Workspace Chat

**Purpose**: Organization-wide discussions

**Use Cases**:
- General announcements
- Cross-app discussions
- Team coordination
- Quick questions
- Brainstorming sessions

**Access**: Always available via sidebar/header

**Features**:
- Single continuous thread
- Visible to all organization members
- Supports all chat features (tags, attachments, threading)
- Searchable across all messages

### 2. Per-Post Chat Threads

**Purpose**: Focused discussions about specific blog posts

**Use Cases**:
- Discuss post content
- Ask clarifying questions
- Suggest improvements
- Share related resources
- Document follow-up decisions

**Access**: Auto-created when viewing blog post

**Features**:
- Thread-specific tags
- Context-aware (knows which post)
- Can be exported back to blog
- Linked to post metadata

---

## Sending Messages

### Basic Message

```
Type your message...
```

Click **Send** or press `Enter` (or `Cmd/Ctrl + Enter` depending on settings)

### Message Formatting

**Supported Markdown**:
- **Bold**: `**text**`
- *Italic*: `*text*`
- `Code`: `` `text` ``
- Code block: ````text````
- Links: `[text](url)`
- Lists: `- item` or `1. item`

**Example**:
```
Here's a **bold** statement with `code` and a [link](https://example.com)
```

### Mentioning Users

Mention team members to notify them:
```
@john Can you review this?
```

Users receive notification when mentioned.

### Message Threading

**Reply to Message**:
1. Hover over message
2. Click "Reply" icon
3. Type response
4. Send

**View Thread**:
- Click on message with replies
- Expands to show full conversation tree
- Collapse to return to main view

---

## Tag System

### Tag Categories

1. **App Tags** 🏷️
   - Purpose: Identify which application is discussed
   - Examples: `web-app`, `admin-app`, `mobile-app`
   - Color: Blue

2. **Topic Tags** 📚
   - Purpose: Categorize discussion subject
   - Examples: `architecture`, `bug`, `feature`, `refactor`
   - Color: Green

3. **Decision Tags** 🎯
   - Purpose: Mark decision-making discussions
   - Examples: `tech-choice`, `design-pattern`, `workflow`
   - Color: Purple

4. **Status Tags** 📊
   - Purpose: Track progress and state
   - Examples: `in-progress`, `resolved`, `blocked`, `completed`
   - Color: Orange

5. **Priority Tags** ⚡
   - Purpose: Indicate urgency
   - Examples: `urgent`, `high`, `medium`, `low`
   - Color: Red

### Adding Tags to Messages

**While Composing**:
1. Type message
2. Click tag icon
3. Select tags from dropdown
4. Send message with tags

**After Sending**:
1. Hover over message
2. Click "..." menu
3. Select "Add Tags"
4. Choose tags

### Creating New Tags

**Requirements**: Moderator or Admin role

**Steps**:
1. Go to Settings > Tags
2. Click "Create Tag"
3. Enter:
   - Name (e.g., "Backend")
   - Category (app, topic, decision, status, priority)
   - Color (hex code)
   - Description (optional)
4. Save

**Best Practices**:
- Use clear, descriptive names
- Follow consistent naming convention
- Avoid tag proliferation (review and consolidate)
- Document tag meanings in blog post

### Filtering by Tags

**Single Tag**:
- Click on tag badge in message
- Shows all messages with that tag

**Multiple Tags**:
1. Click filter icon
2. Select multiple tags
3. Choose filter mode:
   - **AND**: Messages must have ALL selected tags
   - **OR**: Messages can have ANY selected tag

**Clear Filters**: Click "Clear all filters" or close filter panel

---

## File Attachments

### Uploading Files

**Drag & Drop**:
1. Drag file into chat input
2. Preview appears
3. Add message (optional)
4. Send

**Click to Upload**:
1. Click attachment icon
2. Select file from dialog
3. Preview appears
4. Send

### Supported File Types

**Documents**:
- PDF (`.pdf`)
- Text (`.txt`, `.md`)
- Office (`.doc`, `.docx`, `.xls`, `.xlsx`, `.ppt`, `.pptx`)

**Images**:
- JPEG (`.jpg`, `.jpeg`)
- PNG (`.png`)
- GIF (`.gif`)
- WebP (`.webp`)
- SVG (`.svg`)

**Code**:
- Any text file
- Archives (`.zip`, `.tar.gz`)

**Size Limits**:
- Max file size: 10 MB
- Max attachments per message: 5

### Viewing Attachments

**Images**: Display inline with thumbnail
**Documents**: Click to download
**Code Files**: Click to view with syntax highlighting

### Deleting Attachments

1. Hover over attachment
2. Click "..." menu
3. Select "Delete attachment"
4. Confirm

---

## Emoji Reactions

### Adding Reactions

**Quick Reactions**:
1. Hover over message
2. Click emoji icon
3. Select from common reactions

**Custom Emoji**:
1. Hover over message
2. Click "..."
3. Select "Add reaction"
4. Choose any emoji

### Common Reactions

- 👍 Agree / Like
- ❤️ Love / Appreciate
- 😂 Funny
- 🎉 Celebrate
- 🤔 Thinking
- ✅ Done / Resolved
- ❌ Disagree

### Viewing Reactions

Click on reaction count to see who reacted.

---

## Search & Discovery

### Quick Search

**Search Bar**: Located at top of chat panel

**Syntax**:
```
# Text search
authentication

# Tag filter
tag:app tag:decision

# User filter
from:john

# Date filter
after:2025-01-01

# Combine filters
authentication tag:app from:john
```

### Advanced Search

**Access**: Click "Advanced Search" or press `Cmd/Ctrl + Shift + F`

**Filters**:
- Content search (full-text)
- Tag filters (multi-select)
- User filters (author)
- Date range (from/to)
- Thread filter (global or specific post)
- Has attachments
- Has reactions

### Search Results

**Display**:
- Highlighted matches
- Context snippet
- Jump to message button
- Filter by thread

**Actions**:
- Click result to view in context
- Reply to result
- Add to saved searches

---

## Chat Export

### Export Thread to Blog Post

**Purpose**: Document valuable discussions

**Steps**:
1. Click "..." menu on thread
2. Select "Export to Blog"
3. Configure export:
   - Title (auto-filled from thread)
   - Include all messages or filter by tags
   - Include attachments as links
   - Format (markdown)
4. Click "Generate Draft"
5. Review and edit generated post
6. Publish

**Export Options**:

**Include**:
- ✅ All messages
- ✅ Selected messages
- ✅ Messages with specific tags
- ✅ Date range

**Format**:
- Markdown (default)
- HTML
- JSON (for custom processing)

### Use Cases for Export

1. **Decision Records**:
   - Export decision discussions to ADR posts
   - Tag: `decision`

2. **Feature Documentation**:
   - Convert feature planning to docs
   - Tag: `feature`, `app`

3. **Troubleshooting Guides**:
   - Export problem-solving threads
   - Tag: `bug`, `resolved`

4. **Weekly Updates**:
   - Compile week's discussions
   - Filter by date range

---

## Notifications

### Notification Types

1. **Mentions**: Someone @mentioned you
2. **Replies**: Someone replied to your message
3. **Thread Updates**: New messages in subscribed threads
4. **Reactions**: Someone reacted to your message

### Notification Settings

**Configure**:
- Settings > Notifications

**Options**:
- Browser notifications (on/off)
- Email digests (off, daily, weekly)
- Desktop notifications (requires permission)
- Sound alerts (on/off)

### Managing Notifications

**Mark as Read**:
- Click notification
- Click "Mark all as read"

**Mute Thread**:
- Right-click thread
- Select "Mute notifications"

---

## Thread Management

### Creating Threads

**Auto-Creation**:
- New blog posts automatically get threads
- Global chat is always available

**Manual Creation** (future feature):
- Create custom threads for topics
- Organize by project or feature

### Thread Settings

**Thread Title**:
- Edit to make descriptive
- Visible in thread list

**Thread Tags**:
- Apply tags to entire thread
- Inherited by all messages

**Archive Thread**:
- Removes from main list
- Still searchable
- Can be restored

---

## Best Practices

### 1. Message Quality

**Do**:
- Be clear and concise
- Use formatting for readability
- Add context for links
- Tag appropriately

**Don't**:
- Send one-word messages repeatedly
- Over-mention people
- Post large code blocks (use attachments)
- Spam reactions

### 2. Tagging Strategy

**Guidelines**:
- Always tag with at least app + type
- Use priority tags sparingly (only for urgent)
- Update status tags as work progresses
- Be consistent with tag names

**Example**:
```
Message about auth bug in web app:
Tags: web-app, bug, high, in-progress
```

### 3. Threading

**When to Thread**:
- Extended back-and-forth discussions
- Multiple sub-topics
- Keeping main chat clean

**When NOT to Thread**:
- Single reply
- General agreement (use reaction)
- Off-topic (start new message)

### 4. File Organization

**Naming**:
- Use descriptive filenames
- Include version numbers
- Add context in message

**Example**:
```
Attaching: auth-flow-diagram-v2.png
Updated based on yesterday's discussion
```

---

## Keyboard Shortcuts

**General**:
- `Cmd/Ctrl + K`: Open/focus chat
- `Esc`: Close chat
- `/`: Focus search
- `N`: New message

**Message Actions**:
- `R`: Reply to selected message
- `E`: Edit your message
- `Delete`: Delete your message
- `Cmd/Ctrl + Enter`: Send message

**Navigation**:
- `↑/↓`: Navigate messages
- `Enter`: Open selected message
- `Tab`: Next thread
- `Shift + Tab`: Previous thread

---

## Common Workflows

### 1. Quick Question

```
1. Open global chat (Cmd/K)
2. Type question
3. Tag with relevant tags (e.g., app, topic)
4. Send
5. Monitor for responses
```

### 2. Feature Discussion

```
1. Navigate to feature blog post
2. Open per-post chat
3. Start discussion
4. Use threading for sub-topics
5. Tag decisions with "decision" tag
6. Export final decisions to blog
```

### 3. Bug Triage

```
1. Send bug description with:
   - Tags: [app], bug, [priority]
   - Reproduction steps
   - Screenshots/logs as attachments
2. Team discusses in thread
3. Update status tag as work progresses
4. Mark resolved when fixed
```

### 4. Documentation Sprint

```
1. Create documentation goal post
2. Use per-post chat for coordination
3. Team members claim sections (tagged)
4. Share progress in chat
5. Export chat summary to blog
```

---

## Troubleshooting

### Messages Not Sending

**Symptoms**: Message stuck in "sending" state

**Solutions**:
1. Check internet connection
2. Refresh page
3. Check ConvexDB status
4. Verify session is active

### Real-time Updates Not Working

**Symptoms**: Must refresh to see new messages

**Solutions**:
1. Check browser console for errors
2. Verify WebSocket connection
3. Check firewall settings
4. Try different browser

### File Upload Failing

**Symptoms**: File upload times out or fails

**Solutions**:
1. Check file size (max 10 MB)
2. Verify file type is supported
3. Check internet connection
4. Try smaller file or compress

### Tags Not Showing

**Symptoms**: Tags applied but not visible

**Solutions**:
1. Refresh page
2. Check tag permissions
3. Verify tag is active
4. Contact admin if persistent

---

## Tips & Tricks

### 1. Saved Messages

Bookmark important messages:
- Star message
- Access via "Starred" filter
- Organize key information

### 2. Quick Filters

Create saved filter combinations:
- Tag combos you use often
- Custom search queries
- Date ranges

### 3. Draft Messages

Save drafts for later:
- Start typing
- Switch threads
- Draft auto-saves
- Return to complete

### 4. Batch Operations

Select multiple messages:
- Shift + Click range
- Cmd/Ctrl + Click individual
- Bulk tag, export, or delete

---

## Advanced Features

### Custom Tag Workflows

**Example: Sprint Workflow**
1. Create tags: `sprint-45`, `in-review`, `qa-ready`
2. Tag messages with sprint number
3. Filter by sprint to review all work
4. Export sprint summary to blog

### Integration with External Tools

**Webhooks** (future):
- Send notifications to Slack/Discord
- Update project management tools
- Log decisions to external systems

**API Access**:
- Programmatic message creation
- Automated tagging
- Custom integrations

---

## Privacy & Security

### Message Visibility

**Organization-Level**:
- All messages visible to organization members
- No public access
- Row-level security enforced

**User Permissions**:
- **User**: Read, send, react
- **Moderator**: + Edit tags, manage threads
- **Admin**: + Delete any message, manage users

### Data Retention

**Default Policy**:
- Messages retained indefinitely
- Deleted messages soft-deleted (recoverable by admin)
- Attachments deleted after 90 days of message deletion

**Export Your Data**:
- Settings > Export Data
- Download all your messages
- JSON format

---

## Future Enhancements

**Planned Features**:
- [ ] Voice messages
- [ ] Video attachments
- [ ] Screen sharing
- [ ] Polls
- [ ] Rich link previews
- [ ] Threaded view improvements
- [ ] @channel mentions
- [ ] Scheduled messages
- [ ] Message templates
- [ ] Chat analytics

---

## API Reference

For developers building integrations:

### Send Message

```typescript
import { useMutation } from "convex/react";
import { api } from "@/convex/_generated/api";

const sendMessage = useMutation(api.messages.send);

await sendMessage({
  threadId: thread._id,
  content: "Hello, World!",
  tags: [tagId1, tagId2],
  mentions: [userId1],
});
```

### Query Messages

```typescript
import { useQuery } from "convex/react";
import { api } from "@/convex/_generated/api";

const messages = useQuery(api.messages.getMessages, {
  threadId: thread._id,
  limit: 50,
});
```

---

## Support

For chat-related issues:
- **In-App Support**: Global chat > Ask in #support
- **Documentation**: See [docs/](../docs/)
- **GitHub Issues**: [DFWorX Repository](https://github.com/yourusername/DFWorX)

---

**Happy Chatting! 💬**
