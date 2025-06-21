include $(TOPDIR)/rules.mk

PKG_NAME:=homed-zigbee
PKG_VERSION:=3.9.10
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/u236/homed-service-zigbee.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=294f26f0ef43b78d42fd53a569499717f88eff0dfd650d33d469a9383d81554d

PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base qt5serialport qt5mqtt homed-common

TARGET_CXXFLAGS +=-I./homed-common

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/homed-zigbee
  SECTION:=misc
  TITLE:=HOMEd ZigBee Service
  URL:=https://wiki.homed.dev/page/ZigBee
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core +qt5serialport +qt5base-network +qt5mqtt +homed-common
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	( [ -d "$(PKG_BUILD_DIR)/homed-common" ] || cp -av "$(STAGING_DIR)/usr/src/homed-common" "$(PKG_BUILD_DIR)/homed-common" )
	( sed -E -i 's|^include\(.+/([^/]+)\)|include(./homed-common/\1)|' "$(PKG_BUILD_DIR)/homed-zigbee.pro" )
endef

define Package/homed-zigbee/install
	$(INSTALL_DIR) $(1)/usr
	$(CP) $(PKG_INSTALL_DIR_ROOT)/usr/* $(1)/usr/

	$(INSTALL_DIR) $(1)/etc/homed
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/deploy/data/etc/homed/homed-zigbee.conf $(1)/etc/homed

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/deploy/procd/homed-zigbee $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/luci/menu.d/luci-app-homed-zigbee.json $(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/rpcd/acl.d/luci-app-homed-zigbee.json $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/www/luci-static/resources/view/homed/zigbee.js $(1)/www/luci-static/resources/view/homed/

	$(INSTALL_DIR) $(1)/opt/homed-zigbee
endef

$(eval $(call BuildPackage,homed-zigbee))
