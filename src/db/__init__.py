import os

import sqlalchemy as db
from sqlalchemy.orm import sessionmaker

from src.db.model.base import BaseEntity

from .base import create, get, update

db_debug_enabled = True
db_connection = "postgresql+psycopg2://" + os.getenv(
    "DATABASE_URL",
    "postgres:postgres@localhost:5432/products",
)

engine = db.create_engine(
    db_connection,
    isolation_level="READ COMMITTED",
    echo=bool(db_debug_enabled),
)

session = sessionmaker(bind=engine, expire_on_commit=False)

__all__ = ("BaseEntity", "create", "get", "update")
