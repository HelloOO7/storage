#!/usr/bin/env bash

# This file is a modification of the setup scripts from The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="hl"
rp_module_desc="Half-Life for the Pi, based on Xash3D"
rp_module_section="exp"
rp_module_flags=""

function depends_hl() {
    local depends=(cmake cmake-curses-gui libsdl2-dev libsdl2-2.0-0 libsdl2-mixer-dev libsdl2-mixer-2.0-0 libsdl2-net-dev libsdl2-net-2.0-0 libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-image-dev libsdl2-image-2.0-0)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)
    getDepends "${depends[@]}"
}

function sources_hl() {
    gitPullOrClone "$md_build" git://github.com/FWGS/xash3d
    gitPullOrClone "$md_build"/engine/nanogl git://github.com/FWGS/nanogl
    gitPullOrClone "$md_build"/hlsdk git://github.com/FWGS/hlsdk-xash3d
}

function build_hl() {
    cd "$md_build"
    mkdir build && cd build
    sudo cmake -DXASH_NANOGL=yes -DXASH_VGUI=no -DXASH_GLES=yes -DHL_SDK_DIR=../hlsdk/ ..
    sudo make
    cd ..
    cd hlsdk
    mkdir build && cd build
    sudo cmake ..
    sudo make
}

function install_bin_hl() {
    mkdir /home/pi/Half-Life
    cd /home/pi/Half-Life
    wget --no-check-certificate "https://github.com/HelloOO7/storage/raw/master/xash3d.tar" -O xash3d.tar
    tar -xvf xash3d.tar
    rm -r xash3d.tar
}

function install_hl() {
    cd "$md_build"
    mkdir /home/pi/Half-Life
    cp -Rvf hlsdk/build/cl_dll/client.so hlsdk/build/dlls/hl.so build/engine/libxash.so build/game_launch/xash3d build/mainui/libxashmenu.so /home/pi/Half-Life
}

function configure_hl() {
    addPort "$md_id" "hl" "Half-Life" "cd /home/pi/Half-Life && ./xash3d -console"
}

function remove_hl() {
    rm /home/pi/Half-Life/*xash* /home/pi/Half-Life/client.* /home/pi/Half-Life/hl.*
}
