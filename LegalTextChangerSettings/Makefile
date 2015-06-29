ARCHS = armv7 arm64
TARGET = iphone:clang::8.1
SDKVERSION = 8.1

include /var/theos/makefiles/common.mk

BUNDLE_NAME = LegalTextChangerSettings
LegalTextChangerSettings_FILES = LegalTextChangerSettings.mm
LegalTextChangerSettings_INSTALL_PATH = /Library/PreferenceBundles
LegalTextChangerSettings_FRAMEWORKS = UIKit
LegalTextChangerSettings_PRIVATE_FRAMEWORKS = Preferences

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include /var/theos/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LegalTextChangerSettings.plist$(ECHO_END)
