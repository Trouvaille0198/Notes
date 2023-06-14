---
title: "wrk"
date: 2022-08-30
draft: false
author: "MelonCholi"
tags: [快速入门]
categories: [工具]
---

# wrk

参考：https://www.cnblogs.com/quanxiaoha/p/10661650.html

wrk 是一款针对 Http 协议的基准测试工具，它能够在单机多核 CPU 的条件下，使用系统自带的高性能 I/O 机制，如 epoll，kqueue 等，通过多线程和事件模式，对目标机器产生大量的负载。

## 安装

Ubuntu

```shell
sudo apt-get install build-essential libssl-dev git -y
git clone https://github.com/wg/wrk.git wrk
cd wrk
make
# 将可执行文件移动到 /usr/local/bin 位置
sudo cp wrk /usr/local/bin
```

## 快速使用

例

```shell
wrk -t12 -c400 -d30s http://www.baidu.com
```

使用方法

```shell
使用方法: wrk <选项> <被测HTTP服务的URL>                            
  Options:                                            
    -c, --connections <N>  跟服务器建立并保持的TCP连接数量  
    -d, --duration    <T>  压测时间           
    -t, --threads     <N>  使用多少个线程进行压测   
                                                      
    -s, --script      <S>  指定Lua脚本路径       
    -H, --header      <H>  为每一个HTTP请求添加HTTP头      
        --latency          在压测结束后，打印延迟统计信息   
        --timeout     <T>  超时时间     
    -v, --version          打印正在使用的wrk的详细版本信息
                                                      
  <N>代表数字参数，支持国际单位 (1k, 1M, 1G)
  <T>代表时间参数，支持时间单位 (2s, 2m, 2h)
```

output

```shell
Running 30s test @ http://www.baidu.com （压测时间30s）
  12 threads and 400 connections （共12个测试线程，400个连接）
			  （平均值） （标准差）  （最大值）（正负一个标准差所占比例）
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    （延迟）
    Latency   386.32ms  380.75ms   2.00s    86.66%
    (每秒请求数)
    Req/Sec    17.06     13.91   252.00     87.89%
  Latency Distribution （延迟分布）
     50%  218.31ms
     75%  520.60ms
     90%  955.08ms
     99%    1.93s 
  4922 requests in 30.06s, 73.86MB read (30.06s内处理了4922个请求，耗费流量73.86MB)
  Socket errors: connect 0, read 0, write 0, timeout 311 (发生错误数)
Requests/sec:    163.76 (QPS 163.76,即平均每秒处理请求数为163.76)
Transfer/sec:      2.46MB (平均每秒流量2.46MB)
```

lua 配置文件

```lua
wrk.method = "PUT"
wrk.body = '{"_id":"9ee5cc6e-c5a3-4f98-acca-4628be9e187c","_v":"4","assets":[{"_id":"road","contentPath":"https://sit-asset-static.builtopia.cn/model/20220512/square.glb"},{"_id":"Z09xM4","contentPath":"https://asset-static.gocyber.io/processed_model/20220615/d718a195-5282-444b-a178-974375ddfc2e.glb","creatorUserId":"","id":"Z09xM4","lazyLoading":true,"name":"test"},{"_id":"Z2VbvP","contentPath":"https://asset-static.gocyber.io/processed_model/20220616/2759b813-eae2-48dc-b75a-bf980e9acc6f.glb","creatorUserId":"","id":"Z2VbvP","lazyLoading":true,"name":"Entrance-Pyramid"},{"_id":"pe6Bn1","contentPath":"https://asset-static.gocyber.io/processed_model/20220615/f3c1daad-42bf-40f0-8bb3-f2ed46e801d2.glb","id":"pe6Bn1","name":"test","lazyLoading":true,"creatorUserId":""}],"components":[{"_id":"70c21130-9263-4d63-b2af-f403a80f70ea","assetId":"road","componentType":"Model"},{"_id":"762623a5-509d-4cb3-95f3-86b38ef9c01c","componentType":"Transform","position":[0,0,0],"rotation":[0,0,0],"scale":[1,1,1]},{"_id":"3fc4bbc3-6755-4006-b1e9-f0ca32e12fe6","assetId":"Z09xM4","componentType":"Model"},{"_id":"4951c12c-32b2-4db8-b966-6439fa5022d7","componentType":"Transform","position":[-3.8511102199554443,0.8528874516487122,-4.53016996383667],"rotation":[0,0,0],"scale":[1,1,1]},{"_id":"44ffc7bc-eaf4-4f09-a0b0-ff012d403ea3","assetId":"Z09xM4","componentType":"Model"},{"_id":"0b37ceb6-9011-4fa0-92d1-b22699f29a63","componentType":"Transform","position":[-6.349999904632568,0.4399999976158142,-4.03000020980835],"rotation":[0,0,0],"scale":[1,1,1]},{"_id":"e13fe812-2fef-4fe7-9757-3530d80042fa","assetId":"Z2VbvP","componentType":"Model"},{"_id":"5ae8754a-bf2c-42a6-95ff-0da55151416c","componentType":"Transform","position":[-3.0199999809265137,-0.10999999940395355,-6.980000019073486],"rotation":[0,0,0],"scale":[1,1,1]},{"_id":"0cee646f-8168-4b99-81ee-a74b36634cad","componentType":"Model","assetId":"pe6Bn1"},{"_id":"75ce2bdd-7330-471d-b882-5e9ed210c9a8","componentType":"Transform","position":[],"rotation":[0,0,0],"scale":[1,1,1]}],"entities":[{"_id":"Road","components":["70c21130-9263-4d63-b2af-f403a80f70ea","762623a5-509d-4cb3-95f3-86b38ef9c01c"],"name":"Road"},{"_id":"e3a558ae-49c3-4bde-ac79-6594f919df33","components":["3fc4bbc3-6755-4006-b1e9-f0ca32e12fe6","4951c12c-32b2-4db8-b966-6439fa5022d7"],"name":"test"},{"_id":"e8d2c0b4-413f-4735-a67c-e7aaf35f3ac7","components":["44ffc7bc-eaf4-4f09-a0b0-ff012d403ea3","0b37ceb6-9011-4fa0-92d1-b22699f29a63"],"name":"test"},{"_id":"bbbdf95f-1033-480e-ba02-99127e609c61","components":["e13fe812-2fef-4fe7-9757-3530d80042fa","5ae8754a-bf2c-42a6-95ff-0da55151416c"],"name":"Entrance-Pyramid"},{"_id":"5ec0c16f-5429-4d92-aebc-905a894d0c54","name":"test","components":["0cee646f-8168-4b99-81ee-a74b36634cad","75ce2bdd-7330-471d-b882-5e9ed210c9a8"]}],"settings":[{"_id":"dlskjlfkjlkj","name":"Player Spawn Points","positions":[[0,1,0],[0,1,0]]},{"_id":"kkkkk","name":"XXXXXX"}]}'
wrk.headers["Content-Type"] = "application/json"
wrk.headers["cookie"] = "ajs_anonymous_id=e0b1d091-9a9c-403a-86c9-23b273697b7b"

response = function(status, headers, body)
-- print(body) --调试用，正式测试时需要关闭，因为解析response非常消耗资源
end

--  wrk -s ./scripts/post.lua -t16 -c16 -d120s https://gocyber.io/v2/space/DnLJEw/data
```



