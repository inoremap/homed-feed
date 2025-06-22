include $(TOPDIR)/rules.mk

PKG_NAME:=homed-recorder
PKG_VERSION:=1.0.8
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/u236/homed-service-recorder.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=c1c85dd64de84a441b067c10bb891fb1c66acae4fc70868d9e250622e9384077

PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_DEPENDS:=qt5base qt5mqtt homed-common

TARGET_CXXFLAGS +=-I./homed-common

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/homed-recorder
  SECTION:=misc
  TITLE:=HOMEd Recorder Service
  URL:=https://wiki.homed.dev/page/Recorder
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
  DEPENDS:=+qt5base-core +qt5base-network +qt5base-sql +qt5base-plugin-sqldrivers-sqlite +qt5mqtt +homed-common
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	( [ -d "$(PKG_BUILD_DIR)/homed-common" ] || cp -av "$(STAGING_DIR)/usr/src/homed-common" "$(PKG_BUILD_DIR)/homed-common" )
	( sed -E -i 's|^include\(.+/([^/]+)\)|include(./homed-common/\1)|' "$(PKG_BUILD_DIR)/homed-recorder.pro" )
endef

define Package/homed-recorder/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR_ROOT)/usr/bin/* $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/luci/menu.d/luci-app-homed-recorder.json $(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/usr/share/rpcd/acl.d/luci-app-homed-recorder.json $(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/luci/www/luci-static/resources/view/homed/recorder.js $(1)/www/luci-static/resources/view/homed/

	$(INSTALL_DIR) $(1)/etc/homed
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/data/etc/homed/homed-recorder.conf $(1)/etc/homed/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/deploy/procd/homed-recorder $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/opt/homed-recorder
endef

$(eval $(call BuildPackage,homed-recorder))
