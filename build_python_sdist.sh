SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR="$SCRIPT_DIR/build"

if [[ $# -ge 1 ]]; then
	VERSION_NUM=$1
else
    echo "Usage: $0 <wheel/sdist> <VERSION_NUM>"
fi

# use gsed on mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED="gsed"
else
    SED="sed"
fi

# 2. Gather the python project with the reduce build
PYTHON_BUILD_DIR="$SCRIPT_DIR/build_python"

if [ -d "$PYTHON_BUILD_DIR" ]; then
    # ask for confirmation
    echo "The directory $PYTHON_BUILD_DIR exists. Do you want to remove it? (y/n)"
    read -r response
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        rm -rf "$PYTHON_BUILD_DIR"
    else
        echo "Exiting..."
        exit 1
    fi
fi

cp -r "$SCRIPT_DIR/python" "$PYTHON_BUILD_DIR"

# Replace version = "0.0.0" with the desired version
$SED -i "s/version = \"0.0.0\"/version = \"$VERSION_NUM\"/g" "$PYTHON_BUILD_DIR/pyproject.toml" || { echo "Failure"; exit 1; }
# Replace __version__ = "0.0.0" with the desired version
$SED -i "s/__version__ = \"0.0.0\"/__version__ = \"$VERSION_NUM\"/g" "$PYTHON_BUILD_DIR/src/reduce_binary/__init__.py" || { echo "Failure"; exit 1; }

cp -r "$BUILD_DIR/"* "$PYTHON_BUILD_DIR/src/reduce_binary"

cd "$PYTHON_BUILD_DIR" || { echo "Failure"; exit 1; }

pyproject-build --installer=uv --wheel
wheel tags --python-tag py3 --abi-tag none --platform "$(python "$SCRIPT_DIR"/scripts/get_current_platform.py)" dist/*.whl --remove
