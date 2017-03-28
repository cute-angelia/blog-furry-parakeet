---
title: 统一管理N个redis配置PHP类
date: 2015-06-19 05:07:17
tags: [redis, note]
---

多项目建立统一`redis`管理类做处理，管理`N`个`redis`基础配置

<!-- more -->

````
<?php
/**
 * BFRedis.php
 * REDIS 统一使用类
 *
 *
 * @author: Cyw
 * @email: chenyunwen01@bianfeng.com
 * @created: 2015/5/29 15:40
 * @logs:
 * // demo
 * use BFeng\Service\BFRedis as BfRedis;
 * $redis = BfRedis::instance();
 * $redis->set("demo", 'demo');
 * $redis->get('demo');
 *
 */
namespace BFeng\Service;

use Predis;

class BFRedis
{
    protected static $redis, $key;

    protected static $configs = array(
        'cluster'        => true,
        'default'        => array(
            'host'     => '127.0.0.1',
            'port'     => 6379,
            'database' => 0
        ),
        'dev|local'      => array(
            'host'     => '192.168.136.69',
            'port'     => 6379,
            'database' => 0
        ),
        'test'           => array(
            'host'     => '192.168.136.49',
            'port'     => 6379,
            'database' => 0
        ),
        'product|online' => array(
            'host'     => '127.0.0.1',
            'port'     => 6379,
            'database' => 0
        )
    );

    /**
     * redis 连接
     *
     * @param string $env
     *
     *  $client->mset(array('foo' => 'bar', 'lol' => 'wut'));
     *  var_dump($client->mget('foo', 'lol'));
     */
    public static function instance($env = false)
    {
        $env = self::getEnv($env);

        $servers = array_except(self::$configs, array('cluster'));

        $current = isset($servers[$env]) ? $servers[$env] : $servers[0];

        $project = \Config::get('app.project');

        if (empty($project)) {
            throw new \Exception('请在app.php文件配置项目名称 project ', -1);
        }
        $client = new Predis\Client($current, array('prefix' => $project . ':'));
        return $client;
    }

    /**
     * 选择环境
     *
     * @param $env
     * @return mixed
     */
    private static function getEnv($env)
    {
        $env = $env ? $env : app()->environment();
        $configs = array_keys(self::$configs);
        foreach ((array)$configs as $config) {
            if (strpos($config, $env) !== false) {
                $env = $config;
                break;
            }
        }
        return $env;
    }

}
````

