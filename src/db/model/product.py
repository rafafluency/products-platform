from sqlalchemy import JSON, Column, String

from src.db.model.base import BaseEntity


class Product(BaseEntity):
    __tablename__ = "products"

    code = Column(String, primary_key=True)
    name = Column(String)
    type = Column(String)
    parameters = Column(JSON)
    status = Column(String)
