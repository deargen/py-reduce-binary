# 1. Build reduce at build/
TEMP_DIR="$(mktemp -d)"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD_DIR="$SCRIPT_DIR/build"
mkdir -p "$BUILD_DIR"

if [[ $# -ge 1 ]]; then
	REDUCE_RELEASE_TAG=$1
else
    echo "usage: $0 <REDUCE-RELEASE-TAG>"
    exit 1
fi

## Fetch Code
cd "$TEMP_DIR" || { echo "Failure"; exit 1; }
git clone -b $REDUCE_RELEASE_TAG --depth 1 https://github.com/rlabduke/reduce

## Build
export LD_LIBRARY_PATH="$BUILD_DIR/lib"
export CPPFLAGS="-I$BUILD_DIR/include"
export LDFLAGS="-L$BUILD_DIR/lib"
cd "$TEMP_DIR/reduce" || { echo "Failure"; exit 1; }
cmake . -DCMAKE_INSTALL_PREFIX="$BUILD_DIR"
make -j4 && make install


