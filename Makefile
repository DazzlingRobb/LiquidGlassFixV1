ARCHS = arm64 arm64e
TARGET = iphone:clang:16.0:16.0
INSTALL_TARGET_PROCESSES = WeChat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassFixV1
LiquidGlassFixV1_FILES = Tweak.xm
LiquidGlassFixV1_CFLAGS = -fobjc-arc
LiquidGlassFixV1_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
