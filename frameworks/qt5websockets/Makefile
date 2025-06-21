include $(TOPDIR)/rules.mk
-include $(STAGING_DIR)/host/mk/qt-common.mk

PKG_NAME:=qt5websockets
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://invent.kde.org/qt/qt/qtwebsockets.git
PKG_SOURCE_BRANCH_REF:=kde/5.15
PKG_SOURCE_DATE:=$(QTC_SOURCE_DATE)
PKG_SOURCE_VERSION:=db9cb84499229143506a9692fc65d3cb223b3978
PKG_MIRROR_HASH:=4db2383f0ca919da39dc347073298c25f6783bc81a121e93498e62a6ecbcdd20

PKG_VERSION:=$(QTC_VERSION)-$(PKG_SOURCE_DATE)~$(call version_abbrev,$(PKG_SOURCE_VERSION))
PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/qt5websockets
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Libraries
  TITLE:=Qt5WebSockets
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

define Package/qt5websockets/install
	$(call Build/Install/Libs,$(1),libQt5WebSockets)
endef

$(eval $(call BuildPackage,qt5websockets))
