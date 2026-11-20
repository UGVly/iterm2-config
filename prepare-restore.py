"""Build an iTerm2 restore bundle with paths resolved for this Mac."""

import argparse
import json
import plistlib
from pathlib import Path

PATH_FIELDS = ("Background Image Location", "Dynamic Profile Filename", "Working Directory")


def expand_profile_paths(profiles):
    for profile in profiles:
        for field in PATH_FIELDS:
            value = profile.get(field)
            if isinstance(value, str) and (value == "~" or value.startswith("~/")):
                profile[field] = str(Path(value).expanduser())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path, help="New directory for the restore bundle")
    output = parser.parse_args().output.expanduser()
    source = Path(__file__).resolve().parent
    output.mkdir()
    (output / "DynamicProfiles").mkdir()

    plist_name = "com.googlecode.iterm2.plist"
    preferences = plistlib.loads((source / plist_name).read_bytes())
    expand_profile_paths(preferences["New Bookmarks"])
    (output / plist_name).write_bytes(plistlib.dumps(preferences))

    for path in sorted((source / "DynamicProfiles").glob("*.json")):
        document = json.loads(path.read_bytes())
        expand_profile_paths(document["Profiles"])
        (output / "DynamicProfiles" / path.name).write_text(
            json.dumps(document, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


if __name__ == "__main__":
    main()
