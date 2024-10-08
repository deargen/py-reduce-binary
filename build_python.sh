SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR="$SCRIPT_DIR/build"

help() {
    echo "Usage: $0 wheel <VERSION_NUM> <PLATFORM_NAME>"
    echo "   or: $0 sdist <VERSION_NUM>"
}

if [[ $# -lt 2 ]]; then
    help
    exit 1
elif [[ $# -eq 2 ]]; then
    if [[ $1 != "sdist" ]]; then
        help
        exit 1
    fi

    WHEEL_OR_SDIST=$1
	VERSION_NUM=$2
elif [[ $# -eq 3 ]]; then
    if [[ $1 != "wheel" ]]; then
        help
        exit 1
    fi

    WHEEL_OR_SDIST=$1
	VERSION_NUM=$2
    PLATFORM_NAME=$3

    valid_platforms=("macosx_11_0_arm64" \
        "macosx_10_12_x86_64" \
        "manylinux_2_17_x86_64.manylinux2014_x86_64" \
        "manylinux_2_28_x86_64" \
        "manylinux_2_17_i686.manylinux2014_i686" "manylinux_2_17_aarch64.manylinux2014_aarch64" \
        "manylinux_2_17_armv7l.manylinux2014_armv7l" "manylinux_2_17_ppc64le.manylinux2014_ppc64le" \
        "manylinux_2_17_s390x.manylinux2014_s390x")
    
    platform_found=false
    for platform in "${valid_platforms[@]}"; do
        if [[ "$platform" == "$PLATFORM_NAME" ]]; then
            platform_found=true
            break
        fi
    done
    
    if [[ "$platform_found" == false ]]; then
        echo "Unknown platform name: $PLATFORM_NAME"
        help
        exit 1
    fi
else
    help
    exit 1
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
cp "$SCRIPT_DIR/README.md" "$PYTHON_BUILD_DIR"

# Replace version = "0.0.0" with the desired version
$SED -i "s/version = \"0.0.0\"/version = \"$VERSION_NUM\"/g" "$PYTHON_BUILD_DIR/pyproject.toml" || { echo "Failure"; exit 1; }
# Replace __version__ = "0.0.0" with the desired version
$SED -i "s/__version__ = \"0.0.0\"/__version__ = \"$VERSION_NUM\"/g" "$PYTHON_BUILD_DIR/src/reduce_binary/__init__.py" || { echo "Failure"; exit 1; }

cd "$PYTHON_BUILD_DIR" || { echo "Failure"; exit 1; }

if [ "$WHEEL_OR_SDIST" == "wheel" ]; then
    cp -r "$BUILD_DIR/"* "$PYTHON_BUILD_DIR/src/reduce_binary"
    pyproject-build --installer=uv --wheel
    wheel tags --python-tag py3 --abi-tag none --platform "$PLATFORM_NAME" dist/*.whl --remove
else
    pyproject-build --installer=uv --sdist
fi


