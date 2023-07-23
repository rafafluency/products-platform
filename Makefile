# Application tests

install:
	poetry install

clean:
	rm -rf .pytest_cache

test: clean
	poetry run pytest
	$(MAKE) clean

lint:
	isort .
	black .
	flake8

# Alembic migration management
migrations:
	poetry run alembic upgrade head

models-revision:
	poetry run alembic revision --autogenerate -m "$(MESSAGE)"
