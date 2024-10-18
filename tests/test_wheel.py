from __future__ import annotations

import re

from reduce_binary import REDUCE_BIN_PATH, run_reduce


def test_exists():
    assert REDUCE_BIN_PATH.is_file()


def test_name():
    assert REDUCE_BIN_PATH.name == "reduce"


def test_execute_help():
    proc = run_reduce("-h")
    assert proc.returncode == 2


def test_execute_noarg():
    proc = run_reduce("")
    assert proc.returncode == 2


def test_execute_noarg_message():
    proc = run_reduce("", capture_output=True, text=True, encoding="utf-8")
    print(proc)
    if isinstance(proc.stderr, bytes):
        lines = proc.stderr.decode("utf-8")
    else:
        lines = proc.stderr
    first_line = lines.splitlines()[0]
    assert (
        re.match(
            r"^reduce: version .*, Copyright .* J. Michael Word;.*Richardson Lab at Duke University$",
            first_line,
        )
        is not None
    )