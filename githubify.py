import os
import sys
from pathlib import Path

EXCLUDE_INDEXES = (
    "DataProducts",
    "Context",
    "ClassDefinitions",
    "Ontology",
    "v1",
    "draft",
)
FILE_REDIRECT_TPL = """---
redirect_to: "{to}"
---
"""

NGINX_REDIRECT_TPL = """
location /{from} {{
    return 302 $scheme://$host/{to};
}}
"""

NGINX_CONF = ""


def redirect(_from: Path, to: Path):
    to = to.as_posix()
    print(f"Redirecting {_from.as_posix()} -> {to}")
    _from.write_text(FILE_REDIRECT_TPL.format(to=to), encoding="utf-8")

    global NGINX_CONF
    NGINX_CONF += NGINX_REDIRECT_TPL.format(
        **{"from": _from.as_posix()[: -len("index.md")], "to": to}
    )


def process_version(version: Path):
    for (root, dirs, files) in os.walk(str(version), topdown=True):
        root = Path(root)

        if root.name not in EXCLUDE_INDEXES:
            redirect(root / "index.md", root.parent / (root.name + ".jsonld"))


if __name__ == "__main__":
    versions = sys.argv[1:]
    for version in versions:
        process_version(Path(version))

    print(NGINX_CONF)
