import argparse
import json
from pathlib import Path
import shutil
import subprocess


def unresolved(review):
    rows = list(review.get("review_comments") or [])
    for entry in (review.get("files") or {}).values():
        rows.extend(entry.get("comments") or [])
    return sum(row.get("resolved") is not True for row in rows)


def describe(status, reviews):
    sessions = status.get("sessions") or []
    count = sum(unresolved(review) for review in reviews)
    if not reviews and len(sessions) <= 1:
        count = (status.get("comments") or {}).get("unresolved", 0)
    if sessions:
        label = "Reviewing" if len(sessions) == 1 else "Reviewing (%d sessions)" % len(sessions)
        return label + (" — %d unresolved" % count if count else "")
    if count:
        return "%d unresolved comments" % count
    if reviews or status.get("review_file_exists"):
        return "No open comments — approval not recorded"
    return "— no review"


def status_line(cwd):
    if not shutil.which("crit"):
        return "Crit: not installed"
    try:
        process = subprocess.run(["crit", "status", "--json"], cwd=cwd, capture_output=True, text=True, timeout=3)
        if process.returncode:
            return "Crit: status unavailable"
        status = json.loads(process.stdout)
        paths = [entry.get("review_file") for entry in (status.get("sessions") or [])]
        paths.append(status.get("review_file"))
        reviews = []
        for path in dict.fromkeys(filter(None, paths)):
            try:
                reviews.append(json.loads(Path(path).read_text()))
            except (OSError, ValueError):
                continue
        return "Crit: " + describe(status, reviews)
    except (subprocess.SubprocessError, OSError, ValueError):
        return "Crit: status unavailable"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--cwd", required=True)
    print(status_line(parser.parse_args().cwd))
