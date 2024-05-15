-- Add initial code here (run once)

-- Para Table & function  
require "Para"

r = 0
cnt = 0

    -- blStopFlag = 0
    -- blStopFlagTemp = 0

    -- drawing state machine
blIdleFlag = 0
blDrawFlag = 0
blStopFlag = 0
    
    -- max memory 
uwArrayMax = 250-- 如果要變動此參數 同時需要邊動 X-Y的記憶體位置
uwArrayOrigMax = 100

    -- Felix coding flag
-- blUpdateFlag = 1 

-- function call

-- realtime circle control function
-- set flag will interrupt by draw circle interrupt 
function RealTimeCircleClear()  -- clear the forth circle flag
    mem.inter.WriteBit(0, 3, 0)
    mem.inter.WriteBit(0, 11, 1)
end

function RealTimeCircleSet()    -- set the forth circle flag
    mem.inter.WriteBit(0, 11, 0)
    mem.inter.WriteBit(0, 3, 1)
end

function RealTimeDrawCircle()
    -- 清除畫圓軌跡
    -- mem.inter.WriteBit(0, 3, 0)
    -- mem.inter.WriteBit(0, 11, 1)
    RealTimeCircleClear();
    
    link.CopyToInter("{Link2}1@RW-2200",2200,4)
    link.CopyToInter("{Link2}1@RW-2101",2101,1)
    -- 通訊速度 >> 整體速度 需要等待再作取樣 --要調整成互鎖
    -- if (i == 0) then
    --     sys.Sleep(1000)
    -- end
        
    -- update VFD information

    blVFDStatus = mem.inter.ReadBit(2101,0)
    -- blVFDStatus = 0 stopping 、1 Running     
    if (blIdleFlag == 1) then --Idle state
 
        -- 以磁控器開啟為旗標
        if (blVFDStatus == 1) then -- transfer to Draw state
            blDrawFlag = 1
            blIdleFlag = 0
        end
		
		mem.inter.Write(60000, 0) -- 當開始讀值的情況下，會舉起此旗標
        
    elseif(blDrawFlag == 1) then -- draw state
        mem.inter.WriteBit(30, 15, 1)--開啟第一次觸發畫圖執行旗標

        x11 = mem.inter.Read(2200,"signed")
        y12 = mem.inter.Read(2201,"signed")
        x13 = mem.inter.Read(2202,"signed")
        y14 = mem.inter.Read(2203,"signed")

        x110 = mem.inter.Read(1009)*mem.inter.Read(22)/100+x11--平移
        y120 = mem.inter.Read(1009)*mem.inter.Read(22)/100+y12
        x130 = mem.inter.Read(1009)*mem.inter.Read(22)/100+x13
        y140 = mem.inter.Read(1009)*mem.inter.Read(22)/100+y14

        mem.inter.Write(41, x110)--前徑向平移數據轉至畫點暫存區
        mem.inter.Write(42, y120)
        mem.inter.Write(44, x130)--後徑向平移數據轉至畫點暫存區
        mem.inter.Write(45, y140)

        mem.inter.Write(40, 1)--前徑向取樣畫點
        mem.inter.Write(43, 1)--後徑向取樣畫點

        i = i+1 -- counter flag

        -- 防止配方錯亂
        if (i < uwArrayOrigMax ) then
            mem.inter.WriteDW(2*i+5998, x11)--前徑向數據存入暫存區    
            mem.inter.WriteDW(2*i+6198, y12)
            mem.inter.WriteDW(2*i+6398, x13)--後徑向數據存入暫存區      
            mem.inter.WriteDW(2*i+6598, y14)
            mem.inter.WriteBit(3, 1, 1)--存入配方
        end
        -- ################################################################# --
        -- 重製畫圖方法
        mem.inter.WriteDW(2*i+50000                 , x11)
        mem.inter.WriteDW(2*i+50000 + uwArrayMax    , y12)
        mem.inter.WriteDW(2*i+50000 + uwArrayMax * 2, x13)
        mem.inter.WriteDW(2*i+50000 + uwArrayMax * 3, y14)
            
        for uwDrawCnt = i,(uwArrayMax - 1) do
            mem.inter.WriteDW(2*i+50000                 , x11)
            mem.inter.WriteDW(2*i+50000 + uwArrayMax    , y12)
            mem.inter.WriteDW(2*i+50000 + uwArrayMax * 2, x13)
            mem.inter.WriteDW(2*i+50000 + uwArrayMax * 3, y14)
        end
        
        -- ################################################################# --
        -- 
        if (blVFDStatus == 0)  or (i > uwArrayMax - 1)then -- transfer to stop state
            blDrawFlag = 0
            blStopFlag = 1
        end
		
		mem.inter.Write(60000, 1) -- 當開始讀值的情況下，會舉起此旗標
		
    elseif(blStopFlag == 1) then -- stop state 
            
        -- do once state
        
        -- clear flag
        mem.inter.WriteBit(30, 15, 0)--關閉第一次觸發畫圖執行旗標
        mem.inter.WriteBit(30, 0, 0)--畫圖賦歸
        mem.inter.WriteBit(30, 14, 1)--開啟判斷R是否超過極限旗標  
        i = 0
        -- transfer to Idle State
        blIdleFlag = 1  
        blStopFlag = 0
        mem.inter.Write(60000, 0) -- 當開始讀值的情況下，會舉起此旗標
    else
        blIdleFlag = 1
        blStopFlag = 0
        blDrawFlag = 0
        mem.inter.Write(60000, 0) -- 當開始讀值的情況下，會舉起此旗標
    end
    return 0
end

-- Read Parameter
	
function ReadPar()
    mem.inter.Write(5000, link.Read("{Link2}1@RW-0"))--00群
    mem.inter.Write(5001, link.Read("{Link2}1@RW-6"))
    mem.inter.Write(5002, link.Read("{Link2}1@RW-A"))
    mem.inter.Write(5003, link.Read("{Link2}1@RW-11"))
    mem.inter.Write(5004, link.Read("{Link2}1@RW-32"))

    mem.inter.Write(5005, link.Read("{Link2}1@RW-100"))--01群
    mem.inter.Write(5006, link.Read("{Link2}1@RW-101"))
    mem.inter.Write(5007, link.Read("{Link2}1@RW-106"))
    mem.inter.Write(5008, link.Read("{Link2}1@RW-107"))
    mem.inter.Write(5009, link.Read("{Link2}1@RW-108"))
    mem.inter.Write(5010, link.Read("{Link2}1@RW-109"))
    mem.inter.Write(5011, link.Read("{Link2}1@RW-10A"))
    mem.inter.Write(5012, link.Read("{Link2}1@RW-10B"))
    mem.inter.Write(5013, link.Read("{Link2}1@RW-10C"))
    mem.inter.Write(5014, link.Read("{Link2}1@RW-10D"))
    mem.inter.Write(5015, link.Read("{Link2}1@RW-10E"))

    mem.inter.Write(5031, link.Read("{Link2}1@RW-400"))--04群
    mem.inter.Write(5032, link.Read("{Link2}1@RW-401"))
    mem.inter.Write(5033, link.Read("{Link2}1@RW-402"))
    mem.inter.Write(5034, link.Read("{Link2}1@RW-403"))
    mem.inter.Write(5035, link.Read("{Link2}1@RW-404"))
    mem.inter.Write(5036, link.Read("{Link2}1@RW-405"))
    mem.inter.Write(5037, link.Read("{Link2}1@RW-406"))
    mem.inter.Write(5038, link.Read("{Link2}1@RW-407"))
    mem.inter.Write(5039, link.Read("{Link2}1@RW-408"))
    mem.inter.Write(5040, link.Read("{Link2}1@RW-409"))
    mem.inter.Write(5041, link.Read("{Link2}1@RW-40A"))
    mem.inter.Write(5042, link.Read("{Link2}1@RW-40B"))
    mem.inter.Write(5043, link.Read("{Link2}1@RW-40C"))
    mem.inter.Write(5044, link.Read("{Link2}1@RW-40D"))
    mem.inter.Write(5045, link.Read("{Link2}1@RW-40E"))
    mem.inter.Write(5046, link.Read("{Link2}1@RW-40F"))
    mem.inter.Write(5047, link.Read("{Link2}1@RW-410"))
    mem.inter.Write(5048, link.Read("{Link2}1@RW-411"))

    mem.inter.Write(5059, link.Read("{Link2}1@RW-501"))--05群
    mem.inter.Write(5060, link.Read("{Link2}1@RW-502"))
    mem.inter.Write(5061, link.Read("{Link2}1@RW-50E"))
    mem.inter.Write(5062, link.Read("{Link2}1@RW-50F"))
    mem.inter.Write(5064, link.Read("{Link2}1@RW-510"))
    mem.inter.Write(5065, link.Read("{Link2}1@RW-511"))
    mem.inter.Write(5067, link.Read("{Link2}1@RW-512"))
    mem.inter.Write(5068, link.Read("{Link2}1@RW-513"))
    mem.inter.Write(5070, link.Read("{Link2}1@RW-514"))
    mem.inter.Write(5071, link.Read("{Link2}1@RW-515"))
    mem.inter.Write(5073, link.Read("{Link2}1@RW-516"))
    mem.inter.Write(5074, link.Read("{Link2}1@RW-517"))
    mem.inter.Write(5076, link.Read("{Link2}1@RW-518"))
    mem.inter.Write(5077, link.Read("{Link2}1@RW-519"))

    mem.inter.Write(5086, link.Read("{Link2}1@RW-600"))--06群
    mem.inter.Write(5087, link.Read("{Link2}1@RW-601"))
    mem.inter.Write(5088, link.Read("{Link2}1@RW-602"))
    mem.inter.Write(5089, link.Read("{Link2}1@RW-603"))
    mem.inter.Write(5090, link.Read("{Link2}1@RW-604"))
    mem.inter.Write(5091, link.Read("{Link2}1@RW-605"))
    mem.inter.Write(5092, link.Read("{Link2}1@RW-606"))

    mem.inter.Write(5103, link.Read("{Link2}1@RW-800"))--08群
    mem.inter.Write(5104, link.Read("{Link2}1@RW-801"))
    mem.inter.Write(5105, link.Read("{Link2}1@RW-802"))
    mem.inter.Write(5106, link.Read("{Link2}1@RW-803"))
    mem.inter.Write(5107, link.Read("{Link2}1@RW-804"))
    mem.inter.Write(5108, link.Read("{Link2}1@RW-805"))
    mem.inter.Write(5109, link.Read("{Link2}1@RW-806"))
    mem.inter.Write(5110, link.Read("{Link2}1@RW-808"))
    mem.inter.Write(5111, link.Read("{Link2}1@RW-809"))
    mem.inter.Write(5112, link.Read("{Link2}1@RW-80A"))

    mem.inter.Write(5133, link.Read("{Link2}1@RW-A02"))--10群
    mem.inter.Write(5134, link.Read("{Link2}1@RW-A03"))
    mem.inter.Write(5135, link.Read("{Link2}1@RW-A04"))
    mem.inter.Write(5136, link.Read("{Link2}1@RW-A09"))
    mem.inter.Write(5137, link.Read("{Link2}1@RW-A0A"))
    mem.inter.Write(5138, link.Read("{Link2}1@RW-A0B"))
    mem.inter.Write(5139, link.Read("{Link2}1@RW-A0C"))
    mem.inter.Write(5140, link.Read("{Link2}1@RW-A0D"))
    mem.inter.Write(5141, link.Read("{Link2}1@RW-A0E"))
    mem.inter.Write(5142, link.Read("{Link2}1@RW-A49"))
    mem.inter.Write(5143, link.Read("{Link2}1@RW-A4A"))
    mem.inter.Write(5144, link.Read("{Link2}1@RW-A4B"))
    mem.inter.Write(5145, link.Read("{Link2}1@RW-A4C"))
    mem.inter.Write(5146, link.Read("{Link2}1@RW-A4D"))
    mem.inter.Write(5147, link.Read("{Link2}1@RW-A50"))
    mem.inter.Write(5148, link.Read("{Link2}1@RW-A51"))
    mem.inter.Write(5149, link.Read("{Link2}1@RW-A52"))
    mem.inter.Write(5150, link.Read("{Link2}1@RW-A53"))
    mem.inter.Write(5151, link.Read("{Link2}1@RW-A54"))
    mem.inter.Write(5152, link.Read("{Link2}1@RW-A55"))
    mem.inter.Write(5153, link.Read("{Link2}1@RW-A56"))
    mem.inter.Write(5154, link.Read("{Link2}1@RW-A57"))
    mem.inter.Write(5155, link.Read("{Link2}1@RW-A58"))
    mem.inter.Write(5156, link.Read("{Link2}1@RW-A59"))
    mem.inter.Write(5157, link.Read("{Link2}1@RW-A5A"))
    mem.inter.Write(5158, link.Read("{Link2}1@RW-A5B"))
    mem.inter.Write(5159, link.Read("{Link2}1@RW-A5C"))
    mem.inter.Write(5160, link.Read("{Link2}1@RW-A5D"))
    mem.inter.Write(5161, link.Read("{Link2}1@RW-A5E"))
    mem.inter.Write(5162, link.Read("{Link2}1@RW-A5F"))

    mem.inter.Write(5173, link.Read("{Link2}1@RW-B05"))--11群
    mem.inter.Write(5175, link.Read("{Link2}1@RW-B06"))
    mem.inter.Write(5177, link.Read("{Link2}1@RW-B07"))
    mem.inter.Write(5179, link.Read("{Link2}1@RW-B08"))
    mem.inter.Write(5181, link.Read("{Link2}1@RW-B09"))
    mem.inter.Write(5183, link.Read("{Link2}1@RW-B0A"))
    mem.inter.Write(5185, link.Read("{Link2}1@RW-B0B"))
    mem.inter.Write(5187, link.Read("{Link2}1@RW-B0C"))
    mem.inter.Write(5189, link.Read("{Link2}1@RW-B0D"))
    mem.inter.Write(5191, link.Read("{Link2}1@RW-B0E"))
    mem.inter.Write(5193, link.Read("{Link2}1@RW-B0F"))
    mem.inter.Write(5195, link.Read("{Link2}1@RW-B10"))
    mem.inter.Write(5197, link.Read("{Link2}1@RW-B11"))
    mem.inter.Write(5199, link.Read("{Link2}1@RW-B12"))
    mem.inter.Write(5201, link.Read("{Link2}1@RW-B13"))
    mem.inter.Write(5203, link.Read("{Link2}1@RW-B14"))
    mem.inter.Write(5205, link.Read("{Link2}1@RW-B15"))
    mem.inter.Write(5207, link.Read("{Link2}1@RW-B16"))
    mem.inter.Write(5209, link.Read("{Link2}1@RW-B17"))
    mem.inter.Write(5211, link.Read("{Link2}1@RW-B18"))
    mem.inter.Write(5213, link.Read("{Link2}1@RW-B19"))
    mem.inter.Write(5215, link.Read("{Link2}1@RW-B1A"))
    mem.inter.Write(5217, link.Read("{Link2}1@RW-B1B"))
    mem.inter.Write(5219, link.Read("{Link2}1@RW-B1C"))
    mem.inter.Write(5221, link.Read("{Link2}1@RW-B1D"))
    mem.inter.Write(5223, link.Read("{Link2}1@RW-B1E"))
    mem.inter.Write(5225, link.Read("{Link2}1@RW-B1F"))
    mem.inter.Write(5227, link.Read("{Link2}1@RW-B20"))
    mem.inter.Write(5229, link.Read("{Link2}1@RW-B21"))
    mem.inter.Write(5231, link.Read("{Link2}1@RW-B22"))
    mem.inter.Write(5233, link.Read("{Link2}1@RW-B23"))
    mem.inter.Write(5235, link.Read("{Link2}1@RW-B24"))
    mem.inter.Write(5237, link.Read("{Link2}1@RW-B25"))
    mem.inter.Write(5239, link.Read("{Link2}1@RW-B26"))
    mem.inter.Write(5241, link.Read("{Link2}1@RW-B27"))
    mem.inter.Write(5243, link.Read("{Link2}1@RW-B28"))
    mem.inter.Write(5245, link.Read("{Link2}1@RW-B2A"))
    mem.inter.Write(5247, link.Read("{Link2}1@RW-B2B"))
    mem.inter.Write(5249, link.Read("{Link2}1@RW-B2C"))
    mem.inter.Write(5251, link.Read("{Link2}1@RW-B2D"))
    mem.inter.Write(5253, link.Read("{Link2}1@RW-B2E"))
    mem.inter.Write(5255, link.Read("{Link2}1@RW-B2F"))
    mem.inter.Write(5257, link.Read("{Link2}1@RW-B30"))
    mem.inter.Write(5259, link.Read("{Link2}1@RW-B31"))
    mem.inter.Write(5261, link.Read("{Link2}1@RW-B32"))
end



-- Initial Variable For Screen13
mem.inter.Write(1000, 2)
mem.inter.Write(1001, 2)
mem.inter.Write(1002, 2)


while true do

    -- Add loop code here (cyclic run)

    ParaMain()

    i = mem.inter.Read(20)

        --示波器

	if (d2 ~= 1) then--開啟組裝廠不啟用示波器功能
		if (mem.inter.Read(71)==0)then--Error沒發生
			r = 0
			mem.inter.WriteBit(79, 15, 0)--存檔功能賦歸
			-- if (link.ReadBit("{Link2}1@RW-2101.0")==1)then--磁控器運行中 
            if (mem.inter.ReadBit(2101.0)==1)then--磁控器運行中 
				mem.inter.WriteBit(79, 14, 1)--示波器取樣          
			-- elseif (link.ReadBit("{Link2}1@RW-2101.0")==0)then--磁控器停止
            elseif (mem.inter.ReadBit(2101.0)==0)then--磁控器停止
				if (mem.inter.Read(71)~=0) then--Error發生會持續記錄
					mem.inter.WriteBit(79, 14, 1)--示波器取樣
				else
					mem.inter.WriteBit(79, 14, 0)--示波器停止取樣
				end
			end 
		elseif (mem.inter.Read(71)~=0)then--Error發生
			r = r+1
			if (r==1) then
				sys.Sleep(5000)--Error發生多紀錄5s
				mem.inter.WriteBit(79, 14, 0)--示波器停止取樣
				mem.inter.WriteBit(79, 15, 1)--存取示波器數據一次
				sys.Sleep(100)  
			end           
		end
	end

    --draw drive circle
    a1 = mem.inter.ReadBit(30, 0)--畫圖
    a2 = mem.inter.ReadBit(30, 1)--清除
    a10 = mem.inter.ReadBit(30, 15)--畫圖被按過尚未畫完旗標
    a11 = mem.inter.ReadBit(30, 14)--開啟判斷R是否超過極限旗標 
    a3 = mem.inter.ReadBit(30, 2)--出廠圓存入配方
    a4 = mem.inter.ReadBit(30, 3)--出廠圓SD匯出圖形
    a5 = mem.inter.ReadBit(30, 4)--組裝圓存入配方
    a6 = mem.inter.ReadBit(30, 5)--組裝圓SD匯出圖形
    a7 = mem.inter.ReadBit(30, 6)--試車圓存入配方
    a8 = mem.inter.ReadBit(30, 7)--試車圓SD匯出圖形
    a9 = mem.inter.ReadBit(30, 8)--圓形比旗標
    c1 = mem.inter.ReadBit(70, 0)--懸浮啟動/停止
    c2 = mem.inter.ReadBit(75, 1)--存取序號
    d1 = mem.inter.ReadBit(99, 0)--客戶端介面
    d2 = mem.inter.ReadBit(99, 1)--組裝廠介面
    d3 = mem.inter.ReadBit(99, 2)--待刪除頁面
    d4 = mem.inter.ReadBit(99, 3)--間隙片厚度頁面
    e1 = mem.inter.ReadBit(200, 1)--間隙片厚度計算參數存取

    if (d1 == 1) then --客戶端介面

		--link.CopyToInter("{Link2}1@RW-2200", 2200, 6)

		--mem.inter.WriteDW(2200,link.ReadDW("{Link2}1@RW-2200","signed"))--前徑向數據讀取 ken:讀完後結果沒用到?
		--mem.inter.WriteDW(2202,link.ReadDW("{Link2}1@RW-2202","signed"))--後徑向數據讀取
		--mem.inter.Write(2204,link.Read("{Link2}1@RW-2204","signed"))--軸向數據讀取
		x11=mem.inter.Read(2200,"signed")
		y12=mem.inter.Read(2201,"signed")
		x13=mem.inter.Read(2202,"signed")
		y14=mem.inter.Read(2203,"signed")
		z15=mem.inter.Read(2204,"signed")

		R=mem.inter.Read(1009)*1.2--1.2倍Pr10-09
		x110=x11+R--平移
		y120=y12+R
		x130=x13+R
		y140=y14+R

		--前徑向
		mem.inter.Write(3000, x110)--即時曲線X
		mem.inter.Write(3002, y120)--即時曲線y
		mem.inter.Write(3001, x110)--即時曲線X(最少兩點一線，兩點重和) ken:不懂
		mem.inter.Write(3003, y120)--即時曲線y(最少兩點一線，兩點重和) ken:不懂

		--前徑向
		mem.inter.Write(3004, x130)--即時曲線X
		mem.inter.Write(3006, y140)--即時曲線y
		mem.inter.Write(3005, x130)--即時曲線X(最少兩點一線，兩點重和)
		mem.inter.Write(3007, y140)--即時曲線y(最少兩點一線，兩點重和)

		--軸向
		mem.inter.Write(3019, mem.inter.Read(3018,"signed"))--輪巡洗掉第一筆資料加入新資料
		mem.inter.Write(3018, mem.inter.Read(3017,"signed"))
		mem.inter.Write(3017, mem.inter.Read(3016,"signed"))
		mem.inter.Write(3016, mem.inter.Read(3015,"signed"))
		mem.inter.Write(3015, mem.inter.Read(3014,"signed"))
		mem.inter.Write(3014, mem.inter.Read(3013,"signed"))
		mem.inter.Write(3013, mem.inter.Read(3012,"signed"))
		mem.inter.Write(3012, mem.inter.Read(3011,"signed"))
		mem.inter.Write(3011, mem.inter.Read(3010,"signed"))
		mem.inter.Write(3010, mem.inter.Read(2204,"signed"))

		mem.inter.Write(0, 8)--取樣旗標4On(即使曲線)




    elseif (d2 == 1) or (d4 == 1) then--組裝廠介面 

        if (c2 == 1) or (e1 == 1) then --存取序號
			ret, noName = recipe.GetCurEnRcpNoName()--讀取配方名稱字串長度
			v1 = string.len(noName)
			if (mem.inter.Read(4000)==0)and (mem.inter.ReadBit(99, 10)==0)then--未輸入且畫面關閉其標沒觸發 
				screen.Open(10)
			elseif (mem.inter.Read(4000)==0)and (mem.inter.ReadBit(99, 10)==1)then--未輸入且畫面關閉其標觸發 
				screen.CloseSub(10)
				mem.inter.WriteBit(75, 1, 0)--序號參數存取賦歸 
				mem.inter.WriteBit(200, 1, 0)--參數存取按鈕關閉
			else
				screen.CloseSub(10)
				ascii_string = mem.inter.ReadAscii(4000, 12)--keyin配方名稱字串長度
				v2 = string.trim(ascii_string)
				v3 = string.len(v2)
				ret2, noIdx = recipe.GetCurEnRcpNoIndex()
				if (noIdx == 1) then
					screen.Open(9) 
					mem.inter.WriteBit(75, 1, 0)--序號參數存取賦歸
					mem.inter.WriteBit(200, 1, 0)--參數存取按鈕關閉                
				else    
					if (v3 < 12) then--keyin少於12碼跳出序號不存在視窗
						screen.Open(8)
						mem.inter.WriteBit(75, 1, 0)--序號參數存取賦歸
						mem.inter.WriteBit(200, 1, 0)--參數存取按鈕關閉
					elseif (v1 == 12) then--讀取配方名稱字串長度為12跳出確認存取提示
						screen.Open(7)
						mem.inter.WriteBit(99, 13, 1)--開啟觸發確認取消執行旗標
					else--讀取配方名稱字串長度低於12且keyin字串正確直接存入
						mem.inter.WriteBit(99, 12, 1)--開啟觸發參數旗標
						ascii_string = mem.inter.ReadAscii(4000, 12)
						recipe.SetCurEnRcpNoName(ascii_string)
					end
				end 
			end
		end




		f3 = mem.inter.ReadBit(99, 13)--確認取消執行旗標
		if (f3==1)then
			f1 = mem.inter.ReadBit(99, 14)--確認
			f2 = mem.inter.ReadBit(99, 15)--取消
			if (f1 == 1) then--確認覆蓋原先序號名稱	
				mem.inter.WriteBit(99, 12, 1)--開啟觸發參數旗標
				ascii_string = mem.inter.ReadAscii(4000, 12)
				recipe.SetCurEnRcpNoName(ascii_string) 
				mem.inter.WriteBit(99, 14, 0)--確認按鈕賦歸
				mem.inter.WriteBit(99, 13, 0)--確認取消執行旗標賦歸
			elseif (f2 == 1)then
				mem.inter.WriteBit(75, 1, 0)--序號參數存取賦歸
				mem.inter.WriteBit(200, 1, 0)--參數存取按鈕關閉
				sys.Sleep(100)
				screen.CloseSub(7)  --關閉視窗 
				mem.inter.WriteBit(99, 13, 0)--確認取消執行旗標賦歸
				mem.inter.WriteBit(99, 15, 0)--取消按鈕賦歸
			end
		end

        f4 = mem.inter.ReadBit(99, 12)--觸發參數旗標
        if (f4==1)then
            if (d2 == 1) then

				ReadPar();

				mem.inter.Write(1, 0)--加強型配方賦歸
				sys.Sleep(1000) 
				mem.inter.Write(1, 2)--加強型配方賦歸 
				sys.Sleep(1000)
            end
            if (d4 == 1) then 
				mem.inter.Write(3, 0)--配方旗標賦歸
				sys.Sleep(1000)
				mem.inter.Write(3, 2)--存入配方
				sys.Sleep(1000)
            end
			mem.inter.WriteBit(99, 11, 1)--觸發匯出參數配方Excel
			mem.inter.WriteBit(99, 12, 0)--觸發參數旗標賦歸
			screen.CloseSub(7)  --關閉視窗
			mem.inter.WriteBit(75, 1, 0)--序號參數存取賦歸

			mem.inter.WriteBit(200, 1, 0)--參數存取按鈕關閉
		end
        

 	    --畫圖    Felix 修改
        if (a1 == 1) then -- 進入即時畫圓程序
            RealTimeDrawCircle()

        --畫圖被觸發時，畫到一半i會繼續計數
        elseif (a10 == 1) and (a2 == 0)then
            if (i > 0) and (i < 100) then
                sys.Sleep(200)
                i = i+1
            elseif (i == 100) then
                mem.inter.WriteBit(30, 14, 1)--開啟判斷R是否超過極限旗標
                i = 0
                mem.inter.WriteBit(30, 15, 0)--關閉第一次觸發畫圖執行旗標
            end



        --存入配方
        elseif (a3 == 1) then--出廠圓存入配方
            for m = 1,100 do
				x11 = mem.inter.ReadDW(2*m+5998,"signed")--暫存區數據讀取 
				y12 = mem.inter.ReadDW(2*m+6198,"signed")
				x13 = mem.inter.ReadDW(2*m+6398,"signed")
				y14 = mem.inter.ReadDW(2*m+6598,"signed")
				mem.inter.WriteDW(2*m+6998, x11)--前徑向數據存入出廠圓     
				mem.inter.WriteDW(2*m+7198, y12)
				mem.inter.WriteDW(2*m+7398, x13)--後徑向數據存入出廠圓    
				mem.inter.WriteDW(2*m+7598, y14)
            end
            mem.inter.Write(3, 0)--配方旗標賦歸
            sys.Sleep(500)
            mem.inter.Write(3, 2)--存入配方
            sys.Sleep(500)
            mem.inter.WriteBit(30, 2, 0)--存入SD卡按鈕關閉
        elseif (a5 == 1) then--組裝圓存入配方
            for n = 1,100 do
				x11 = mem.inter.ReadDW(2*n+5998,"signed")--暫存區數據讀取 
				y12 = mem.inter.ReadDW(2*n+6198,"signed")
				x13 = mem.inter.ReadDW(2*n+6398,"signed")
				y14 = mem.inter.ReadDW(2*n+6598,"signed")
				mem.inter.WriteDW(2*n+7998, x11)--前徑向數據存入組裝圓    
				mem.inter.WriteDW(2*n+8198, y12)
				mem.inter.WriteDW(2*n+8398, x13)--後徑向數據存入組裝圓  
				mem.inter.WriteDW(2*n+8598, y14)
            end
            mem.inter.Write(3, 0)--配方旗標賦歸
            sys.Sleep(500)
            mem.inter.Write(3, 2)--存入配方
            sys.Sleep(500)
            mem.inter.WriteBit(30, 4, 0)--存入SD卡按鈕關閉
        elseif (a7 == 1) then--試車圓存入配方
            for o = 1,100 do
				x11 = mem.inter.ReadDW(2*o+5998,"signed")--暫存區數據讀取   
				y12 = mem.inter.ReadDW(2*o+6198,"signed")
				x13 = mem.inter.ReadDW(2*o+6398,"signed")
				y14 = mem.inter.ReadDW(2*o+6598,"signed")
				mem.inter.WriteDW(2*o+8998, x11)--前徑向數據存入試車圓   
				mem.inter.WriteDW(2*o+9198, y12)
				mem.inter.WriteDW(2*o+9398, x13)--後徑向數據存入試車圓 
				mem.inter.WriteDW(2*o+9598, y14)
            end
            mem.inter.Write(3, 0)--配方旗標賦歸
            sys.Sleep(500)
            mem.inter.Write(3, 2)--存入配方
            sys.Sleep(500)
            mem.inter.WriteBit(30, 6, 0)--存入SD卡按鈕關閉

        --SD匯出圖形
        elseif (a4 == 1) or (a6 == 1) or (a8 == 1)then
            mem.inter.Write(3, 0)
            mem.inter.Write(3, 4)--配方讀取
            sys.Sleep(500)

        --清除 
        elseif (a2 == 1) then 
            mem.inter.WriteBit(30, 15, 0)--關閉第一次觸發畫圖執行旗標



            i = 0
            p = 0
            for p = 1,100 do
				mem.inter.WriteDW(2*p+5998, 0)--前徑向暫存區歸零    
				mem.inter.WriteDW(2*p+6198, 0)
				mem.inter.WriteDW(2*p+6398, 0)--後徑向暫存區歸零    
				mem.inter.WriteDW(2*p+6598, 0)
            end
            mem.inter.WriteBit(40, 1, 1)--前徑向暫存圓清除
            mem.inter.WriteBit(43, 1, 1)--後徑向暫存圓清除
            mem.inter.Write(0, 3840)--出廠圓、組裝圓、試車圓取樣清除
            mem.inter.WriteBit(33, 0, 0)--清除R超過極限旗標

            mem.inter.WriteBit(30, 14, 0)--關閉判斷R是否超過極限旗標
            mem.inter.WriteBit(30, 0, 0)--清除賦歸


        end

        --圖形比
        if (a9 == 1) then

            mem.inter.Write(87, 2*mem.inter.Read(1009)*mem.inter.Read(22)/100)
            mem.inter.Write(91, mem.inter.Read(1009)*mem.inter.Read(22)/100)
            mem.inter.Write(93, 0-mem.inter.Read(91,"signed"))
            mem.inter.WriteBit(40, 1, 1)--前徑向暫存圓清除
            mem.inter.WriteBit(43, 1, 1)--後徑向暫存圓清除


            mem.inter.Write(0, 3840)
            sys.Sleep(500)
            if (a4 == 1) then
				mem.inter.WriteBit(0, 0, 1)
            end
            if (a6 == 1) then
				mem.inter.WriteBit(0, 1, 1)
            end
            if (a8 == 1) then
				mem.inter.WriteBit(0, 2, 1)
            end
            mem.inter.WriteBit(0, 3, 1)

            mem.inter.WriteBit(30, 8, 0)--圖形比旗標賦歸       
        end

		if (a11 == 1) then--開啟判斷R是否超過極限
			mem.inter.WriteBit(33, 0, 0)
			for q = 20,80 do
				R1square=(math.abs(mem.inter.ReadDW(2*q+5998,"signed"))*math.abs(mem.inter.ReadDW(2*q+5998,"signed")))+(math.abs(mem.inter.ReadDW(2*q+6198,"signed"))*math.abs(mem.inter.ReadDW(2*q+6198,"signed")))
				R2square=(math.abs(mem.inter.ReadDW(2*q+6398,"signed"))*math.abs(mem.inter.ReadDW(2*q+6398,"signed")))+(math.abs(mem.inter.ReadDW(2*q+6598,"signed"))*math.abs(mem.inter.ReadDW(2*q+6598,"signed")))
				Rcompare = mem.inter.Read(1009)
				Rcomparerange = mem.inter.Read(31)*Rcompare/100
				Rcomparepos=Rcompare+Rcomparerange
				Rcompareneg=Rcompare-Rcomparerange
				Rcomparepossquare=Rcomparepos*Rcomparepos
				Rcomparenegsquare=Rcompareneg*Rcompareneg
				if (R1square>=Rcomparepossquare)or (R1square<=Rcomparenegsquare)or (R2square>=Rcomparepossquare)or(R2square<=Rcomparenegsquare) then
					mem.inter.WriteBit(33, 0, 1)
				end
				mem.inter.WriteBit(30, 14, 0)
			end
		end
    end

    cnt = cnt + 1
    mem.inter.Write(459,i)
    sys.Sleep(20)  -- 需要調整                                                                      
    mem.inter.Write(20, i)
end






