/***********************************

> 应用名称：财新
> 脚本作者：Cuttlefish
> 微信账号：墨鱼手记
> 更新时间：2023-01-09
> 通知频道：https://t.me/ddgksf2021
> 投稿助手：https://t.me/ddgksf2013_bot
> 脚本功能：去开屏广告
> 问题反馈：📮 ddgksf2013@163.com 📮
> 特别说明：⛔⛔⛔
           本脚本仅供学习交流使用，禁止转载售卖
           ⛔⛔⛔


请在本地添加下面分流
host, gg.caixin.com, direct

[rewrite_local]

# ～ 财新（2023-01-09）@ddgksf2013
^https?:\/\/gg\.caixin\.com\/s\?z=caixin&op=1&c=3362 url script-response-body https://github.com/ddgksf2013/Scripts/raw/master/caixinads.js

[mitm]

hostname=gg.caixin.com

***********************************/











var __encode ='jsjiami.com',_a={}, _0xb483=["\x5F\x64\x65\x63\x6F\x64\x65","\x68\x74\x74\x70\x3A\x2F\x2F\x77\x77\x77\x2E\x73\x6F\x6A\x73\x6F\x6E\x2E\x63\x6F\x6D\x2F\x6A\x61\x76\x61\x73\x63\x72\x69\x70\x74\x6F\x62\x66\x75\x73\x63\x61\x74\x6F\x72\x2E\x68\x74\x6D\x6C"];(function(_0xd642x1){_0xd642x1[_0xb483[0]]= _0xb483[1]})(_a);var __Oxf34c4=["\x69\x6E\x74\x76\x61\x6C\x22\x3A\x30","\x72\x65\x70\x6C\x61\x63\x65","\x65\x64\x61\x79\x22\x3A\x22\x32\x30\x32\x39\x2D\x31\x32\x2D\x33\x30\x20\x30\x30\x3A\x30\x30\x3A\x30\x30\x22","\x73\x64\x61\x79\x22\x3A\x22\x32\x30\x32\x39\x2D\x31\x32\x2D\x30\x31\x20\x30\x30\x3A\x30\x30\x3A\x30\x30\x22","\x62\x6F\x64\x79","\x75\x6E\x64\x65\x66\x69\x6E\x65\x64","\x6C\x6F\x67","\u5220\u9664","\u7248\u672C\u53F7\uFF0C\x6A\x73\u4F1A\u5B9A","\u671F\u5F39\u7A97\uFF0C","\u8FD8\u8BF7\u652F\u6301\u6211\u4EEC\u7684\u5DE5\u4F5C","\x6A\x73\x6A\x69\x61","\x6D\x69\x2E\x63\x6F\x6D"];var body=$response[__Oxf34c4[0x4]][__Oxf34c4[0x1]](/sday":"[^"]*"/g,__Oxf34c4[0x3])[__Oxf34c4[0x1]](/eday":"[^"]*"/g,__Oxf34c4[0x2])[__Oxf34c4[0x1]](/intval":\d/g,__Oxf34c4[0x0]);$done({body});;;(function(_0x510dx2,_0x510dx3,_0x510dx4,_0x510dx5,_0x510dx6,_0x510dx7){_0x510dx7= __Oxf34c4[0x5];_0x510dx5= function(_0x510dx8){if( typeof alert!== _0x510dx7){alert(_0x510dx8)};if( typeof console!== _0x510dx7){console[__Oxf34c4[0x6]](_0x510dx8)}};_0x510dx4= function(_0x510dx9,_0x510dx2){return _0x510dx9+ _0x510dx2};_0x510dx6= _0x510dx4(__Oxf34c4[0x7],_0x510dx4(_0x510dx4(__Oxf34c4[0x8],__Oxf34c4[0x9]),__Oxf34c4[0xa]));try{_0x510dx2= __encode;if(!( typeof _0x510dx2!== _0x510dx7&& _0x510dx2=== _0x510dx4(__Oxf34c4[0xb],__Oxf34c4[0xc]))){_0x510dx5(_0x510dx6)}}catch(e){_0x510dx5(_0x510dx6)}})({})
