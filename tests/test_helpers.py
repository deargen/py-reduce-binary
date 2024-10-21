from __future__ import annotations

import logging
import tempfile
from os import PathLike
from pathlib import Path

import pytest

from biotest.compare_files import assert_two_pdb_files_within_tolerance
from reduce_binary.helpers import protonate

logger = logging.getLogger(__name__)

SCRIPT_DIR = Path(__file__).resolve().parent


@pytest.mark.parametrize(
    ("in_pdb_path", "answer_pdb_path"),
    [
        (
            SCRIPT_DIR / "data/input_pdbs/2P1Q_B.pdb",
            SCRIPT_DIR / "data/expected_outputs/protonate/2P1Q_B.pdb",
        ),
        (
            SCRIPT_DIR / "data/input_pdbs/2P1Q_C.pdb",
            SCRIPT_DIR / "data/expected_outputs/protonate/2P1Q_C.pdb",
        ),
    ],
)
def test_protonate(in_pdb_path: str | PathLike, answer_pdb_path: str | PathLike):
    answer_pdb_path = Path(answer_pdb_path)

    with tempfile.TemporaryDirectory() as tmpdir:
        out_pdb_path = Path(tmpdir) / "protonated.pdb"
        logger.warning(f"out_pdb_path: {out_pdb_path}")
        protonate(
            in_pdb_path,
            out_pdb_path,
            remove_hydrogen_first=True,
        )

        assert_two_pdb_files_within_tolerance(
            out_pdb_path,
            answer_pdb_path,
            tolerance=1e-3,
        )
