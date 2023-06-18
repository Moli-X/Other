/*
脚本引用https://raw.githubusercontent.com/Liquor030/Sub_Ruleset/master/Script/Super.js
*/
var body = $response.body.replace(/id\":([0-9]{15,})/g, 'id":"$1str"');
body = JSON.parse(body);
if (body.data.data) {
    obj = body.data.data;
} else if (body.data.replies) {
    obj = body.data.replies;
} else if (body.data.cell_comments) {
    obj = body.data.cell_comments;
} else {
    obj = null;
}

if (obj instanceof Array) {
    if (obj != null) {
        for (var i in obj) {
            if (obj[i].ad_info != null) {
                obj.splice(i, 1);
            }
            if (obj[i].item != null) {
                if (obj[i].item.video != null) {
                    obj[i].item.video.video_download.url_list = obj[i].item.origin_video_download.url_list;
                }
                for (var j in obj[i].item.comments) {
                    if (obj[i].item.comments[j].video != null) {
                        obj[i].item.comments[j].video_download.url_list = obj[i].item.comments[j].video.url_list;
                    }
                }
            }
            if (obj[i].comment_info != null) {
                if (obj[i].comment_info.video != null) {
                    obj[i].comment_info.video_download.url_list = obj[i].comment_info.video.url_list;
                }
            }
        }
    }
} else {
    if (obj.item != null) {
        if (obj.item.video != null) {
            obj.item.video.video_download.url_list = obj.item.origin_video_download.url_list;
        }
        for (var j in obj.item.comments) {
            if (obj.item.comments[j].video != null) {
                obj.item.comments[j].video_download.url_list = obj.item.comments[j].video.url_list;
            }
        }
    }
    if (obj.comment_info != null) {
        if (obj.comment_info.video != null) {
            obj.comment_info.video_download.url_list = obj.comment_info.video.url_list;
        }
    }
}
body = JSON.stringify(body);
body = body.replace(/id\":\"([0-9]{15,})str\"/g, 'id":$1');
body = body.replace(/\"can_download\":false/g, '"can_download":true');
body = body.replace(/tplv-ppx-logo.image/g, '0x0.gif');
body = body.replace(/tplv-ppx-logo/g, '0x0');
$done({
    body
});
