# Reduce Binary

Depends on the following packages:

```bash
pip install uv
uv tool install wheel
uv tool install build

# Mac
brew install gnu-sed
```

![build](https://github.com/kiyoon/reduce-binary/actions/workflows/check_app_version.yml/badge.svg)

This utilises GitHub Action to **detect, build and release the latest version of the app as soon as they get released**.

One-liner to get the latest reduce.appimage build:
```bash
curl -s https://api.github.com/repos/deargen/reduce-binary/releases/latest \
| grep "browser_download_url.*appimage" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - \
&& chmod +x reduce.appimage

## optionaly, move it into your $PATH
mv reduce.appimage /usr/local/bin/reduce
reduce
```

For macOS, get `.tar.gz`.

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        curl -s https://api.github.com/repos/deargen/reduce-binary/releases/latest \
        | grep "browser_download_url.*macos-aarch64.tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | wget -qi - \
        && mv reduce-macos-aarch64.tar.gz reduce.tar.gz
    else
        curl -s https://api.github.com/repos/deargen/reduce-binary/releases/latest \
        | grep "browser_download_url.*macos-x86_64.tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | wget -qi - \
        && mv reduce-macos-x86_64.tar.gz reduce.tar.gz
    fi
fi
```

### What is this?
1. For Linux, a Docker build of Reduce Appimage
2. For macOS, a build script which generates `reduce.tar.gz`.

### Why use Docker?
The advantages of using docker:
- Obtain consistent build results on any computer.
- No need to install a slew of build packages on your own machine.
- Built from the official source code, so you can trust.

### Build it yourself from source code
I assume you have docker installed already.
```bash
# change the version in the script
bash build.sh
```

### Where has the AppImage been tested to run?
It has been tested on these fine Linux platforms and will likely work for anything newer than centos 6.9 (which is a few years old now.) Please file an issue if you find otherwise or need support on a different platform.
```
ubuntu 22.04
ubuntu 20.04
ubuntu 18.04
manjaro 19.02
centos 7
centos 8
fedora 33
```
The distributed build will not work on old os's (like Centos 6), since they have older glibc libraries.
If you need it to work on those systems, try modifying the Dockerfile to use an older ubuntu as the base image and doing a docker build.

### What is the sauce that makes this work?
The [Dockerfile](Dockerfile) contains all the magic ingredients to compile the app.

### Credit
This project is forked and inspired from [tmux-appimage](https://github.com/nelsonenzo/tmux-appimage) but added Github Action CI to build and release automatically.


## Maintainance Note (Important)

The Github Action will be disabled if the project doesn't update for a few months. You can re-enable it in the "Actions" tab.


## ✅ TODO

- [ ] Cross-compile for Linux
- [ ] Windows build
