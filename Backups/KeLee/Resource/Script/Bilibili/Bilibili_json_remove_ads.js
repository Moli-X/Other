/*
脚本引用https://raw.githubusercontent.com/Keywos/rule/main/JS/bjson.js
*/
const url = $request.url;
if (!$response.body) $done({});
let i = JSON.parse($response.body);
if (url.includes("/x/v2/splash/list")) {
  // 开屏广告
  if (i.data?.list) {
    for (let e of i.data.list)
      (e.duration = 0), (e.begin_time = 2240150400), (e.end_time = 2240150400);
  }
// 强制设置的皮肤
} else if (url.includes("/x/resource/show/skin")) {
  if (obj.data?.common_equip) {
    delete obj.data.common_equip;
  }
} else if (url.includes("/x/v2/feed/index?")) {
  // 推荐广告
  i.data?.items &&
    (i.data.items = i.data.items.filter(
      (i) =>
        !i.banner_item &&
        !i.ad_info &&
        -1 === i.card_goto?.indexOf("ad") &&
        ["small_cover_v2", "large_cover_v1", "large_cover_single_v9"].includes(
          i.card_type
        )
    ));
} else if (url.includes("/x/v2/feed/index/story?")) {
  i.data?.items &&
    (i.data.items = i.data.items.filter(
      (i) => !i.ad_info && -1 === i.card_goto?.indexOf("ad")
    ));
} else if (url.includes("/x/resource/show/tab")) {
  if (
    // 首页标签页
    ((i.data.tab = [
      {
        id: 40,
        tab_id: "推荐tab",
        default_selected: 1,
        name: "推荐",
        uri: "bilibili://pegasus/promo",
        pos: 1,
      },
      {
        id: 41,
        tab_id: "hottopic",
        name: "热门",
        uri: "bilibili://pegasus/hottopic",
        pos: 2,
      },
      {
        id: 151,
        tab_id: "film",
        name: "影视",
        uri: "bilibili://pgc/cinema-tab",
        pos: 3,
      },
      {
        id: 545,
        tab_id: "bangumi",
        name: "动画",
        uri: "bilibili://pgc/home",
        pos: 4,
      },
      {
        id: 39,
        tab_id: "直播tab",
        name: "直播",
        uri: "bilibili://live/home",
        pos: 5,
      },
    ]),
    i.data?.bottom?.length > 3)
  ) {
    const e = [177, 179, 181];
    (i.data.top = [
      {
        id: 176,
        icon: "http://i0.hdslb.com/bfs/archive/d43047538e72c9ed8fd8e4e34415fbe3a4f632cb.png",
        tab_id: "消息Top",
        name: "消息",
        uri: "bilibili://link/im_home",
        pos: 1,
      },
    ]),
      (i.data.bottom = i.data.bottom.filter((i) => e.includes(i.id)));
  }
} else if (url.includes("/x/v2/account/mine?")) {
  // 我的页面
  // 标准版：
  // 396离线缓存 397历史记录 398我的收藏 399稍后再看 171个性装扮 172我的钱包 407联系客服 410设置
  // 港澳台：
  // 534离线缓存 8历史记录 4我的收藏 428稍后再看
  // 352离线缓存 1历史记录 405我的收藏 402个性装扮 404我的钱包 544创作中心
  // 概念版：
  // 425离线缓存 426历史记录 427我的收藏 428稍后再看 171创作中心 430我的钱包 431联系客服 432设置
  // 国际版：
  // 494离线缓存 495历史记录 496我的收藏 497稍后再看 741我的钱包 742稿件管理 500联系客服 501设置
  // 622为会员购中心 425开始为概念版id
  if (i.data?.sections_v2) {
    const e = [
      396, 397, 398, 399, 402, 404, 407, 410, 494, 495, 496, 497, 500, 501,
    ];
    i.data.sections_v2.forEach((i) => {
      ["创作中心", "創作中心"].includes(i.title) &&
        ((i.title = void 0), (i.type = void 0)),
        (i.items = i.items.filter((i) => e.includes(i.id))),
        (i.button = {}),
        (i.be_up_title = void 0),
        (i.tip_icon = void 0),
        (i.tip_title = void 0);
    }),
      i.data?.live_tip && (i.data.live_tip = {}),
      i.data?.answer && (i.data.answer = {}),
      // 开启本地会员标识
      (i.data.vip_section = void 0),
      (i.data.vip_section_v2 = void 0),
      i.data.vip.status ||
        ((i.data.vip_type = 2),
        (i.data.vip.type = 2),
        (i.data.vip.status = 1),
        (i.data.vip.vip_pay_type = 1),
        (i.data.vip.due_date = 466982416e4));
  }
} else if (url.includes("/x/v2/account/mine/ipad")) {
  if (i.data?.ipad_upper_sections) {
    // 投稿 创作首页 稿件管理 有奖活动
    delete i.data.ipad_upper_sections;
  }
  if (i.data?.ipad_recommend_sections) {
    // 789我的关注 790我的消息 791我的钱包 792直播中心 793大会员 794我的课程 2542我的游戏
    const e = [789, 790];
    i.data.ipad_recommend_sections = i.data.ipad_recommend_sections.filter(
      (i) => e.includes(i.id)
    );
  }
  if (i.data?.ipad_more_sections) {
    // 797我的客服 798设置 1070青少年守护
    const e = [797, 798];
    i.data.ipad_more_sections = i.data.ipad_more_sections.filter((i) =>
      e.includes(i.id)
    );
  }
} else if (url.includes("/x/v2/account/myinfo?")) {
  // 会员清晰度
  i.data?.vip &&
    !i.data.vip.status &&
    ((i.data.vip.type = 2),
    (i.data.vip.status = 1),
    (i.data.vip.vip_pay_type = 1),
    (i.data.vip.due_date = 466982416e4));
} else if (url.includes("/x/v2/search/square")) {
  // 热搜广告
  i.data = [{ type: "history", title: "搜索历史" }];
} else if (url.includes("/xlive/app-room/v1/index/getInfoByRoom")) {
  // 直播广告
  i.data &&
    ((i.data.activity_banner_info = void 0),
    (i.data.shopping_info = { is_show: 0 }));
} else if (
  // 观影页广告
  url.includes("pgc/page/bangumi") ||
  url.includes("pgc/page/cinema/tab?")
) {
  i.result?.modules &&
    i.result.modules.forEach((i) => {
      i.style.startsWith("tip") || [1283, 241, 1441, 1284].includes(i.module_id)
        ? (i.items = [])
        : i.style.startsWith("banner")
        ? (i.items = i.items.filter((i) => i.link.includes("play")))
        : i.style.startsWith("function") &&
          (i.items = i.items.filter((i) => i.blink.startsWith("bilibili")));
    });
}
$done({ body: JSON.stringify(i) });
