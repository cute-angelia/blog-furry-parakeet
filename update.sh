#!/bin/bash
cd /data/www/furry-parakeet
whoami

git fetch --all
git reset --hard origin/master

echo "update ok!"

/usr/local/bin/hexo g && /usr/local/bin/hexo d
echo "deploy ok !"