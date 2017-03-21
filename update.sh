#!/bin/bash
cd /data/www/blog
whoami

git fetch --all
git reset --hard origin/hexo

echo "update ok!"

/usr/local/bin/hexo g && /usr/local/bin/hexo d
echo "deploy ok !"
