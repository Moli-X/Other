 /*
README:https://github.com/VirgilClyne/Cloudflare
*/

const $ = new Env("☁ Cloudflare: 1️⃣ 1.1.1.1 v1.5.1(3).panel");
const DataBase = {
	"1dot1dot1dot1": {
		"Settings": {"Switch":true,"setupMode":"ChangeKeypair","Verify":{"RegistrationId":null,"Mode":"Token","Content":null}},
		"Configs": {
			"Request":{"url":"https://api.cloudflareclient.com","headers":{"authorization":null,"content-Type":"application/json","user-Agent":"1.1.1.1/2109031904.1 CFNetwork/1327.0.4 Darwin/21.2.0","cf-client-version":"i-6.7-2109031904.1"}},
			"i18n":{
				"zh-Hans":{"IPv4":"公用 IPv4","IPv6":"公用 IPv6","COLO":"主机托管中心","WARP_Level":"WARP 隐私","Account_Type":"账户类型","Data_Info":"流量信息","Unknown":"未知","Fail":"获取失败","WARP_Level_Off":"没有保护","WARP_Level_On":"部分保护","WARP_Level_Plus":"完整保护","Account_Type_unlimited":"无限版","Account_Type_limited":"有限版","Account_Type_team":"团队版","Account_Type_plus":"WARP+","Account_Type_free":"免费版","Data_Info_Used":"已用流量","Data_Info_Residual":"剩余流量","Data_Info_Total":"总计流量","Data_Info_Unlimited":"无限流量"},
				"zh-Hant":{"IPv4":"公用 IPv4","IPv6":"公用 IPv6","COLO":"主機託管中心","WARP_Level":"WARP 隱私","Account_Type":"賬戶類型","Data_Info":"流量信息","Unknown":"未知","Fail":"獲取失敗","WARP_Level_Off":"沒有保護","WARP_Level_On":"部分保護","WARP_Level_Plus":"完整保護","Account_Type_unlimited":"無限版","Account_Type_limited":"有限版","Account_Type_team":"團隊版","Account_Type_plus":"WARP+","Account_Type_free":"免費版","Data_Info_Used":"已用流量","Data_Info_Residual":"剩餘流量","Data_Info_Total":"總計流量","Data_Info_Unlimited":"無限流量"},
				"en":{"IPv4":"Public IPv4","IPv6":"Public IPv6","COLO":"Colocation Center","WARP_Level":"WARP Level","Account_Type":"Account Type","Data_Info":"Data Information","Unknown":"Unknown","Fail":"Fail to Get","WARP_Level_Off":"No Protection","WARP_Level_On":"Partial Protection","WARP_Level_Plus":"Complete Protection","Account_Type_unlimited":"Unlimited Ver.","Account_Type_limited":"Limited Ver.","Account_Type_team":"Team Ver.","Account_Type_plus":"WARP+","Account_Type_free":"Free Ver.","Data_Info_Used":"Used","Data_Info_Residual":"Residual","Data_Info_Total":"Total","Data_Info_Unlimited":"Unlimited"}
			}
		}
	},
	"VPN": {
		"Settings":{"Switch":true,"PrivateKey":"","PublicKey":""},
		"Configs":{"interface":{"addresses":{"v4":"","v6":""}},"peers":[{"public_key":"","endpoint":{"host":"","v4":"","v6":""}}]}
	},
	"DNS": {
		"Settings":{"Switch":true,"Verify":{"Mode":"Token","Content":""},"zone":{"id":"","name":"","dns_records":[{"id":"","type":"A","name":"","content":"","ttl":1,"proxied":false}]}},
		"Configs":{"Request":{"url":"https://api.cloudflare.com/client/v4","headers":{"content-type":"application/json"}}}
	},
	"WARP": {
		"Settings":{"Switch":true,"setupMode":null,"deviceType":"iOS","Verify":{"License":null,"Mode":"Token","Content":null,"RegistrationId":null}},
		"Configs":{"Request":{"url":"https://api.cloudflareclient.com","headers":{"authorization":null,"content-type":"application/json","user-agent":"1.1.1.1/2109031904.1 CFNetwork/1327.0.4 Darwin/21.2.0","cf-client-version":"i-6.7-2109031904.1"}},"Environment":{"iOS":{"Type":"i","Version":"v0i2109031904","headers":{"user-agent":"1.1.1.1/2109031904.1 CFNetwork/1327.0.4 Darwin/21.2.0","cf-client-version":"i-6.7-2109031904.1"}},"macOS":{"Type":"m","Version":"v0i2109031904","headers":{"user-agent":"1.1.1.1/2109031904.1 CFNetwork/1327.0.4 Darwin/21.2.0","cf-client-version":"m-2021.12.1.0-0"}},"Android":{"Type":"a","Version":"v0a1922","headers":{"user-agent":"okhttp/3.12.1","cf-client-version":"a-6.3-1922"}},"Windows":{"Type":"w","Version":"","headers":{"user-agent":"","cf-client-version":""}},"Linux":{"Type":"l","Version":"","headers":{"user-agent":"","cf-client-version":""}}}}
	}
};

/***************** Processing *****************/
(async () => {
	const { Settings, Caches, Configs } = await setENV("Cloudflare", "1dot1dot1dot1", DataBase);
	const Language = $environment?.language ?? "zh-Hans"
	// 构造面板信息
	let Panel = {
		title: $.isStash() ? "𝙒𝘼𝙍𝙋 𝙄𝙣𝙛𝙤" : "☁ 𝙒𝘼𝙍𝙋 𝙄𝙣𝙛𝙤"
	};
	// 构造请求信息
	let Request = DataBase.WARP.Configs.Request;
	// 兼容性修正
	if ($.isLoon()) Request = ReReqeust(Request, $environment?.params?.node);
	//else if ($.isQuanX()) Request = ReReqeust(Request, $environment?.params?.node);;
	else if ($.isSurge()) Request.headers["x-surge-skip-scripting"] = "true";
	// 获取 WARP 信息
	const [Trace4, Trace6] = await Promise.allSettled([Cloudflare(Request, "trace4"), Cloudflare(Request, "trace6")]).then(results => results.map(result => formatTrace(result.value)));
	// 填充面板信息
	if ($.isLoon() || $.isQuanX()) {
		Panel.message = `${Configs.i18n[Language]?.IPv4 ?? "公用 IPv4"}: ${Trace4?.ip ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.IPv6 ?? "公用 IPv6"}: ${Trace6?.ip ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.COLO ?? "主机托管中心"}: ${Trace4?.loc ?? Trace6?.loc} | ${Trace4?.colo ?? Trace6?.colo | Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.WARP_Level ?? "WARP 隐私"}: ${Trace4?.warp ?? Trace6?.warp ?? Configs.i18n[Language]?.Fail ?? "获取失败"}`;
	} else if ($.isSurge() || $.isStash()) {
		Panel.icon = $.isStash() ? "https://raw.githubusercontent.com/shindgewongxj/WHATSINStash/main/icon/warp.png" : "lock.icloud.fill";
		Panel["icon-color"] = "#f48220";
		Panel.content = `${Configs.i18n[Language]?.IPv4 ?? "公用 IPv4"}: ${Trace4?.ip ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.IPv6 ?? "公用 IPv6"}: ${Trace6?.ip ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.COLO ?? "主机托管中心"}: ${Trace4?.loc ?? Trace6?.loc} | ${Trace4?.colo ?? Trace6?.colo | Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
			+ `${Configs.i18n[Language]?.WARP_Level ?? "WARP 隐私"}: ${Trace4?.warp ?? Trace6?.warp ?? Configs.i18n[Language]?.Fail ?? "获取失败"}`;
	};
	// 获取账户信息
	if (Caches?.url && Caches?.headers) {
		// 构造请求信息
		Request.url = Caches?.url;
		Request.headers = Caches?.headers ?? {};
		// 获取账户信息
		const Account = await Cloudflare(Request, "GET").then(result => formatAccount(result?.account ?? {}));
		// 填充面板信息
		if ($.isLoon() || $.isQuanX()) {
			Panel.message += `\n`
				+ `${Configs.i18n[Language]?.Account_Type ?? "账户类型"}: ${Account?.data?.type ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
				+ `${Configs.i18n[Language]?.Data_Info ?? "流量信息"}: ${Account?.data?.text ?? Configs.i18n[Language]?.Fail ?? "获取失败"}`;

		} else if ($.isSurge() || $.isStash()) {
			Panel.content += `\n`
				+ `${Configs.i18n[Language]?.Account_Type ?? "账户类型"}: ${Account?.data?.type ?? Configs.i18n[Language]?.Fail ?? "获取失败"}\n`
				+ `${Configs.i18n[Language]?.Data_Info ?? "流量信息"}: ${Account?.data?.text ?? Configs.i18n[Language]?.Fail ?? "获取失败"}`;
		};
	};
	// 输出面板信息
	$.done(Panel);
})()
	.catch((e) => $.logErr(e))
	.finally(() => $.done())

/***************** Function *****************/
/**
 * Get Environment Variables
 * @link https://github.com/VirgilClyne/VirgilClyne/blob/main/function/getENV/getENV.min.js
 * @author VirgilClyne
 * @param {String} t - Persistent Store Key
 * @param {String} e - Platform Name
 * @param {Object} n - Default Database
 * @return {Promise<*>}
 */
async function getENV(t,e,n){let i=$.getjson(t,n),s={};if("undefined"!=typeof $argument&&Boolean($argument)){let t=Object.fromEntries($argument.split("&").map((t=>t.split("="))));for(let e in t)f(s,e,t[e])}let g={...n?.Default?.Settings,...n?.[e]?.Settings,...i?.[e]?.Settings,...s},o={...n?.Default?.Configs,...n?.[e]?.Configs,...i?.[e]?.Configs},a=i?.[e]?.Caches||void 0;return"string"==typeof a&&(a=JSON.parse(a)),{Settings:g,Caches:a,Configs:o};function f(t,e,n){e.split(".").reduce(((t,i,s)=>t[i]=e.split(".").length===++s?n:t[i]||{}),t)}}

/**
 * Set Environment Variables
 * @author VirgilClyne
 * @param {String} name - Persistent Store Key
 * @param {String} platform - Platform Name
 * @param {Object} database - Default DataBase
 * @return {Promise<*>}
 */
async function setENV(name, platform, database) {
	$.log(`⚠ ${$.name}, Set Environment Variables`, "");
	let { Settings, Caches = {}, Configs } = await getENV(name, platform, database);
	/***************** Prase *****************/
	Settings.Switch = JSON.parse(Settings.Switch) // BoxJs 字符串转 Boolean
	switch (Settings.Verify.Mode) {
		case "Token":
			Configs.Request.headers["authorization"] = `Bearer ${Settings.Verify.Content}`;
			break;
		case "ServiceKey":
			Configs.Request.headers["x-auth-user-service-key"] = Settings.Verify.Content;
			break;
		case "Key":
			Settings.Verify.Content = Array.from(Settings.Verify.Content.split("\n"))
			//$.log(JSON.stringify(Settings.Verify.Content))
			Configs.Request.headers["x-auth-key"] = Settings.Verify.Content[0];
			Configs.Request.headers["x-auth-email"] = Settings.Verify.Content[1];
			break;
		default:
			$.log("无可用授权方式", `Mode=${Settings.Verify.Mode}`, `Content=${Settings.Verify.Content}`);
			break;
	};
	$.log(`🎉 ${$.name}, Set Environment Variables`, `Settings: ${typeof Settings}`, `Settings内容: ${JSON.stringify(Settings)}`, "");
	return { Settings, Caches, Configs }
};

function formatTrace(trace, i18n = DataBase["1dot1dot1dot1"].Configs.i18n, language = $environment?.language ?? "zh-Hans") {
	switch (trace?.warp) {
		case "off":
			trace.warp += ` | ${i18n[language]?.WARP_Level_Off ?? "没有保护"}`;
			break;
		case "on":
			trace.warp += ` | ${i18n[language]?.WARP_Level_On ?? "部分保护"}`;
			break;
		case "plus":
			trace.warp += ` | ${i18n[language]?.WARP_Level_Plus ?? "完整保护"}`;
			break;
		case undefined:
			break;
		default:
			trace.warp += ` | ${i18n[language]?.Unknown ?? "未知"}`;
			break;
	};
	return trace;
};

function formatAccount(account, i18n = DataBase["1dot1dot1dot1"].Configs.i18n, language = $environment?.language ?? "zh-Hans") {
	switch (account.account_type) {
		case "unlimited":
			account.data = {
				"type": `${i18n[language]?.Account_Type_unlimited ?? "无限版"} | ${account?.account_type}`,
				"limited": false,
			}
			break;
		case "limited":
			account.data = {
				"type": `${i18n[language]?.Account_Type_limited ?? "有限版"} | ${account?.account_type}`,
				"limited": true,
				"used": parseInt(account.premium_data - account.quota) / 1024 / 1024 / 1024,
				"flow": parseInt(account.quota) / 1024 / 1024 / 1024,
				"total": parseInt(account.premium_data) / 1024 / 1024 / 1024
			}
			break;
		case "team":
			account.data = {
				"type": `${i18n[language]?.Account_Type_team ?? "团队版"} | ${account?.account_type}`,
				"limited": false,
			}
			break;
		case "plus":
			account.data = {
				"type": `${i18n[language]?.Account_Type_plus ?? "WARP+"} | ${account?.account_type}`,
				"limited": false,
			}
			break;
		case "free":
			account.data = {
				"type": `${i18n[language]?.Account_Type_free ?? "免费版"} | ${account?.account_type}`,
				"limited": true,
				"used": parseInt(account.premium_data - account.quota) / 1024 / 1024 / 1024,
				"flow": parseInt(account.quota) / 1024 / 1024 / 1024,
				"total": parseInt(account.premium_data) / 1024 / 1024 / 1024
			}
			break;
		default:
			account.data = {
				"type": `${i18n[language]?.Unknown ?? "未知"} | ${account?.account_type}`,
				"limited": undefined
			}
			break;
	};
	switch (account.data.limited) {
		case true:
			account.data.text = `\n${i18n[language]?.Data_Info_Used ?? "已用流量"}: ${account.data.used.toFixed(2)}GB`
				+ `\n${i18n[language]?.Data_Info_Residual ?? "剩余流量"}: ${account.data.flow.toFixed(2)}GB`
				+ `\n${i18n[language]?.Data_Info_Total ?? "总计流量"}: ${account.data.total.toFixed(2)}GB`
			break;
		case false:
			account.data.text = `${i18n[language]?.Data_Info_Unlimited ?? "无限流量"} | ♾️`
			break;
		default:
			account.data.text = `${i18n[language]?.Unknown ?? "未知"} | unknown`
			break;
	}
	return account;
};

async function Cloudflare(Request = DataBase.WARP.Configs.Request, opt = "trace") {
	/*
	let Request = {
		// Endpoints
		"url": "https://api.cloudflareclient.com",
		"headers": {
			"Host": "api.cloudflareclient.com",
			"content-type": "application/json",
			"user-agent": "1.1.1.1/2109031904.1 CFNetwork/1327.0.4 Darwin/21.2.0",
			"cf-client-version": "i-6.7-2109031904.1"
		}
	};
	*/
	let _Request = JSON.parse(JSON.stringify(Request));
	switch (opt) {
		case "trace":
			_Request.url = "https://cloudflare.com/cdn-cgi/trace";
			delete _Request.headers;
			return await formatCFJSON(_Request);
		case "trace4":
			_Request.url = "https://1.1.1.1/cdn-cgi/trace";
			delete _Request.headers;
			return await formatCFJSON(_Request);
		case "trace6":
			_Request.url = "https://[2606:4700:4700::1111]/cdn-cgi/trace";
			delete _Request.headers;
			return await formatCFJSON(_Request);
		case "GET":
			// GET Cloudflare JSON
			$.log('GET');
			//$.log(JSON.stringify(_Request));
			return await getCFjson(_Request);
		case "FATCH":
			// FATCH Cloudflare JSON
			$.log('FATCH');
			//$.log(JSON.stringify(_Request));
			return await fatchCFjson(_Request);
	};

	/***************** Function *****************/
	// Format Cloudflare JSON
	async function formatCFJSON(request) {
		return await $.http.get(request).then(response => {
			let arr = response.body.trim().split('\n').map(e => e.split('='))
			return Object.fromEntries(arr)
		})
	};
	// Function 0A
	// Get Cloudflare JSON
	function getCFjson(request) {
		return new Promise((resolve) => {
			$.get(request, (error, response, data) => {
				try {
					if (error) throw new Error(error)
					else if (data) {
						const _data = JSON.parse(data)
						if (Array.isArray(_data.messages)) _data.messages.forEach(message => {
							if (message.code !== 10000) $.msg($.name, `code: ${message.code}`, `message: ${message.message}`);
						})
						switch (_data.success) {
							case true:
								resolve(_data?.result?.[0] ?? _data?.result); // _data.result, _data.meta
								break;
							case false:
								if (Array.isArray(_data.errors)) _data.errors.forEach(error => { $.msg($.name, `code: ${error.code}`, `message: ${error.message}`); })
								break;
							case undefined:
								resolve(response);
						};
					} else throw new Error(response);
				} catch (e) {
					$.logErr(`❗️${$.name}, ${getCFjson.name}执行失败`, `request = ${JSON.stringify(request)}`, ` error = ${error || e}`, `response = ${JSON.stringify(response)}`, `data = ${data}`, "")
				} finally {
					//$.log (`🚧 ${$.name}, ${getCFjson.name} 调试信息`, `request = ${JSON.stringify (request)}`, `data = ${data}`, "")
					resolve()
				}
			})
		})
	};

	// Function 0B
	// Fatch Cloudflare JSON
	function fatchCFjson(request) {
		return new Promise((resolve) => {
			$.post(request, (error, response, data) => {
				try {
					if (error) throw new Error(error)
					else if (data) {
						const _data = JSON.parse(data)
						if (Array.isArray(_data.messages)) _data.messages.forEach(message => {
							if (message.code !== 10000) $.msg($.name, `code: ${message.code}`, `message: ${message.message}`);
						})
						switch (_data.success) {
							case true:
								resolve(_data?.result?.[0] ?? _data?.result); // _data.result, _data.meta
								break;
							case false:
								if (Array.isArray(_data.errors)) _data.errors.forEach(error => { $.msg($.name, `code: ${error.code}`, `message: ${error.message}`); })
								break;
							case undefined:
								resolve(response);
						};
					} else throw new Error(response);
				} catch (e) {
					$.logErr(`❗️${$.name}, ${fatchCFjson.name}执行失败`, `request = ${JSON.stringify(request)}`, ` error = ${error || e}`, `response = ${JSON.stringify(response)}`, `data = ${data}`, "")
				} finally {
					//$.log (`🚧 ${$.name}, ${fatchCFjson.name} 调试信息`, `request = ${JSON.stringify (request)}`, `data = ${data}`, "")
					resolve()
				}
			})
		})
	};

}

/**
 * Construct Redirect Reqeusts
 * @author VirgilClyne
 * @param {Object} request - Original Request Content
 * @param {Object} proxyName - Proxies Name
 * @return {Object} Modify Request Content with Policy
 */
function ReReqeust(request = {}, proxyName = "") {
	$.log(`⚠ ${$.name}, Construct Redirect Reqeusts`, "");
	if (proxyName) {
		if ($.isLoon()) request.node = proxyName;
		if ($.isQuanX()) {
			if (request.opts) request.opts.policy = proxyName;
			else request.opts = { "policy": proxyName };
		};
		if ($.isSurge()) {
			delete request.id;
			request.headers["X-Surge-Policy"] = proxyName;
			request.policy = proxyName;
		};
		if ($.isStash()) $.logErr(`❗️${$.name}, ${Fetch.name}执行失败`, `不支持的 app: Stash`, "");
		if ($.isShadowrocket()) $.logErr(`❗️${$.name}, ${Fetch.name}执行失败`, `不支持的 app: Shadowrocket`, "");
	}
	$.log(`🎉 ${$.name}, Construct Redirect Reqeusts`, "");
	//$.log(`🚧 ${$.name}, Construct Redirect Reqeusts`, `Request:${JSON.stringify(request)}`, "");
	return request;
};

/***************** Env *****************/
// prettier-ignore
// https://github.com/chavyleung/scripts/blob/master/Env.min.js
function Env(t,s){class e{constructor(t){this.env=t}send(t,s="GET"){t="string"==typeof t?{url:t}:t;let e=this.get;return"POST"===s&&(e=this.post),new Promise((s,i)=>{e.call(this,t,(t,e,r)=>{t?i(t):s(e)})})}get(t){return this.send.call(this.env,t)}post(t){return this.send.call(this.env,t,"POST")}}return new class{constructor(t,s){this.name=t,this.http=new e(this),this.data=null,this.dataFile="box.dat",this.logs=[],this.isMute=!1,this.isNeedRewrite=!1,this.logSeparator="\n",this.encoding="utf-8",this.startTime=(new Date).getTime(),Object.assign(this,s),this.log("",`\ud83d\udd14${this.name}, \u5f00\u59cb!`)}isNode(){return"undefined"!=typeof module&&!!module.exports}isQuanX(){return"undefined"!=typeof $task}isSurge(){return"undefined"!=typeof $environment&&$environment["surge-version"]}isLoon(){return"undefined"!=typeof $loon}isShadowrocket(){return"undefined"!=typeof $rocket}isStash(){return"undefined"!=typeof $environment&&$environment["stash-version"]}toObj(t,s=null){try{return JSON.parse(t)}catch{return s}}toStr(t,s=null){try{return JSON.stringify(t)}catch{return s}}getjson(t,s){let e=s;const i=this.getdata(t);if(i)try{e=JSON.parse(this.getdata(t))}catch{}return e}setjson(t,s){try{return this.setdata(JSON.stringify(t),s)}catch{return!1}}getScript(t){return new Promise(s=>{this.get({url:t},(t,e,i)=>s(i))})}runScript(t,s){return new Promise(e=>{let i=this.getdata("@chavy_boxjs_userCfgs.httpapi");i=i?i.replace(/\n/g,"").trim():i;let r=this.getdata("@chavy_boxjs_userCfgs.httpapi_timeout");r=r?1*r:20,r=s&&s.timeout?s.timeout:r;const[o,h]=i.split("@"),a={url:`http://${h}/v1/scripting/evaluate`,body:{script_text:t,mock_type:"cron",timeout:r},headers:{"X-Key":o,Accept:"*/*"},timeout:r};this.post(a,(t,s,i)=>e(i))}).catch(t=>this.logErr(t))}loaddata(){if(!this.isNode())return{};{this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),s=this.path.resolve(process.cwd(),this.dataFile),e=this.fs.existsSync(t),i=!e&&this.fs.existsSync(s);if(!e&&!i)return{};{const i=e?t:s;try{return JSON.parse(this.fs.readFileSync(i))}catch(t){return{}}}}}writedata(){if(this.isNode()){this.fs=this.fs?this.fs:require("fs"),this.path=this.path?this.path:require("path");const t=this.path.resolve(this.dataFile),s=this.path.resolve(process.cwd(),this.dataFile),e=this.fs.existsSync(t),i=!e&&this.fs.existsSync(s),r=JSON.stringify(this.data);e?this.fs.writeFileSync(t,r):i?this.fs.writeFileSync(s,r):this.fs.writeFileSync(t,r)}}lodash_get(t,s,e){const i=s.replace(/\[(\d+)\]/g,".$1").split(".");let r=t;for(const t of i)if(r=Object(r)[t],void 0===r)return e;return r}lodash_set(t,s,e){return Object(t)!==t?t:(Array.isArray(s)||(s=s.toString().match(/[^.[\]]+/g)||[]),s.slice(0,-1).reduce((t,e,i)=>Object(t[e])===t[e]?t[e]:t[e]=Math.abs(s[i+1])>>0==+s[i+1]?[]:{},t)[s[s.length-1]]=e,t)}getdata(t){let s=this.getval(t);if(/^@/.test(t)){const[,e,i]=/^@(.*?)\.(.*?)$/.exec(t),r=e?this.getval(e):"";if(r)try{const t=JSON.parse(r);s=t?this.lodash_get(t,i,""):s}catch(t){s=""}}return s}setdata(t,s){let e=!1;if(/^@/.test(s)){const[,i,r]=/^@(.*?)\.(.*?)$/.exec(s),o=this.getval(i),h=i?"null"===o?null:o||"{}":"{}";try{const s=JSON.parse(h);this.lodash_set(s,r,t),e=this.setval(JSON.stringify(s),i)}catch(s){const o={};this.lodash_set(o,r,t),e=this.setval(JSON.stringify(o),i)}}else e=this.setval(t,s);return e}getval(t){return this.isSurge()||this.isShadowrocket()||this.isLoon()||this.isStash()?$persistentStore.read(t):this.isQuanX()?$prefs.valueForKey(t):this.isNode()?(this.data=this.loaddata(),this.data[t]):this.data&&this.data[t]||null}setval(t,s){return this.isSurge()||this.isShadowrocket()||this.isLoon()||this.isStash()?$persistentStore.write(t,s):this.isQuanX()?$prefs.setValueForKey(t,s):this.isNode()?(this.data=this.loaddata(),this.data[s]=t,this.writedata(),!0):this.data&&this.data[s]||null}initGotEnv(t){this.got=this.got?this.got:require("got"),this.cktough=this.cktough?this.cktough:require("tough-cookie"),this.ckjar=this.ckjar?this.ckjar:new this.cktough.CookieJar,t&&(t.headers=t.headers?t.headers:{},void 0===t.headers.Cookie&&void 0===t.cookieJar&&(t.cookieJar=this.ckjar))}get(t,s=(()=>{})){if(t.headers&&(delete t.headers["Content-Type"],delete t.headers["Content-Length"]),this.isSurge()||this.isShadowrocket()||this.isLoon()||this.isStash())this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient.get(t,(t,e,i)=>{!t&&e&&(e.body=i,e.statusCode=e.status?e.status:e.statusCode,e.status=e.statusCode),s(t,e,i)});else if(this.isQuanX())this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:e,statusCode:i,headers:r,body:o}=t;s(null,{status:e,statusCode:i,headers:r,body:o},o)},t=>s(t&&t.error||"UndefinedError"));else if(this.isNode()){let e=require("iconv-lite");this.initGotEnv(t),this.got(t).on("redirect",(t,s)=>{try{if(t.headers["set-cookie"]){const e=t.headers["set-cookie"].map(this.cktough.Cookie.parse).toString();e&&this.ckjar.setCookieSync(e,null),s.cookieJar=this.ckjar}}catch(t){this.logErr(t)}}).then(t=>{const{statusCode:i,statusCode:r,headers:o,rawBody:h}=t,a=e.decode(h,this.encoding);s(null,{status:i,statusCode:r,headers:o,rawBody:h,body:a},a)},t=>{const{message:i,response:r}=t;s(i,r,r&&e.decode(r.rawBody,this.encoding))})}}post(t,s=(()=>{})){const e=t.method?t.method.toLocaleLowerCase():"post";if(t.body&&t.headers&&!t.headers["Content-Type"]&&(t.headers["Content-Type"]="application/x-www-form-urlencoded"),t.headers&&delete t.headers["Content-Length"],this.isSurge()||this.isShadowrocket()||this.isLoon()||this.isStash())this.isSurge()&&this.isNeedRewrite&&(t.headers=t.headers||{},Object.assign(t.headers,{"X-Surge-Skip-Scripting":!1})),$httpClient[e](t,(t,e,i)=>{!t&&e&&(e.body=i,e.statusCode=e.status?e.status:e.statusCode,e.status=e.statusCode),s(t,e,i)});else if(this.isQuanX())t.method=e,this.isNeedRewrite&&(t.opts=t.opts||{},Object.assign(t.opts,{hints:!1})),$task.fetch(t).then(t=>{const{statusCode:e,statusCode:i,headers:r,body:o}=t;s(null,{status:e,statusCode:i,headers:r,body:o},o)},t=>s(t&&t.error||"UndefinedError"));else if(this.isNode()){let i=require("iconv-lite");this.initGotEnv(t);const{url:r,...o}=t;this.got[e](r,o).then(t=>{const{statusCode:e,statusCode:r,headers:o,rawBody:h}=t,a=i.decode(h,this.encoding);s(null,{status:e,statusCode:r,headers:o,rawBody:h,body:a},a)},t=>{const{message:e,response:r}=t;s(e,r,r&&i.decode(r.rawBody,this.encoding))})}}time(t,s=null){const e=s?new Date(s):new Date;let i={"M+":e.getMonth()+1,"d+":e.getDate(),"H+":e.getHours(),"m+":e.getMinutes(),"s+":e.getSeconds(),"q+":Math.floor((e.getMonth()+3)/3),S:e.getMilliseconds()};/(y+)/.test(t)&&(t=t.replace(RegExp.$1,(e.getFullYear()+"").substr(4-RegExp.$1.length)));for(let s in i)new RegExp("("+s+")").test(t)&&(t=t.replace(RegExp.$1,1==RegExp.$1.length?i[s]:("00"+i[s]).substr((""+i[s]).length)));return t}queryStr(t){let s="";for(const e in t){let i=t[e];null!=i&&""!==i&&("object"==typeof i&&(i=JSON.stringify(i)),s+=`${e}=${i}&`)}return s=s.substring(0,s.length-1),s}msg(s=t,e="",i="",r){const o=t=>{if(!t)return t;if("string"==typeof t)return this.isLoon()||this.isShadowrocket()?t:this.isQuanX()?{"open-url":t}:this.isSurge()||this.isStash()?{url:t}:void 0;if("object"==typeof t){if(this.isLoon()){let s=t.openUrl||t.url||t["open-url"],e=t.mediaUrl||t["media-url"];return{openUrl:s,mediaUrl:e}}if(this.isQuanX()){let s=t["open-url"]||t.url||t.openUrl,e=t["media-url"]||t.mediaUrl,i=t["update-pasteboard"]||t.updatePasteboard;return{"open-url":s,"media-url":e,"update-pasteboard":i}}if(this.isSurge()||this.isShadowrocket()||this.isStash()){let s=t.url||t.openUrl||t["open-url"];return{url:s}}}};if(this.isMute||(this.isSurge()||this.isShadowrocket()||this.isLoon()||this.isStash()?$notification.post(s,e,i,o(r)):this.isQuanX()&&$notify(s,e,i,o(r))),!this.isMuteLog){let t=["","==============\ud83d\udce3\u7cfb\u7edf\u901a\u77e5\ud83d\udce3=============="];t.push(s),e&&t.push(e),i&&t.push(i),console.log(t.join("\n")),this.logs=this.logs.concat(t)}}log(...t){t.length>0&&(this.logs=[...this.logs,...t]),console.log(t.join(this.logSeparator))}logErr(t,s){const e=!(this.isSurge()||this.isShadowrocket()||this.isQuanX()||this.isLoon()||this.isStash());e?this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t.stack):this.log("",`\u2757\ufe0f${this.name}, \u9519\u8bef!`,t)}wait(t){return new Promise(s=>setTimeout(s,t))}done(t={}){const s=(new Date).getTime(),e=(s-this.startTime)/1e3;this.log("",`\ud83d\udd14${this.name}, \u7ed3\u675f! \ud83d\udd5b ${e} \u79d2`),this.log(),this.isSurge()||this.isShadowrocket()||this.isQuanX()||this.isLoon()||this.isStash()?$done(t):this.isNode()&&process.exit(1)}}(t,s)}
