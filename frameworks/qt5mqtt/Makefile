include $(TOPDIR)/rules.mk
-include $(STAGING_DIR)/host/mk/qt-common.mk

PKG_NAME:=qt5mqtt
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://invent.kde.org/qt/qt/qtmqtt.git
PKG_SOURCE_BRANCH_REF:=5.15.2
PKG_SOURCE_DATE:=$(QTC_SOURCE_DATE)
PKG_SOURCE_VERSION:=cade213f562049400da81e60762400df68d7c56b
PKG_MIRROR_HASH:=b56cbb2f4d1efcfdc404dee35bc415e687ea5d304091fc7d825561caf6c7ab2f

PKG_VERSION:=5.15.2-$(PKG_SOURCE_DATE)~$(call version_abbrev,$(PKG_SOURCE_VERSION))
PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/qt5mqtt
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Libraries
  TITLE:=Qt5Mqtt
  URL:=https://invent.kde.org/qt
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core +qt5base-network
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

define Package/qt5mqtt/install
	$(call Build/Install/Libs,$(1),libQt5Mqtt)
endef

$(eval $(call BuildPackage,qt5mqtt))
