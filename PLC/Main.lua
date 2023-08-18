local ListNumber=5
local ListRange={0,0,1,15,16,16,17,24,25,69}


--====================上海大花智能追蹤點膠公版程序==================================
--====================2023.08.15 CAD-CAM               ==================================
--[[                  地址定義
=========input&output=============================================================
/* Others */ 
0x3000-----"DW"------产量
0x3002-----"W"-------WorkFlg，0:空跑 / 1:工作
0x3003-----"W"-------WorkDO，排膠DO編號（1~12）
0x3004-----"W"-------主站手臂編號：0-3
0x3005-----"W"-------Robot1State，0:禁用 / 1:啟用
0x3006-----"W"-------Robot2State，0:禁用 / 1:啟用
0x3007-----"W"-------Robot3State，0:禁用 / 1:啟用
0x3008-----"W"-------Robot4State，0:禁用 / 1:啟用
0x3009-----"W"-------當前手臂编号，0-3
0x300A-----"W"-------CVT测试使用，用于决定当前手臂是否动作，0不动作/1动作
0x300B----"W"-------CT----单位ms


/* CVT Parameter */from PC  
------------皮带1---------------------------------------------
0x3010------"DW"-----CV1_cvtSpeedOffset，   %d, like 98% --> 98, 
0x3012------"DW"-----CV1_visionlengthOffset --um,%d
0x3014------"DW"-----CV1_cvtFactor_num      --um,%d
0x3016------"DW"-----CV1_cvtFactor_den      --puu,%d
0x3018------"DW"-----CV1_CVCmpstVectorP1_X  --um,%d
0x301A------"DW"-----CV1_CVCmpstVectorP1_Y  --um,%d
0x301C------"DW"-----CV1_CVCmpstVectorP2_X  --um,%d 
0x301E------"DW"-----CV1_CVCmpstVectorP2_Y  --um,%d
0x3020------"DW"-----CV1_VisionLength       --um,%d
0x3022------"DW"-----CV1_TrigLine_X         --um,%d
0x3024------"DW"-----CV1_TrigLine_Y         --um,%d
0x3026------"DW"-----CV1_EndLine_X          --um,%d
0x3028------"DW"-----CV1_EndLine_Y          --um,%d
0x302A------"W"------CV1_CvtMode     ，1:有視覺 / 2:無視覺
0x302B------"W"------CV1_CvtTrigMode ，1:DO觸發 / 2:DI觸發
0x302C------"W"------CV1_UserDefineDI       --DI编号
0x302D------"W"------CV1_UserDefineDO       --DO编号
0x302E------"W"------CV1_CamTrigTime        --ms,%d 

/* Process Parameter */to PC
0x3030,"DW" : error_num :記錄一次錯誤數據 

------四点标定相机和手臂点位-------------------------------------
0x3050-----"DW"-----"CamX1" --pixel, %.3f
0x3052-----"DW"-----"CamY1" --pixel, %.3f
0x3054-----"DW"-----"CamX2" --pixel, %.3f
0x3056-----"DW"-----"CamY2" --pixel, %.3f
0x3058-----"DW"-----"CamX3" --pixel, %.3f
0x305A-----"DW"-----"CamY3" --pixel, %.3f
0x305C-----"DW"-----"CamX4" --pixel, %.3f
0x305E-----"DW"-----"CamY4" --pixel, %.3f

0x3060-----"DW"-----"RobX1" --mm,%.3f
0x3062-----"DW"-----"RobY1" --mm,%.3f
0x3064-----"DW"-----"RobX2" --mm,%.3f
0x3066-----"DW"-----"RobY2" --mm,%.3f
0x3068-----"DW"-----"RobX3" --mm,%.3f
0x306A-----"DW"-----"RobY3" --mm,%.3f
0x306C-----"DW"-----"RobX4" --mm,%.3f
0x306E-----"DW"-----"RobY4" --mm,%.3f	

/* Point Information */from PC
---------待机点---------------------------------------------------
0x3090-----"DW"-----待机点"X"
0x3092-----"DW"-----待机点"Y"
0x3094-----"DW"-----待机点"Z"
0x3096-----"DW"-----待机点"RY"
0x3098-----"DW"-----待机点"RZ"
0x309A-----"DW"-----待机点"UF"
0x309C-----"DW"-----待机点"TF"
0x309E-----"DW"-----待机点"Hand"

---------自動排膠点---------------------------------------------------
0x30A0-----"DW"-----待机点"X"
0x30A2-----"DW"-----待机点"Y"
0x30A4-----"DW"-----待机点"Z"
0x30A6-----"DW"-----待机点"RY"
0x30A8-----"DW"-----待机点"RZ"
0x30AA-----"DW"-----待机点"UF"
0x30AC-----"DW"-----待机点"TF"
0x30AE-----"DW"-----待机点"Hand"

-------量产工艺参数----------------
0x30F0----"W"------SpdL----单位mm/s
0x30F1----"W"------SpdJ---单位百分比
0x30F2----"W"------开胶延时---单位ms
0x30F3----"W"------关胶延时---单位ms
0x30F4----"W"------NGZoneRadius--单位mm
0x30F5----"W"------radius----单位mm


DXF檔案分段設置
0x30FC  , "DW" : SectionEnable，啟用分段參數 1启用  2禁用
0x30FE  , "DW" : SectionNum，分段設置數量
0x3100+i*16+0, "DW" : SectionOffsetX[i+1], 
0x3100+i*16+2, "DW" : SectionOffsetY[i+1], 
0x3100+i*16+4, "DW" : SectionOffsetZ[i+1], 
0x3100+i*16+6, "DW" :  每段点位与上方点的高度差
0x3100+i*16+8, "DW" : SectionGlueTime[i+1], 
0x3100+i*16+10, "DW" : SectionGlueSpeed[i+1], 
0x3100+i*16+12, "DW" : SectionPointsNum[i+1], 
0x3100+i*16+14, "DW" : SectionIsDisable[i+1], 

示教點位單點
0x31FC  , "DW" : Sinlept_sum，單點點位數量
0x3200+i*16+0, "DW" : 單點點位X, 
0x3200+i*16+2, "DW" : 單點點位Y, 
0x3200+i*16+4, "DW" : 單點點位Z, 
0x3200+i*16+6, "DW" :  "Zup":上方点上升高度
0x3200+i*16+8, "DW" : 單點點位RZ, 
0x3200+i*16+10, "DW" : 單點點位H, 
0x3200+i*16+12, "DW" : 單點點位出膠時間, 

示教點位連續
0x31FE  , "DW" : Sinlept_sum，連續軌跡數量
0x3300+i*16+0, "DW" : 連續軌跡點位X, 
0x3300+i*16+2, "DW" : 連續軌跡點位Y, 
0x3300+i*16+4, "DW" : 連續軌跡點位Z, 
0x3200+i*16+6, "DW" :  "Zup":上方点上升高度
0x3300+i*16+8, "DW" : 連續軌跡點位RZ, 
0x3300+i*16+10, "DW" : 連續軌跡點位H, 
0x3300+i*16+12, "DW" : 連續軌跡出膠速度, 

--]]
--================================================================================
--================================================================================
--================================================================================

PointNum={}--轨迹段落数据处理 
Total = 1081
Count = 0 
LineHopsNum = 1  --连续轨迹跳点间隔
DefaultGlueTime=0.1             --默认的注胶时间，如上位未设置分段参数，则默认采用该值
DefaultGlueSpeed=2000           --默认的注胶速度
DefaultGlueAcc=25000            --默认的注胶加速度
DefaultGlueDec=25000            --默认的注胶減速度
SafeHset = 10                  --安全高度設置

Tolerance=1                     --根据轨迹的首尾两点之间的距离判断是否为闭合曲线，该参数视情况确认是否需要开出来
PassPointNum=10                 --闭合曲线，需要多走的点位数量
for i = 1,ListNumber do
	PointNum[i]={}
	PointNum[i][1]=ListRange[(i-1)*2+1]+1011 --第i段轨迹初始点
    PointNum[i][2]=ListRange[(i-1)*2+2]+1011 --第i段轨迹末尾点
end


--- <summary>从PC接收CVT参数</summary>
--- <argument name=" "> </argument>
function OnceDateFromPC()
    WorkFlg = ReadModbus(0x3002,"W") --1:Work / 0:NoWork
    WorkDO  = ReadModbus(0x3003,"W")
    CVTMasterIdx = ReadModbus(0x3004,"W") 
    Robot0State = ReadModbus(0x3005,"W")
    Robot1State = ReadModbus(0x3006,"W")
    Robot2State = ReadModbus(0x3007,"W")
    Robot3State = ReadModbus(0x3008,"W")
    CurrentRobotIndex=ReadModbus(0x3009,"W")
    CV1_cvtSpeedOffset = ReadModbus(0x3010,"DW")/100
    CV1_visionlengthOffset = ReadModbus(0x3012,"DW")-20000 
    CV1_cvtFactor_num = ReadModbus(0x3014,"DW")
    CV1_cvtFactor_den = ReadModbus(0x3016,"DW")
    CV1_CVCmpstVectorP1_X = ReadModbus(0x3018,"DW") 
    CV1_CVCmpstVectorP1_Y = ReadModbus(0x301A,"DW")
    CV1_CVCmpstVectorP2_X = ReadModbus(0x301C,"DW")
    CV1_CVCmpstVectorP2_Y =  ReadModbus(0x301E,"DW")
    CV1_VisionLength = ReadModbus(0x3020,"DW")
    CV1_TrigLine_X = ReadModbus(0x3022,"DW") 
    CV1_TrigLine_Y = ReadModbus(0x3024,"DW") 
    CV1_EndLine_X = ReadModbus(0x3026,"DW")  
    CV1_EndLine_Y = ReadModbus(0x3028,"DW")
    CV1_CVTMode = ReadModbus(0x302A,"W")
    CV1_CvtTrigMode = ReadModbus(0x302B,"W")
    CV1_UserDefineDI = ReadModbus(0x302C,"W")
    CV1_UserDefineDO = ReadModbus(0x302D,"W") 
    CV1_CamTrigTime = ReadModbus(0x302E,"W") 
    --CV1_CamTrigDist = ReadModbus(0x302F,"W") 

    CamX1 = ReadModbus(0x3050,"DW")/1000    
    CamY1 = ReadModbus(0x3052,"DW")/1000   
    CamX2 = ReadModbus(0x3054,"DW")/1000    
    CamY2 = ReadModbus(0x3056,"DW")/1000      
    CamX3 = ReadModbus(0x3058,"DW")/1000    
    CamY3 = ReadModbus(0x305A,"DW")/1000
    CamX4 = ReadModbus(0x305C,"DW")/1000    
    CamY4 = ReadModbus(0x305E,"DW")/1000          

    RobX1 = ReadModbus(0x3060,"DW")/1000
    RobY1 = ReadModbus(0x3062,"DW")/1000
    RobX2 = ReadModbus(0x3064,"DW")/1000
    RobY2 = ReadModbus(0x3066,"DW")/1000                      
    RobX3 = ReadModbus(0x3068,"DW")/1000
    RobY3 = ReadModbus(0x306A,"DW")/1000              
    RobX4 = ReadModbus(0x306C,"DW")/1000
    RobY4 = ReadModbus(0x306E,"DW")/1000                
end

--- <summary>从PC接收工艺参数</summary>
function GetCraftParam()
	RunSpeedL= ReadModbus(0x30F0, "W")
	RunSpeedJ= ReadModbus(0x30F1, "W")
	OpenGlueDelay=ReadModbus(0x30F2, "W")/1000
	CloseGlueDelay=ReadModbus(0x30F3, "W")/1000
	CV_NGZoneRadius=ReadModbus(0x30F4, "W")*1000   ---单位mm
	radius =ReadModbus(0x30F5, "W")   ---单位mm
end

--- <summary>从PC接收从站IP地址</summary>
function GetSlaveIP()
	SlaveIP3=ReadModbus(0x30B0, "W")
	SlaveIP4=ReadModbus(0x30B1, "W")
end

--- <summary>計算TransCCD</summary>
-- length:四點校正偏移距離
-- cmpstVectorX, cmpstVectorY, cmpstVectorZ:輸送帶移動方向向量
function CVT_CalTransCCD(length, cmpstVectorX, cmpstVectorY, cmpstVectorZ)
	local vector_length = cmpstVectorX*cmpstVectorX
	vector_length = vector_length + cmpstVectorY*cmpstVectorY
	vector_length = vector_length + cmpstVectorZ*cmpstVectorZ
	vector_length = SQRT(vector_length)
	cmpstVectorX = cmpstVectorX / vector_length
	cmpstVectorY = cmpstVectorY / vector_length
	cmpstVectorZ = cmpstVectorZ / vector_length
	--length = ABS(length)
	local trans_ccd_x = -1 * length * cmpstVectorX 
	local trans_ccd_y = -1 * length * cmpstVectorY 
	local trans_ccd_z = -1 * length * cmpstVectorZ 
	return trans_ccd_x, trans_ccd_y, trans_ccd_z
end

--- <summary>計算CV移動方向的向量</summary>
function CVT_CalCmpstVector(P1X, P1Y, P1Z, P2X, P2Y, P2Z)
	local cmpstVectorX, cmpstVectorY, cmpstVectorZ
	cmpstVectorX = P2X - P1X
	cmpstVectorY = P2Y - P1Y
	cmpstVectorZ = P2Z - P1Z
	local vectorLength = SQRT(cmpstVectorX*cmpstVectorX + cmpstVectorY*cmpstVectorY + cmpstVectorZ*cmpstVectorZ)
	cmpstVectorX = cmpstVectorX / vectorLength * 10000
	cmpstVectorY = cmpstVectorY / vectorLength * 10000
	cmpstVectorZ = cmpstVectorZ / vectorLength * 10000
	return cmpstVectorX, cmpstVectorY, cmpstVectorZ
end
--- <summary>CVT1參數設置</summary>
function CVT1Set()
	
    CV_ID = 1
    ---->輸送帶1參數設定<----
    --CV模式選擇
    CVT_SelectMode(CV_ID,CV1_CVTMode)              --1:视觉, 2:无视觉 
    CVT_SetTriggerMode(CV_ID, CV1_CvtTrigMode)     --1:DO觸發, 2:DI 感測器觸發
    if CVTMasterIdx == CurrentRobotIndex then
        CVT_SetUserDefineDO(CV_ID,CV1_UserDefineDO)    --觸發DO編號設定
    else
        CVT_SetUserDefineDI(CV_ID,CV1_UserDefineDI)    --感測器編號設定
    end

    CVT_SetCamTrigTime(CV_ID,CV1_CamTrigTime)      --觸發時間設定

    --編碼器比例
    cvtSpeedOffset = CV1_cvtSpeedOffset
    CV_interval = 10                               --均值濾波，1關閉
    CV_cvtFactor_num = CV1_cvtFactor_num *(1+cvtSpeedOffset)   -- 分子 ... (um)    --※输送带实际运转长度        
    CV_cvtFactor_den = CV1_cvtFactor_den * CV_interval       -- 分母(不可為0) ... (PUU or Pulse) P5-37 

    --輸送帶之於手臂的方向向量
    CVCmpstVectorP1_X = CV1_CVCmpstVectorP1_X            
    CVCmpstVectorP1_Y = CV1_CVCmpstVectorP1_Y
    CVCmpstVectorP1_Z = 0
    CVCmpstVectorP2_X = CV1_CVCmpstVectorP2_X
    CVCmpstVectorP2_Y = CV1_CVCmpstVectorP2_Y
    CVCmpstVectorP2_Z = 0

    cmpstVectorX, cmpstVectorY, cmpstVectorZ = 
    CVT_CalCmpstVector(CVCmpstVectorP1_X, CVCmpstVectorP1_Y, CVCmpstVectorP1_Z, 
                        CVCmpstVectorP2_X, CVCmpstVectorP2_Y, CVCmpstVectorP2_Z)    

    CV_cmpstVectorX = cmpstVectorX
    CV_cmpstVectorY = cmpstVectorY
    CV_cmpstVectorZ = 0

    --视觉与手臂偏移转换关系(um)
    visionlength_offset = CV1_visionlengthOffset    --相機與手臂偏移補正
    visionLength = CV1_VisionLength + visionlength_offset   --相機與手臂偏移

    trans_ccd_x, trans_ccd_y, trans_ccd_z = 
    CVT_CalTransCCD(visionLength, CV_cmpstVectorX, CV_cmpstVectorY, CV_cmpstVectorZ)
    CV_trans_ccd_x = trans_ccd_x
    CV_trans_ccd_y = trans_ccd_y
    CV_rotat_ccd_c = 0

    --視覺比例
    CV_vuPix2UmNum = 1      -- 距離轉換係數分子
    CV_vuPix2UmDen = 1      -- 距離轉換係數分母
    CV_vuAgRatioNum = 1     -- 角度轉換係數分子
    CV_vuAgRatioDen = 1     -- 角度轉換係數分母
    CV_vuXYExchgFlag = 0    -- 視覺座標系XY對調旗標，1開啟，0關閉  

    CV_NGZoneRadius = CV_NGZoneRadius     --样本預測落点区域大小(預設區域為圓，此為圓之半徑，單位um)

    --觸髮線
    CV_robotTrigLinePX = CV1_TrigLine_X
    CV_robotTrigLinePY = CV1_TrigLine_Y
    CV_robotTrigLine  = CVT_CalRobotTrigLine(CV_robotTrigLinePX, CV_robotTrigLinePY, CV_cmpstVectorX, CV_cmpstVectorY)

    --終止線
    CV_zoneEndPX = CV1_EndLine_X
    CV_zoneEndPY = CV1_EndLine_Y
    CV_zoneEndLine = CVT_CalZoneEndLine(CV_zoneEndPX, CV_zoneEndPY, CV_cmpstVectorX, CV_cmpstVectorY)


    --四點標定  
    C1 = Point(CamX1,CamY1)--(pixel)
    C2 = Point(CamX2,CamY2)--(pixel)
    C3 = Point(CamX3,CamY3)--(pixel)
    C4 = Point(CamX4,CamY4)--(pixel)
    P1 = Point(RobX1,RobY1)--(mm)
    P2 = Point(RobX2,RobY2)--(mm)
    P3 = Point(RobX3,RobY3)--(mm)
    P4 = Point(RobX4,RobY4)--(mm)

    CoordTransform_2D_Use(CV_ID, C1, C2, C3, C4, P1, P2, P3, P4)--如果转换关系设定于视觉，请屏蔽这行指令
    radius =radius
    CVT_SetNGZoneExistArea(CV_ID, P1, P2, P3, P4, radius)

    --進階參數，一般不需要改動
    CV_cvtuIdx = CV_ID   --CVT序號
    CV_vuIdx = CV_ID         
    CV_cvtUFIdx = CV_ID  --UF ID
    CV_instSlotIdx = CV_ID
    CV_instType = 2
    CV_instIdx = 1
    CV_srcType = 1                   --CV速度来源类型，1實體外部編碼器，3實體伺服命令，4實體伺服回授
    CV_srcIdx = 1                    --CV速度来源編號，實體外部編碼器：1~4，實體伺服命令：1~6 or 13~16，實體伺服回授：1~6 or 13~16
    CV_CRotatSwFlag = 0              --RZ軸旋轉與否 0->隨視覺角度旋轉, 1->RZ角度固定

    ---Advanced Function---
    --[[
    if (CurrentRobotIndex==CVTMasterIdx and CurrentRobotIndex==0 and Robot1State==1) then  --如果当前手臂是主站，并且当前手臂是第一台，并且第二台没被警用
        CVT_Master(2,1,{2,2}) 
        CVT_PartnerType("main") --設定為Partner Main
        CVT_Robot2(192, 168, SlaveIP3, SlaveIP4,true) --Via為.3
    end
    ]]
    CVT_PartnerType("MAIN") 
   -- CVT_Master(2,1,{1,1}) 
    CVT_Robot2(192, 168, SlaveIP3, SlaveIP4,true) --Via為.3
     
     
    CVT_Initialization(CV_cvtuIdx, CV_instType, CV_instIdx, CV_srcType, CV_srcIdx, CV_cvtFactor_num, CV_cvtFactor_den,
                        CV_interval, CV_cmpstVectorX, CV_cmpstVectorY, CV_cmpstVectorZ, CV_cvtUFIdx, CV_trans_ccd_x, CV_trans_ccd_y, CV_rotat_ccd_c,
                        CV_vuIdx, CV_vuPix2UmNum, CV_vuPix2UmDen, CV_vuAgRatioNum, CV_vuAgRatioDen, CV_vuXYExchgFlag, CV_CRotatSwFlag,
                        CV_NGZoneRadius, CV_zoneEndLine, CV_robotTrigLine, CV_instSlotIdx)			
end

--- <summary>检查输入数据是否在设定区间，是则返回1，否则返回0</summary>
function DateCheck (DateIns,Maxum,Minimum)
local DateChe = DateIns	
local MaxSet = Maxum
local MinSet = Minimum
local result
if DateChe< MinSet or DateChe> MaxSet then
	result = 0
else
    result = 1
end
return result	
end

function ResetUF1()
 UF1O_X=(CV1_TrigLine_X+CV1_EndLine_X)/2000
 UF1O_Y=(CV1_TrigLine_Y+CV1_EndLine_Y)/2000
 
 WritePoint("UF1O", "X",   UF1O_X)
 WritePoint("UF1O", "Y",   UF1O_Y)
 
 WritePoint("UF1X", "X",   UF1O_X+10)
 WritePoint("UF1X", "Y",   UF1O_Y)
 
 WritePoint("UF1Y", "X",   UF1O_X)
 WritePoint("UF1Y", "Y",   UF1O_Y+10)
 
 --SetUF(1, "UF1O", "UF1X", "UF1Y")
 
end

--- <summary>UF初始化程序，原點為觸髮線和終止線中點，方向平行大地坐標系，高度為0</summary>
--- <argument name=" "> 輸入UF編號、起始線XY和終止線xy</argument>
function UFReset(UFIdx,CV1_TrigLine_X,CV1_TrigLine_Y,CV1_EndLine_X,CV1_EndLine_Y)
local PoX = 0.5*( CV1_TrigLine_X +CV1_EndLine_X )/1000
local PoY = 0.5*( CV1_TrigLine_Y +CV1_EndLine_Y )/1000
local PxX = PoX + 10
local PxY = PoY
local PxyX = PxX
local PxyY = PxY + 10
--SetGlobalPoint(Point, PointName, X data, Y data, Z data, RZ data, Hand, UF, TF, JRC)
SetGlobalPoint(1, "GL_P0", PoX, PoY, 0, 0, 0, 0, 1, {0,0,0,1,0,0,0,4})
SetGlobalPoint(2, "GL_Px", PxX, PxY, 0, 0, 0, 0, 1, {0,0,0,1,0,0,0,4})
SetGlobalPoint(3, "GL_Py", PxyX, PxyY, 0, 0, 0, 0, 1, {0,0,0,1,0,0,0,4})
---------------------------------------------------------
SetUF(CV_cvtUFIdx,"GL_P0","GL_Px","GL_Py")
end
--- <summary>从PC接收全局待機點並寫到P1001</summary>
function GetStandbyPt()
	WritePoint(1001, "X",   ReadModbus(0x3090, "DW")/1000)
    WritePoint(1001, "Y",   ReadModbus(0x3092, "DW")/1000)
    WritePoint(1001, "Z",   ReadModbus(0x3094, "DW")/1000)
  --WritePoint(1001, "RY",  ReadModbus(0x3096, "DW")/1000)
	WritePoint(1001, "RZ",  ReadModbus(0x3098, "DW")/1000)
    WritePoint(1001, "UF",  ReadModbus(0x309A, "DW"))
    WritePoint(1001, "TF",  ReadModbus(0x309C, "DW")) 
    WritePoint(1001, "H",   ReadModbus(0x309E, "DW")) 
end


--- <summary>读取分段设定参数（速度/时间、X,Y,Z补偿值）</summary>
function  GetSectionParamFromPC()  
	SectionGlueTime={}
	SectionGlueSpeed={}
	SectionOffsetX={}
	SectionOffsetY={}
	SectionOffsetZ={}
	SectionOffsetZup={}
	SectionPointsNum={}
	SectionIsDisable={}
	SectionEnable=ReadModbus(0x30FC , "DW")    --0×30FC 分段设置啟用，啟用為1，未啟用為2
	SectionNum=ReadModbus(0x30FE , "DW")    --0×30FE 分段设置数量 
	if SectionEnable == 1 then
        for i=0,SectionNum-1 do
            SectionOffsetX[i+1]=ReadModbus(0x3100+i*16+0 , "DW")/1000
            SectionOffsetY[i+1]=ReadModbus(0x3100+i*16+2 , "DW")/1000
            SectionOffsetZ[i+1]=ReadModbus(0x3100+i*16+4 , "DW")/1000
            SectionOffsetZup[i+1]=ReadModbus(0x3100+i*16+6 , "DW")/1000
            SectionGlueTime[i+1]=ReadModbus(0x3100+i*16+8 , "DW")/1000
            SectionGlueSpeed[i+1]=ReadModbus(0x3100+i*16+10 , "DW")
            SectionPointsNum[i+1]=ReadModbus(0x3100+i*16+12 , "DW")
            SectionIsDisable[i+1]=ReadModbus(0x3100+i*16+14 , "DW")
        end   
    end
end

--- <summary>提取PC示教的单点涂胶点位</summary>
function ReadTeachSinglePointFromPC()
    SingleGlue_Zup={}  --接收单点涂胶上方点的抬升高度
    glue_time = {} --接收注胶时间，单位:s
    Sinlept_sum = ReadModbus(0x31FC,"DW")	
    for i = 0,Sinlept_sum-1 do 
    	WritePoint(0100+i, "X", ReadModbus(0x3200+i*16+0, "DW")/1000)
        WritePoint(0100+i, "Y", ReadModbus(0x3200+i*16+2, "DW")/1000)
        WritePoint(0100+i, "Z", ReadModbus(0x3200+i*16+4, "DW")/1000)
        SingleGlue_Zup[i]=ReadModbus(0x3200+i*16+6, "DW")/1000
        WritePoint(0100+i, "RZ", ReadModbus(0x3200+i*16+8,"DW")/1000)
        WritePoint(0100+i, "H", ReadModbus(0x3200+i*16+10, "DW"))
        WritePoint(0100+i, "UF",1) --默认UF1
        WritePoint(0100+i, "TF",1) --默认TF1
        glue_time[i] = ReadModbus(0x3200+i*16+12, "DW")/1000 
    end 
end

--- <summary>提取PC示教的连续涂胶点位，目前上位只允许示教一个连续轨迹</summary>
function ReadTeachContinuePointFromPC()
	ContinueGlue_Zup={}  --接收连续涂胶上方点的抬升高度
    glue_speed = {} --接收注胶速度，单位:s
    Continuept_sum = ReadModbus(0x31FE,"DW")	

    for i = 0,Continuept_sum-1 do 
        WritePoint(0200+i, "X", ReadModbus(0x3300+i*16+0, "DW")/1000)
        WritePoint(0200+i, "Y", ReadModbus(0x3300+i*16+2, "DW")/1000)
        WritePoint(0200+i, "Z", ReadModbus(0x3300+i*16+4, "DW")/1000)
        ContinueGlue_Zup[i]=ReadModbus(0x3300+i*16+6, "DW")/1000
        WritePoint(0200+i, "RZ", ReadModbus(0x3300+i*16+8,"DW")/1000)
        WritePoint(0200+i, "H", ReadModbus(0x3300+i*16+10, "DW"))
        WritePoint(0200+i, "UF",1) --默认UF1
        WritePoint(0200+i, "TF",1) --默认TF1
        glue_speed[i] = ReadModbus(0x3300+i*16+12, "DW") 
    end 
end

--- <summary>檢查閉合曲線</summary>
--- <argument name="Index">軌跡編號</argument>
function CheckSectionIsClose(Index)
	local PostionX1 = ReadPoint(PointNum[Index][1],"X") 
	local PostionY1 = ReadPoint(PointNum[Index][1],"Y") 
	local PostionX2 = ReadPoint(PointNum[Index][2],"X") 
	local PostionY2 = ReadPoint(PointNum[Index][2],"Y") 
	local Dis= POW((PostionY2-PostionY1),2)+POW((PostionX2-PostionX1),2)
	local num_sum = PointNum[Index][2] - PointNum[Index][1]
	if(SQRT(Dis)<Tolerance) and num_sum > PassPointNum then  --满足该条件，则判定为闭合曲线
        return 1
	else
        return 0
	end
end



--- <summary>檢查分段數量一致性，一致返回1，否則返回0</summary>
function CheckGlueSectionFromPC()
	if(SectionNum~=ListNumber) then   ---如果上位机发送的分段数量和本程序内的分段数量不符，则抛异常
        UserPrint("SectionNum is Error")
        return 0
    else
        for i = 1,ListNumber do
        	if(PointNum[i][2]-PointNum[i][1]+1~=SectionPointsNum[i]) then
        		UserPrint("ListRange is Error")
                return 0
        	end
        end
        return 1
    end
end

--- <summary>PC修改參數後出膠</summary>	
function GlueWithPCParam()
	for i = 1,ListNumber do
        	if(SectionIsDisable[i]==1) then
        		---如果该分段禁用，则不做动作
        	else
                Num=PointNum[i][1]
                MovL(PointNum[i][1]+Z(SectionOffsetZup[i]),"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至第i段轨迹初始点上方
                --UserPrint("SectionOffsetZ[i]=",SectionOffsetZ[i])
                --UserPrint("SectionOffsetZup[i]=",SectionOffsetZup[i])
                
                MovL(PointNum[i][1],DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至第i段轨迹初始点
                 --MovL(PointNum[i][1]+X(SectionOffsetX[i])+Y(SectionOffsetY[i])+Z(SectionOffsetZ[i]),"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)
                if(PointNum[i][2]-PointNum[i][1]==0) then   -- 单点  
                    if WorkFlg == 1 then
                        DO(GlueDO,"ON")
                    end
                    DELAY(SectionGlueTime[i])--开胶时间
                    --UserPrint("DefaultGlueTime=",DefaultGlueTime)
                     --UserPrint("SectionGlueTime[i]=",SectionGlueTime[i])
                else
                    if WorkFlg == 1 then
                        DO(GlueDO,"ON")
                    end
                    DELAY(OpenGlueDelay)   --开胶延时
                    while Num <= PointNum[i][2] do 
                        --可以根据i进行分段设置不同速度、加速度、跳点个数等参数
                        MovL(Num,"PASS",SectionGlueSpeed[i],DefaultGlueAcc,DefaultGlueDec)
                        Num = Num + LineHopsNum
                    end
                    if(SectionIsClose[i]==1) then   --如果是闭合曲线，则多走一定数量的点位，该参数视现场情况确定是否需要开出来
                        Num=PointNum[i][1]
                        while Num <= PointNum[i][1]+PassPointNum do 
                        --可以根据i进行分段设置不同速度、加速度、跳点个数等参数
                            MovL(Num,"PASS",SectionGlueSpeed[i],DefaultGlueAcc,DefaultGlueDec)
                            Num = Num + LineHopsNum
                        end
                    end
                end
                --第i段轨迹结束关胶等处理
                DO(GlueDO, "OFF") 
                DELAY(CloseGlueDelay) --关胶延时
                MovJ(3,(SectionOffsetZ[i]+SectionOffsetZup[i])) 
            end
        	
    end
end

--- <summary>PC示教的出膠,先單點再連續</summary>	
function GlueWithPCteach()
	if(Sinlept_sum>0) then
		for pt_now=0,Sinlept_sum-1 do
			MovL(0100 + pt_now +Z(SingleGlue_Zup[pt_now]),"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至第i段轨迹初始点上方
            MovL(0100 + pt_now,"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至第i段轨迹初始点
            DELAY(OpenGlueDelay)   --开胶延时
			if WorkFlg == 1 then
                DO(GlueDO,"ON")
            end
            DELAY(glue_time[pt_now]) 			                   
            DO(GlueDO, "OFF")
            --第i段轨迹结束关胶等处理
            DO(GlueDO, "OFF") 
            DELAY(CloseGlueDelay) --关胶延时
            MovJ(3,safeH) 
        end	
	end
    if(Continuept_sum>0) then
    	MovL(0200 +Z(ContinueGlue_Zup[0]),"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至轨迹初始点上方
        MovL(0200 ,"PASS",DefaultGlueSpeed,DefaultGlueAcc,DefaultGlueDec)--移动至轨迹初始点
        if WorkFlg == 1 then
            DO(GlueDO,"ON")
        end 
        DELAY(OpenGlueDelay)  --开胶延时
		for pt_now=0,Continuept_sum-1 do
            MovL(0200 + pt_now,"PASS",glue_speed[pt_now],DefaultGlueAcc,DefaultGlueDec)
            pt_end = pt_now
        end
        DO(GlueDO, "OFF")            --軌跡執行完畢膠閥關閉  
		DELAY(CloseGlueDelay) --关胶延时
		MovJ(3,safeH) 
	end
end


--=============================参数初始化區域======================================
RobotServoOff()
CVT_ChangeMotion()
OnceDateFromPC()
GetStandbyPt()
GetCraftParam()

--ResetUF1()

GetSectionParamFromPC()
ReadTeachSinglePointFromPC()
ReadTeachContinuePointFromPC()
GetSlaveIP()

CVT1Set()

--=============運動參數和模式設置========================================
RobotServoOff()
OnceDateFromPC()
--GetStandbyPt()
--GetCVTtestParam()


GetSlaveIP()
CVT1Set()
DELAY(0.02)
SafetyMode(5)


PassMode("DEC")
SetOverlapTime(50)

RobotServoOn()
ChangeUF(0)
DELAY(0.05)
ChangeUF(0)
DELAY(0.05)
DELAY(0.1)
MovJ(3,-5)
DELAY(0.1)
SpdL(300)
AccL(5000)
DecL(5000)

MovP(1001)         -- 预设待机点

SpdJ(RunSpeedJ)
AccJ(80.0)
DecJ(80.0)

SpdL(RunSpeedL)
AccL(10000)
DecL(10000)

Accur("ROUGH")
SetAccur(3,1280000)
SetAccur(4,1280000)


 UFReset(CV_cvtUFIdx,CV1_TrigLine_X,CV1_TrigLine_Y,CV1_EndLine_X,CV1_EndLine_Y)


--================运行轨迹================================================


P0x,P0y,P0z = GetUF(1)
safeH = P0z+SafeHset
if safeH>0 then
	safeH = 0
end

Output=0
GlueDO= WorkDO



CheckResult = CheckGlueSectionFromPC()
if(CheckResult==0) then         ---如果上位机发送的分段数量和本程序内的分段数量不符，则停止手臂程序
    error_num =  error_num + 1
    WriteModbus(0x3030,"DW",error_num)
    UserPrint("\n","！！！出現錯誤數據！！錯誤第：",error_num,"次") 
    if error_num >= 59999 then   --防止寄存器數值爆炸
        error_num  = 0
    end   
    PAUSE()
end
SectionIsClose={}
for i = 1,ListNumber do
    Num=PointNum[i][1]
    if(PointNum[i][2]-PointNum[i][1]==0) then   -- 单点  
        SectionIsClose[i]=0
	else
        SectionIsClose[i]= CheckSectionIsClose(i)            
	end
end  

-- 機器人塗膠
while true do
    cvtuIdx1= 1
    --確認啟動追隨條件是否滿足
    while CVT_ChkBotTrigCond(cvtuIdx1) == 0 do  end
        TimerOn()
        CVT_VelIn(cvtuIdx1)
        CVT_ObjDoneFlag(cvtuIdx1, 0)
       
    --===============追隨動作規畫區域=================
    
        ---執行解析軌跡
        GlueWithPCParam()
        
        ---執行示教軌跡
        GlueWithPCteach()
    
    -- ===============================================
        CVT_VelOut(cvtuIdx1)
        CVT_ObjDoneFlag(cvtuIdx1, 1)
        ----停止追隨輸送帶1
        CT = TimerRead()
        UserPrint("CT=",CT)
		UserPrint("QueueCnt=",QueueCnt,"\tQueueIdx=",QueueIdx,"\tWorkInfoX=",WorkInfoX,"\tWorkInfoY=",WorkInfoY)
        --加工完成復位，如果有料進來則直接抬起後進入追蹤，
        -- 如果沒有料進來則回到待機點
        if CVT_ChkBotTrigCond(cvtuIdx1) == 0 then
        	ChangeUF(1)
        	ChangeUF(0)
            MovP(1001)-- 待机点
        else
            MovJ(3,-20)
        end
    
    --==============================產能、CT統計===========================================
        --DO(12,"OFF")             --產能計算復歸
        --產能計數，超過限額則自動置為1，否則加1
        PickNum = ReadModbus(0x3000,"DW")
        Chkflg = DateCheck(PickNum,4000000000,0)
        if  Chkflg == 1 then
            Output = Output + 1
            WriteModbus(0x3000,"W",Output)
        else
            WriteModbus(0x3000,"W",1)
        end
            WriteModbus(0x300B,"W",CT) 
--=================================================================================
 end


