from sqlalchemy import JSON, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from src.db.model.base import BaseEntity


class BundleProduct(BaseEntity):
    __tablename__ = "bundle_products"

    bundle_id = Column(Integer, ForeignKey("bundles.id"), primary_key=True)
    product_code = Column(
        String, ForeignKey("products.code"), primary_key=True
    )
    parameters = Column(JSON)
    bundle = relationship("Bundle", back_populates="bundle_products")
    product = relationship("Product", back_populates="bundle_products")
