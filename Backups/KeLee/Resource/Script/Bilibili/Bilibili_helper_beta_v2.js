// Build: 2023/6/11 12:50:51
(() => {
  console.time = function (e) {
    (this._times = this._times || {}), (this._times[e] = Date.now());
  };
  console.timeEnd = function (e) {
    if (this._times && this._times[e]) {
      let t = Date.now() - this._times[e];
      console.log(`${e}: ${t}ms`), delete this._times[e];
    } else console.log(`Timer with label ${e} does not exist.`);
  };
  function n(e) {
    $done({ body: JSON.stringify(e) });
  }
  function s(e) {
    (e.data.item = e.data.item.filter((t) => !t.linktype.endsWith("_ad"))),
      n(e);
  }
  function r(e) {
    let t = ["account", "event_list", "preload", "show"],
      c = { max_time: 0, min_interval: 31536e3, pull_interval: 31536e3 },
      f = {
        duration: 0,
        enable_pre_download: !1,
        end_time: 2209046399,
        begin_time: 220896e4,
      };
    if (
      e.data &&
      (t.forEach((i) => delete e.data[i]),
      Object.entries(c).forEach(([i, d]) => {
        e.data[i] && (e.data[i] = d);
      }),
      e.data.list)
    )
      for (let i of e.data.list) Object.assign(i, f);
    n(e);
  }
  function a(e) {
    (e.data.items = e.data.items.filter((t) => !/banner|cm/.test(t.card_type))),
      n(e);
  }
  var p = $request.url,
    o = $response.body;
  o || $done({});
  o = JSON.parse(o);
  var l = { search: s, "feed/index": a, splash: r };
  for (let e in l)
    if (p.includes(e)) {
      l[e](o);
      break;
    }
  $done({});
})();
