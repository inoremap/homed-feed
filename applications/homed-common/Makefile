include $(TOPDIR)/rules.mk

PKG_NAME:=homed-common
PKG_VERSION:=1.0.15
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/u236/homed-service-common.git
PKG_SOURCE_VERSION:=$(PKG_VERSION)
PKG_MIRROR_HASH:=8cfe897011b9ebf06375d850a49f11d1aab123dcb8806aaaacddac394eda8d41

PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
#PKG_BUILD_DEPENDS:=qt5base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
#-include $(STAGING_DIR)/host/mk/qmake.mk

define Package/homed-common
  SECTION:=misc
  TITLE:=HOMEd Services Common Files
  URL:=https://wiki.homed.dev
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
#  DEPENDS:=+qt5base-core
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	( sed -i 's/^QMAKE_POST_LINK/# QMAKE_POST_LINK/' "$(PKG_BUILD_DIR)/homed-common.pri" )
endef

define Build/Configure
endef

define Build/Compile
endef

define Build/Install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/src/homed-common
	$(CP) $(PKG_BUILD_DIR)/*.{h,cpp,pri} $(1)/usr/src/homed-common/
endef

define Package/homed-common/install
	$(INSTALL_DIR) $(1)/usr/share/homed-common
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/deploy/data/usr/share/homed-common/expose.json $(1)/usr/share/homed-common/
endef

$(eval $(call BuildPackage,homed-common))
