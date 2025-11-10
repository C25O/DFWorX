# YAML-NODE MANAGER

> A visual node-based editor for declaratively defining and managing custom object types, properties, features, and relationships through an intuitive canvas interface backed by YAML configuration files.

## 🎯 Overview

YAML-NODE MANAGER bridges the gap between visual design tools and code-first configuration management. It empowers users of all technical levels to:

- **Visual Users**: Create and manage complex data structures through an intuitive drag-and-drop node canvas
- **Technical Users**: Define, import, export, and version control object schemas using clean, declarative YAML files
- **Teams**: Collaborate seamlessly with a unified format that serves both visual and code-based workflows

## 🌟 Core Concept

The application operates on a simple yet powerful principle:

1. **Visual Canvas**: An elegant, secure web interface provides an extremely user-friendly node-editor canvas
2. **Object Modeling**: Users construct various types of objects, object properties, and linked relationships
3. **Interactive Editing**: Add new custom node types, edit properties, and connect nodes by dragging edges
4. **YAML Backend**: Everything is stored in unified YAML templates for version control, import/export, and programmatic access
5. **Bi-directional Sync**: Changes in the visual editor update YAML; changes in YAML update the visual representation

## ✨ Key Features

### Visual Interface
- **Node-based canvas** with smooth drag-and-drop interactions
- **Real-time rendering** of object relationships and hierarchies
- **Custom node types** for different object categories
- **Connection management** with visual relationship indicators
- **Zoom and pan controls** for managing complex diagrams
- **Undo/redo** functionality for safe experimentation

### Data Management
- **Object type definition** with custom properties and features
- **Relationship mapping** between connected objects
- **Property validation** with type checking and constraints
- **Default values** and required field enforcement
- **Unique constraints** for key properties
- **Enum and option sets** for controlled vocabularies

### YAML Integration
- **Import/Export** entire schemas or individual object types
- **Template system** for rapid object creation
- **Version control friendly** YAML format
- **Validation** against schema rules
- **Comments and documentation** preserved in YAML files
- **Hot reload** for development workflows

### Enterprise Features
- **Multi-user collaboration** with conflict resolution
- **Access control** for sensitive object types
- **Audit logging** of schema changes
- **Database persistence** (PostgreSQL)
- **API access** for programmatic integration
- **ERD generation** with Liam-ERD

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Web Interface                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │         Next.js 14 + TypeScript                   │  │
│  │  ┌────────────┐  ┌──────────────┐  ┌──────────┐ │  │
│  │  │  Shadcn/UI │  │  React Flow  │  │ Liam-ERD │ │  │
│  │  └────────────┘  └──────────────┘  └──────────┘ │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ▲ │
                          │ ▼
┌─────────────────────────────────────────────────────────┐
│                   Application Layer                      │
│  ┌──────────────────────────────────────────────────┐  │
│  │        YAML Parser/Generator                      │  │
│  │     Schema Validator & Type System                │  │
│  │     Object Manager & Relationship Engine          │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ▲ │
                          │ ▼
┌─────────────────────────────────────────────────────────┐
│                  Persistence Layer                       │
│  ┌──────────────────────────────────────────────────┐  │
│  │           PostgreSQL Database                     │  │
│  │        YAML File Storage System                   │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Node.js 16.8 or later
- npm or yarn package manager
- PostgreSQL 14+ (for persistence)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/yaml-node-manager.git
cd yaml-node-manager
```

2. Install dependencies:
```bash
npm install
```

3. Install core packages:
```bash
npm install reactflow @xyflow/react
npm install -D tailwindcss postcss autoprefixer
npm install js-yaml
npm install @types/js-yaml -D
```

4. Set up environment variables:
```bash
cp .env.example .env.local
# Edit .env.local with your database credentials
```

5. Initialize the database:
```bash
npm run db:migrate
```

### Running the Application

1. Start the development server:
```bash
npm run dev
```

2. Open your browser and navigate to:
```
http://localhost:3000
```

3. Start creating your first object type!

## 📖 Usage Examples

### Visual Mode: Creating a User Object

1. Click **"Add Object Type"** button
2. Name it "User"
3. Add properties:
   - Click **"Add Property"** → Name: "email", Type: "string", Required: ✓, Unique: ✓
   - Click **"Add Property"** → Name: "age", Type: "number"
   - Click **"Add Property"** → Name: "role", Type: "enum", Options: ['admin', 'user', 'guest']
4. Save the object type

### Code Mode: Same User Object in YAML

```yaml
user:
  description: "System user account"
  fields:
    email:
      type: string
      description: "User's email address"
      required: Yes
      unique: Yes
    age:
      type: number
      description: "User's age in years"
      required: No
    role:
      type: enum
      description: "User's system role"
      options: ['admin','user','guest']
      default: 'user'
      required: Yes
```

### Creating Relationships

1. Create a second object type: "Post"
2. Add a property: "author" with type "User" (relationship)
3. Drag from the User node to the Post node
4. Select relationship type: "one-to-many"

The YAML automatically generates:

```yaml
post:
  description: "User-generated content"
  fields:
    title:
      type: string
      required: Yes
    content:
      type: string
      required: Yes
    author:
      type: User
      relationship: many-to-one
      required: Yes
```

## 📚 Documentation

- **[User Guide](./docs/USER-GUIDE.md)** - Complete walkthrough for end users
- **[YAML Schema Reference](./docs/YAML-SCHEMA.md)** - Detailed YAML format specification
- **[Technical Specification](./docs/TECHNICAL-SPEC.md)** - Architecture and development guide
- **[API Documentation](./docs/API.md)** - REST API and integration guide
- **[Data Types Reference](./docs/DATA-TYPES.md)** - Comprehensive type system documentation

## 🛠️ Technology Stack

| Category | Technology |
|----------|-----------|
| Frontend Framework | Next.js 14 |
| Language | TypeScript |
| Node Editor | React Flow (@xyflow/react) |
| UI Components | Shadcn/UI + Radix UI |
| Styling | Tailwind CSS |
| ERD Visualization | Liam-ERD |
| Database | PostgreSQL |
| YAML Parser | js-yaml |
| State Management | Zustand |
| Form Validation | Zod |

## 🗺️ Roadmap

### Phase 1: Core Functionality ✅
- [x] Visual node editor with React Flow
- [x] YAML import/export
- [x] Basic object types and properties
- [x] Relationship modeling

### Phase 2: Enhanced Features (Current)
- [ ] Advanced validation rules
- [ ] Custom field types
- [ ] Template library
- [ ] Collaboration features

### Phase 3: Enterprise Ready
- [ ] Role-based access control
- [ ] Version history and rollback
- [ ] API generation from schemas
- [ ] Database migration generation
- [ ] Team workspaces

### Phase 4: Advanced Capabilities
- [ ] AI-assisted schema design
- [ ] Visual query builder
- [ ] Real-time collaboration
- [ ] Schema marketplace
- [ ] Plugin system

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests: `npm test`
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- React Flow team for the excellent node editor library
- Shadcn for the beautiful UI components
- The YAML community for the specification

## 📞 Support

- **Documentation**: [https://docs.yaml-node-manager.io](https://docs.yaml-node-manager.io)
- **Issues**: [GitHub Issues](https://github.com/yourusername/yaml-node-manager/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/yaml-node-manager/discussions)
- **Email**: support@yaml-node-manager.io

---

**Built with ❤️ by Takwene** | Blending technology and innovation
