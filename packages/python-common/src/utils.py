"""Shared utility functions."""

from datetime import datetime, timezone
from typing import Any
from uuid import UUID


def utc_now() -> datetime:
    """
    Get current UTC datetime.

    Returns:
        Current UTC datetime
    """
    return datetime.now(timezone.utc)


def serialize_datetime(dt: datetime) -> str:
    """
    Serialize datetime to ISO format string.

    Args:
        dt: Datetime to serialize

    Returns:
        ISO format string
    """
    return dt.isoformat()


def serialize_uuid(uuid: UUID) -> str:
    """
    Serialize UUID to string.

    Args:
        uuid: UUID to serialize

    Returns:
        String representation
    """
    return str(uuid)


def to_camel_case(snake_str: str) -> str:
    """
    Convert snake_case to camelCase.

    Args:
        snake_str: Snake case string

    Returns:
        Camel case string
    """
    components = snake_str.split("_")
    return components[0] + "".join(x.title() for x in components[1:])


def to_snake_case(camel_str: str) -> str:
    """
    Convert camelCase to snake_case.

    Args:
        camel_str: Camel case string

    Returns:
        Snake case string
    """
    import re

    return re.sub(r"(?<!^)(?=[A-Z])", "_", camel_str).lower()
