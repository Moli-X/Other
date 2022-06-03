// Author:Pih
// 该小组件为在作者Pih的基础上进行的UI界面修改及相关代码调整Telegram @anker1209
// 0427 - [1]加快了处理速度[2]减少了无意义的查询[3]减少报错
// Update time:2021/04/27

log("开始运行");

//#region 初始化设定

const files = FileManager.local(); //文件存储位置
const currentDate = new Date();
const apiKey = "UR8ASaplvIwavDfR"; //彩云天气apiKey，自行申请
const isShowLocation = true; // 是否显示位置信息
const tencentApiKey = ""; // 腾讯位置服务apiKey，自带官方key，也可以使用自己申请的
const lockLocation = false; //是否锁定定位信息
const lockLocationData = ""; // 锁定的定位信息，如果不填则从缓存中取
const locale = "zh_cn"; //时间显示语言
const newBG = false; //是否设置或者使用新的背景图片
const removeBG = false; //是否需要清空背景图片
const showYY = false; //是否只显示一言，否则优先显示日历事件
const numberOfEvents = 3; //显示事件数量
const targetDate = 360; //显示未来多少天内的日历事件
const ignoreCal = ""; //添加你需要不显示的事件的日历名称，多个日历用逗号分割，例如："中国节假日", "工作", "生日"

//#endregion

if (numberOfEvents <= 0) showYY = true;

//#region 颜色设置

const gColor = "ffffff"; //全局颜色，如果想调整各部分颜色，修改下方相应颜色即可
const dayColor = "ffffff"; // 白天 白色ffffff
const nightColor = "1C1C1C"; // 晚上 暗灰色1C1C1C
const bgcolor = new Color('#FFFAF0', 1); //背景颜色
const timecolor = new Color('#FF0000', 1); //时间颜色
const ctcolor = new Color('#00EE00', 1); //实时温度颜色
const ctbgcolor = new Color('#FF0000', 1); //实时温度条背景颜色
const ctfgcolor = new Color('#FF0000', 1); //实时温度条前景颜色
const todaycolor = new Color('#00EE00', 1); //今日最低最高温度颜色
const aircolor = new Color('#FF0000', 1); //AQI空气质量颜色
const dotcolor = new Color('#FF0000', 1); //虚线颜色
const etitlecolor = new Color('#FF0000', 1); //事件标题颜色
const etimecolor = new Color('#0000EE', 1); //事件时间颜色
const hourlycolor = new Color('#FF0000', 1); //小时预报文字颜色
const hourlybgcolor = new Color('#00EE00', 1); //小时预报温度条背景颜色
const hourlyfgcolor = new Color('#00EE00', 1); //小时预报温度条前景颜色
const daybarcolor = new Color('#FF0000', 1); //星期预报分割条颜色
const daycolor = new Color('#00FF00', 1); //星期预报文字颜色
const rainycolor = new Color('#00EE00', 1); //下雨天温度字体颜色
const yycolor = new Color('#00EE00', 1); //一言颜色
const btcolor = new Color('#FFA500', 1); //下雨天温度字体颜色

//#endregion

//#region 设备信息

const scale = Device.screenScale();
const widgetHeight = getWidgetSize().h;
const widgetWidth = getWidgetSize().w;
// 背景调整
const firstRibbonPosition = 10;
const secondRibbonPosition = 71;
const defaultfontsize = 20;
const slipPosition = 370;
const daystoShow = 6;

//#endregion

//#region 天气信息

const myLocation = await getLocation();
if (!myLocation) throw "定位失败";
// ######数据设定#######
const caiyun = await getCaiyunData();
if (!caiyun || !caiyun.dataToday || !caiyun.dataToday.result) throw "未加载到天气数据";
const alertInfo = caiyun.dataToday.result.alert.content[0];
// log ("预警信息"+alertInfo)
const dailyTemperature = caiyun.dataToday.result.daily.temperature;
const rainIndex = caiyun.dataToday.result.hourly.precipitation;
const comfortindex = caiyun.dataToday.result.realtime.life_index.comfort.index;
const feelslikeT = Math.round(caiyun.dataToday.result.realtime.temperature);
const currentTemperature = feelslikeT.toString(); // +"º"
const feeling = caiyun.dataToday.result.realtime.life_index.comfort.desc;
const realtimeweather = caiyun.dataToday.result.realtime.skycon;
const todaysunrise = caiyun.dataToday.result.daily.astro[0].sunrise.time;
const todaysunset = caiyun.dataToday.result.daily.astro[0].sunset.time;
const todaysunsetdate = caiyun.dataToday.result.daily.astro[0].date;

const tomorrowsunrise = caiyun.dataToday.result.daily.astro[1].sunrise.time;
const tomorrowsunrisedate = caiyun.dataToday.result.daily.astro[1].date;
const tomorrowsunset = caiyun.dataToday.result.daily.astro[1].sunset.time;

const data = caiyun.dataToday.result.hourly.temperature;
const dailydata = caiyun.dataToday.result.daily.temperature;
const Mainweather = caiyun.dataToday.result.daily.skycon;
const CHNAQI = caiyun.dataToday.result.realtime.air_quality.aqi.chn.toString();
const CHNAQIDes = caiyun.dataToday.result.realtime.air_quality.description.chn;
// log(CHNAQI)
const USAQI = caiyun.dataToday.result.realtime.air_quality.aqi.usa.toString();
// log(USAQI)

const weatherDesc = caiyun.dataToday.result.forecast_keypoint;

const probabilityOfRain = caiyun.dataToday.result.minutely.probability;
// log(probabilityOfRain)
const maxProbability =
    (Math.max(probabilityOfRain[0], probabilityOfRain[1], probabilityOfRain[2], probabilityOfRain[3]) * 100)
        .toString()
        .slice(0, 2) + "%";

//#endregion

// ######字体设置#######
const widget = new ListWidget();
widget.setPadding(0, 0, 0, 0);

//#region 根据日出日落时间更换背景色

let dyBgColor = new Color(dayColor, 1);
let replaceStr = "00:00";
let todaysunriseTime = new Date(todaysunsetdate.replace(replaceStr, todaysunrise));
let todaySunsetTime = new Date(todaysunsetdate.replace(replaceStr, todaysunset));
let tomorrowSunriseTime = new Date(tomorrowsunrisedate.replace(replaceStr, tomorrowsunrise));

if (currentDate.getTime() > todaySunsetTime.getTime() && currentDate.getTime() > todaysunriseTime) {
    dyBgColor = new Color(nightColor, 1);
}
if (currentDate.getTime() < todaySunsetTime.getTime() && currentDate.getTime() < todaysunriseTime) {
    dyBgColor = new Color(nightColor, 1);
}
widget.backgroundColor = dyBgColor;

//#endregion

//#region 背景选择

const imgPath = files.joinPath(files.documentsDirectory(), "testPath");
if (newBG && config.runsInApp) {
    const img = await Photos.fromLibrary();
    widget.backgroundImage = img;
    files.writeImage(imgPath, img);
} else {
    if (files.fileExists(imgPath)) {
        try {
            widget.backgroundImage = files.readImage(imgPath);
            log("读取图片成功");
        } catch (e) {
            widget.backgroundColor = bgcolor;
            log(e.message);
        }
    }
}
if (removeBG && files.fileExists(imgPath)) {
    try {
        files.remove(imgPath);
        log("背景图片清理成功");
    } catch (e) {
        widget.backgroundColor = bgcolor;
        log(e.message);
    }
}
//#endregion

//#region 顶部虚线绘制

const topDrawing = new DrawContext();
topDrawing.size = new Size(642, secondRibbonPosition + 17);
topDrawing.opaque = false;
topDrawing.respectScreenScale = true;
// for (i=0;i<78;i++)
// {drawLine(topDrawing,30+i*7.5, 84, 35+i*7.5, 84, dotcolor, 2)}

//#endregion

//#region 空气质量颜色以及程度

var AQIcolor;
// 选择 AQI 数据 USAQI or CHNAQI
let AQIData = CHNAQI;
if (AQIData <= 50) {
    ac = "00e400";
} else if (AQIData <= 100) {
    ac = "f8c50a";
} else if (AQIData <= 150) {
    ac = "ff7e00";
} else if (AQIData <= 200) {
    ac = "ff0000";
} else if (AQIData <= 300) {
    ac = "ba0033";
} else {
    ac = "7e0023";
}
AQIcolor = new Color(ac, 1);
fillRect(topDrawing, 522, 58, 90, 18, 6, AQIcolor);

//#endregion

//#region 位置信息

if (isShowLocation) {
    const areaData = await getLocationArea();
    if (areaData && areaData.result && areaData.result.address_component) {
        const city = areaData.result.address_component.city;
        const district = areaData.result.address_component.district;
        const street = areaData.result.address_component.street;

        //drawText(topDrawing,30, 28, 150, 24, city, timecolor, "regular",20,"left")

        drawText(topDrawing, 30, 28, 150, 24, district, timecolor, "regular", 20, "left");

        drawText(topDrawing, 30, 54, 150, 24, street, timecolor, "regular", 20, "left");
    }
}

//#endregion

//#region 日期显示

const df = new DateFormatter();
df.locale = locale;
const date = currentDate;

// 获取周数
let beginDate = new Date(date.getFullYear(), 0, 1);
let theWeek =
    "第" + Math.ceil((parseInt((date - beginDate) / (24 * 60 * 60 * 1000)) + 1 + beginDate.getDay()) / 7) + "周";
log("开始时间" + beginDate);
log("计算结果" + Math.ceil((parseInt((date - beginDate) / (24 * 60 * 60 * 1000)) + 1 + beginDate.getDay()) / 7));
log(theWeek);

// 星期 EEEE星期几 EEE周几
df.dateFormat = "EEE";
let week = df.string(date);

// 日期格式
df.dateFormat = "MMMd日";
let dateFormat = df.string(date);

// 获取农历信息
const lunarInfo = await getLunar(date.getDate() - 1);
let lunarJoinInfo = lunarInfo.infoLunarText + " " + lunarInfo.holidayText;

let datePointX = isShowLocation ? 140 : 30;
drawText(
    topDrawing,
    datePointX,
    28,
    250,
    24,
    currentDate.getFullYear().toString().concat("年").concat(dateFormat) + " " + theWeek,
    timecolor,
    "regular",
    20,
    "left"
);

drawText(topDrawing, datePointX, 54, 300, 24, week + " " + lunarJoinInfo, timecolor, "regular", 20, "left");
// drawText(topDrawing,160, firstRibbonPosition+40, 225, 24, lunarJoinInfo, timecolor, "regular",20,"left")

//#endregion

//#region 当天天气信息

// 当前天气
await drawIcon(topDrawing, 365, 30, realtimeweather, 40);
// 当前温度
drawText(topDrawing, 420, 25, 100, 54, currentTemperature, ctcolor, "regular", 52, "center");

// 空气质量&下雨概率
var textColortoShow;
textColortoShow = aircolor;
// 显示长度截取
let des = CHNAQIDes;
des = des.length > 2 ? des.slice(0, 2) : des;
drawText(topDrawing, 522, 58, 90, 17, AQIData + " - " + des, textColortoShow, "semibold", 15, "center");

//#region 温度条位置
var tempHeight;
if (feelslikeT < Math.round(dailyTemperature[0].min)) {
    tempHeight = 8;
}
if (feelslikeT > Math.round(dailyTemperature[0].max)) {
    tempHeight = 90;
}
if (feelslikeT >= Math.round(dailyTemperature[0].min) && feelslikeT <= Math.round(dailyTemperature[0].max)) {
    tempHeight =
        ((feelslikeT - Math.round(dailyTemperature[0].min)) * 82) /
            (Math.round(dailyTemperature[0].max) - Math.round(dailyTemperature[0].min)) +
        8;
}
//#endregion

//#region 温度条
fillRect(topDrawing, 522, 47, 90, 8, 4, ctbgcolor);
fillRect(topDrawing, 522, 47, tempHeight, 8, 4, ctfgcolor);
//#endregion

// 今天最高最低温度 +"º"
drawText(
    topDrawing,
    522,
    25,
    45,
    18,
    Math.round(dailyTemperature[0].min).toString(),
    todaycolor,
    "semibold",
    18,
    "left"
);
drawText(
    topDrawing,
    566,
    25,
    45,
    18,
    Math.round(dailyTemperature[0].max).toString(),
    todaycolor,
    "semibold",
    18,
    "right"
);

const contentStack = widget.addStack();
contentStack.layoutVertically();
contentStack.size = new Size(widgetWidth / scale, widgetHeight / scale);

const topStack = contentStack.addStack();
topStack.size = new Size(widgetWidth / scale, (widgetHeight * 98) / 296 / scale);
topStack.addImage(topDrawing.getImage());
// contentStack.url = 'calshow:' + (Math.floor(currentDate.getTime() / 1000) - 978307200)

//#endregion

//#region 获取日程和一言

const middleStack = contentStack.addStack();
middleStack.layoutHorizontally();
const eventStack = middleStack.addStack();
eventStack.size = new Size((widgetWidth * 355) / 642 / scale, (widgetHeight * (255 - 88)) / 296 / scale);
if (showYY) {
    eventStack.layoutVertically();
    eventStack.setPadding(0, 16, 0, 10);
    eventStack.addSpacer();

    const providepoetry = await poetry();
    let yy = providepoetry.hitokoto;
    let yyshow = eventStack.addText(yy);
    yyshow.font = Font.lightSystemFont(14);
    yyshow.textColor = yycolor;
    eventStack.addSpacer();

    const r1 = eventStack.addStack();
    r1.addSpacer();
    let author_who = r1.addText(providepoetry.from_who + "   " + providepoetry.from);
    author_who.font = Font.lightSystemFont(10);
    author_who.textColor = yycolor;
    author_who.textOpacity = 0.8;
    author_who.linelimit = 1;
    eventStack.addSpacer(6);
} else {
    const eventDrawing = new DrawContext();
    eventDrawing.size = new Size(355, 255 - 98);
    eventDrawing.opaque = false;
    eventDrawing.respectScreenScale = true;

    currentDate.setDate(currentDate.getDate());
    console.log(`Filter event by start date ${currentDate}`);
    // 结束时间设置为当日"+targetDate"天的日期
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + targetDate);
    console.log(`Filter event by end date ${endDate}`);

    const allEvents = await CalendarEvent.between(currentDate, endDate, []);
    console.log(`Get ${allEvents.length} events from this time range`);
    const futureEvents = showYY ? [] : enumerateEvents(allEvents);

    for (let i = 0; i < numberOfEvents; i++) {
        const event = futureEvents[i];
        if (!event) {
            break;
        }
        const eventColor = event.calendar.color;
        fillRect(eventDrawing, 30, 88 - 88 + i * 55, 5, 45, 2, eventColor);
        // 标题
        const title = event.title;

        drawText(eventDrawing, 45, 86 - 88 + i * 55, 305, 24, title, etitlecolor, "bold", 22, "left");
        // 限制行高。
        if (futureEvents.length >= 3) {
            title.lineLimit = 1;
        }
        // 格式化时间信息。
        let df = new DateFormatter();
        df.useShortDateStyle();
        // 剩余时间(日)
        const timeLeft =
            (df.date(df.string(event.startDate)) - df.date(df.string(currentDate))) / (1000 * 60 * 60 * 24);
        // const eventSeconds = Math.floor(currentDate.getTime() / 1000) - 978307200 + timeLeft * 3600 * 24;
        // const duration = (df.date(df.string(event.endDate)) - df.date(df.string(event.startDate))) / (1000 * 60 * 60 * 24); //事件持续时间

        // log(timeLeft)
        // 事件时间提醒
        var timeText;
        var eventTimeColor;
        if (timeLeft == 0) {
            df.useNoDateStyle();
            df.useShortTimeStyle();
            eventTimeColor = new Color("0000ff");
            if (event.isAllDay) {
                timeText = "今天全天";
            } else {
                timeText = "今天" + df.string(event.startDate);
                console.log(`${df.date(df.string(event.startDate))}`);
            }
        }
        //     } else {
        if (
            timeLeft < 0
            //     && duration > 0
        ) {
            let df = new DateFormatter();
            const longEventDate = "d日HH:mm";
            df.dateFormat = longEventDate;
            timeText = df.string(event.startDate) + "-" + df.string(event.endDate);
            // 今日事件字体颜色
            eventTimeColor = new Color("0000ff");
        }
        //       else {
        if (timeLeft == 1) {
            df.useNoDateStyle();
            df.useShortTimeStyle();
            if (event.isAllDay) {
                timeText = "明天全天";
                eventTimeColor = new Color("0000ff");
            } else {
                timeText = "明天" + df.string(event.startDate);
                eventTimeColor = new Color("0000ff");
            }
        }
        //         else{
        if (timeLeft > 1) {
            let df = new DateFormatter();
            let startTime = event.startDate;
            let finishTime = event.endDate;
            df.dateFormat = "EEE";
            let eee = df.string(startTime);
            df.dateFormat = "MMMd日";
            let ddd = df.string(startTime);
            let sep = "-";
            df.dateFormat = "h:mm";
            let detailTimes = df.string(startTime) + sep + df.string(finishTime);
            if (event.isAllDay) {
                timeText = eee + " " + ddd + " 在" + timeLeft + "天之后";
            } else {
                timeText = eee + " " + ddd + " " + detailTimes + " 在" + timeLeft + "天之后";
            }
            eventTimeColor = etimecolor;
            //         log(timeText)
        }
        //         log (timeText)
        drawText(eventDrawing, 45, 88 - 88 + i * 55 + 25, 305, 30, timeText, eventTimeColor, "medium", 18, "left");
    }
    eventStack.addImage(eventDrawing.getImage());
}
eventStack.url = "calshow:" + (Math.floor(currentDate.getTime() / 1000) - 978307200);

//#endregion

//#region 天气预报
const weatherDrawing = new DrawContext();
weatherDrawing.size = new Size(642 - 355, 255 - 98);
weatherDrawing.opaque = false;
weatherDrawing.respectScreenScale = true;

const deltaX = (610 - slipPosition) / (daystoShow * 2);
const firstPointtoLeft = slipPosition + deltaX;

const ToTop = 120 - 98;
var min, max, diff;
for (var i = 0; i < daystoShow; i++) {
    let temp = Math.round(data[i].value);
    min = temp < min || min == undefined ? temp : min;
    max = temp > max || max == undefined ? temp : max;
}

diff = max - min;

if (diff == 0) {
    diff = diff + 1;
    max = max + 0.3;
}

for (i = 0; i < daystoShow - 1; i++) {
    let timeText = data[i].datetime.slice(11, 13);
}
//#region 小时预报
for (i = 0; i < daystoShow; i++) {
    // 颜色定义
    var temperaturetextcolor;
    var temeratureBarcolor;
    if (rainIndex[i * 2].value >= 0.06) {
        temperaturetextcolor = rainycolor;
        temeratureBarcolor = rainycolor;
    } else {
        temperaturetextcolor = hourlycolor;
        temeratureBarcolor = hourlyfgcolor;
    }

    // 温度条位置
    if (Math.round(data[i * 2].value) < Math.round(dailyTemperature[0].min)) {
        tempHeight = 8;
    }
    if (Math.round(data[i * 2].value) >= Math.round(dailyTemperature[0].max)) {
        tempHeight = 40;
    }

    if (
        Math.round(data[i * 2].value) >= Math.round(dailyTemperature[0].min) &&
        Math.round(data[i * 2].value) < Math.round(dailyTemperature[0].max)
    )
        tempHeight =
            ((Math.round(data[i * 2].value) - Math.round(dailyTemperature[0].min)) * 32) /
                (Math.round(dailyTemperature[0].max) - Math.round(dailyTemperature[0].min)) +
            8;

    // ######温度条#######
    fillRect(weatherDrawing, firstPointtoLeft - 4 + 2.15 * i * deltaX - 355 - 5, 115 - 98 + 3, 8, 40, 4, hourlybgcolor);
    fillRect(
        weatherDrawing,
        firstPointtoLeft - 4 + 2.15 * i * deltaX - 355 - 5,
        150 - tempHeight - 98 + 3 + 5,
        8,
        tempHeight,
        4,
        temeratureBarcolor
    );

    // 温度+"º"
    drawText(
        weatherDrawing,
        firstPointtoLeft + deltaX * i * 2.15 - 20 - 355 - 5,
        150 - 98 + 10,
        40,
        20,
        Math.round(data[i * 2].value).toString(),
        temperaturetextcolor,
        "regular",
        16,
        "center"
    );

    // 时间
    let weathertimeText = data[i * 2].datetime.slice(11, 13);
    let zero = weathertimeText.slice(0, 1);
    weathertimeText = zero == 0 ? weathertimeText.replace("0", "") : weathertimeText;
    if (i == 0) {
        weathertimeText = "现在";
    } else {
        weathertimeText = weathertimeText + "时";
        // + ":00"
    }
    drawText(
        weatherDrawing,
        firstPointtoLeft + deltaX * i * 2.1 - 20 - 355 - 5,
        100 - 98 - 4,
        40,
        30,
        weathertimeText,
        temperaturetextcolor,
        "regular",
        16,
        "center"
    );
}
//#endregion
//#region 每日预报
for (i = 1; i < 4; i++) {
    //   log(Mainweather[i].value)

    // 图标
    await drawIcon(weatherDrawing, 10 + 88 * (i - 1) + 40 - 1 - 3, 196 - 98 - 10 + 3, Mainweather[i].value, 30);

    // 每日温度+"º"
    let dMax = Math.round(dailydata[i].max).toString();
    let dMin = Math.round(dailydata[i].min).toString();
    fillRect(weatherDrawing, 5 + 88 * (i - 1) + 6 + 1, 173 - 98 + 40 + 16 + 2, 70, 4, 2, daybarcolor);
    drawText(
        weatherDrawing,
        5 + 88 * (i - 1) + 6 + 1,
        173 - 98 + 20 + 62 - 18,
        40,
        20,
        dMin,
        daycolor,
        "regular",
        18,
        "left"
    );
    drawText(
        weatherDrawing,
        5 + 88 * (i - 1) + 6 + 40 + 1,
        173 - 98 + 20 + 62 - 18,
        30,
        20,
        dMax,
        daycolor,
        "regular",
        18,
        "right"
    );

    // 每日日期
    const weatherDate = new Date();
    weatherDate.setDate(weatherDate.getDate() + i);
    // log(weatherDate)
    df.dateFormat = "E";
    drawText(
        weatherDrawing,
        5 + 88 * (i - 1) - 1,
        173 - 98 + 24,
        50,
        20,
        df.string(weatherDate),
        daycolor,
        "a",
        16,
        "center"
    );
}

const weatherStack = middleStack.addStack();
weatherStack.size = new Size((widgetWidth * (642 - 355)) / 642 / scale, (widgetHeight * (255 - 98)) / 296 / scale);
weatherStack.addImage(weatherDrawing.getImage());
weatherStack.url = "https://caiyunapp.com/weather/";
//#endregion

//#endregion

//#region 底部信息展示
const bottomDrawing = new DrawContext();
bottomDrawing.size = new Size(642, 296 - 255);
bottomDrawing.opaque = false;
bottomDrawing.respectScreenScale = true;

// 底部虚线绘制
// for (i=0;i<78;i++)
// {drawLine(bottomDrawing,30+i*7.5, 1, 35+i*7.5, 1,
// dotcolor, 2)}

// 如果没有预警信息，显示天气描述
var content;
var alertTextColor;
// log (alertInfo)
if (alertInfo == undefined) {
    content = weatherDesc;
} else {
    content = "注意：" + alertInfo.title;
}
drawText(bottomDrawing, 0, 7, 642, 25, content, btcolor, "regular", 20, "center");

const bottomStack = contentStack.addStack();
bottomStack.size = new Size(widgetWidth / scale, (widgetHeight * (296 - 255)) / 296 / scale);
bottomStack.addImage(bottomDrawing.getImage());

//#endregion

Script.setWidget(widget);
widget.presentMedium();
Script.complete();

//#region 绘画帮助
/** 画线 */
function drawLine(drawing, x1, y1, x2, y2, color, width) {
    let path = new Path();
    path.move(new Point(Math.round(x1), Math.round(y1)));
    path.addLine(new Point(Math.round(x2), Math.round(y2)));

    drawing.addPath(path);
    drawing.setStrokeColor(color);
    drawing.setLineWidth(width);
    drawing.strokePath();
}

/** 绘制文字 */
function drawText(drawing, x, y, width, height, text, color, font, fontsize, alignment) {
    if (font == "a") {
        drawing.setFont(Font.boldRoundedSystemFont(fontsize));
    }
    if (font == "default") {
        drawing.setFont(Font.lightMonospacedSystemFont(fontsize));
    }
    if (font == "semibold") {
        drawing.setFont(Font.semiboldSystemFont(fontsize));
    }
    if (font == "bold") {
        drawing.setFont(Font.boldSystemFont(fontsize));
    }
    if (font == "medium") {
        drawing.setFont(Font.mediumSystemFont(fontsize));
    }
    if (font == "regular") {
        drawing.setFont(Font.regularSystemFont(fontsize));
    }
    drawing.setTextColor(color);
    if (alignment == "left") {
        drawing.setTextAlignedLeft();
    }
    if (alignment == "center") {
        drawing.setTextAlignedCenter();
    }
    if (alignment == "right") {
        drawing.setTextAlignedRight();
    }
    drawing.drawTextInRect(text, new Rect(x, y, width, height));
}

/** 绘制主要天气图标 */
async function drawIcon(drawing, x1, y1, WeatherCondition, size) {
    if (WeatherCondition == "CLOUDY") {
        y1 = y1 + 8;
    }
    if (
        WeatherCondition == "LIGHT_RAIN" ||
        WeatherCondition == "MODERATE_RAIN" ||
        WeatherCondition == "HEAVY_RAIN" ||
        WeatherCondition == "STORM_RAIN"
    ) {
        y1 = y1 + 4;
    }

    await drawSfs(drawing, x1, y1, provideSymbol(WeatherCondition, 0), size, "FFFFFF");
}

/** 提供天气图标名称 */
function provideSymbol(cond, night) {
    //   log("字体大小"+size)
    let symbols = {
        CLEAR_DAY: function () {
            return "sun.max.fill";
        },
        CLEAR_NIGHT: function () {
            return "moon.stars.fill";
        },
        PARTLY_CLOUDY_DAY: function () {
            return "cloud.sun.fill";
        },
        PARTLY_CLOUDY_NIGHT: function () {
            return "cloud.moon.fill";
        },
        CLOUDY: function () {
            return "cloud.fill";
        },
        LIGHT_HAZE: function () {
            return night ? "cloud.fog.fill" : "sun.haze.fill";
        },
        MODERATE_HAZE: function () {
            return night ? "cloud.fog.fill" : "sun.haze.fill";
        },
        HEAVY_HAZE: function () {
            return night ? "cloud.fog.fill" : "sun.haze.fill";
        },
        LIGHT_RAIN: function () {
            return "cloud.drizzle.fill";
        },
        MODERATE_RAIN: function () {
            return "cloud.rain.fill";
        },
        HEAVY_RAIN: function () {
            return "cloud.rain.fill";
        },
        STORM_RAIN: function () {
            return "cloud.heavyrain.fill";
        },
        FOG: function () {
            return "cloud.fog.fill";
        },
        LIGHT_SNOW: function () {
            return "cloud.sleet.fill";
        },
        MODERATE_SNOW: function () {
            return "cloud.snow.fill";
        },
        HEAVY_SNOW: function () {
            return "cloud.snow.fill";
        },
        STORM_SNOW: function () {
            return "snow";
        },
        DUST: function () {
            return night ? "cloud.fog.fill" : "sun.dust.fill";
        },
        SAND: function () {
            return night ? "cloud.fog.fill" : "sun.dust.fill";
        },
        WIND: function () {
            return "wind";
        },
    };
    return symbols[cond]();
}

/** 绘制symblos */
async function drawSfs(drawing, x1, y1, symblos, size, color) {
    let sfs = SFSymbol.named(symblos);
sfs.applyFont(Font.systemFont(size));
    let img = sfs.image;
    let col = new Color(color ? color : "FFFFFF");
    let tintedSymbol = await tintSFSymbol(img, col);
    let symbolCanvas = new DrawContext();
    symbolCanvas.opaque = false;
    symbolCanvas.size = new Size(size, size);
    const symbolRect = new Rect(0, 0, size, size);
    symbolCanvas.drawImageInRect(tintedSymbol, symbolRect);
    const newSymbolImage = symbolCanvas.getImage();
    drawing.drawImageAtPoint(newSymbolImage, new Point(x1, y1));
}

function fillRect(drawing, x, y, width, height, cornerradio, color) {
    let path = new Path();
    let rect = new Rect(x, y, width, height);
    path.addRoundedRect(rect, cornerradio, cornerradio);
    drawing.addPath(path);
    drawing.setFillColor(color);
    drawing.fillPath();
}

function drawPoint(drawing, x1, y1, color, diaofPoint) {
    let currPath = new Path();
    currPath.addEllipse(new Rect(x1, y1, diaofPoint, diaofPoint));
    drawing.addPath(currPath);
    drawing.setFillColor(color);
    drawing.fillPath();
}
//#endregion

//#region 数据获取

/** 获取彩云天气数据# */
async function getCaiyunData() {
    var data;
    var cacheValue = cacheGet("CaiyunCache", 120);
    // 假设存储器已经存在且距离上次请求时间不足60秒，使用存储器数据
    if (cacheValue) {
        log("==>请求时间间隔过小，使用缓存数据");
        data = jsonParse(cacheValue);
        // 否则利用 api 得到新的数据
    } else {
        try {
            const weatherReq =
                "https://api.caiyunapp.com/v2.5/" +
                apiKey +
                "/" +
                myLocation +
                "/weather.json?alert=true&dailysteps=7&lang=zh_CN";
            const dataToday = await new Request(weatherReq).loadJSON();
            log(JSON.stringify(weatherReq));
            data = { dataToday };
            cacheSet("CaiyunCache", JSON.stringify(data));
            log("==>天气信息请求成功");
        } catch (e) {
            data = jsonParse(cacheGet("CaiyunCache"), {});
            log("==>天气信息请求失败，使用缓存数据/" + e.message);
        }
    }
    return data;
}

/** 获取定位信息 */
async function getLocation() {
    var latitude, longitude;
    var locationString;
    // 如果位置设定保存且锁定了，从缓存文件读取信息
    var locationCache = cacheGet("mylocation", 120);
    if (lockLocation) {
        log("位置锁定，使用预设或缓存数据" + locationString);
        locationString = lockLocationData || locationCache;
    } else if (locationCache) {
        log("位置查询过于频繁,使用缓存数据" + locationCache);
        locationString = locationCache;
    } else {
        try {
            const location = await Location.current();
            latitude = location.latitude;
            longitude = location.longitude;
            locationString = longitude + "," + latitude;
            cacheSet("mylocation", locationString);
            log("==>定位成功");
        } catch (e) {
            locationString = cacheGet("mylocation");
            log("==>无法定位，使用缓存定位数据/" + e.message);
        }
        //   return locationString
    }
    log("地址" + locationString);
    return locationString;
}

/** 根据定位信息获取位置信息
 * location 经纬度
 * key API key
 * get_poi 位置周边数据 0否 1是
 */
async function getLocationArea() {
    let area;
    // 加个缓存
    let areaCache = cacheGet("areaCache", 120);
    // 假设存储器已经存在且距离上次请求时间不足60秒，使用存储器数据
    if (areaCache) {
        log("腾讯位置API请求时间间隔过小，使用缓存数据");
        area = jsonParse(areaCache);
    }
    if (area) return area;
    let locationLs = myLocation.split(",");
    try {
        // 官方文档的key
        let testKey = "OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77";
        let apiKey = tencentApiKey == "" ? testKey : tencentApiKey;
        let areaReq =
            "https://apis.map.qq.com/ws/geocoder/v1?location=" +
            locationLs[1] +
            "," +
            locationLs[0] +
            "&key=" +
            apiKey +
            "&get_poi=0";
        let areaRequest = new Request(areaReq);
        let header = { Referer: "https://lbs.qq.com/" };
        areaRequest.method = "GET";
        areaRequest.headers = header;
        area = await areaRequest.loadJSON();
        log("腾讯位置API请求成功：" + areaReq);
        cacheSet("areaCache", JSON.stringify(area));
    } catch (err) {
        log("getLocationArea出错：" + err.message);
        area = jsonParse(cacheGet("areaCache"));
    }
    return area;
}

/** 未来事件 */
function enumerateEvents(allEvents) {
    let futureEvents = [];
    for (const event of allEvents) {
        if (
            event.endDate.getTime() > currentDate.getTime() &&
            !event.title.startsWith("Canceled:") &&
            ![ignoreCal].includes(event.calendar.title)
        ) {
            futureEvents.push(event);
        }
    }
    return futureEvents;
}

/** 获取一言 */
async function poetry() {
    var poetryData;
    try {
        poetryData = await new Request("https://v1.hitokoto.cn/?c=i&encode=json&max_length=40").loadJSON();
        cacheSet("yiyan", JSON.stringify(poetryData));
        log("==>一言获取成功");
    } catch (e) {
        poetryData = jsonParse(cacheGet("yiyan"));
        log("==>获取一言失败，使用缓存数据");
    }

    return poetryData;
}

/** 获取万年历 */
async function getLunar(day) {
    // 缓存key
    const cacheKey = "lsp-lunar-cache";
    // 万年历数据
    let response = undefined;
    try {
        const request = new Request("https://wannianrili.51240.com/");
        const defaultHeaders = {
            "user-agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.67 Safari/537.36",
        };
        request.method = "GET";
        request.headers = defaultHeaders;
        const html = await request.loadString();
        let webview = new WebView();
        await webview.loadHTML(html);
        var getData = `
            function getData() {
                try {
                    infoLunarText = document.querySelector('div#wnrl_k_you_id_${day}.wnrl_k_you .wnrl_k_you_id_wnrl_nongli').innerText
                    holidayText = document.querySelectorAll('div.wnrl_k_zuo div.wnrl_riqi')[${day}].querySelector('.wnrl_td_bzl').innerText
                    if(infoLunarText.search(holidayText) != -1) {
                        holidayText = ''
                    }
                } catch {
                    holidayText = ''
                }
                return {infoLunarText: infoLunarText, holidayText: holidayText}
            }
            
            getData()`;

        // 节日数据
        response = await webview.evaluateJavaScript(getData, false);
        cacheSet(cacheKey, JSON.stringify(response));
        console.log(`农历输出：${JSON.stringify(response)}`);
    } catch (e) {
        console.error(`农历请求出错：${e}`);
        if (Keychain.contains(cacheKey)) {
            response = jsonParse(cacheGet(cacheKey));
        }
    }

    return response;
}

//#endregion

//#region 帮助类

function getWidgetSize() {
    let deviceSize = (Device.screenSize().height * scale).toString();
    let deviceInfo = {
        2778: {
            models: ["12 Pro Max"],
            small: { w: 510, h: 510 },
            medium: { w: 1092, h: 510 },
            large: { w: 1092, h: 1146 },
        },

        2532: {
            models: ["12", "12 Pro"],
            small: { w: 474, h: 474 },
            medium: { w: 1014, h: 474 },
            large: { w: 1014, h: 1062 },
        },

        2688: {
            models: ["Xs Max", "11 Pro Max"],
            small: { w: 507, h: 507 },
            medium: { w: 1080, h: 507 },
            large: { w: 1080, h: 1137 },
        },

        1792: {
            models: ["11", "Xr"],
            small: { w: 338, h: 338 },
            medium: { w: 720, h: 338 },
            large: { w: 720, h: 758 },
        },

        2436: {
            models: ["X", "Xs", "11 Pro"],
            small: { w: 465, h: 465 },
            medium: { w: 987, h: 465 },
            large: { w: 987, h: 1035 },
        },

        2208: {
            models: ["6+", "6s+", "7+", "8+"],
            small: { w: 471, h: 471 },
            medium: { w: 1044, h: 471 },
            large: { w: 1044, h: 1071 },
        },

        1334: {
            models: ["6", "6s", "7", "8"],
            small: { w: 296, h: 296 },
            medium: { w: 642, h: 296 },
            large: { w: 642, h: 648 },
        },

        1136: {
            models: ["5", "5s", "5c", "SE"],
            small: { w: 282, h: 282 },
            medium: { w: 584, h: 282 },
            large: { w: 584, h: 622 },
        },
    };

    let widgetSize = deviceInfo[deviceSize].medium;
    return widgetSize;
}
/** json处理,防止报错 */
function jsonParse(str, dft) {
    if (typeof str == "string") {
        try {
            return JSON.parse(str);
        } catch (e) {
            if (dft) return dft;
            return undefined;
        }
    }
    return undefined;
}
/** 获取缓存数据 */
function cacheGet(key, allowSeconds) {
    let cache = "";
    if (!Keychain.contains(key)) return cache;
    var json = jsonParse(Keychain.get(key));
    if (allowSeconds && allowSeconds > 0) {
        if (currentDate - json.time <= allowSeconds * 1000) cache = json.value;
    } else {
        cache = json.value;
    }
    return cache;
}
/** 设置缓存数据
 * @param {String} key key
 * @param {String} value value
 */
function cacheSet(key, value) {
    if (value == null || value == undefined) return;
    if (typeof value != "string") value = JSON.stringify(value);
    Keychain.set(
        key,
        JSON.stringify({
            value: value,
            time: new Date().getTime(),
        })
    );
}
/** 删除缓存数据 */
function cacheDel(key) {
    Keychain.remove(key);
}

/**
 * source: https://talk.automators.fm/t/define-the-color-of-a-sf-symbols-in-drawcontext/9897/3
 * @param {Image} image The image from the SFSymbol
 * @param {Color} color The color it should be tinted with
 */
async function tintSFSymbol(image, color) {
    let html = `
    <img id="image" src="data:image/png;base64,${Data.fromPNG(image).toBase64String()}" />
    <canvas id="canvas"></canvas>
    `;

    let js = `
      let img = document.getElementById("image");
      let canvas = document.getElementById("canvas");
      let color = 0x${color.hex};
  
      canvas.width = img.width;
      canvas.height = img.height;
      let ctx = canvas.getContext("2d");
      ctx.drawImage(img, 0, 0);
      let imgData = ctx.getImageData(0, 0, img.width, img.height);
      // ordered in RGBA format
      let data = imgData.data;
      for (let i = 0; i < data.length; i++) {
        // skip alpha channel
        if (i % 4 === 3) continue;
        // bit shift the color value to get the correct channel
        data[i] = (color >> (2 - i % 4) * 8) & 0xFF
      }
      ctx.putImageData(imgData, 0, 0);
      canvas.toDataURL("image/png").replace(/^data:image\\/png;base64,/, "");
    `;

    let wv = new WebView();
    await wv.loadHTML(html);
    let base64 = await wv.evaluateJavaScript(js);
    return Image.fromData(Data.fromBase64String(base64));
}

//#endregion
