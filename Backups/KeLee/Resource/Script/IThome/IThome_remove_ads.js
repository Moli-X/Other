/*
引用脚本https://raw.githubusercontent.com/toulanboy/scripts/master/ithome_ad/ithome_ad.js
脚本二改https://github.com/Keywos/rule/raw/main/JS/ithomes.js
*/
const isLoon =typeof $loon !== 'undefined'
let lbt=true, zd=true
if (isLoon){
	lbt = $persistentStore.read("移除轮播图") === "开启";
    zd = $persistentStore.read("移除置顶") === "开启";
}
let i = JSON.parse($response.body);
if(lbt){
    i.data.list = i.data.list.filter(function(item) {
    return item.feedType !== 10002;  //轮播
    });
}
if(zd){
    i.data.list = i.data.list.filter(function(item) {
    return item.feedType !== 10003;  //置顶
    });
}
i.data.list = i.data.list.filter(item => {
  return item.feedType !== 10000 || (item.feedContent.smallTags[0]?.text === null || !item.feedContent.smallTags[0].text.includes("广告"));
});

$done({body: JSON.stringify(i)});