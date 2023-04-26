wildrepo -- Wildcard-based GitHub repository finder

This is a small tool that was written to assist with mass backups of Git
repositories. It is open source, but only guaranteed to work on my machine.

You will need to generate an API access token for use with Wildrepo. If using
classic tokens (recommended), creating a token with the `repo:*` and `read:org`
scopes has been known to work.

WARNING: At the time of writing (2023-04-26), in order to be able to search for
private repositories you are a collaborator on, you must be using a "classic"
OAuth API token rather than the "fine-grained" beta tokens. Using fine-grained
tokens will prevent Wildrepo from being able to see some repositories.

Copyright (c) 2023 Jon Palmisciano; licensed under the BSD 3-Clause license.
