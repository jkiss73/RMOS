# ******************************************************************************************************************
# File : Makefile.mak
#
# Description: Make libaries for specified targets   
#
#  TARGET = provide one or list "c64 vic20 c128 be" 
#  BUILD_TYPE 	= specify either release or debug    
#  build-libs	= Build just the libraries
#  gen-headers 	= Geneate just the header files from a kernel listing
#  build-clean  = Calls build-clean to all libaries 
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

include $(TOP)/config/system.config
include $(TOP)/config/$(TARGET).config

TARGET_BUILD_DIR = $(TOP)/build/$(TARGET)

TARGET_KERNEL_LISTING = $(TARGET_BUILD_DIR)/kernel.lst
TARGET_TEMPLATE_FILE = $(TOP)/include/kapi-common.tpl 
TARGET_INCLUDE_DIR = $(TOP)/include/$(TARGET)
TARGET_OUTPUT_HDR = $(TARGET_INCLUDE_DIR)/kapi-gen


.PHONY: all

all: gen-headers build-libs

build-libs:
	@for dirs in $(BUILD-LIBS); do \
		make -C $$dirs BUILD_TYPE="$(BUILD_TYPE)" TARGET=$(TARGET); \
	done

gen-headers:
	@echo "Generating header files for target " $(TARGET)
	python $(TOP)/tools/list2def.py -l $(TARGET_KERNEL_LISTING) -t $(TARGET_TEMPLATE_FILE) -o $(TARGET_OUTPUT_HDR).inc -sv $(OS_VERSION) -kv $(KERNEL_VERSION)
	python $(TOP)/tools/list2def.py -ch -l $(TARGET_KERNEL_LISTING) -t $(TARGET_TEMPLATE_FILE) -o $(TARGET_OUTPUT_HDR).h -sv $(OS_VERSION) -kv $(KERNEL_VERSION)

build-clean:
	@for dirs in $(BUILD-LIBS); do \
		make -C $$dirs BUILD_TYPE="$(BUILD_TYPE)" TARGET=$(TARGET) build-clean; \
	done

