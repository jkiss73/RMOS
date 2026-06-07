# ******************************************************************************************************************
# File : Makefile.mak
#
# Description: Make specified sub-systems and targets   
#
#  TARGET = provide one or list "c64 vic20 c128 be" 
#  BUILD_TYPE = specify either release or debug    
#  build-kernel = Build just the kernel
#  build-apps   = Build just the apps and dependancies
#  build-libs   = Build just the libraries
#  build-test   = Build the test suite for the target(s)
#  build-clean  = Calls build-clean to all make subsystems
#
#  ex1 : make BUILD_TYPE=release TARGET=c64   			Kernel release build for the c64 target
#  ex2 : make BUILD_TYPE=debug TARGET="c64 vic20"		Kernel debug build for c64 and vic20
#  ex3 : make											This is an error, need to specify BUILD_TYPE and at least one TARGET
#  ex4 : make BUILD_TYPE=debug TARGET=c64 build-apps  	Apps debug build for c64 target  
#
# Author(s) : John Kiss
#
# Copyright (c) 2026-Present, John Kiss All rights reserved.
# This source code is licensed under the BSD-style license found in the LICENSE file 
# in the root directory of this source tree.
# ******************************************************************************************************************

override TARGET := $(TARGET)
override BUILD_TYPE := $(BUILD_TYPE)

build-kernel: 
	@for target in $(TARGET); do \
		make -C kernel BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target; \
	done

build-apps: build-libs
	@for target in $(TARGET); do \
		make -C apps BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target; \
	done

build-libs: 
	@for target in $(TARGET); do \
		make -C lib BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target; \
	done

build-test: 
	@for target in $(TARGET); do \
		make -C test BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target; \
	done

build-clean: 
	@for target in $(TARGET); do \
		make -C kernel BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target build-clean; \
		make -C apps BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target build-clean; \
		make -C lib BUILD_TYPE="$(BUILD_TYPE)" TARGET=$$target build-clean; \
	done


