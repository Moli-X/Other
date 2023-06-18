/*
爱企查解锁
脚本作者：litieyin
引用地址：https://raw.githubusercontent.com/litieyin/AD_VIP/main/Script/aiqicha.js
*/

let obj = JSON.parse($response.body);
    obj.data = {
    "vip": 1,
    "consume": 150,
    "time": "2099-12-31",
    "signInStaus": 0
  }
$done({body: JSON.stringify(obj)});
