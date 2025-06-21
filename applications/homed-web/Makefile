include $(TOPDIR)/rules.mk

PKG_NAME:=homed-web
PKG_VERSION:=2.6.4
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/u236/homed-service-web.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=0c043be6e9ddcc63fac8a84dea6f98c219900f608f931cda14580cdb086a8201

PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base qt5websockets qt5mqtt homed-common

TARGET_CXXFLAGS +=-I./homed-common

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/homed-web
  SECTION:=misc
  TITLE:=HOMEd Web Service
  URL:=https://wiki.homed.dev/page/Web
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core +qt5base-network +qt5websockets +qt5mqtt +homed-common
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	( [ -d "$(PKG_BUILD_DIR)/homed-common" ] || cp -av "$(STAGING_DIR)/usr/src/homed-common" "$(PKG_BUILD_DIR)/homed-common" )
	( sed -E -i 's|^include\(.+/([^/]+)\)|include(./homed-common/\1)|' "$(PKG_BUILD_DIR)/homed-web.pro" )
endef

define Package/homed-web/install
	$(INSTALL_DIR) $(1)/usr
	$(CP) $(PKG_INSTALL_DIR_ROOT)/usr/* $(1)/usr/

	$(INSTALL_DIR) $(1)/usr/share
	$(CP) $(PKG_BUILD_DIR)/deploy/data/usr/share/homed-web $(1)/usr/share/

	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/luci/menu.d/luci-app-homed-web.json $(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/rpcd/acl.d/luci-app-homed-web.json $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/www/luci-static/resources/view/homed/web.js $(1)/www/luci-static/resources/view/homed/

	$(INSTALL_DIR) $(1)/etc/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/data/etc/homed/homed-web.conf $(1)/etc/homed/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/deploy/procd/homed-web $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/opt/homed-web
endef

$(eval $(call BuildPackage,homed-web))
