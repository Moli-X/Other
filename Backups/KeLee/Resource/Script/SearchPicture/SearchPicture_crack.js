/*
搜图神器解锁
脚本作者：Mr.Eric
引用地址：https://raw.githubusercontent.com/Alex0510/Eric/master/surge/Script/SearchArtifact.js
*/

let obj = JSON.parse($response.body);

obj.data.vipType = 1024,
obj.data.username = "Mr.Eric首发",
obj.data.avatarUrl = "http://cdn-stsq-ios.soutushenqi.com/avatar_1661878453",

$done({body: JSON.stringify(obj)});
