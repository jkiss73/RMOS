# ******************************************************************************************************************
# File : Makefile.mak
#
# Description: Make libaries for specified targets   
#
#  TARGET = provide one or list "c64 vic20 c128 be" 
#  BUILD_TYPE 	= specify either release or debug    
#  build-apps	= Build just the applications
#  build-clean  = Calls build-clean to all applications 
#
#  ex1 : make BUILD_TYPE=release TARGET=c64   			Release libraries build for the c64 target. Generates the header files
#  ex2 : make BUILD_TYPE=debug TARGET="c64 vic20"		Debug libraries build  for c64 and vic20.  Generates the header files
#  ex3 : make											This is an error, need to specify BUILD_TYPE and at least one TARGET
#  ex4 : make BUILD_TYPE=debug TARGET=c64 build-libs  	Debug libraries build for c64 target. No headers generated  
#
# Author(s) : John Kiss
#
# Copyright (c) 2026-Present, John Kiss All rights reserved.
# This source code is licensed under the BSD-style license found in the LICENSE file 
# in the root directory of this source tree.
# ******************************************************************************************************************
override TARGET := $(TARGET)
override BUILD_TYPE := $(BUILD_TYPE)

TOP=../..

include $(TOP)/config/$(TARGET).config
include $(TOP)/config/toolchain.config

.PHONY: all

all: build-apps

build-apps: 
	@for dirs in $(BUILD-APPS); do \
		make -C $$dirs BUILD_TYPE="$(BUILD_TYPE)" TARGET=$(TARGET); \
	done

build-clean:
	@for dirs in $(BUILD-APPS); do \
		make -C $$dirs BUILD_TYPE="$(BUILD_TYPE)" TARGET=$(TARGET) build-clean; \
	done

include $(TOP)/src/Makefile.rules