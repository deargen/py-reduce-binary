import regex
from reduce_binary import REDUCE_BIN_PATH, reduce


def test_exists():
    assert REDUCE_BIN_PATH.is_file()


def test_name():
    assert REDUCE_BIN_PATH.name == "reduce"


def test_execute_help():
    return_code = reduce("-h")
    assert return_code == 2


def test_execute_noarg():
    return_code = reduce()
    assert return_code == 2


def test_execute_noarg_message():
    proc = reduce(return_completed_process=True, capture_output=True, text=True)
    print(proc)
    if isinstance(proc.stderr, bytes):
        lines = proc.stderr.decode("utf-8")
    else:
        lines = proc.stderr
    first_line = lines.splitlines()[0]
    assert (
        regex.match(
            r"^reduce: version .*, Copyright .* J. Michael Word;.*Richardson Lab at Duke University$",
            first_line,
        )
        is not None
    )
