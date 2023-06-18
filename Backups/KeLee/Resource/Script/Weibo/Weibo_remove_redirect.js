/*
引用地址：https://raw.githubusercontent.com/RuCu6/QuanX/main/Scripts/weibo.js
*/
// 2023-02-07 19:58
const weibor = /https?:\/\/weibo\.cn\/sinaurl\?(.*&)?(u|toasturl|goto)=(.*?)(&.*)?$/;

const oldurl = $request.url;
let newurl = "";
if (oldurl.indexOf("weibo.cn/sinaurl") !== -1) {
  newurl = decodeURIComponent(weibor.exec(oldurl)[3]);
} else if (oldurl.indexOf("shop.sc.weibo.com/h5/jump/error") !== -1) {
  newurl = decodeURIComponent(weibor2.exec(oldurl)[2]);
} else if (oldurl.indexOf("sinaurl.cn") !== -1 || oldurl.indexOf("t.cn") !== -1) {
  let headers = $response.headers;
  newurl = headers.Location;
}

newurl = newurl.indexOf("http") == 0 ? newurl : "http://" + newurl;
const isQuanX = typeof $notify != "undefined";
const newstatus = isQuanX ? "HTTP/1.1 302 Temporary Redirect" : 302;

const noredirect = {
  status: newstatus,
  headers: { Location: newurl }
};

let resp = isQuanX ? noredirect : { response: noredirect };
resp = typeof $response != "undefined" ? noredirect : resp;

$done(resp);