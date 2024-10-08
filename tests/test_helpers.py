from __future__ import annotations

import logging
import tempfile
from os import PathLike
from pathlib import Path

import numpy as np
import pytest

from reduce_binary.helpers import protonate

logger = logging.getLogger(__name__)

SCRIPT_DIR = Path(__file__).resolve().parent


def check_pdb_atoms_almost_equal(
    pdb1_str: str,
    pdb2_str: str,
):
    # ATOM    998  N   PHE B   9      18.937-159.292 -13.075  1.00 30.49           N
    pdb1_lines = pdb1_str.splitlines()
    pdb2_lines = pdb2_str.splitlines()
    assert len(pdb1_lines) == len(pdb2_lines)

    for pdb1_line, pdb2_line in zip(pdb1_lines, pdb2_lines):
        if pdb1_line.startswith("ATOM") and pdb2_line.startswith("ATOM"):
            coord_1 = (
                float(pdb1_line[32:38]),
                float(pdb1_line[38:47]),
                float(pdb1_line[47:56]),
            )
            coord_2 = (
                float(pdb2_line[32:38]),
                float(pdb2_line[38:47]),
                float(pdb2_line[47:56]),
            )

            for c1, c2 in zip(coord_1, coord_2):
                assert np.isclose(
                    c1, c2, atol=1e-3
                ), f"{pdb1_line.rstrip()} and {pdb2_line.rstrip()} are not equal."

            line1_except_coord = pdb1_line[:32] + pdb1_line[56:]
            line2_except_coord = pdb2_line[:32] + pdb2_line[56:]
            assert (
                line1_except_coord.rstrip() == line2_except_coord.rstrip()
            ), f"{pdb1_line.rstrip()} and {pdb2_line.rstrip()} are not equal."

        else:
            assert (
                pdb1_line.rstrip() == pdb2_line.rstrip()
            ), f"{pdb1_line.rstrip()} and {pdb2_line.rstrip()} are not equal."

    return True


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

        check_pdb_atoms_almost_equal(
            out_pdb_path.read_text(),
            answer_pdb_path.read_text(),
        )
