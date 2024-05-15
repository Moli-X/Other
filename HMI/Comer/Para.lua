--[[
    File        : Para                                                     
    Description : Restrore parameter to AMBD、C2000_HS、C2000_R
                  Check parameter changed and List Result
                                                                                                                                                                      #
    Author      : Mark.sh.chien
    
    Para Array:

        Format Description : ParaIndex, 150RT, 250RT, 350RT, 450RT, Float format
        AMBD     : AMBD Parameter
        C2000_HS : C2000_HS Parameter
        C2000_R  : Wait for Update
   
    Switch function Case:

        AMBD_WriteParaCase
        AMBD_ReadParaCase

        C2000_HS_WriteParaCase
        C2000_HS_ReadParaCase

        C2000_R_WriteParaCase
        C2000_R_ReadParaCase
       
    Function:
        
        ComparePara
        IntConvertToFloat
        FloatConvertToInt
        stringFormat
        MachineCodeCheck
        FwVersionCheck 
  
        AMBD_UpdatePara        
        AMBD_ComparePara
         
        C2000_HS_UpdatePara
        C2000_HS_ComparePara
 
        C2000_R_UpdatePara
        C2000_R_ComparePara
        
        ParaMain

--]]

--- To Be define Parameter, 參數中有未定義參數，寫入可跳過----
local C2000_HS_TBD = 9999
local AMBD_TBD = 9999

--- 畫面控制用Word 編號
local ParaScreenControlWord = 999
local ParaScreenRTInputWord = 1000

--- 錯誤提示子畫面編號
local AMBDErrorCodeScreen     = 13
local C2000HSErrorCodeScreen  = 14
local C2000RErrorCodeScreen   = 15
local FW_VersionErrorScreen   = 16

--- 切換畫面控制(bit 0)，更新或比較參數時，HMI會鎖定切換畫面
local ScreenChangeLock = 1003

--- Disk_ID : The location that Compare Result file will update to ---
--- 0 : HMI
--- 2 : USB
--- 3 : SD
local Disk_ID = 3

--- For Debug ---
local DebugFlag = 1
local Debug_Para 

--[[ 
    Name        : AMBD Parameter 
    Description : Para for Each RT 
    
    Date        : 2022.10.28
    Note        : 
                  
--]]


AMBD = {
      }
	   
--[[ 
    Name        : CH2000_HS  
    Description : Para for Each C2000_HS RT     
    Date        : 2022.10.12
                  2022.10.28 更新為國穎提供最新參數
                  2022.11.03 增加 01-12, 01-13, 10-31, 11-00, 11-01 
    Note        : 
                  機種代碼:
                    150RT:37(110KW)
                    250RT:45(220KW)
                    350RT:51(355KW)
                    450RT:51(355KW)

--]]
 
C2000_HS = {
            {"00-00",39,45,47,51,51,0},
            {"00-06",100,100,100,100,100,0},
            {"00-17",8,8,8,7,7,0},
            {"00-20",1,1,1,1,1,0},
            {"00-21",1,1,1,1,1,0},
            {"05-33",1,1,1,1,1,0},
            {"00-11",6,6,6,6,6,0},
            {"00-22",1,1,1,1,1,0},
            {"00-37",101,101,101,101,101,0},
            {"01-12",50.00,50.00,50.00,50.00,50.00,2},
            {"01-13",50.00,50.00,50.00,50.00,50.00,2},
            {"01-24",5.00,5.00,5.00,5.00,5.00,2},
            {"01-00",383.33,321.67,250.00,225.00,218.33,2},
            {"01-01",408.00,333.00,250.00,240.00,240.00,2},
            {"01-02",380.0,380.0,380.0,380.0,380.0,1},
            {"05-34",21000,3200,3800,5700,5700,0},
            {"05-35",115.00,180.00,220.00,345.00,345.00,2},
            {"05-36",24500,20000,15000,14400,14400,0},
            {"05-37",2,2,2,2,2,0},
            {"05-38",200.0,597.0,1330.0,909.0,909.0,1},
            {"05-39",0.014,0.008,0.003,0.004,0.004,3},
            {"05-40",0.23,0.21,0.17,0.12,0.12,2},
            {"05-41",0.28,0.23,0.17,0.13,0.13,2},
            {"05-43",7,10,14,16,16,0},
            {"10-53",1,1,1,1,1,0},
            {"10-31",20,25,20,30,30,0},
            {"11-00",1,1,1,1,1,0},
            {"11-01",100,50,256,256,256,0},
            {"11-03",2,2,2,2,2,0},
            {"11-04",2,1,2,2,2,0},
            {"11-05",2,2,2,2,2,0},
            {"06-03",110,105,100,105,105,0},
            {"06-04",110,105,100,105,105,0},
            {"06-12",110,105,100,105,105,0},
            {"00-09",64,64,64,64,64,0},
            {"06-00",360.0,360.0,360.0,360.0,360.0,1},
            {"06-62",20.0,20.0,20.0,20.0,20.0,1},
            {"06-76",0,0,0,0,0,0},
            {"07-13",2,2,2,2,2,0},
            {"07-14",3.0,3.0,3.0,3.0,3.0,1},
            {"07-62",30000,33000,8000,25000,25000,0},
            {"07-63",150,150,150,150,150,0},
            {"06-88",294.0,448.0,532.0,798.0,798.0,1},
            {"15-68",150,150,150,150,150,0},
            {"15-73",0,0,0,0,0,0},
            {"15-84",4,4,4,4,4,0},
            {"15-90",5,5,5,5,5,0},
            {"10-13",20,20,20,20,20,0},
            {"10-14",0.5,0.5,0.5,0.5,0.5,1},
            {"10-15",2,2,2,2,2,0},
            {"02-02",5,5,5,5,5,0},
      }

--[[ 
    Name        : CH2000_R  
    Description : Para for Each C2000_R RT 
    
    Date        : 2022.10.28  
    Note        : 
                 
--]]
 
C2000_R = { 
            
           }

--[[ 
    Name        : AMBD_WriteParaCase  
    Description : Mapping Para Write function for AMBD 
    
    Date        : 2022.10.11
    Note        : 
                  
--]]

AMBD_WriteParaCase = {

}


--[[ 
    Name        : AMBD_ReadParaCase  
    Description : Mapping Para Read function for AMBD 
    
    Date        : 2022.10.11
    Note        : 
                  
--]]
AMBD_ReadParaCase = {

}

--[[ 
    Name        : C2000_HS_WriteParaCase  
    Description : Mapping Para Write function for C2000_HS  
    
    Date        : 2022.10.11
    Note        : 
                  
--]]

 C2000_HS_WriteParaCase ={["00-00"] = function(v) link.Write("{Link2}4@RW-0000", v) end,
                          ["00-06"] = function(v) link.Write("{Link2}4@RW-0006", v) end,
                          ["00-17"] = function(v) link.Write("{Link2}4@RW-0011", v) end,
                          ["00-20"] = function(v) link.Write("{Link2}4@RW-0014", v) end,
                          ["00-21"] = function(v) link.Write("{Link2}4@RW-0015", v) end,
                          ["05-33"] = function(v) link.Write("{Link2}4@RW-0521", v) end,
                          ["00-11"] = function(v) link.Write("{Link2}4@RW-000B", v) end,
                          ["00-22"] = function(v) link.Write("{Link2}4@RW-0016", v) end,
                          ["00-37"] = function(v) link.Write("{Link2}4@RW-0025", v) end,
                          ["01-12"] = function(v) link.Write("{Link2}4@RW-010C", v) end, -- 2022.11.03 新增 
                          ["01-13"] = function(v) link.Write("{Link2}4@RW-010D", v) end, -- 2022.11.03 新增
                          ["01-24"] = function(v) link.Write("{Link2}4@RW-0118", v) end,
                          ["01-00"] = function(v) link.Write("{Link2}4@RW-0100", v) end,
                          ["01-01"] = function(v) link.Write("{Link2}4@RW-0101", v) end,
                          ["01-02"] = function(v) link.Write("{Link2}4@RW-0102", v) end,
                          ["05-34"] = function(v) link.Write("{Link2}4@RW-0522", v) end,
                          ["05-35"] = function(v) link.Write("{Link2}4@RW-0523", v) end,
                          ["05-36"] = function(v) link.Write("{Link2}4@RW-0524", v) end,
                          ["05-37"] = function(v) link.Write("{Link2}4@RW-0525", v) end,
                          ["05-38"] = function(v) link.Write("{Link2}4@RW-0526", v) end,
                          ["05-39"] = function(v) link.Write("{Link2}4@RW-0527", v) end,
                          ["05-40"] = function(v) link.Write("{Link2}4@RW-0528", v) end,
                          ["05-41"] = function(v) link.Write("{Link2}4@RW-0529", v) end,
                          ["05-43"] = function(v) link.Write("{Link2}4@RW-052B", v) end,
                          ["10-53"] = function(v) link.Write("{Link2}4@RW-0A35", v) end,
                          ["10-31"]	= function(v) link.Write("{Link2}4@RW-0A1F", v) end, -- 2022.11.03 新增
                          ["11-00"] = function(v) link.Write("{Link2}4@RW-0B00", v) end, -- 2022.11.03 新增
                          ["11-01"] = function(v) link.Write("{Link2}4@RW-0B01", v) end, -- 2022.11.03 新增
                          ["11-03"] = function(v) link.Write("{Link2}4@RW-0B03", v) end, -- 2023.05.04 新增
                          ["11-04"] = function(v) link.Write("{Link2}4@RW-0B04", v) end, -- 2023.05.04 新增
                          ["11-05"] = function(v) link.Write("{Link2}4@RW-0B05", v) end, -- 2023.05.04 新增
                          ["06-03"] = function(v) link.Write("{Link2}4@RW-0603", v) end,
                          ["06-04"] = function(v) link.Write("{Link2}4@RW-0604", v) end,
                          ["06-12"] = function(v) link.Write("{Link2}4@RW-060C", v) end,
                          ["00-09"] = function(v) link.Write("{Link2}4@RW-0009", v) end,
                          ["06-00"] = function(v) link.Write("{Link2}4@RW-0600", v) end,
                          ["06-62"] = function(v) link.Write("{Link2}4@RW-063E", v) end, -- 2023.05.04 新增
                          ["06-76"] = function(v) link.Write("{Link2}4@RW-064C", v) end,
                          ["07-13"] = function(v) link.Write("{Link2}4@RW-070D", v) end,
                          ["07-14"] = function(v) link.Write("{Link2}4@RW-070E", v) end, -- 2023.05.04 新增
                          ["07-62"] = function(v) link.Write("{Link2}4@RW-073E", v) end,
                          ["07-63"] = function(v) link.Write("{Link2}4@RW-073F", v) end,
                          ["06-88"] = function(v) link.Write("{Link2}4@RW-0658", v) end,
                          ["15-68"] = function(v) link.Write("{Link2}4@RW-0f44", v) end,
                          ["15-73"] = function(v) link.Write("{Link2}4@RW-0f49", v) end, -- 2023.05.04 新增
                          ["15-84"] = function(v) link.Write("{Link2}4@RW-0f54", v) end,
                          ["15-90"] = function(v) link.Write("{Link2}4@RW-0f5A", v) end,
                          ["10-13"] = function(v) link.Write("{Link2}4@RW-0A0D", v) end, -- 2023.05.04 新增
                          ["10-14"] = function(v) link.Write("{Link2}4@RW-0A0E", v) end, -- 2023.05.04 新增
                          ["10-15"] = function(v) link.Write("{Link2}4@RW-0A0F", v) end, -- 2023.05.04 新增
                          ["02-02"] = function(v) link.Write("{Link2}4@RW-0202", v) end,
}


--C2000_HS_WriteParaCase = {["10-31"]	= function(v) link.Write("{Link2}1@RW-0A1F", v) end,}

--[[ 
    Name        : C2000_HS_ReadParaCase  
    Description : Mapping Para Read function for C2000_HS  
    
    Date        : 2022.10.11
                  2022.10.28 
                  2022.11.03
    Note        : 
                  
--]]
C2000_HS_ReadParaCase =  {["00-00"] = function() return link.Read("{Link2}4@RW-0000") end,
                          ["00-06"] = function() return link.Read("{Link2}4@RW-0006") end,
                          ["00-17"] = function() return link.Read("{Link2}4@RW-0011") end,
                          ["00-20"] = function() return link.Read("{Link2}4@RW-0014") end,
                          ["00-21"] = function() return link.Read("{Link2}4@RW-0015") end,
                          ["05-33"] = function() return link.Read("{Link2}4@RW-0521") end,
                          ["00-11"] = function() return link.Read("{Link2}4@RW-000B") end,
                          ["00-22"] = function() return link.Read("{Link2}4@RW-0016") end,
                          ["00-37"] = function() return link.Read("{Link2}4@RW-0025") end,
                          ["01-12"] = function() return link.Read("{Link2}4@RW-010C") end, -- 2022.11.03 新增 
                          ["01-13"] = function() return link.Read("{Link2}4@RW-010D") end, -- 2022.11.03 新增
                          ["01-24"] = function() return link.Read("{Link2}4@RW-0118") end,
                          ["01-00"] = function() return link.Read("{Link2}4@RW-0100") end,
                          ["01-01"] = function() return link.Read("{Link2}4@RW-0101") end,
                          ["01-02"] = function() return link.Read("{Link2}4@RW-0102") end,
                          ["05-34"] = function() return link.Read("{Link2}4@RW-0522") end,
                          ["05-35"] = function() return link.Read("{Link2}4@RW-0523") end,
                          ["05-36"] = function() return link.Read("{Link2}4@RW-0524") end,
                          ["05-37"] = function() return link.Read("{Link2}4@RW-0525") end,
                          ["05-38"] = function() return link.Read("{Link2}4@RW-0526") end,
                          ["05-39"] = function() return link.Read("{Link2}4@RW-0527") end,
                          ["05-40"] = function() return link.Read("{Link2}4@RW-0528") end,
                          ["05-41"] = function() return link.Read("{Link2}4@RW-0529") end,
                          ["05-43"] = function() return link.Read("{Link2}4@RW-052B") end,
                          ["10-53"] = function() return link.Read("{Link2}4@RW-0A35") end,
                          ["10-31"]	= function() return link.Read("{Link2}4@RW-0A1F") end, -- 2022.11.03 新增
                          ["11-00"] = function() return link.Read("{Link2}4@RW-0B00") end, -- 2022.11.03 新增
                          ["11-01"] = function() return link.Read("{Link2}4@RW-0B01") end, -- 2022.11.03 新增
                          ["11-03"] = function() return link.Read("{Link2}4@RW-0B03") end, -- 2023.05.04 新增
                          ["11-04"] = function() return link.Read("{Link2}4@RW-0B04") end, -- 2023.05.04 新增
                          ["11-05"] = function() return link.Read("{Link2}4@RW-0B05") end, -- 2023.05.04 新增
                          ["06-03"] = function() return link.Read("{Link2}4@RW-0603") end,
                          ["06-04"] = function() return link.Read("{Link2}4@RW-0604") end,
                          ["06-12"] = function() return link.Read("{Link2}4@RW-060C") end,
                          ["00-09"] = function() return link.Read("{Link2}4@RW-0009") end,
                          ["06-00"] = function() return link.Read("{Link2}4@RW-0600") end,
                          ["06-62"] = function() return link.Read("{Link2}4@RW-063E") end, -- 2023.05.04 新增
                          ["06-76"] = function() return link.Read("{Link2}4@RW-064C") end,
                          ["07-13"] = function() return link.Read("{Link2}4@RW-070D") end,
                          ["07-14"] = function() return link.Read("{Link2}4@RW-070E") end, -- 2023.05.04 新增
                          ["07-62"] = function() return link.Read("{Link2}4@RW-073E") end,
                          ["07-63"] = function() return link.Read("{Link2}4@RW-073F") end,
                          ["06-88"] = function() return link.Read("{Link2}4@RW-0658") end, -- 2023.05.04 新增
                          ["15-68"] = function() return link.Read("{Link2}4@RW-0f44") end,
                          ["15-73"] = function() return link.Read("{Link2}4@RW-0f49") end, -- 2023.05.04 新增
                          ["15-84"] = function() return link.Read("{Link2}4@RW-0f54") end,
                          ["15-90"] = function() return link.Read("{Link2}4@RW-0f5A") end,
                          ["10-13"] = function() return link.Read("{Link2}4@RW-0A0D") end, -- 2023.05.04 新增
                          ["10-14"] = function() return link.Read("{Link2}4@RW-0A0E") end, -- 2023.05.04 新增
                          ["10-15"] = function() return link.Read("{Link2}4@RW-0A0F") end, -- 2023.05.04 新增
                          ["02-02"] = function() return link.Read("{Link2}4@RW-0202") end,
                         }


--[[ 
    Name        : C2000_R_WriteParaCase  
    Description : Mapping Para Write function for C2000_R  
    
    Date        : 2022.10.28
    Note        : 
                  
--]]

C2000_R_WriteParaCase = {}

--[[ 
    Name        : C2000_R_ReadParaCase  
    Description : Mapping Para Read function for C2000_R  
    
    Date        : 2022.10.28
    Note        : 
                  
--]]

C2000_R_ReadParaCase = {}

--[[ 
    Name        : IntConvertToFloat  
    Description : Covert Interger to float for get value form AMBD or VFD
                  Covert by Format   
    Date        : 2022.10.11
    Note        : 
                                   
--]]

function IntConvertToFloat(int, format)

    local value
    
    if format == 0 then 
        value = int
    else
        value = int/math.pow(10, format)
    end
    
    return value
end


--[[ 
    Name        : FloatConvertToInt  
    Description : Covert float to Interger for write value to AMBD or VFD
                  Covert by Format   
    Date        : 2022.10.11
    Note        : 
                                   
--]]
function FloatConvertToInt(float, format)

    local value

    if(format == 0) then 
        value = 1
    else
        value = math.pow(10, format)
    end

    value = float * value

    return value

end

--[[ 
    Name        : stringFormat  
    Description : Display format set up
                   Ex : 7.00 -----> 7.0
   
    Date        : 2022.10.27
    Note        : 
                                   
--]]
function stringFormat(value, format)

   case = {
     [0] = function() return string.format("%d",   value) end,  
     [1] = function() return string.format("%.1f", value) end,
     [2] = function() return string.format("%.2f", value) end,
     [3] = function() return string.format("%.3f", value) end, 
     [4] = function() return string.format("%.4f", value) end,
     [5] = function() return string.format("%.5f", value) end,
     [6] = function() return string.format("%.6f", value) end,
     [7] = function() return string.format("%.7f", value) end,
     [8] = function() return string.format("%.8f", value) end,   
   }

   return case[format]()

end

--[[ 
    Name        : ComparePara  
    Description : Compare Para and Show result on txt file  
    
    Date        : 2022.10.12
    Note        : 
                  
--]]
function ComparePara(handle, ParaIndex, CurrentPara, HMIStorePara, format) 
 
    local offset

    -- seekbase : file start: 0, current: 1, file tail: 2 
    local seekbase

    if CurrentPara ~= HMIStorePara then

       offset = 0
       seekbase = 2
       
       -- Find the file end      
       file.Seek(handle, offset, seekBase)
       
       -- Write Result to txt file
       file.Write(handle, ParaIndex, string.len(ParaIndex))

       newline = string.format("\r\r\r\r\r\r")
       file.Write(handle, newline, string.len(newline))
 
       -- Write  Current Para
       CurrentPara = stringFormat(CurrentPara, format)
       file.Write(handle, CurrentPara, string.len(CurrentPara))

       newline = string.format("\r\r\r\r\r\r")
       file.Write(handle, newline, string.len(newline))
   
       -- Write HMI Store Para
       HMIStorePara = stringFormat(HMIStorePara, format)
       file.Write(handle, HMIStorePara, string.len(HMIStorePara))
    
       newline = string.format("\n")
       file.Write(handle, newline, string.len(newline))
    
    end
end


--[[ 
    Name        : MachineCodeCheck  
    Description : Check Machine Code and open Error Code Screen  
    
    Date        : 2022.10.26
    Note        : 
 
    Return Value :
               0 : MachineCode Not Match
               1 : MachineCode Match                      
--]]

function MachineCodeCheck(MachineCode, ScreenIndex)

    -- Read Machine Code 
    CurrentCode = link.Read("{Link2}4@RW-0000")

    if (CurrentCode ~= MachineCode) then
        screen.Open(ScreenIndex)
        return 0
    end

    return 1
end




--[[ 
    Name        : FwVersionCheck  
    Description : Check FW Version and open Error Code Screen  
    
    Date        : 2022.10.28
    Note        : 
 
    Return Value :
               0 : FwVersion Not Match
               1 : FwVersion Match                      
--]]

function FwVersionCheck(FwVersion, ScreenIndex)

    -- Read Machine Code 
    CurrentFwVersion = link.Read("{Link2}4@RW-0006")

    -- Covert Int to Float
    CurrentFwVersion = IntConvertToFloat(CurrentFwVersion, 0) 

    if (CurrentFwVersion ~= FwVersion) then
        screen.Open(ScreenIndex)
        return 0
    end

    return 1
end



--[[ 
    Name        : AMBD_UpdatePara  
    Description : Update AMBD Para   
    
    Date        : 2022.10.12
    Note        :                  
--]]

function AMBD_UpdatePara(RT_Index) 
    
    -- Get AMBD Table Size    
    local size = table.count(AMBD)

    -- Group Index
    local paraindex 
    local value
    -- 小數點位數
    local format

    -- Check Machine Code 
    ret = MachineCodeCheck(AMBD[1][2], AMBDErrorCodeScreen)
    if (ret == 0) then
        return
    end

    -- Update Para 
    for i=1,size do
        
        paraindex = AMBD[i][1]
        value     = AMBD[i][RT_Index]
        format    = AMBD[i][6]
         
        --if Para index match, Save parameter to AMBD 
        if (AMBD_WriteParaCase[paraindex])then 

            --if Para is To Be Define, will not update to AMBD
            if (value ~= AMBD_TBD) then

                -- For Debug
                if  (Debug == 1) and (para == Debug_Para) then
                    paraindex = AMBD[i][1]
                    value = AMBD[i][RT_Index]                
                end

                -- Covert to Int for update AMBD Para
                value = FloatConvertToInt(value, format)  

                -- Mapping AMBD Write modbus function
                if (paraindex ~= "00-00") and (paraindex ~= "00-06") then
                    AMBD_WriteParaCase[paraindex](value)
                end
            end 
        end 
    end

end


--[[ 
    Name        : AMBD_ComparePara  
    Description : Compare AMBD current Para with HMI Default Para   
    
    Date        : 2022.10.12
    Note        :                  
--]]

function AMBD_ComparePara(RT_Index)

    local paraindex
    local para = 0
    local size = table.count(AMBD)

    local filename = "AMBD_ParaCheck"
   
    -- Item
    local Item = "Para     AMBD     HMI"

    -- Check Machine Code 
    ret = MachineCodeCheck(AMBD[1][2], AMBDErrorCodeScreen)
    if (ret == 0) then
        return
    end

    -- Update Result File
    ret = file.Exist(Disk_ID, filename)
    if (ret == 1) then
       file.Delete(Disk_ID, filename)
    end

    ret, handle = file.Open(Disk_ID,filename, 1) 

    -- Write Item ...
    file.Write(handle, Item, string.len(Item)) 

    file.Write(handle, "\n", string.len("\n"))


    for i=1,size do

        paraindex  = AMBD[i][1]
        paraformat = AMBD[i][6]
        HMIStoreValue = AMBD[i][RT_Index]

        -- Read Para from AMBD
        if (AMBD_ReadParaCase[paraindex]) then
            para = AMBD_ReadParaCase[paraindex]()
        end

        -- Covert Int to Float
        para = IntConvertToFloat(para, paraformat) 
 
        if AMBD[i][RT_Index] ~= AMBD_TBD and (paraindex ~= "00-09") and (paraindex ~= "00-02") then
            ComparePara(handle, paraindex, para, HMIStoreValue, paraformat)
        end

    end

    file.Close(handle)
               
end

--[[ 
    Name        : C2000_HS_UpdatePara  
    Description : Update C2000_HS current Para with HMI Default Para   
    
    Date        : 2022.10.12
    Note        :                  
--]]

function C2000_HS_UpdatePara(RT_Index)
   
    -- Get C2000_HS Table Size    
    local size = table.count(C2000_HS)

    -- Group Index
    local paraindex 
    local value
    -- 小數點位數
    local format

    -- Check Machine Code 
    ret = MachineCodeCheck(C2000_HS[1][RT_Index], C2000HSErrorCodeScreen)
    if (ret == 0) then
        return
    end

    --[[ Check Fw Version
    ret = FwVersionCheck(C2000_HS[2][RT_Index], 10)
    if (ret == 0) then
        return
    end
    --]]

    -- Update Para
    for i=1,2 do
        for i=1,size do
            
            paraindex = C2000_HS[i][1]
            value     = C2000_HS[i][RT_Index]
            format    = C2000_HS[i][7]
            mem.inter.WriteAscii(130, paraindex, string.len(paraindex))
            mem.inter.WriteAscii(135, value, string.len(value))
            -- mem.inter.WriteFloat(135, convert.ToNum(value))
             
            --if Para index match, Save parameter to C2000_HS
            if (C2000_HS_WriteParaCase[paraindex])then 

                --if Para is To Be Define, will not update to AMBD
                if (value ~= C2000_HS_TBD) then

                    -- For Debug
                    if  (Debug == 1) and (paraindex == "10-31") then
                        paraindex = C2000_HS[i][1]
                        value = C2000_HS[i][RT_Index]                
                    end

                    -- Covert to Int for update AMBD Para
                    value = FloatConvertToInt(value, format)  

                    -- Mapping C2000_HS Write modbus function
                    if (paraindex ~= "00-00") and (paraindex ~= "00-06") then
                        C2000_HS_WriteParaCase[paraindex](value)
                        --link.Write("{Link2}1@RW-0A1F", 30)
                    end
                    
                end 
            end 

            sys.Sleep(200)

        end
    end
    --link.Write("{Link2}1@RW-0A1F", C2000_HS[21][RT_Index])
end

--[[ 
    Name        : C2000_HS_ComparePara  
    Description : Compare C2000_HS current Para with HMI Default Para   
    
    Date        : 2022.10.12
    Note        :                  
--]]
function C2000_HS_ComparePara(RT_Index)
    
    local paraindex
    local para = 0
    local size = table.count(C2000_HS)

    local filename = "C2000_R_ParaCheck"
    
    -- Item :
    local Item = "Para      C-R       HMI"

    -- Check Machine Code 
    ret = MachineCodeCheck(C2000_HS[1][RT_Index], C2000HSErrorCodeScreen)
    if (ret == 0) then
        return
    end

    --[[ Check Fw Version
    ret = FwVersionCheck(C2000_HS[2][RT_Index], 10)
    if (ret == 0) then
        return
    end  
    --]]

    -- Update Result File
    ret = file.Exist(Disk_ID, filename)
    if (ret == 1) then
       file.Delete(Disk_ID, filename)
    end

    ret, handle = file.Open(Disk_ID,filename, 1) 

    -- Write Item ...
    file.Write(handle, Item, string.len(Item)) 

    file.Write(handle, "\n", string.len("\n"))

    for i=1,size do

        paraindex  = C2000_HS[i][1]
        paraformat = C2000_HS[i][7]
        HMIStoreValue = C2000_HS[i][RT_Index]

        -- Read Para from C2000_HS
        para = C2000_HS_ReadParaCase[paraindex]()

        -- Covert Int to Float
        para = IntConvertToFloat(para, paraformat) 
 
        -- "00-02" Pass, Because for setting Factory parameter
        if (HMIStoreValue ~= C2000_HS_TBD) and (paraindex ~= "00-02") then
            ComparePara(handle, paraindex, para, HMIStoreValue, paraformat)
        end

    end

    file.Close(handle)
           
end



--[[ 
    Name        : C2000_R_UpdatePara  
    Description : Update C2000_R Para   
    
    Date        : 2022.10.28
    Note        :                  
--]]

function C2000_R_UpdatePara(RT_Index) 
    
    -- Get C2000_R Table Size    
    local size = table.count(C2000_R)

    -- Group Index
    local paraindex 
    local value
    -- 小數點位數
    local format

    -- Check Machine Code 
    ret = MachineCodeCheck(C2000_R[1][2], C2000RErrorCodeScreen)
    if (ret == 0) then
        return
    end

    -- Update Para 
    for i=1,size do
        
        paraindex = C2000_R[i][1]
        value     = C2000_R[i][RT_Index]
        format    = C2000_R[i][6]
         
        --if Para index match, Save parameter to AMBD 
        if (C2000_R_WriteParaCase[paraindex])then 

            --if Para is To Be Define, will not update to AMBD
            if (value ~= C2000_R_TBD) then

                -- For Debug
                if  (Debug == 1) and (para == Debug_Para) then
                    paraindex = C2000_R[i][1]
                    value = C2000_R[i][RT_Index]                
                end

                -- Covert to Int for update AMBD Para
                value = FloatConvertToInt(value, format)  

                -- Mapping AMBD Write modbus function
                if (paraindex ~= "00-00") and (paraindex ~= "00-06") then
                    C2000_R_WriteParaCase[paraindex](value)
                end
            end 
        end 
    end

end






--[[ 
    Name        : C2000_R_ComparePara  
    Description : Compare C2000_R current Para with HMI Default Para   
    
    Date        : 2022.10.28
    Note        :                  
--]]
function C2000_R_ComparePara(RT_Index)
    
    local paraindex
    local para = 0
    local size = table.count(C2000_R)

    local filename = "C2000_R_ParaCheck"
    
    -- Item :
    local Item = "Para      C-R       HMI"

    -- Check Machine Code 
    ret = MachineCodeCheck(C2000_R[1][RT_Index], C2000RErrorCodeScreen)
    if (ret == 0) then
        return
    end
  
    -- Update Result File
    ret = file.Exist(Disk_ID, filename)
    if (ret == 1) then
       file.Delete(Disk_ID, filename)
    end

    ret, handle = file.Open(Disk_ID,filename, 1) 

    -- Write Item ...
    file.Write(handle, Item, string.len(Item)) 

    file.Write(handle, "\n", string.len("\n"))

    for i=1,size do

        paraindex  = C2000_R[i][1]
        paraformat = C2000_R[i][6]
        HMIStoreValue = C2000_R[i][RT_Index]

        -- Read Para from C2000_HS
        para = C2000_HS_ReadParaCase[paraindex]()

        -- Covert Int to Float
        para = IntConvertToFloat(para, paraformat) 
 
        -- "00-02" Pass, Because for setting Factory parameter
        if (HMIStoreValue ~= C2000_R_TBD) and (paraindex ~= "00-02") then
            ComparePara(handle, paraindex, para, HMIStoreValue, paraformat)
        end

    end

    file.Close(handle)
           
end



--[[ 
    Name        : ParaMain  
    Description : for SRS_FR_006 : One Key Para update and Para Check   
    
    Date        : 2022.09.06
    Note        : 
                    Use Word(Intermemory) 

                    Screen Control Word
                    999       : Para function Control Word
                      Start Bit
                        --Bit 0 : AMBD_UpdatePara
                        --Bit 1 : AMBD_ComparePara

                        --Bit 2 : C2000_HS_UpdatePara
                        --Bit 3 : C2000_HS_ComparePara
   
                        --Bit 5 : C2000_R_UpdatePara
                        --Bit 6 : C2000_R_ComparePara 
 
                    RT Input Word
                    1000 : AMBD     RT
                    1001 : C2000_HS Rt 
                    1002 : C2000_R  Rt

                    Screen Lock control Word
                    1003
                        --Bit 0 : Screen Change Lock bit
                              1 -- Lock
                              0 -- UnLock

                        --Bit 15: 暫時鎖定用，目前用C2000_R           
--]]

function ParaMain()

    -- AMBD 
    if (mem.inter.ReadBit(ParaScreenControlWord, 0) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1)
         
        AMBD_UpdatePara(mem.inter.Read(ParaScreenRTInputWord))

        mem.inter.WriteBit(ParaScreenControlWord, 0, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0)

    end
  
    if (mem.inter.ReadBit(ParaScreenControlWord, 1) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1) 
        
        AMBD_ComparePara(mem.inter.Read(ParaScreenRTInputWord))

        mem.inter.WriteBit(ParaScreenControlWord, 1, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0)

    end

    --C2000_HS
    if (mem.inter.ReadBit(ParaScreenControlWord, 3) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1)
         
        C2000_HS_UpdatePara(mem.inter.Read(ParaScreenRTInputWord+1))

        --link.Write("{Link2}1@RW-0A1F", 30)  
      
        mem.inter.WriteBit(ParaScreenControlWord, 3, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0) 
    end

    if (mem.inter.ReadBit(ParaScreenControlWord, 4) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1) 
         
        C2000_HS_ComparePara(mem.inter.Read(ParaScreenRTInputWord+1))  
       
        mem.inter.WriteBit(ParaScreenControlWord, 4, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0) 
    end

    --C2000_R
    if (mem.inter.ReadBit(ParaScreenControlWord, 4) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1)
         
        C2000_R_UpdatePara(mem.inter.Read(ParaScreenRTInputWord+1))  
      
        mem.inter.WriteBit(ParaScreenControlWord, 4, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0) 
    end

    if (mem.inter.ReadBit(ParaScreenControlWord, 5) == 1) then

        -- Lock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 1) 
         
        C2000_R_ComparePara(mem.inter.Read(ParaScreenRTInputWord+1))  
       
        mem.inter.WriteBit(ParaScreenControlWord, 5, 0)

        -- UnLock Screen Button
        mem.inter.WriteBit(ScreenChangeLock, 0, 0) 
    end

    

end






