let rHead = "<head>";
let newStyle =
  "<head><style> .wpoScript, .ec_ad_results, .ec_wise_ad, .page-copyright{display:none!important} </style>";
let body = $response.body.replace(rHead, newStyle);
$done({ body });