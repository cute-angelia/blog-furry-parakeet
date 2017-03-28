---
title: java-maven
date: 2014-10-07 22:43:17
tags: [java]
---

## 配置 pom.xml 搭建项目

`pom.xml`可以管理各个包依赖，方便快捷

<!-- more -->

## 生成数据库文件

[https://github.com/mybatis/generator](https://github.com/mybatis/generator)

    java -jar mybatis-generator-core-1.3.2.jar -configfile generateConfig.xml -overwrite

`generateConfig.xml` demo

```` xml generateConfig.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN" "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
<!-- 数据库驱动-->
	<classPathEntry	location="mysql-connector-java-5.1.7-bin.jar"/>
	<context id="DB2Tables"	targetRuntime="MyBatis3">
		<commentGenerator>
			<property name="suppressDate" value="true"/>
			<!-- 是否去除自动生成的注释 true：是 ： false:否 -->
			<property name="suppressAllComments" value="true"/>
		</commentGenerator>
		<!--数据库链接URL，用户名、密码 -->
		<jdbcConnection driverClass="com.mysql.jdbc.Driver" connectionURL="jdbc:mysql://localhost/mysqldb" userId="user" password="pwd">
		</jdbcConnection>
		<javaTypeResolver>
			<property name="forceBigDecimals" value="false"/>
		</javaTypeResolver>
		<!-- 生成模型的包名和位置-->
		<javaModelGenerator targetPackage="com.dtwk.cxf.model" targetProject="src">
			<property name="enableSubPackages" value="true"/>
			<property name="trimStrings" value="true"/>
		</javaModelGenerator>
		<!-- 生成映射文件的包名和位置-->
		<sqlMapGenerator targetPackage="com.dtwk.cxf.mapping" targetProject="src">
			<property name="enableSubPackages" value="true"/>
		</sqlMapGenerator>
		<!-- 生成DAO的包名和位置-->
		<javaClientGenerator type="XMLMAPPER" targetPackage="com.dtwk.cxf.dao" targetProject="src">
			<property name="enableSubPackages" value="true"/>
		</javaClientGenerator>
		<!-- 要生成哪些表-->
		<!--
		<table tableName="dtwk_device" domainObjectName="DtwkDeviceDto" enableCountByExample="true" enableUpdateByExample="true" enableDeleteByExample="true" enableSelectByExample="true" selectByExampleQueryId="true"></table>
		-->
		<table schema="portal" tableName="tablename" />
	</context>
</generatorConfiguration>
````


##ArtifactDescriptorException

`eclipse` `maven` 识别 `pom.xml` 的时候，`eclipse`中遇到了`ArtifactDescriptorException`的问题

经过强制的更新包之外，仍然报错

    mvn dependency:tree
    
    mvn clean install -e -U

后来，在`pom.xml` `dependencies` 手动执行 `add dependenice` 成功恢复正常

原因可能是`eclipse`的缓存，更新包之后重启，估计也能行得通



