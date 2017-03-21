title: 全自动部署hexo
date: 2016-01-29 05:07:17
tags: [hexo, pm2, note]
---

全自动？ test -> done

提供几条思路供参考

代码统一托管于`git`主项目`hexo`分支,区分`gh-pages`

1. `git` `push`钩子
2. 脚本定时更新
3. 使用`pm2`守护监控文件变化，也可以


补充：2016年4月22日10:32:04

## `git` `push`钩子

### php 脚本，需要对应php执行者拥有操作权限

````
<?php
	/**
	 * GIT DEPLOYMENT SCRIPT
	 *
	 * Used for automatically deploying websites via github or bitbucket, more deets here:
	 *
	 *		https://gist.github.com/1809044
	 */

	// The commands
	$commands = array(
		'echo $PWD',
		'whoami',
		'git pull',
		'git status',
		'git submodule sync',
		'git submodule update',
		'git submodule status',
	);

	//laravel
	chdir('../');

	// Run the commands for output
	$output = '';
	foreach($commands AS $command){
		// Run it
		$tmp = shell_exec($command);
		// Output
		$output .= "<span style=\"color: #6BE234;\">\$</span> <span style=\"color: #729FCF;\">{$command}\n</span>";
		$output .= htmlentities(trim($tmp)) . "\n";
	}

	// Make it pretty for manual user access (and why not?)
?>
<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title>GIT DEPLOYMENT SCRIPT</title>
</head>
<body style="background-color: #000000; color: #FFFFFF; font-weight: bold; padding: 0 10px;">
<pre>
 .  ____  .    ____________________________
 |/      \|   |                            |
[| <span style="color: #FF0000;">&hearts;    &hearts;</span> |]  | Git Deployment Script v0.1 |
 |___==___|  /              &copy; oodavid 2012 |
              |____________________________|

<?php echo $output; ?>
</pre>
</body>
</html>

````


## 脚本定时更新

### 更新git代码

````
#!/bin/bash
cd /opt/www/rose1988c.github.io
whoami
git pull origin hexo
git status
#git submodule sync
#git submodule update
#git submodule status

git add .
git commit -m "auto update post"
git push origin hexo

echo "update ok!"

````

### 生成并发布

````
#!/bin/bash/env nodejs

cd /opt/www/rose1988c.github.io

export=/usr/local/bin:$PATH

/usr/local/bin/hexo g
/usr/local/bin/hexo d
echo "deploy ok !"
````

### 定时任务

````
52 * * * * (date && sh /opt/www/rose1988c.github.io/update.sh && sh /opt/www/rose1988c.github.io/deploy.sh ) >> /var/log/crontab/hexo.log 2>&1
````
