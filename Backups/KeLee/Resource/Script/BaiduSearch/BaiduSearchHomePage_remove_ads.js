let rHead = "<head>";
let newStyle =
  "<head><style> #foot, .recordcode, .index-copyright, div[style*=overflow], article, .rn-container, .square-enterance, .ns-square-point, .voice.call, .ts-image-uploader, .ts-image-uploader-icon, .ts-image-uploader-icon-point, .qrcode.call, .navs-bottom-bar, .tab_news_1, .s-loading-frame.bottom{display:none!important} </style>";
let body = $response.body.replace(rHead, newStyle);
$done({ body });