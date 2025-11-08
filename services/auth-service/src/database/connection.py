from functools import lru_cache

from supabase import Client, create_client

from src.config import get_settings

settings = get_settings()


@lru_cache
def get_supabase_client() -> Client:
    """
    Get cached Supabase client instance.

    Returns:
        Supabase client
    """
    return create_client(settings.supabase_url, settings.supabase_key)
