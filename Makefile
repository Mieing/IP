TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = IP

IP_FILES = main.m
IP_CFLAGS = -fobjc-arc
IP_CODESIGN_FLAGS = -Sentitlements.plist
IP_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk
