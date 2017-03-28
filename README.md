## Blog by chenyunwen.cn
 
[chenyunwen.cn](http://chenyunwen.cn)

### 初始设置

````
git config --global user.name "hexo"
git config --global user.email "rose20.99.c@gmail.com"

npm install hexo-cli -g
npm install hexo-deployer-git --save
npm install
````


### update hexo

````
cp _config.yml _config.yml.bak
rm package.json -f
hexo init
npm install
npm install hexo-deployer-git --save
cp _config.yml.bak _config.yml -f
rm source/_posts/hello-world.md -f
````

### crontab

````
52 * * * * (date && sh /opt/www/blog/update.sh) >> /var/log/hexo.log 2>&1
0 3 * * *  rm /var/log/hexo.log
````