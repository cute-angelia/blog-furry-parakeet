---
title: LEDE 安装 DLNA
tags: [lede, openwrt]
---

安装 dlna 让局域网电视机观看 lede 影片

### 安装

```
opkg update
opkg install minidlna

// 可选
opkg install luci-app-minidlna
```

### 配置文件

vim /etc/config/minidlna

```
#------------------------------------------------------#
# port for HTTP (descriptions, SOAP, media transfer) traffic
#------------------------------------------------------#
port=8200

#------------------------------------------------------#
# network interfaces to serve, comma delimited
#------------------------------------------------------#
network_interface=br-lan

#------------------------------------------------------#
# set this to the directory you want scanned.
# * if have multiple directories, you can have multiple media_dir= lines
# * if you want to restrict a media_dir to a specific content type, you
#   can prepend the type, followed by a comma, to the directory:
#   + "A" for audio  (eg. media_dir=A,/home/jmaggard/Music)
#   + "V" for video  (eg. media_dir=V,/home/jmaggard/Videos)
#   + "P" for images (eg. media_dir=P,/home/jmaggard/Pictures)
#------------------------------------------------------#
# Directory of media is depend on your storage
#------------------------------------------------------#
media_dir=/mnt/sdb2/downloads
media_dir=/mnt/sda3/downloads
#------------------------------------------------------#
# set this if you want to customize the name that shows up on your clients
#------------------------------------------------------#
friendly_name=DLNA Server

#------------------------------------------------------#
# set this if you would like to specify the directory where you want MiniDLNA to store its database and album art cache
#------------------------------------------------------#
db_dir=/var/run/minidlna

#------------------------------------------------------#
# set this if you would like to specify the directory where you want MiniDLNA to store its log file
#------------------------------------------------------#
log_dir=/var/log/minidlna

#------------------------------------------------------#
# this should be a list of file names to check for when searching for album art
# note: names should be delimited with a forward slash ("/")
#------------------------------------------------------#
album_art_names=Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg

#------------------------------------------------------#
# set this to no to disable inotify monitoring to automatically discover new files
# note: the default is yes
#------------------------------------------------------#
inotify=yes

#------------------------------------------------------#
# set this to yes to enable support for streaming .jpg and .mp3 files to a TiVo supporting HMO
#------------------------------------------------------#
enable_tivo=no

#------------------------------------------------------#
# set this to strictly adhere to DLNA standards.
# * This will allow server-side downscaling of very large JPEG images,
#   which may hurt JPEG serving performance on (at least) Sony DLNA products.
#------------------------------------------------------#
strict_dlna=no

#------------------------------------------------------#
# default presentation url is http address on port 80
#------------------------------------------------------#
presentation_url=http://192.168.1.1:8200/

#------------------------------------------------------#
# notify interval in seconds. default is 895 seconds.
#------------------------------------------------------#
notify_interval=900

#------------------------------------------------------#
# serial and model number the daemon will report to clients
# in its XML description
#------------------------------------------------------#
serial=12345678
model_number=1

#------------------------------------------------------#
# specify the path to the MiniSSDPd socket
#------------------------------------------------------#
#minissdpdsocket=/var/run/minissdpd.sock

#------------------------------------------------------#
# use different container as root of the tree
# possible values:
#   + "." - use standard container (this is the default)
#   + "B" - "Browse Directory"
#   + "M" - "Music"
#   + "V" - "Video"
#   + "P" - "Pictures"
# if you specify "B" and client device is audio-only then "Music/Folders" will be used as root
#------------------------------------------------------#
#root_container=.

```

### 启动

```
minidlna -f /etc/config/minidlna
```

### 其他

如果 `opkg update` 不了，修改源

```
cp /etc/opkg/distfeeds.conf /etc/opkg/distfeeds_bak.conf
vim /etc/opkg/distfeeds.conf
```

源地址

```
src/gz openwrt_koolshare_mod_core http://openwrt.rinvay.cc/snapshots/targets/x86/64/packages
src/gz openwrt_koolshare_mod_base http://openwrt.rinvay.cc/snapshots/packages/x86_64/base
src/gz openwrt_koolshare_mod_luci http://openwrt.rinvay.cc/snapshots/packages/x86_64/luci
src/gz openwrt_koolshare_mod_packages http://openwrt.rinvay.cc/snapshots/packages/x86_64/packages
src/gz openwrt_koolshare_mod_routing http://openwrt.rinvay.cc/snapshots/packages/x86_64/routing
src/gz openwrt_koolshare_mod_telephony http://openwrt.rinvay.cc/snapshots/packages/x86_64/telephony
```
