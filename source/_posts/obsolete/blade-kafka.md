title: Blade Kafka
date: 2015-06-25 22:44:31
tags: [kafka, hadoop, note]
---

## 基本操作

````
/**
 * kafka写数据
 *
 * @param $url
 * @param $topic
 * @param $message
 * @return mixed
 */
function curl_kafka($url, $topic, $message)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, sprintf('topic=%s&message=%s', $topic, $message));
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}


/**
 * kafka读数据
 *
 * @param $url
 * @param $topic
 * @return string
 */
function curl_kafka_get($url, $topic)
{
    $data = array('topic' => $topic);
    $url .= '?' . http_build_query($data);
    return file_get_contents_ex($url, 6);
}

function file_get_contents_ex($url, $timeout = 6)
{
    $ctx = stream_context_create(array (
        'http' => array (
            'timeout' => $timeout
        )
    ));
    return file_get_contents($url, 0, $ctx);
}

````

<!-- more -->

## Topic 定义


* blade.YuanBaoInc //元宝增加

* blade.YuanBaoDec //元宝消耗


## message 定义

````
areaid$^areatypeid$^numid$^gameid$^timestamp$^amout$^description$^type1$^type2$^ext$^
````
