from typing import Type

from src import db
from src.db import model


def create(model: model.BaseEntity) -> model.BaseEntity:
    with db.session() as s:
        s.add(model)
        s.commit()
        return model


def get(
    field,
    value,
    cls: Type[model.BaseEntity],
) -> model.BaseEntity | None:
    with db.session() as s:
        return s.query(cls).filter_by(**{field: value}).first()


def update(
    model: model.BaseEntity,
    new_model: model.BaseEntity,
) -> model.BaseEntity:
    with db.session() as s:
        merged_model = s.merge(model)
        for attr, value in new_model.__dict__.items():
            if (
                attr != "id"
                and hasattr(merged_model, attr)
                and getattr(merged_model, attr) != value
            ):
                setattr(merged_model, attr, value)
        s.commit()
        return merged_model
