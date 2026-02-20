#!/usr/bin/env bash

clear

if [ "$1" = "install" ]; then
    mkdir -p build
    pushd build

    if [ ! -d root ]; then
        mkdir root
        pushd root

        git clone https://github.com/alliedmodders/sourcemod --recursive
        git clone https://github.com/alliedmodders/metamod-source
        git clone https://github.com/alliedmodders/hl2sdk hl2sdk-css -b css
        git clone https://github.com/alliedmodders/ambuild

        python -m venv venv
        source venv/bin/activate
        python -m pip install ./ambuild
        deactivate

        popd
    fi

    popd
elif [ "$1" = "build" ]; then
    ROOT_PATH=$(pwd)
    mkdir -p build/output

    source build/root/venv/bin/activate

    pushd build/output

    python ../../configure.py \
        --sm-path=$ROOT_PATH/build/root/sourcemod \
        --mms-path=$ROOT_PATH/build/root/metamod-source \
        --hl2sdk-root=$ROOT_PATH/build/root \
        --hl2sdk-manifest-path=$ROOT_PATH/build/root/sourcemod/hl2sdk-manifests \
        --sdks=css

    ambuild

    deactivate

    popd
else
    echo "No valid command was specified"
fi
