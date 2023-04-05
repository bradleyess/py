import functools
import sys

from loguru import logger

# Remove default logger, we only want to use our custom logger.
logger.remove(0)
logger.add(sys.stdout, serialize=True, level="INFO")
logger.add(sys.stderr, serialize=True, level="ERROR")


def logger_wraps(*, entry=True, exit=True, level="DEBUG"):
    """
    Decorator to log entry and exit incl. values of a function.
    """

    def wrapper(func):
        name = func.__name__

        @functools.wraps(func)
        def wrapped(*args, **kwargs):
            logger_ = logger.opt(depth=1)
            if entry:
                logger_.log(
                    level, "Entering '{}' (args={}, kwargs={})", name, args, kwargs
                )
            result = func(*args, **kwargs)
            if exit:
                logger_.log(level, "Exiting '{}' (result={})", name, result)
            return result

        return wrapped

    return wrapper
