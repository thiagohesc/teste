# app/utils/const.py
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field


class Settings(BaseSettings):
    AUTH: str = Field(..., description="Chave de autorização")
    DOMAIN: str = Field(..., description="Domínio raiz, ex: exemplo.com")
    BACKEND: str = Field(..., description="Subdomínio do backend, ex: api")
    FRONTEND: str = Field(..., description="Subdomínio do frontend, ex: app")

    # Pydantic v2
    model_config = SettingsConfigDict(
        env_file=".env",  # útil fora do Docker; no Docker use envs do compose
        case_sensitive=True,
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()
