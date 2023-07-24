from alembic.command import upgrade
from alembic.config import Config
from aws_lambda_powertools.logging import correlation_paths

from src.common import logger

logger = logger.get_logger()


@logger.inject_lambda_context(
    correlation_id_path=correlation_paths.LAMBDA_FUNCTION_URL
)
def handler(event, context):
    logger.info("Running alembic upgrade command of Products database")

    config = Config(file_="alembic.ini")
    config.set_main_option(
        "script_location",
        "migration",
    )

    upgrade(config, "head")

    logger.info("Ended alembic upgrade command of Products database")
