"""GitHub functionality"""

import json
import logging
import os

try:
    from urllib2 import urlopen
    from urllib2 import HTTPError
except ImportError:
    from urllib.request import urlopen
    from urllib.error import HTTPError


def github_request_url(api):
    """Get authenticated URL for a GitHub API path"""
    url = "https://api.github.com{api}".format(api=api)
    try:
        access_token = os.environ["GITHUB_OAUTH_TOKEN"]
        if access_token:
            url += "?access_token={access_token}".format(access_token=access_token)
    except KeyError:
        pass
    return url


def get_latest_version(repository):
    """Get latest release for a GitHub repository"""
    try:
        # Get tag name from the latest release
        api = "/repos/{repository}/releases/latest".format(repository=repository)
        url = github_request_url(api)
        response_body = urlopen(url).read()
        release = json.loads(response_body)
        logging.debug(
            "Latest release for %s found: %s", repository, release["tag_name"]
        )
        return release["tag_name"]
    except HTTPError as http_error:
        if http_error.code == 404:
            logging.debug("Latest release for %s not found", repository)
            # No releases, get latest tag name
            api = "/repos/{repository}/tags".format(repository=repository)
            url = github_request_url(api)
            response_body = urlopen(url).read()
            tags = json.loads(response_body)
            if len(tags) > 0:
                return tags[0]["name"]
            logging.warning("No tags found for %s", repository)
            return None

        if http_error.code == 403:
            logging.warning("HTTP 403 when reading tags for %s", repository)
            raise http_error

        raise http_error
