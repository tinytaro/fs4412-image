#!/bin/bash
packages=build-essential man-db gdb git vim wget cmake ninja-build
apt update
apt install -y ${packages}
