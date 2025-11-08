# @dfworx/ui

Shared UI component library for DFWorX applications.

## Overview

This package contains reusable React components built with:
- Shadcn UI components
- Tailwind CSS for styling
- TypeScript for type safety

## Usage

Import components in your Next.js app:

```tsx
import { Button, Card } from '@dfworx/ui'

export default function Page() {
  return (
    <Card>
      <Button>Click me</Button>
    </Card>
  )
}
```

## Adding Shadcn Components

To add Shadcn UI components to this package:

```bash
cd packages/ui
npx shadcn-ui@latest add button
npx shadcn-ui@latest add card
# ... other components
```

Then export them in `src/index.ts`.

## Development

This is an internal package that gets consumed by apps in the monorepo. Changes are automatically picked up by dependent apps.
