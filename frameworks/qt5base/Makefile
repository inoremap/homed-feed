#
# Copyright (C) 2020 OpenWrt.org
# Author: Mirko Vogt <mirko-openwrt@nanl.de>
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# TODO / known bugs:
# - plugins don't work when sstrip is used for stripping
# - no X11/wayland/xcb/kms support so far - primary target is linuxfb

include $(TOPDIR)/rules.mk
include ./files/qt-common.mk

PKG_NAME:=qt5base
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://invent.kde.org/qt/qt/qtbase.git
PKG_SOURCE_BRANCH_REF:=kde/5.15
PKG_SOURCE_DATE:=$(QTC_SOURCE_DATE)
PKG_SOURCE_VERSION:=c5b9db065ca5682b0bee339197c847da8b2710c1
PKG_MIRROR_HASH:=123aaeed550194faa6194eccf3217231575012ec0607ae70c39c6f47b9cdd2bc

PKG_VERSION:=$(QTC_VERSION)-$(PKG_SOURCE_DATE)~$(call version_abbrev,$(PKG_SOURCE_VERSION))
PKG_SYS_NAME:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SYS_NAME)
HOST_BUILD_DIR=$(BUILD_DIR)/host/$(PKG_SYS_NAME)
PKG_BUILD_PARALLEL:=1
HOST_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_BUILD_FLAGS:=no-mips16
# Yes, the host build depends on the target build. This is not a mistake!
# The target build provides the (target specific) qmake.mk file which
# is also used for host builds.
# Host projects depend on qt5base/host which however don't build
# if qt5base didn't install the qmake.mk file before.
# Benefit of the target build providing qmake.mk instead of the host build
# is that the host build really only needs to be built, if there're targets
# which actually depend on it. At the time of this writing, only qt5tools
# makes use of the host build.
HOST_BUILD_DEPENDS:=qt5base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/nls.mk
include ./files/qmake.mk

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_qt5base-network \

# Do not use sstrip for QT5. When sstrip is used the QT5 plugin loading does
# not work, because of QT''s internal elf parser, see
# https://bugreports.qt.io/browse/QTBUG-52567
# Use the code from the gcc package to use strip instaed.
ifneq ($(CONFIG_USE_SSTRIP),)
  STRIP:=$(TARGET_CROSS)strip $(call qstrip,$(CONFIG_STRIP_ARGS))
  RSTRIP:= \
    export CROSS="$(TARGET_CROSS)" \
		$(if $(CONFIG_KERNEL_KALLSYMS),NO_RENAME=1) \
		$(if $(CONFIG_KERNEL_PROFILING),KEEP_SYMBOLS=1); \
    NM="$(TARGET_CROSS)nm" \
    STRIP="$(STRIP)" \
    STRIP_KMOD="$(SCRIPT_DIR)/strip-kmod.sh" \
    $(SCRIPT_DIR)/rstrip.sh
endif

define Package/qt5base/Default
  SECTION:=libs
  CATEGORY:=Libraries
  SUBMENU:=Libraries
  TITLE:=Qt5Base
  URL:=https://invent.kde.org/qt
  MAINTAINER:=inoremap <inoremap@middle.of.nowhere>
endef

#define Package/qt5base-concurrent
#  $(call Package/qt5base/Default)
#  TITLE+=concurrent
#  DEPENDS+=+qt5base-core
#endef

define Package/qt5base-core
  $(call Package/qt5base/Default)
  TITLE+=core
  DEPENDS+=+libpthread +libpcre2-16 +libstdcpp +libatomic $(ICONV_DEPENDS)
endef

define Package/qt5base-network
  $(call Package/qt5base/Default)
  TITLE+=network
  DEPENDS+=+qt5base-core +libopenssl
endef

define Package/qt5base-sql
  $(call Package/qt5base/Default)
  TITLE+=sql
  DEPENDS+=+qt5base-core
endef

#define Package/qt5base-test
#  $(call Package/qt5base/Default)
#  TITLE+=test
#  DEPENDS+=+qt5base-core
#endef

#define Package/qt5base-xml
#  $(call Package/qt5base/Default)
#  TITLE+=xml
#  DEPENDS+=+qt5base-core
#endef

#### plugins

###### sql

define Package/qt5base-plugin-sqldrivers-sqlite
  $(call Package/qt5base/Default)
  TITLE+=sqldriver sqlite (plugin)
  DEPENDS+=+qt5base-core +qt5base-sql +libsqlite3
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) \
		./files/mkspecs/linux-openwrt-g++ \
		$(PKG_BUILD_DIR)/mkspecs/

	( cd $(PKG_BUILD_DIR) ; ./bin/syncqt.pl -version $(QTC_VERSION) )
endef

# TARGET_CFLAGS += \
# 	  -I$(STAGING_DIR)/usr/include/freetype2 \
# 	  -I$(STAGING_DIR)/usr/include/libdrm

define Build/Configure
	# CROSS/TARGET_* need to be passed to configure, in order to use cross-compiling tools to check for requirements.
	# Usually used variables such as CC/CXX/CFLAGS/CXXFLAGS/LDFLAGS would be used for compilation of host tools (qmake, moc, etc.),
	# hence we use the TARGET_* nomenclature.
	( cd $(PKG_BUILD_DIR) ; \
		TARGET_CROSS="$(TARGET_CROSS)" \
		TARGET_CFLAGS="$(TARGET_CFLAGS)" \
		TARGET_CXXFLAGS="$(TARGET_CFLAGS) $(TARGET_CXXFLAGS)" \
		TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
		./configure \
			--prefix=$(QT_INSTALL_PREFIX) \
			--extprefix=$(QT_EXTPREFIX) \
			--hostprefix=$(QT_HOST_PREFIX) \
			--gcc-sysroot=no \
			--bindir=$(QT_INSTALL_BINS) \
			--headerdir=$(QT_INSTALL_HEADERS) \
			--libdir=$(QT_INSTALL_LIBS) \
			--archdatadir=$(QT_INSTALL_ARCHDATA) \
			--plugindir=$(QT_INSTALL_PLUGINS) \
			--libexecdir=$(QT_INSTALL_LIBEXECS) \
			--importdir=$(QT_INSTALL_IMPORTS) \
			--qmldir=$(QT_INSTALL_QML) \
			--datadir=$(QT_INSTALL_DATA) \
			--docdir=$(QT_INSTALL_DOCS) \
			--translationdir=$(QT_INSTALL_TRANSLATIONS) \
			--sysconfdir=$(QT_INSTALL_CONFIGURATION) \
			--examplesdir=$(QT_INSTALL_EXAMPLES) \
			--testsdir=$(QT_INSTALL_TESTS) \
			--hostbindir=$(QT_HOST_BINS) \
			--hostlibdir=$(QT_HOST_LIBS) \
			--hostdatadir=$(QT_HOST_DATA) \
			--c++std=c++17 \
			--verbose=yes \
			--opensource \
			--confirm-license \
			--release=yes \
			--optimized-tools=no \
			--optimize-size=yes \
			--strip=no \
			--shared=yes \
			--framework=no \
			--xplatform=linux-openwrt-g++ \
			--reduce-exports=yes \
			--reduce-relocations=no \
			--pch=no \
			--ltcg=no \
			--use-gold-linker=no \
			--warnings-are-errors=no \
			--pkg-config=yes \
			--compile-examples=no \
			--nomake=examples \
			--nomake=tests \
			--gui=no \
			--widgets=no \
			--dbus=no \
			--accessibility=no \
			--doubleconversion=qt \
			--glib=no \
			--eventfd=no \
			--inotify=no \
			--iconv=$(if $(CONFIG_BUILD_NLS),$(if $(CONFIG_LIBC_USE_GLIBC)$(CONFIG_LIBC_USE_MUSL),posix)$(if $(CONFIG_LIBC_USE_UCLIBC),gnu),no) \
			--icu=no \
			--pcre=system \
			--zlib=no \
			--zstd=no \
			--journald=no \
			--syslog=no \
			--ssl=$(if $(CONFIG_PACKAGE_qt5base-network),yes,no) \
			$(if $(CONFIG_PACKAGE_qt5base-network),--openssl-linked,) \
			--libproxy=no \
			--system-proxies=yes \
			--cups=no \
			--fontconfig=no \
			--freetype=no \
			--harfbuzz=no \
			--gtk=no \
			--opengl=no \
			--opengles3=no \
			--egl=no \
			--xcb-xlib=no \
			--directfb=no \
			--eglfs=no \
			--gbm=no \
			--linuxfb=no \
			--xcb=no \
			\
			--libudev=no \
			--evdev=no \
			--libinput=no \
			--mtdev=no \
			--tslib=no \
			--bundled-xcb-xinput=no \
			--xkbcommon=no \
			--gif=no \
			--ico=no \
			--libjpeg=no \
			--libpng=no \
			--sql-db2=no \
			--sql-ibase=no \
			--sql-mysql=no \
			--sql-oci=no \
			--sql-odbc=no \
			--sql-psql=no \
			--sql-sqlite=yes \
			--sql-sqlite2=no \
			--sql-tds=no \
			--sqlite=system \
	)
endef


define Host/Configure
	# CROSS/TARGET_* need to be passed to configure, in order to use cross-compiling tools to check for requirements.
	# Usually used variables such as CC/CXX/CFLAGS/CXXFLAGS/LDFLAGS would be used for compilation of host tools (qmake, moc, etc.),
	# hence we use the TARGET_* nomenclature.
	( cd $(HOST_BUILD_DIR) ; \
		TARGET_CFLAGS="$(HOST_CFLAGS)" \
		TARGET_CXXFLAGS="$(HOST_CFLAGS) $(HOST_CXXFLAGS)" \
		TARGET_LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
			--prefix=$(STAGING_DIR_HOST) \
			--hostprefix=$(STAGING_DIR_HOST) \
			--hostdatadir=$(STAGING_DIR_HOST)/share \
			--datadir=$(STAGING_DIR_HOST)/share \
			--archdatadir=$(STAGING_DIR_HOST)/lib \
			--gcc-sysroot=no \
			--verbose=yes \
			--opensource \
			--confirm-license \
			--release=yes \
			--optimized-tools=no \
			--optimize-size=no \
			--strip=no \
			--shared=yes \
			--framework=no \
			--reduce-exports=no \
			--reduce-relocations=no \
			--pch=no \
			--ltcg=no \
			--use-gold-linker=no \
			--warnings-are-errors=no \
			--pkg-config=yes \
			--compile-examples=no \
			--make=libs \
			--nomake=tools \
			--nomake=examples \
			--gui=yes \
			--widgets=no \
			--dbus=no \
			--accessibility=no \
			--doubleconversion=qt \
			--glib=no \
			--eventfd=no \
			--inotify=no \
			--iconv=no \
			--icu=no \
			--pcre=qt \
			--zlib=qt \
			--journald=no \
			--syslog=no \
			--ssl=no \
			--libproxy=no \
			--system-proxies=no \
			--cups=no \
			--fontconfig=no \
			--freetype=no \
			--harfbuzz=no \
			--gtk=no \
			--opengl=no \
			--opengles3=no \
			--egl=no \
			--xcb-xlib=no \
			--directfb=no \
			--eglfs=no \
			--gbm=no \
			--linuxfb=no \
			--xcb=no \
			\
			--libudev=no \
			--evdev=no \
			--libinput=no \
			--mtdev=no \
			--tslib=no \
			--bundled-xcb-xinput=no \
			--xkbcommon=yes \
			--gif=no \
			--ico=no \
			--libjpeg=no \
			--libpng=no \
			--sql-db2=no \
			--sql-ibase=no \
			--sql-mysql=no \
			--sql-oci=no \
			--sql-odbc=no \
			--sql-psql=no \
			--sql-sqlite=no \
			--sql-sqlite2=no \
			--sql-tds=no \
			--sqlite=no \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) \
		$(STAGING_DIR)/host/mk

	$(CP) \
		./files/qmake.mk \
		$(STAGING_DIR)/host/mk/

	$(CP) \
		./files/qt-common.mk \
		$(STAGING_DIR)/host/mk/

	$(call Build/Install/HostFiles,$(1))
	$(call Build/Install/Headers,$(1))
	$(call Build/Install/Libs,$(1),*)
endef

define Host/Install
	$(call Host/Install/Default)

	$(INSTALL_DIR) \
	  $(STAGING_DIR_HOST)/bin \
	  $(STAGING_DIR_HOST)/lib \
	  $(STAGING_DIR_HOST)/include \
	  $(STAGING_DIR_HOST)/share

	$(CP) \
	  $(HOST_INSTALL_DIR)/lib/* \
	  $(STAGING_DIR_HOST)/lib/

	$(CP) \
	  $(HOST_INSTALL_DIR)/include/* \
	  $(STAGING_DIR_HOST)/include/

	$(CP) \
	  $(HOST_INSTALL_DIR)/share/* \
	  $(STAGING_DIR_HOST)/share/

	$(CP) \
	  $(HOST_INSTALL_DIR)/bin/* \
	  $(STAGING_DIR_HOST)/bin/
endef

#define Package/qt5base-concurrent/install
#	$(call Build/Install/Libs,$(1),libQt5Concurrent)
#endef

define Package/qt5base-core/install
	$(call Build/Install/Libs,$(1),libQt5Core)
endef

define Package/qt5base-network/install
	$(call Build/Install/Libs,$(1),libQt5Network)
endef

define Package/qt5base-sql/install
	$(call Build/Install/Libs,$(1),libQt5Sql)
endef

#define Package/qt5base-test/install
#	$(call Build/Install/Libs,$(1),libQt5Test)
#endef

#define Package/qt5base-xml/install
#	$(call Build/Install/Libs,$(1),libQt5Xml)
#endef

define Package/qt5base-plugin-sqldrivers-sqlite/install
	$(call Build/Install/Plugins,$(1),sqldrivers,libqsqlite)
endef

#$(eval $(call BuildPackage,qt5base-concurrent))
$(eval $(call BuildPackage,qt5base-core))
$(eval $(call BuildPackage,qt5base-network))
$(eval $(call BuildPackage,qt5base-sql))
#$(eval $(call BuildPackage,qt5base-test))
#$(eval $(call BuildPackage,qt5base-xml))
$(eval $(call BuildPackage,qt5base-plugin-sqldrivers-sqlite))
$(eval $(call HostBuild))
