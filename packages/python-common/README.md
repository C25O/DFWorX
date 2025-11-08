# dfworx-common

Shared Python utilities and helpers for DFWorX services.

## Overview

This package contains common functionality used across multiple Python services:
- Database utilities
- Helper functions
- Shared constants
- Common models

## Installation

This package is designed to be installed locally in other services:

```bash
# In a service directory
uv add ../packages/python-common
```

## Usage

```python
from dfworx_common.database import get_db_client
from dfworx_common.utils import utc_now, to_camel_case

# Get database client
db = get_db_client(url, key)

# Use utility functions
timestamp = utc_now()
camel = to_camel_case("snake_case_string")
```

## Development

Run tests:
```bash
uv run pytest
```

Type check:
```bash
uv run mypy src/
```

Lint:
```bash
uv run ruff check .
```
