include $(TOPDIR)/rules.mk
-include $(STAGING_DIR)/host/mk/qt-common.mk

PKG_NAME:=qt5serialport
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://invent.kde.org/qt/qt/qtserialport.git
PKG_SOURCE_BRANCH_REF:=kde/5.15
PKG_SOURCE_DATE:=$(QTC_SOURCE_DATE)
PKG_SOURCE_VERSION:=9bb2b66259413ac4eda1ddf64209ef44412aa55d
PKG_MIRROR_HASH:=d8008af5765fe26d594704481b3e46d427432550f192c465b544906aedd1e966

PKG_VERSION:=$(QTC_VERSION)-$(PKG_SOURCE_DATE)~$(call version_abbrev,$(PKG_SOURCE_VERSION))
PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/qt5serialport
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Libraries
  TITLE:=Qt5SerialPort
  URL:=https://invent.kde.org/qt
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	( cd $(PKG_BUILD_DIR) ; syncqt.pl -version $(QTC_VERSION) )
endef

define Build/InstallDev
	$(call Build/Install/HostFiles,$(1))
	$(call Build/Install/Headers,$(1))
	$(call Build/Install/Libs,$(1),*)
endef

define Package/qt5serialport/install
	$(call Build/Install/Libs,$(1),libQt5SerialPort)
endef

$(eval $(call BuildPackage,qt5serialport))
