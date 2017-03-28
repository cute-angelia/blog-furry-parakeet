title: apache 访问使用另外一个工作空间项目
date: 2014-01-28 15:35:55
tags: [apache]
---

## DocumentRoot 主站网页存储位置

一般`apache`默认一个`DocumentRoot`。多个`workspace` 如 `git`&`workspace`&`home`

默认配置

	<Directory />
	    AllowOverride none
	    Require all denied
	/Directory>

拒绝掉了所有不是指定目录的请求

我们可以修改一下

	<Directory />
	    #AllowOverride none
	    #Require all denied
		Options FollowSymLinks
	    AllowOverride ALL
	    Order deny,allow
	    Deny from all
	</Directory>

<!-- more -->

以下是对主站点的目录进行访问控制： 

	<Directory "/mnt/web/clusting"> 
		Options FollowSymLinks 
		AllowOverride None 
		Order allow,deny 
		Allow from all 
	</Directory> 

在上面这段目录属性配置中，主要有下面的选项： 
* `Options`：配置在特定目录使用哪些特性，常用的值和基本含义如下： 

*     `ExecCGI`: 在该目录下允许执行CGI脚本。 

*     `FollowSymLinks`: 在该目录下允许文件系统使用符号连接。 

*     `Indexes`: 当用户访问该目录时，如果用户找不到`DirectoryIndex`指定的主页文件(例如`index.html`),则返回该目录下的文件列表给用户。

*     `SymLinksIfOwnerMatch`: 当使用符号连接时，只有当符号连接的文件拥有者与实际文件的拥有者相同时才可以访问。 

其它可用值和含义请参阅：[http://www.clusting.com/Apache/ApacheManual/mod/core.html#options](http://www.clusting.com/Apache/ApacheManual/mod/core.html#options)

*     `AllowOverride`：允许存在于`.htaccess`文件中的指令类型(`.htaccess`文件名是可以改变的，其文件名由`AccessFileName`指令决定)： 

*     `None`: 当`AllowOverride`被设置为`None`时。不搜索该目录下的`.htaccess`文件（可以减小服务器开销）。 

*     `All`: 在`.htaccess`文件中可以使用所有的指令。 

其他的可用值及含义(如：Options FileInfo AuthConfig Limit等)，请参看：[go](http://www.clusting.com/Apache/ApacheManual/mod/core.html#AllowOverride)

*     `Order`：控制在访问时`Allow`和`Deny`两个访问规则哪个优先： 

*     `Allow`：允许访问的主机列表(可用域名或子网，例如：`Allow from 192.168.0.0/16`)。 

*     `Deny`：拒绝访问的主机列表。 

更详细的用法可参看：[go](http://www.clusting.com/Apache/ApacheManual/mod/mod_access.html#order)

*     `DirectoryIndex` `index.html` `index.htm` `index.php` #主页文件的设置（本例将主页文件设置为：`index.html`,`index.htm`和`index.php`） 

[from](http://liudaoru.iteye.com/blog/336338)


<abbr title="End of file">EOF</abbr>
