title: ubuntu-dpkg-warning-missing
date: 2014-10-27 03:40:46
tags: ubuntu
---

## dpkg: warning: files list file for package `*****'

装软件的时候总是提示dpkg: warning: files list file for package `*****' missing, assuming package has no files currently installed，导致无法安装任何软件

解决办法：

````
#!/bin/bash
set -e

# Clean out /var/cache/apt/archives
apt-get clean
# Fill it with all the .debs we need
apt-get --reinstall -dy install $(dpkg --get-selections | grep '[[:space:]]install' | cut -f1)

DIR=$(mktemp -d -t info-XXXXXX)
for deb in /var/cache/apt/archives/*.deb
do
    # Move to working directory
    cd "$DIR"
    # Create DEBIAN directory
    mkdir -p DEBIAN
    # Extract control files
    dpkg-deb -e "$deb"
    # Extract file list, fixing up the leading ./ and turning / into /.
    dpkg-deb -c "$deb" | awk '{print $NF}' | cut -c2- | sed -e 's/^\/$/\/./' > DEBIAN/list
    # Figure out binary package name
    DEB=$(basename "$deb" | cut -d_ -f1)
    # Copy each control file into place
    cd DEBIAN
    for file in *
    do
        cp -a "$file" /var/lib/dpkg/info/"$DEB"."$file"
    done
    # Clean up
    cd ..
    rm -rf DEBIAN
done
rmdir "$DIR"
````

原理是重新下载所有安装过的软件包，然后从中提取文件列表信息复制到info文件夹里。（所以请在网速较好的时候使用）
[原文](http://blog.sina.com.cn/s/blog_82fc65ea0101k1pz.html)
