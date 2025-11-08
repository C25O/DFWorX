from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr

router = APIRouter()


class UserRegister(BaseModel):
    """User registration model."""

    email: EmailStr
    password: str
    name: str


class UserLogin(BaseModel):
    """User login model."""

    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    """Token response model."""

    access_token: str
    token_type: str = "bearer"


@router.post("/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
async def register(user_data: UserRegister) -> TokenResponse:
    """
    Register a new user.

    Args:
        user_data: User registration data

    Returns:
        Access token for the new user

    Raises:
        HTTPException: If registration fails
    """
    # TODO: Implement user registration with Supabase
    return TokenResponse(access_token="mock_token")


@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin) -> TokenResponse:
    """
    Authenticate user and return access token.

    Args:
        credentials: User login credentials

    Returns:
        Access token for the authenticated user

    Raises:
        HTTPException: If authentication fails
    """
    # TODO: Implement user authentication with Supabase
    return TokenResponse(access_token="mock_token")


@router.post("/logout")
async def logout() -> dict[str, str]:
    """
    Logout user and invalidate token.

    Returns:
        Success message
    """
    # TODO: Implement token invalidation
    return {"message": "Successfully logged out"}
