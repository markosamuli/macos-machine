"""Configure"""

import logging
import os

if 'DEBUG' in os.environ:
    logging.basicConfig(level=logging.DEBUG)
