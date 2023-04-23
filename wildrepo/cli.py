#!/usr/bin/env python3

"""
wildrepo -- Wildcard-based GitHub repository finder

Usage:
    wildrepo [-t <token>] [<pattern> ...]

Options:
    -t, --token TOKEN      Personal access token to use
    -h, --help             Show help and usage information
"""

from docopt import docopt

import os
import sys

from wildrepo.github import Client, Pattern
from wildrepo.utils import eprint


def main():
    # Set help flag if no arguments are provided.
    if len(sys.argv) == 1:
        sys.argv.append("-h")
    args = docopt(__doc__)  # pyright: ignore

    token = args["--token"] or os.environ.get("WILDREPO_TOKEN")
    if token is None:
        eprint(
            "Error: Missing authentication token, set `WILDREPO_TOKEN` or pass `-t <token>`",
        )
        sys.exit(1)

    client = Client(token)

    # Expand all patterns and collect a list of repositories.
    repos = []
    patterns = [Pattern(rp) for rp in args["<pattern>"]]
    for p in patterns:
        repos += client.expand_pattern(p)

    for r in repos:
        print(r.ssh_url)
