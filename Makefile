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

# Docker compose
compose-down:
	docker-compose down

compose-stop:
	docker-compose stop $(SERVICE)

## local database container
compose-database:
	docker-compose up -d postgres