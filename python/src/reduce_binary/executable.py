from __future__ import annotations

import os
import subprocess
from pathlib import Path
from typing import Any, Literal, overload

BIN_DIR = Path(__file__).parent / "bin"
if os.name == "nt":
    REDUCE_BIN_PATH = BIN_DIR / "reduce.exe"
else:
    REDUCE_BIN_PATH = BIN_DIR / "reduce"


@overload
def reduce(
    *args: str, return_completed_process: Literal[True], **kwargs: Any
) -> subprocess.CompletedProcess[str | bytes]: ...


@overload
def reduce(
    *args: str, return_completed_process: Literal[False] = ..., **kwargs: Any
) -> int: ...


@overload
def reduce(
    *args: str, return_completed_process: bool = False, **kwargs: Any
) -> int | subprocess.CompletedProcess[str | bytes]: ...


def reduce(
    *args: str, return_completed_process: bool = False, **kwargs: Any
) -> int | subprocess.CompletedProcess[str | bytes]:
    complete_process = subprocess.run([REDUCE_BIN_PATH, *args], **kwargs)
    if return_completed_process:
        return complete_process
    return complete_process.returncode
