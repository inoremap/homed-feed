# HOMEd feed

## Description

This is an OpenWrt package feed containing Qt libraries and HOMEd applications.

## Usage

To use these packages, add the following line to the feeds.conf
in the OpenWrt buildroot:

```
src-git homed https://github.com/inoremap/homed-feed.git
```

This feed should be included and enabled by default in the OpenWrt buildroot. To install all its package definitions, run:

```
./scripts/feeds update homed
./scripts/feeds install -a -p homed
```

The HOMEd packages should now appear in menuconfig.
