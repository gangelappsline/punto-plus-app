#!/usr/bin/env python3
"""Expose bounded CI diagnostics through the PR API when log storage is blocked.

Only called for same-repository pull requests. No PR-provided values are executed
as shell code. Reporting never changes the failing job's result.
"""
import json
import os
from pathlib import Path
import subprocess
import sys


def main():
    event = json.loads(Path(os.environ['GITHUB_EVENT_PATH']).read_text())
    number = event['pull_request']['number']
    repository = os.environ['GITHUB_REPOSITORY']
    run_id = os.environ['GITHUB_RUN_ID']
    sections = [f'### CI diagnostics · {os.environ["GITHUB_JOB"]}',
                f'Run: https://github.com/{repository}/actions/runs/{run_id}']
    for name in sys.argv[1:]:
        path = Path(name)
        if path.is_file():
            # Keep below GitHub's comment limit; avoid nested code fences.
            text = path.read_text(errors='replace')[-18000:].replace('```', "'''")
            sections.append(f'#### {path.name}\n```text\n{text}\n```')
    subprocess.run(['gh', 'pr', 'comment', str(number), '--repo', repository,
                    '--body', '\n\n'.join(sections)], check=True)


if __name__ == '__main__':
    main()
