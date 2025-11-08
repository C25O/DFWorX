"""Shared database utilities."""

from functools import lru_cache

from supabase import Client, create_client


@lru_cache
def get_db_client(url: str, key: str) -> Client:
    """
    Get cached database client instance.

    Args:
        url: Database URL
        key: Database key

    Returns:
        Database client
    """
    return create_client(url, key)
