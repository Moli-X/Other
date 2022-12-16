
/**
 * @fileoverview Template to compose HTTP reqeuest.
 * 
 */

const url = `http://bbs.inovance.com/plugin.php?id=k_misign:sign&operation=qiandao&format=text&formhash=cef82206`;
const method = `GET`;
const headers = {
'Accept-Encoding' : `gzip, deflate`,
'Cookie' : `Rnuy_2132_lastact=1671160960%09forum.php%09; Rnuy_2132_popadv=a%3A0%3A%7B%7D; Rnuy_2132_sid=lI38io; Rnuy_2132_onlineusernum=414; Rnuy_2132_home_diymode=1; Rnuy_2132_auth=f9d9J%2BXdLzm6wDa5TmLz2xs3qHLLSPVJnh5mH48bErCk4orjxu6D6gTBTIskzg%2FMcPI3nI8t95U%2F3Wxc2hNYYGzkfg; Rnuy_2132_lastcheckfeed=49654%7C1671160892; Rnuy_2132_ulastactivity=24a2CJdBpuprVRP%2F1JIV%2B0OqP34ZIkbg%2FPwlU6AbDChAd41c%2FIRB; Rnuy_2132_seccode=3877.2701c60abd3c206920; PHPSESSID=h3fak8u0o6i06rfb59e8tm3tlp; Rnuy_2132_nofavfid=1; Rnuy_2132_visitedfid=40; Rnuy_2132_lastvisit=1669936247; Rnuy_2132_saltkey=rZ14Aar2`,
'Connection' : `keep-alive`,
'Content-Type' : `application/x-www-form-urlencoded; charset=utf-8`,
'Accept' : `*/*`,
'Host' : `bbs.inovance.com`,
'User-Agent' : `Mozilla/5.0 (iPhone; CPU iPhone OS 16_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1`,
'Referer' : `http://bbs.inovance.com/forum.php?forumlist=1&mobile=2`,
'Accept-Language' : `zh-CN,zh-Hans;q=0.9`,
'X-Requested-With' : `XMLHttpRequest`
};
const body = ``;

const myRequest = {
    url: url,
    method: method,
    headers: headers,
    body: body
};

$task.fetch(myRequest).then(response => {
    console.log(response.statusCode + "\n\n" + response.body);
    $done();
}, reason => {
    console.log(reason.error);
    $done();
});
