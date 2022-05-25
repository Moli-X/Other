// Author: Pih
// Update: 2022.01.11

//主题颜色设置
const themes = {
  light: {
    background: new Color('#ffffff'),//明亮背景
  },
  dark: {
    background: new Color('#282828', 1),//暗黑背景
  }
};

//文字颜色设置（颜色代码,透明度）
textColor1 = new Color('#228B22', 1)//新冠肺炎
textColor2 = new Color('#FFA500', 1)//新增确诊
textColor3 = new Color('#32CD32', 0.9)//省份名称
textColor4 = new Color('#FF4500', 0.9)//新增TOP
textColor5 = new Color('#888888', 1)//热点话题

//定义主题名称
const conf = {
  client: 'h5',
  theme: 'system'
};

// =========================================

const innerColor = new Color("FFA500", 1)
const outerColor = new Color("FF0000", 0.8)

const webview = new WebView();
await webview.loadURL("https://i.snssdk.com/forum/ncov_data/?data_type=%5B2%2C4%2C8%5D");

var getData = `
  function runit() {
    const ord = document.querySelector('*').innerText;
const data = eval("("+ord+")");
const nationwide = eval("("+data.ncov_nation_data+")").nationwide
const Top10 = eval("("+data.ncov_nation_data+")").confirmedIncrProvinceTop10
const description = eval("("+data.ncov_nation_data+")").incrTips
const outputdata = {"Top10":Top10,"description":description,"nationwide":nationwide}

    completion (outputdata);
  }

  runit();
`

let TodayIncr = await webview.evaluateJavaScript(getData, true);
// console.log(response)
// log (typeof response)
// ======== End ========

log(TodayIncr.nationwide[0])
const data = TodayIncr.nationwide

const covidnews = (await new Request("https://opendata.baidu.com/data/inner?tn=reserved_all_res_tn&dspName=iphone&from_sf=1&dsp=iphone&resource_id=28565&alr=1&query=%E5%9B%BD%E5%86%85%E6%96%B0%E5%9E%8B%E8%82%BA%E7%82%8E%E6%9C%80%E6%96%B0%E5%8A%A8%E6%80%81").loadJSON()).Result[0].items_v2[0].aladdin_res.DisplayData.result.items
// .loadString()).slice(17,-29)).docs
// log(covidnews)
const chartDrawing = new DrawContext()
chartDrawing.size = new Size(642, 221)
chartDrawing.opaque=false
chartDrawing.respectScreenScale=true

// ######
fillRect(20, 110, 590, 2, 0, new Color("808080", 0.2)) //横杠

// fillRect(0, 110, 680, 120, 0, new Color("dddddd", 0.1))

drawText(12, 5, 80, 80, "🦠", Color.white(), "a", 40, "center")


var max;
	for(i = 0; i<30 ;i++)
  {
	let	temp = data[i].confirmedIncr;
		max = (temp > max || max == undefined ? temp : max)
	}
log(max)
// log(data.incTrend[data.incTrend.length-1].sure_cnt)
// log(data.incTrend[data.incTrend.length-30].sure_cnt)
const deltaY = 50/max
for(i = 0; i<30 ;i++)
{
let	temp = data[29-i].confirmedIncr*deltaY 
let width = 8,color = Color.green()
if (i==29)
{
color = new Color("cf4442",1)}

fillRect(40+i*13.5, 100-temp, width, temp, 4, color)
}

drawText(78, 15, 300, 60, "新冠疫情", textColor1, "a",24, "left")

drawText(330, 30, 120, 60, "30天趋势图", textColor3, "a",16, "left")
log(data[0].date.slice(-2))


// drawText(30, 108, 572, 20, TodayIncr.description,Color.white(), "a", 12, "center")


// ######
drawText(430, 18, 190, 60, data[0].date.slice(-2)+"日新增确诊", textColor2, "a",22, "center")

let fontSize = 47
if (Math.round(data[0].confirmedIncr) > 999)
{fontSize = 40}
drawText(430, 52, 190, 60, "+"+Math.round(data[0].confirmedIncr).toString(), new Color("#FF0000",0.8), "a",fontSize, "center")
// fillRect(0, 111, 642, 110, 0, new Color("121a2a",0.4))


// {
// fillRect(30+i*10, 219, 6, 2, 0, Color.gray())
// }

var IncrMax;
	for(i = 0; i<(TodayIncr.Top10.length) ;i++)
  {
if(TodayIncr.Top10[i].inboundIncr == undefined)
{TodayIncr.Top10[i].inboundIncr = 0}
let	temp = 
TodayIncr.Top10[i].confirmedIncr
// log("每项值"+temp)
	IncrMax = (temp > IncrMax || IncrMax == undefined ? temp : IncrMax)
	}
const incrDelta = 42/IncrMax
let gap = (425/TodayIncr.Top10.length)
// log ("长度:"+ TodayIncr.length+"，gap:"+ gap)

for(i = 0; i<(TodayIncr.Top10.length) ;i++)
{
let	totalTemp = 
(TodayIncr.Top10[i].confirmedIncr)*incrDelta
fillRect(37+i*gap, 174-totalTemp, 21, totalTemp, 0, innerColor)
let	temp = 
(TodayIncr.Top10[i].inboundIncr)*incrDelta
fillRect(37+i*gap, 174-temp, 21, temp, 0, outerColor)
let inboundIncr = TodayIncr.Top10[i].inboundIncr
if(inboundIncr==0)
{inboundIncr=""}
drawText(25+i*gap, 175, 45, 20, inboundIncr.toString(), outerColor, "a",14, "center")//境外输入数
let increasedNum = TodayIncr.Top10[i].confirmedIncr- TodayIncr.Top10[i].inboundIncr
if(increasedNum== 0)
{increasedNum=""}
drawText(25+i*gap, 158-totalTemp, 45, 20, increasedNum.toString(), innerColor, "a",14, "center")//本土新增数
drawText(25+i*gap, 195, 45, 20, TodayIncr.Top10[i].name, textColor3, "a",14, "center")//省份名称
}

fillRect(
// 460-((10-TodayIncr.length)*43)
490, 155, 80, 20, 0, innerColor)
drawText(
// 515-((10-TodayIncr.length)*43), 
490,157, 80, 30, "本土新增", new Color("ffffff",0.7), "a",14, "center")
fillRect(
// 460-((10-TodayIncr.length)*43)
490, 180, 80, 20, 0, outerColor)
drawText(
// 515-((10-TodayIncr.length)*43)
490, 182, 80, 30, "境外输入", new Color("ffffff",0.7), "a",14, "center")
drawText(485, 130, 190, 60, "新增Top 10", textColor4, "a",16, "left")
const widget = new ListWidget()
widget.setPadding(0, 0, 0, 0)

const scale = Device.screenScale()
const width = getWidgetSize().w
const height = getWidgetSize().h
// log (width)
const contentStack = widget.addStack()
contentStack.layoutVertically()
contentStack.size = new Size(width/scale, height/scale)
const InfoStack = contentStack.addStack()
InfoStack.size = new Size(width/scale, (221/296)*height/scale)
InfoStack.addImage(chartDrawing.getImage())
const newsStack = contentStack.addStack()// 
//newsStack.backgroundColor = new Color("333333", 0.08)
// new Color("121a2a", 1)
newsStack.layoutVertically()
newsStack.size = new Size(width/scale, (75/296)*height/scale)
newsStack.setPadding(5, 15, 5, 15)
// ##################
// let now = currentDate()
let time1 = new Date(covidnews[0].eventTime*1000)
// covidnews[0].eventTime
let df = new DateFormatter()
df.dateFormat = "MM/dd HH:mm"

const news1 = newsStack.addText(df.string(time1)+" " + covidnews[0].eventDescription)
  news1.font = Font.systemFont(10)
  news1.textColor = textColor5
  news1.url = covidnews[0].eventUrl

  newsStack.addSpacer(5)
//   
//   
let time2 = new Date(covidnews[1].eventTime*1000)

    const news2 = newsStack.addText(df.string(time2)+" " + covidnews[1].eventDescription)
  news2.font = Font.systemFont(10)
  news2.textColor = textColor5
  news2.url = covidnews[1].eventUrl
  
// ##################

//定义背景颜色
widget.backgroundColor = conf.theme === 'system'
    ? Color.dynamic(themes.light.background, themes.dark.background)
    : themes[conf.theme].background;

Script.setWidget(widget)
widget.presentMedium()
Script.complete()


function fillRect (x,y,width,height,cornerradio,color)
{
let path = new Path()
let rect = new Rect(x, y, width, height)
path.addRoundedRect(rect, cornerradio, cornerradio)
chartDrawing.addPath(path)
chartDrawing.setFillColor(color)
chartDrawing.fillPath()
}

function drawText(x, y, width,height,text,color,font,fontsize,alignment)
  {
    if (font=="a"){
chartDrawing.setFont(Font.boldRoundedSystemFont(fontsize))}
if (font=="default"){
chartDrawing.setFont(Font.lightMonospacedSystemFont(fontsize))}
if (font=="semibold"){
chartDrawing.setFont(Font.semiboldSystemFont(fontsize))}
  chartDrawing.setTextColor(color)
  if(alignment == "left")
  {chartDrawing.setTextAlignedLeft()}
  if(alignment == "center")
  {chartDrawing.setTextAlignedCenter()}
  if(alignment == "right")
  {chartDrawing.setTextAlignedRight()}
  chartDrawing.drawTextInRect(text, new Rect(x, y, width, height))
}

function Addblur (Img)
{
  const drawing = new DrawContext()
  drawing.size = Img.size
  const rect = new Rect(0, 0, drawing.size.width, drawing.size.height)
  drawing.drawImageInRect(Img, rect)
  drawing.setFillColor(new Color("000000", 0.02))
  drawing.fillRect(rect)

  let blurImg = drawing.getImage()
return blurImg
}

function getWidgetSize ()
{
let deviceSize = (Device.screenSize().height*scale).toString()
let deviceInfo = 
  {  "2778": {
    "models"  : ["12 Pro Max"],
    "small"   : { "w": 510,   "h":  510 },
    "medium"  : { "w": 1092,  "h": 510 },
    "large"   : { "w": 1092,  "h": 1146}
  },

  "2532": {
    "models"  : ["12", "12 Pro"],
    "small"   : {"w": 474,  "h": 474 },
    "medium"  : {"w": 1014, "h": 474 },
    "large"   : {"w": 1014, "h": 1062 }
  },
   
  "2688": {
    "models"  : ["Xs Max", "11 Pro Max"],
    "small"   : {"w": 507,  "h": 507},
    "medium"  : {"w": 1080, "h": 507},
    "large"   : {"w": 1080, "h": 1137}
  },
  
  "1792": {
    "models"  : ["11", "Xr"],
    "small"   : {"w": 338, "h": 338},
    "medium"  : {"w": 720, "h": 338},
    "large"   : {"w": 720, "h": 758}
  },
  
  "2436": {
    "models"  : ["X", "Xs", "11 Pro"],
    "small"   : {"w": 465, "h": 465},
    "medium"  : {"w": 987, "h": 465},
    "large"   : {"w": 987, "h": 1035}
  },
  
  "2208": {
    "models"  : ["6+", "6s+", "7+", "8+"],
    "small"   : {"w": 471, "h": 471},
    "medium"  : {"w": 1044, "h": 471},
    "large"   : {"w": 1044, "h": 1071}
  },
  
  "1334": {
    "models"  : ["6","6s","7","8"],
    "small"   : {"w": 296, "h": 296},
    "medium"  : {"w": 642, "h": 296},
    "large"   : {"w": 642, "h": 648}
  },

  "1136": {
    "models"  : ["5","5s","5c","SE"],
    "small"   : {"w": 282, "h": 282},
    "medium"  : {"w": 584, "h": 282},
    "large"   : {"w": 584, "h": 622}
  }
}

let widgetSize = deviceInfo[deviceSize].medium
return widgetSize
// 
}
