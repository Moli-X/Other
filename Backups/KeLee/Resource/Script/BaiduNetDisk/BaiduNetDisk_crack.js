/*
脚本引用自https://raw.githubusercontent.com/510004015/Quantumult_X/Remote/Premium/BaiduCloud.js
*/
let Premium = $response.body;
var modified = JSON.parse(Premium);
modified = {
  "product_infos" : [
    {
      "cur_svip_type" : "Crack",
      "product_name" : "svip2_nd",
      "product_description" : "解锁倍速+画质",
      "function_num" : 510004015,
      "start_time" : 1672502400,
      "buy_description" : "无下载加速",
      "buy_time" : 980784000,
      "product_id" : "问好",
      "auto_upgrade_to_svip" : 0,
      "end_time" : 4070880000,
      "cluster" : "vip",
      "detail_cluster" : "svip",
      "status" : 0
    }
  ],
  "level_info" : {
    "current_level" : 10,
  }
};
$done({body:JSON.stringify(modified)});