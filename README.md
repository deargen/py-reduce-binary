# pip install reduce-binary

![build](https://github.com/deargen/py-reduce-binary/actions/workflows/build_and_release.yml/badge.svg)

[![image](https://img.shields.io/pypi/v/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/reduce-binary)](https://pypistats.org/packages/reduce-binary)
[![image](https://img.shields.io/pypi/l/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)
[![image](https://img.shields.io/pypi/pyversions/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)


Install and use [reduce](https://github.com/rlabduke/reduce) with ease in Python.

```bash
pip install reduce-binary
```

```python
from reduce_binary import REDUCE_BIN_PATH, reduce
print(REDUCE_BIN_PATH)
reduce("-h")
```

Supported platforms:

- Linux x86_64 (Ubuntu 20.04 +)
- MacOS x86_64, arm64 (Intel and Apple Silicon)


## 👨‍💻️ Maintenance Notes

### Releasing a new version with CI (recommended)

Go to Github Actions and run the `Build and Release` workflow.

Version rule:

4.14.post2: 4.14 is the reduce version, postN can increase with the changes of the package and the builds.


### Running locally

This section describes how it works.

To run it locally, first install the dependencies:

```bash
pip install uv
uv tool install wheel
uv tool install build

# Mac
brew install gnu-sed
```

Build the app (reduce):

```bash
# build/
bash build_reduce.sh v4.14
```

Build the wheel. It copies the `python` to `build_python/`, built binary into it, modifies the version number and builds the wheel in `build_python/dist/`.:

```bash
# One of the following
bash build_python.sh wheel 4.14 manylinux_2_28_x86_64.manylinux2014_x86_64
bash build_python.sh wheel 4.14 macosx_10_12_x86_64
bash build_python.sh wheel 4.14 macosx_11_0_arm64
bash build_python.sh sdist 4.14
```

Test the wheel

```bash
uv venv
source .venv/bin/activate
uv pip install -r requirements_test.txt
uv pip install build_python/dist/*.whl
pytest
```


## ✅ TODO

- [ ] Cross-compile for Linux
- [ ] Windows build
