#!/bin/bash/env nodejs

cd /opt/www/rose1988c.github.io

export=/usr/local/bin:$PATH

/usr/local/bin/hexo g 
/usr/local/bin/hexo d
echo "deploy ok !"
