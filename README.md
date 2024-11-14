# pip install reduce-binary (unofficial)

![build](https://github.com/deargen/py-reduce-binary/actions/workflows/build_and_release.yml/badge.svg)
[![Actions status](https://github.com/deargen/py-reduce-binary/workflows/Tests/badge.svg)](https://github.com/deargen/py-reduce-binary/actions)
[![codecov](https://codecov.io/github/deargen/py-reduce-binary/graph/badge.svg?token=S9MD6B44J6)](https://codecov.io/github/deargen/py-reduce-binary)

[![image](https://img.shields.io/pypi/v/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/reduce-binary)](https://pypistats.org/packages/reduce-binary)
[![image](https://img.shields.io/pypi/l/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)
[![image](https://img.shields.io/pypi/pyversions/reduce-binary.svg)](https://pypi.python.org/pypi/reduce-binary)

Install and use [reduce](https://github.com/rlabduke/reduce) with ease in Python.

```bash
pip install reduce-binary
```

```python
import reduce_binary

print(reduce_binary.REDUCE_BIN_PATH)
reduce_binary.run_reduce("-h")  # like subprocess.run(["reduce", "-h"])
reduce_binary.popen_reduce("-h")  # like subprocess.Popen(["reduce", "-h"])

# For no-argument case, pass an empty string
reduce_binary.run_reduce("")  # like subprocess.run(["reduce"])

# Pass a list of arguments
reduce_binary.run_reduce(["-Trim", "input.pdb"])
```

There exists a wrapper function.

```python
from reduce_binary.helpers import protonate

protonate(
    "input.pdb",
    "output.pdb",
    remove_hydrogen_first=True,
    print_stderr=False,
)
```

Supported platforms:

- Linux x86_64
- MacOS x86_64, arm64 (Intel and Apple Silicon)

> [!NOTE]
> Installing the package does NOT put the binary in $PATH.  
> Instead, the API will tell you where it is located.

## 👨‍💻️ Maintenance Notes

### Releasing a new version with CI (recommended)

Go to Github Actions and run the `Build and Release` workflow.

Version rule:

e.g.: 4.14.0.2

- 4.14 is the reduce version
- the last digit is the build/API version number

### Testing with CI (recommended)

Go to Github Actions and run the `Build and Release` workflow, with **"Dry run" checked**.

It will build and test the wheels on all platforms, without releasing them to PyPI.


### Running locally

This section describes how it works.

To run it locally, first install the dependencies:

```bash
pip install uv --user --break-system-packages
uv tool install wheel
uv tool install build

# Mac
brew install gnu-sed
```

Build the app at `buiid/` (reduce):

```bash
# Linux
bash build_reduce_linux.sh v4.14
# Mac (Intel)
MACOSX_DEPLOYMENT_TARGET=10.12 bash build_reduce_mac.sh v4.14
# Mac (Apple Silicon)
MACOSX_DEPLOYMENT_TARGET=11.0 bash build_reduce_mac.sh v4.14
```

> [!NOTE]
> Linux build uses an old version of ubuntu docker to be compatible with old systems.  
> It also checks if the glibc dependency is lower than 2.17.  
> In the future you may need to increase this version in the script.

> [!NOTE]
> The `MACOSX_DEPLOYMENT_TARGET` is the cmake flag.  
> <https://cmake.org/cmake/help/latest/envvar/MACOSX_DEPLOYMENT_TARGET.html>

Build the wheel. It copies the `python` to `build_python/`, built binary into it, modifies the version number and builds the wheel in `build_python/dist/`.:

```bash
# One of the following
bash build_python.sh 4.14 manylinux_2_17_x86_64.manylinux2014_x86_64
bash build_python.sh 4.14 macosx_10_12_x86_64
bash build_python.sh 4.14 macosx_11_0_arm64
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
- [ ] CHANGELOG and publish to releases
