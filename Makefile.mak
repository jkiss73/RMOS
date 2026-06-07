# ******************************************************************************************************************
# File : Makefile.mak
#
# Description: Make for all or specified targets & sub-systems   
#
#  TARGET = default is all or specify one or list "c64 vic20 c128 be" default is all targets 
#  BUILD_TYPE = release or debug  - Debug is the default if not specified  
#  build-kernel = Build just the kernel
#  build-clean  = Calls build-clean for all subsystem compoenents and removes the build directory
#
#  ex1 : make BUILD_TYPE=release              	Release build for all targets
#  ex4 : make									Debug system build for all targets
#  ex5 : make build-clean						Cleans up all target builds and removes the build dir

# Author(s) : John Kiss
#
# Copyright (c) 2026-Present, John Kiss All rights reserved.
# This source code is licensed under the BSD-style license found in the LICENSE file 
# in the root directory of this source tree.
# ******************************************************************************************************************

#TARGET ?= c64 vic20 c128 be
TARGET ?= c64
BUILD_TYPE ?= debug

.PHONY: build-kernel 

all: build-clean build-kernel 

build-kernel: build-dir
		make -C src BUILD_TYPE="$(BUILD_TYPE)" TARGET="$(TARGET)" build-kernel

build-dir:
	mkdir -p build

build-clean:
	make -C src BUILD_TYPE="$(BUILD_TYPE)" TARGET="$(TARGET)" build-clean
	rm -rf build

dist-clean:	
	rm -rf build

