import pytest

from src.auth.service import hash_password, verify_password, create_access_token, verify_token


def test_hash_password():
    """Test password hashing."""
    password = "test_password_123"
    hashed = hash_password(password)

    assert hashed != password
    assert len(hashed) > 0


def test_verify_password():
    """Test password verification."""
    password = "test_password_123"
    hashed = hash_password(password)

    assert verify_password(password, hashed)
    assert not verify_password("wrong_password", hashed)


def test_create_access_token():
    """Test JWT token creation."""
    data = {"sub": "user123", "email": "test@example.com"}
    token = create_access_token(data)

    assert isinstance(token, str)
    assert len(token) > 0


def test_verify_token():
    """Test JWT token verification."""
    data = {"sub": "user123", "email": "test@example.com"}
    token = create_access_token(data)

    payload = verify_token(token)

    assert payload is not None
    assert payload["sub"] == "user123"
    assert payload["email"] == "test@example.com"


def test_verify_invalid_token():
    """Test verification of invalid token."""
    invalid_token = "invalid.token.here"
    payload = verify_token(invalid_token)

    assert payload is None
