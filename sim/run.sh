#!/bin/bash

set -e #exit on error

cd "$(dirname "$0")"

BUILD_DIR="build"
mkdir -p $BUILD_DIR

SRC_DIR="../src"
TB="fifo_tb.v"
TOP="fifo.v"

iverilog -o $BUILD_DIR/fifo_tb $SRC_DIR/$TOP $TB
vvp $BUILD_DIR/fifo_tb
