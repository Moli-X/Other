/***********************************************
> 应用名称：墨鱼自用喜马拉雅去广告脚本
> 脚本作者：@ddgksf2013
> 微信账号：墨鱼手记
> 更新时间：2022-04-29
> 通知频道：https://t.me/ddgksf2021
> 贡献投稿：https://t.me/ddgksf2013_bot
> 问题反馈：ddgksf2013@163.com
> 特别提醒：如需转载请注明出处，谢谢合作！
***********************************************/	  


const version = 'V1.0.27';


let body=$response.body;if(body){switch(!0){case/discovery-category\/customCategories/.test($request.url):try{let e=JSON.parse(body);e.customCategoryList&&(e.customCategoryList=e.customCategoryList.filter(e=>("recommend"==e.itemType||"template_category"==e.itemType||"single_category"==e.itemType)&&1005!==e.categoryId)),e.defaultTabList&&(e.defaultTabList=e.defaultTabList.filter(e=>("recommend"==e.itemType||"template_category"==e.itemType||"single_category"==e.itemType)&&1005!==e.categoryId)),body=JSON.stringify(e)}catch(t){console.log("customCategories: "+t)}break;case/discovery-category\/v\d\/category/.test($request.url):try{let a=JSON.parse(body);a.focusImages&&a.focusImages.data&&(a.focusImages.data=a.focusImages.data.filter(e=>-1!=e.realLink.indexOf("open")&&!e.isAd)),body=JSON.stringify(a)}catch(i){console.log("categories: "+i)}break;case/focus-mobile\/focusPic/.test($request.url):try{let s=JSON.parse(body);s.header&&s.header.length<=1&&(s.header[0].item.list[0].data=s.header[0].item.list[0].data.filter(e=>-1!=e.realLink.indexOf("open")&&!e.isAd)),body=JSON.stringify(s)}catch(r){console.log("discovery-feed"+r)}break;case/discovery-feed\/v\d\/mix/.test($request.url):try{let d=JSON.parse(body),o=new Set([1001,1005,1009,1013,1015,1022,1e5]);if(d.header&&d.header.length>=2){d.header[1].item.list=d.header[1].item.list.filter(e=>o.has(e.id));for(let l=0;l<d.header[1].item.list.length;l++)d.header[1].item.list[l].displayClass="one_line";delete d.header[0]}else if(d.header&&d.header.length<=1){d.header[0].item.list=d.header[0].item.list.filter(e=>o.has(e.id));for(let y=0;y<d.header[0].item.list.length;y++)d.header[0].item.list[y].displayClass="one_line"}d.body=d.body.filter(e=>e.item.playsCounts>1e6&&!e.item.adInfo),body=JSON.stringify(d)}catch(c){console.log("discovery-feed:"+c)}break;case/mobile-user\/v\d\/homePage/.test($request.url):try{let m=new Set([210,213,215]),g=JSON.parse(body);if(g.data.serviceModule.entrances){let $=g.data.serviceModule.entrances.filter(e=>m.has(e.id));g.data.serviceModule.entrances=$}body=JSON.stringify(g)}catch(f){console.log("mobile-user:"+f)}break;default:$done({})}$done({body})}else $done({});
