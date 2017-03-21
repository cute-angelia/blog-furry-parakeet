title: Xshell主题Solarized Dark
date: 2014-02-22 22:42:44
tags: [xshell, theme]
---

## 自定义Xshell颜色主题Color Schemes

	<color>
	[Solarized Dark]
	text(bold)=839496
	magenta(bold)=6c71c4
	text=839496
	white(bold)=fdf6e3
	green=859900
	red(bold)=cb4b16
	green(bold)=586e75
	black(bold)=073642
	red=dc322f
	blue=268bd2
	black=002b36
	blue(bold)=839496
	yellow(bold)=657b83
	cyan(bold)=93a1a1
	yellow=b58900
	magenta=dd3682
	background=042028
	white=eee8d5
	cyan=2aa198
	[Names]
	count=1
	name0=Solarized Dark

以上内容保存为`.xcs`文件下导入

设置`LS_COLORS`，通过`env`查看值，如相同可略过。

	alias ls='ls --color=auto'
	LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
	export LS_COLORS



<abbr title="End of file">EOF</abbr>
