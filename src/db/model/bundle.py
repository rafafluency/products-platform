from sqlalchemy import Column, Integer, String

from db.model.base import BaseEntity


class Bundle(BaseEntity):
    __tablename__ = "bundles"

    id = Column(Integer, primary_key=True, autoincrement=True)
    description = Column(String)
    status = Column(String)
    hotmart_id = Column(Integer)
