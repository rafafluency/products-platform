import logging
import os

import logstash
from aws_lambda_powertools import Logger

_SERVICE_NAME = "products-platform"
_app_name = os.getenv("APP_NAME", "local")
_log_level = os.getenv("LOG_LEVEL", "INFO")
_logstash_host = os.getenv("LOGSTASH", None)


def _create_handler() -> logging.Handler:
    stream_handler = logging.StreamHandler()

    try:
        if not _logstash_host:
            return stream_handler

        port = 16156
        host = _logstash_host

        if ":" in _logstash_host:
            host_split = _logstash_host.split(":")
            host = host_split[0]
            port = int(host_split[1])

        return logstash.TCPLogstashHandler(host=host, port=port)
    except Exception:
        return stream_handler


def get_logger() -> Logger:
    return Logger(
        service=_SERVICE_NAME,
        name=_app_name,
        level=_log_level,
        logger_handler=_create_handler(),
    )
