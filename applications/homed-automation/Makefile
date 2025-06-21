include $(TOPDIR)/rules.mk

PKG_NAME:=homed-automation
PKG_VERSION:=2.0.7
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/u236/homed-service-automation.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=b2034498046f9990f56dfd4390874f522750ae7647c8dc40c150d1e563f3f9a0

PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base qt5mqtt homed-common

TARGET_CXXFLAGS +=-I./homed-common

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/homed-automation
  SECTION:=misc
  TITLE:=HOMEd Automation Service
  URL:=https://wiki.homed.dev/page/Automation
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core +qt5base-network +qt5mqtt +homed-common
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	( [ -d "$(PKG_BUILD_DIR)/homed-common" ] || cp -av "$(STAGING_DIR)/usr/src/homed-common" "$(PKG_BUILD_DIR)/homed-common" )
	( sed -E -i 's|^include\(.+/([^/]+)\)|include(./homed-common/\1)|' "$(PKG_BUILD_DIR)/homed-automation.pro" )
endef

define Package/homed-automation/install
	$(INSTALL_DIR) $(1)/usr
	$(CP) $(PKG_INSTALL_DIR_ROOT)/usr/* $(1)/usr/

	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/luci/menu.d/luci-app-homed-automation.json $(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/rpcd/acl.d/luci-app-homed-automation.json $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/www/luci-static/resources/view/homed/automation.js $(1)/www/luci-static/resources/view/homed/

	$(INSTALL_DIR) $(1)/etc/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/data/etc/homed/homed-automation.conf $(1)/etc/homed/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/deploy/procd/homed-automation $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/opt/homed-automation
endef

$(eval $(call BuildPackage,homed-automation))
