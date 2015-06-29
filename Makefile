export GO_EASY_ON_ME = 1

export ARCHS = armv7 arm64
export TARGET = iphone:clang::8.1
export SDKVERSION = 8.1

include /var/theos/makefiles/common.mk

TWEAK_NAME = LegalTextChanger
LegalTextChanger_FILES = Tweak.xm
LegalTextChanger_FRAMEWORKS = Foundation CoreFoundation UIKit
ADDITIONAL_OBJCFLAGS = -fobjc-arc
SUBPROJECTS = LegalTextChangerSettings

include /var/theos/makefiles/tweak.mk
include /var/theos/makefiles/aggregate.mk

after-install::
	install.exec "killall -9 backboardd"
