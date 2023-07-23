from datetime import datetime
from uuid import UUID

from sqlalchemy import DateTime, func
from sqlalchemy.orm import DeclarativeBase, Mapped, class_mapper, mapped_column


class BaseEntity(DeclarativeBase):
    """
    define a series of common elements that may be applied to mapped
    table classes using this class as a base class.
    """

    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )
    updated_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True),
        onupdate=func.now(),
        nullable=True,
    )

    def to_dict(self):
        columns = [
            column.key for column in class_mapper(self.__class__).columns
        ]
        data_dict = {column: getattr(self, column) for column in columns}
        for column, value in data_dict.items():
            if isinstance(value, UUID):
                data_dict[column] = str(value)
            elif isinstance(value, datetime):
                data_dict[column] = value.strftime("%Y-%m-%d %H:%M:%S")
        return data_dict


metadata = BaseEntity.metadata
