from wildrepo.utils import eprint

from github import Github
from github.Repository import Repository

from fnmatch import fnmatch
from typing import List, Optional


class Pattern:
    """
    Pattern describing one or more repos belonging to an organization.
    """

    entity: str
    query: str

    def __init__(self, raw: str) -> None:
        parts = raw.split("/")
        self.entity = parts[0]
        self.query = parts[1]

    def __repr__(self) -> str:
        return f"<Pattern '{str(self)}'>"

    def __str__(self) -> str:
        return f"{self.entity}/{self.query}"


class Client:
    """
    Simplified GitHub API client.
    """

    # Cached repositories for the authenticated user.
    au_repo_cache: List[Repository] = []

    def __init__(self, token) -> None:
        self.github = Github(token)

        self.au_repo_cache = []

    def get_auth_user_repos(self) -> List[Repository]:
        """
        Get the authenticated user's repos; caches repos for speed.
        """

        if len(self.au_repo_cache) == 0:
            au = self.github.get_user()
            self.au_repo_cache = list(au.get_repos())

        return self.au_repo_cache

    def get_entity_repos(self, name: str) -> Optional[List[Repository]]:
        """
        Get all of the repositories belonging to a user or organization.
        """

        try:
            entity = self.github.get_user(name)
            return list(entity.get_repos("all"))
        except:
            return None

    def expand_pattern(self, pattern: Pattern) -> List[Repository]:
        """
        Get all of the repositories matched by this pattern.
        """

        if (repos := self.get_entity_repos(pattern.entity)) is None:
            eprint(
                f"Failed to get repos for entity while expanding pattern `{str(pattern)}`.",
            )
            return []

        # Add the authenticated user's repos, which may include private repos
        # belonging to the target entity not returned by `get_entity_repos`,
        # then remove any duplicates.
        repos += self.get_auth_user_repos()
        repos = set(repos)

        return [
            r
            for r in repos
            if (fnmatch(r.name, pattern.query) and r.owner.login == pattern.entity)
        ]
