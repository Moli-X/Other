/*
脚本来自彭于晏https://raw.githubusercontent.com/89996462/Quantumult-X/main/ycdz/cubox.js
*/

var body = $response.body;
var url = $request.url;
var obj = JSON.parse(body);

const vip = '/userInfo';


if (url.indexOf(vip) != -1) {
    obj.data.level = 1;
    obj.data.expireTime = "2099-09-12T23:50:23+08:00";
    obj.data.nickName = "彭于晏解锁";
    obj.data.thirdNickName = "彭于晏解锁";
    obj.data.isExpire = false;
    obj.data.active = true;
    obj.data.payTime = 1660006006;

	body = JSON.stringify(obj);
}


$done({body});
