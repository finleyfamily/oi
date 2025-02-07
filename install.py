#!/usr/bin/env python3
"""This script will install `oi`."""
# NOTE (kyle): pieces of installer have been borrowed from https://install.python-poetry.org/

from __future__ import annotations

import sys

# eager version check so we fail nicely before possible syntax errors
if sys.version_info < (3, 10):  # noqa: UP036
    sys.stdout.write("oi installer requires Python 3.10 or newer to run!\n")
    sys.exit(1)

import argparse
import json
import os
import re
import shutil
import sysconfig
import tempfile
from contextlib import closing
from functools import cached_property, cmp_to_key
from io import UnsupportedOperation
from pathlib import Path
from typing import Any, Literal, TypedDict
from urllib.request import Request, urlopen, urlretrieve

GITHUB_REPO = "finleyfamily/oi"
"""GitHub repository (``<owner>/<repo>``)."""

SHELL = os.getenv("SHELL", "")
WINDOWS = sys.platform.startswith("win") or (sys.platform == "cli" and os.name == "nt")
MINGW = sysconfig.get_platform().startswith("mingw")
MACOS = sys.platform == "darwin"

FOREGROUND_COLORS = {
    "black": 30,
    "red": 31,
    "green": 32,
    "yellow": 33,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "white": 37,
}
"""Terminal escape codes for foreground colors."""

BACKGROUND_COLORS = {
    "black": 40,
    "red": 41,
    "green": 42,
    "yellow": 43,
    "blue": 44,
    "magenta": 45,
    "cyan": 46,
    "white": 47,
}
"""Terminal escape codes for background colors."""

OPTIONS = {"bold": 1, "underscore": 4, "blink": 5, "reverse": 7, "conceal": 8}
"""Additional terminal escape code styles."""

PRE_MESSAGE = """# Welcome to {package}!

This will download and install the latest version of {package}.

It will add the `{package}` command to {package}'s bin directory, located at:

{home_bin}

You can uninstall at any time by executing this script with the --uninstall option,
and these changes will be reverted.
"""

POST_MESSAGE = """{package} ({version}) is installed now. Great!

You can test that everything is set up by executing:

`{test_command}`
"""

POST_MESSAGE_CONFIGURE_UNIX = """
Add `export PATH="{home_bin}:$PATH"` to your shell configuration file.
"""

POST_MESSAGE_NOT_IN_PATH = """{package} ({version}) is installed now. Great!

To get started you need {package}'s bin directory ({home_bin}) in your `PATH`
environment variable.
{configure_message}
Alternatively, you can call {package} explicitly with `{package_executable}`.

You can test that everything is set up by executing:

`{test_command}`
"""


def style(
    fg: str | None = None,
    bg: str | None = None,
    options: str | list[str] | tuple[str, ...] | None = None,
) -> str:
    """Create terminal escape code style."""
    codes: list[int | str] = []

    if fg:
        codes.append(FOREGROUND_COLORS[fg])

    if bg:
        codes.append(BACKGROUND_COLORS[bg])

    if options:
        if not isinstance(options, list | tuple):
            options = [options]

        codes.extend([OPTIONS[i] for i in options])

    return "\033[{}m".format(";".join(map(str, codes)))


STYLES = {
    "info": style("cyan", None, None),
    "comment": style("yellow", None, None),
    "success": style("green", None, None),
    "error": style("red", None, None),
    "warning": style("yellow", None, None),
    "b": style(None, None, ("bold",)),
}
"""Predetermined message styles."""


def is_decorated() -> bool:
    """Determine if terminal output should be decorated."""
    if WINDOWS:
        return (
            os.getenv("ANSICON") is not None
            or os.getenv("ConEmuANSI") == "ON"  # noqa: SIM112
            or os.getenv("Term") == "xterm"  # noqa: SIM112
        )

    if not hasattr(sys.stdout, "fileno"):
        return False

    try:
        return os.isatty(sys.stdout.fileno())
    except UnsupportedOperation:
        return False


def colorize(style: str, text: Path | str) -> str:
    """Conditionally colorize terminal output."""
    if not is_decorated():
        return str(text)
    return f"{STYLES[style]}{text}\033[0m"


def string_to_bool(value: bool | str) -> bool:
    """Convert string to bool."""
    if isinstance(value, bool):
        return value
    return value.lower() in {"true", "1", "y", "yes"}


class ArchiveExtractor:
    """Abstract base class for archive extractors."""

    archive: Path
    """Resolved path to the archive file."""

    def __init__(self, archive: Path | str) -> None:
        """Instantiate class.

        Args:
            archive: Path to the archive file.

        """
        self.archive = Path(archive).resolve()

        if not self.archive.is_file():
            raise FileNotFoundError(self.archive)

    def extract(self, destination: Path | None = None) -> Path:
        """Extract the archive file.

        Args:
            destination: Where the archive file will be extracted to.

        Returns:
            Path to the extraction.

        """
        if not destination:
            destination = self.archive.parent
        else:
            destination.mkdir(exist_ok=True, parents=True)
        shutil.unpack_archive(self.archive, destination)
        return destination

    def __bool__(self) -> Literal[True]:
        """Boolean representation of this object."""
        return True

    def __str__(self) -> str:
        """String representation of this object."""
        return str(self.archive)


class Installer:
    """Logic to perform install."""

    API_URL = f"https://api.github.com/repos/{GITHUB_REPO}"
    """GitHub API URL."""

    GIT_REPO = f"https://github.com/{GITHUB_REPO}"
    """Repository where source is stored."""

    VERSION_REGEX = re.compile(
        r"v?(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:\.(\d+))?"
        "("
        "[._-]?"
        r"(?:(stable|beta|b|rc|RC|alpha|a|patch|pl|p)((?:[.-]?\d+)*)?)?"
        "([.-]?dev)?"
        ")?"
        r"(?:\+[^\s]+)?"
    )

    def __init__(
        self,
        *,
        allow_prereleases: bool = False,
        force: bool = False,
        global_install: bool = False,
        version: str | None = None,
    ) -> None:
        """Instantiate class.

        Args:
            allow_prereleases: Allows prereleases to be considered for install
                when a version is not explicitly provided.
            force: Always perform the install, even if the requested version is
                detected as the currently installed version.
            global_install: Install globally for all users.
            version: Version to install from GitHub releases.

        """
        self._version = version
        self._allow_prereleases = allow_prereleases
        self._force = force
        self.global_install = global_install

    @property
    def allows_prereleases(self) -> bool:
        """Whether prereleases can be installed."""
        return self._allow_prereleases

    @cached_property
    def bin_dir(self) -> Path:
        """User's bin directory."""
        rv = Path("/usr/local/bin") if self.global_install else Path.home() / ".local/bin"
        rv.mkdir(exist_ok=True, parents=True)
        return rv

    @cached_property
    def current_version(self) -> tuple[str, str, str, str, str, str, str, str] | None:
        """Currently installed version."""
        if self.version_file.exists():
            version_match = self.VERSION_REGEX.findall(self.version_file.read_text())
            if version_match:
                return version_match[0]
        return None

    @cached_property
    def lib_dir(self) -> Path:
        """User's lib directory."""
        rv = Path("/usr/local/lib") if self.global_install else Path.home() / ".local/lib"
        rv.mkdir(exist_ok=True, parents=True)
        return rv

    @cached_property
    def releases(self) -> list[dict[str, Any]]:
        """List of available releases."""
        metadata = self._get(f"{self.API_URL}/releases")

        def _compare_versions(x: dict[str, Any], y: dict[str, Any]) -> Literal[-1, 0, 1]:
            mx = self.VERSION_REGEX.match(x["tag_name"])
            my = self.VERSION_REGEX.match(y["tag_name"])

            if not mx or not my:
                raise NotImplementedError(
                    f"could not parse a version from {x} and/or {y}"  # noqa: EM102
                )

            vx = (*tuple(int(p) for p in mx.groups()[:3]), mx.group(5))
            vy = (*tuple(int(p) for p in my.groups()[:3]), my.group(5))

            if vx < vy:
                return -1
            if vx > vy:
                return 1

            return 0

        releases = sorted(metadata, key=cmp_to_key(_compare_versions))
        releases.reverse()
        return releases

    @cached_property
    def version_file(self) -> Path:
        """Path to ``version.sh`` file."""
        return self.lib_dir / "oi" / "version.sh"

    def _get(self, url: str, *, json_response: bool = True) -> Any:  # noqa: ANN401
        """Make an HTTP GET request."""
        headers: dict[str, str] = {}
        if json_response:
            headers.update(
                {
                    "Accept": "application/vnd.github+json",
                    "X-GitHub-Api-Version": "2022-11-28",
                }
            )
        request = Request(url, headers=headers)  # noqa: S310

        with closing(urlopen(request)) as r:  # noqa: S310
            response = r.read()
        if json_response:
            return json.loads(response.decode())
        return response.decode()

    def _install_comment(self, version: str, message: str) -> None:
        self.write_stdout(
            "Installing {} ({}): {}".format(
                colorize("info", "oi"),
                colorize("b", version),
                colorize("comment", message),
            )
        )

    def display_post_message(self, version: str) -> None:
        """Display post-install message."""
        paths = os.getenv("PATH", "").split(":")

        message = POST_MESSAGE_NOT_IN_PATH
        if paths and str(self.bin_dir) in paths:
            message = POST_MESSAGE

        self.write_stdout(
            message.format(
                package=colorize("info", "oi"),
                version=colorize("b", version),
                home_bin=colorize("comment", self.bin_dir),
                package_executable=colorize("b", self.bin_dir / "oi"),
                configure_message=POST_MESSAGE_CONFIGURE_UNIX.format(
                    home_bin=colorize("comment", self.bin_dir)
                ),
                test_command=colorize("b", "oi --version"),
            )
        )

    def display_pre_message(self) -> None:
        """Display pre-install message."""
        self.write_stdout(
            PRE_MESSAGE.format(
                package=colorize("info", "oi"),
                home_bin=colorize("comment", self.bin_dir),
            )
        )

    def download_release_artifact(self, artifact: ReleaseArtifact, tmp_dir: Path) -> Path:
        """Download a release artifact."""
        self.write_stdout(
            "Downloading from {}...".format(colorize("info", artifact["browser_download_url"]))
        )
        out_file = tmp_dir / artifact["name"]
        urlretrieve(artifact["browser_download_url"], out_file)  # noqa: S310
        return out_file

    def find_oi_release_artifact(
        self, *, artifact_type: Literal["zip", "gtar"] = "gtar", version: str
    ) -> ReleaseArtifact:
        """Find oi artifact to be downloaded."""
        release = self._get(f"{self.API_URL}/releases/tags/v{version.lstrip('v')}")
        asset: ReleaseArtifact | None = None
        mime_type = (
            "application/zip" if artifact_type == "zip" else f"application/x-{artifact_type}"
        )
        for i in release["assets"]:
            if i["content_type"] == mime_type:
                asset = i
                break

        if not asset:
            msg = f"Version {version} doesn't have an asset of type '{mime_type}'"
            self.write_stdout(colorize("error", msg))
            raise ValueError(msg)

        return asset

    def get_version(
        self,
    ) -> tuple[str | None, tuple[str, str, str, str, str, str, str, str] | None]:
        """Get version to install."""
        self.write_stdout(colorize("info", "retrieving releases..."))

        release = None
        if self._version:
            releases = [v for v in self.releases if v["tag_name"] == self._version]
            if not releases:
                msg = f"Version {self._version} doesn't exist"
                self.write_stdout(colorize("error", msg))

                raise ValueError(msg)
            release = releases[0]

        if not release:
            for i in self.releases:
                if i["prerelease"] and not self.allows_prereleases:
                    continue
                release = i
                break

        if not release:
            msg = "Unable to determine a release to use, try passing '--allow-prereleases'."
            self.write_stdout(colorize("error", msg))
            raise ValueError(msg)

        if self.current_version and (
            ".".join(self.current_version[:3]) + self.current_version[4]
            == release["tag_name"].lstrip("v")
            and not self._force
        ):
            self.write_stdout(
                f"The latest version ({colorize('b', release['tag_name'])}) is already installed"
            )

            return None, self.current_version

        return release["tag_name"].lstrip("v"), self.current_version

    def install(self, artifact_type: Literal["gtar", "zip"] = "gtar") -> int:
        """Installs oi."""
        self.display_pre_message()
        try:
            version, _ = self.get_version()
        except ValueError:
            return 1

        if version is None:
            return 0

        self.write_stdout(
            "Installing {} ({})".format(colorize("info", "oi"), colorize("info", version))
        )

        with tempfile.TemporaryDirectory() as tmp_dir:
            extracted = (
                ArchiveExtractor(
                    self.download_release_artifact(
                        self.find_oi_release_artifact(artifact_type=artifact_type, version=version),
                        Path(tmp_dir),
                    )
                ).extract()
                / "oi"
            )

            shutil.rmtree(self.lib_dir / "oi", ignore_errors=True)
            shutil.move(extracted, self.lib_dir)

        self._install_comment(version, f"Symlinking into {self.bin_dir}")
        bin_file = self.bin_dir / "oi"
        if bin_file.exists():
            bin_file.unlink()
        bin_file.symlink_to(self.lib_dir / "oi" / "oi")
        self._install_comment(version, "Complete")
        self.display_post_message(version)
        return 0

    def uninstall(self) -> int:
        """Uninstall oi."""
        lib_dir = self.lib_dir / "oi"
        if not lib_dir.exists():
            self.write_stdout("{} is not currently installed.".format(colorize("info", "oi")))
            return 1

        if self.current_version:
            self.write_stdout(
                "Removing {} ({})".format(
                    colorize("info", "oi"),
                    colorize(
                        "b",
                        ".".join(self.current_version[:3]) + self.current_version[4],
                    ),
                )
            )
        else:
            self.write_stdout("Removing {}".format(colorize("info", "oi")))

        (self.bin_dir / "oi").unlink(missing_ok=True)
        if lib_dir.exists():
            shutil.rmtree(lib_dir)
        return 0

    def write_stdout(self, line: str) -> None:
        """Log to stdout."""
        sys.stdout.write(line + "\n")


class ReleaseArtifact(TypedDict):
    """TypedDict for ``asserts`` of ``/repos/{owner}/{repo}/releases/tags/{tag}``."""

    browser_download_url: str
    content_type: str
    created_at: str
    id: int
    name: str
    size: int
    state: str
    updated_at: str
    uploader: dict[str, Any]
    url: str


def main() -> int:
    """Entrypoint of this script."""
    parser = argparse.ArgumentParser(
        add_help=False,
        description="Installs the latest (or given) version of oi.",
    )
    parser.add_argument(
        "-a",
        "--artifact-type",
        action="store",
        choices=["gtar", "zip"],
        default="gtar",
        dest="artifact_type",
        help="Artifact type to install.",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        default=False,
        dest="force",
        help="Install on top of existing version.",
    )
    parser.add_argument(
        "-g",
        "--global",
        action="store_true",
        default=False,
        dest="global_install",
        help="Install globally for all users. NOTE: Should be run with elevated privileges (e.g. 'sudo').",
    )
    parser.add_argument(
        "-p",
        "--allow-prereleases",
        action="store_true",
        default=False,
        dest="allow_prereleases",
        help="Allows prereleases to be considered for install when a version is not explicitly provided.",
    )
    parser.add_argument(
        "--uninstall",
        action="store_true",
        default=False,
        dest="uninstall",
        help="Uninstall oi.",
    )
    parser.add_argument(
        "--version", help="Explicitly provide the version to install.", dest="version"
    )
    args = parser.parse_args()

    installer = Installer(
        allow_prereleases=args.allow_prereleases,
        force=args.force,
        global_install=args.global_install,
        version=args.version,
    )

    try:
        if args.uninstall:
            return installer.uninstall()
        return installer.install(args.artifact_type)
    except Exception as err:  # noqa: BLE001
        import traceback

        installer.write_stdout(colorize("error", "".join(traceback.format_exception(err))))
        installer.write_stdout(colorize("error", "Installation failed!"))
        return 1


if __name__ == "__main__":
    sys.exit(main())
