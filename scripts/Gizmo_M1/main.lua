-- ********************************************************************************
-- **  Gizmo-Labs® Widget OMP Hobby M1                                           **
-- ********************************************************************************
-- **  Author: Marco Staab (Gizmo-Labs)®  January 2024                           **
-- ********************************************************************************

-- ********************************************************************************
-- **  Explanation of the different Tickers					                     **
-- **  DrawScreenTicker: 														 **
-- **  Initialized with Value 0													 **
-- **  On Value 0   --> Load Bitmap for Background-Mask, increment by 1	     	 **
-- **  On Value > 0 --> Draw Bitmap for Background-Mask							 **
-- **  Reset to Value 0 --> When Screen-Resolution has changed OR				 **
-- **  Reset to Value 0 --> After each 2 seconds by OS_CPU_Timer    			 **
-- **																			 **
-- **  DrawCycleTicker: 														 **
-- **  Initialized with Value 0													 **
-- **  On Value 0   --> Load Bitmap for Background-Mask, increment by 1	     	 **
-- **  On Value > 0 --> Draw Bitmap for Background-Mask							 **
-- **  Reset to Value 0 --> When Screen-Resolution has changed OR				 **
-- **  Reset to Value 0 --> After each 2 seconds by OS_CPU_Timer    			 **
-- **																			 **
-- **  OS_CPU_Timer: 															 **
-- **  Initialized with Value 0, only at startup						   		 **
-- **  Value is increment by 1 each second								     	 **
-- **  Reset to Value 0 --> Never during runtime      							 **
-- ********************************************************************************

local imagePath = "/scripts/Gizmo_M1/img"
local screenSize

--===================================================
-- Local Variables Flight Timer
--===================================================
local FlightTimer

--===================================================
-- Local Variables Receiver (RX)
--===================================================
local RxBatt
local RxBattValue
local RxBattSource

local RxSignal
local RxSignalValue
local RxSignalSource

--===================================================
-- Local Variables General
--===================================================

local Time_Temp = 0
local Debug_Mode = true
local DrawCycleTicker = 0

local ModelChoice

--===================================================
-- Convert Timer-Seconds into Timer-Minutes + Seconds
--===================================================

local function convert_Timer(val)
	
	local hour = math.floor(val/3600)
	local minute = math.floor((val -hour * 3600)/60)
	local second = val-hour * 3600 - minute * 60
	local timerStrg = string.format("%02d:%02d:%02d",hour,minute,second) -- format decimals

	return timerStrg
end

--===================================================
-- Draw the Values into the Image Mask
--===================================================
local function draw_Values()

	if Debug_Mode == true then
		print("Draw Values")
	end
	
	--===================================================
	-- Screen for Tandem X18 without Title Bar
	--===================================================
	if (screenSize == "X18fullScreenWithOutTitle") then

		DrawScreenTicker = DrawScreenTicker + 1
		
		--=================================================================
		-- Get the current Flight Mode		
		--=================================================================
		lcd.font(FONT_ITALIC)
		
		CurrentFlightMode = system.getSource({category=CATEGORY_FLIGHT_VALUE, member=CURRENT_FLIGHT_MODE}):stringValue()
		
		if CurrentFlightMode ~= nil then						
			lcd.drawText(160, 75, string.format("%s", CurrentFlightMode), CENTERED)
		end
		
		--=================================================================
		-- Check if a source entry for TxBatt is present in parameters mask
		-- if nothing found --> draw Text "----" in the Background Mask
		-- else --> draw Sensor Value
		--=================================================================		
			 
		TxBatt = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE})					
        		
		if TxBatt ~= nil then				    			
			TxBattValue = TxBatt:value()				
			lcd.drawNumber(392, 217, TxBattValue, 0, 2, CENTERED)								
		else			
			lcd.drawText(382, 217, "----")
		end
								
		--=================================================================
		-- Check if a source entry for RxBatt is present in parameters mask
		-- if nothing found --> draw Text "----" in the Background Mask
		-- else --> draw Sensor Value
		--=================================================================

		if RxBattSource ~= nil then
			RxBatt = system.getSource(RxBattSource)
        else			
			RxBatt = nil
		end
		
		if RxBatt ~= nil then
			RxBattValue = RxBatt:value()			
			lcd.drawNumber(392, 248, RxBattValue, 0, 2, CENTERED)								
		else
			lcd.drawText(382, 248, "----")
		end
				
		--=================================================================
		-- Check if a source entry for RxSignal is present in parameters mask
		-- if nothing found --> draw Text "----" in the Background Mask
		-- else --> draw Sensor Value
		--=================================================================
		
		if RxSignalSource ~= nil then
			RxSignal = system.getSource(RxSignalSource)			
		else
			RxSignal = nil
		end
		
		if RxSignal ~= nil then
			RxSignalValue = RxSignal:value()			
			lcd.drawNumber(392, 280, RxSignalValue, 0, 0, CENTERED)
		else		    
			lcd.drawText(382, 280, "----")
		end
		
		--=================================================================
		-- Check if a source entry for Flight-Timer is present in parameters mask
		-- if nothing found --> draw Text "----" in the Background Mask
		-- else --> draw Sensor Value
		--=================================================================				
		
		FlightTimer = system.getSource({category=CATEGORY_TIMER, member=0, options=0})
		
		if FlightTimer ~= nil then						
			lcd.drawText(145, 280, convert_Timer(FlightTimer:value()), 0, 0, CENTERED)
		else		    
			lcd.drawText(145, 278, "----")
		end		
	end
end

--===================================================
-- Draw background
--===================================================
local function draw_background()

	if Debug_Mode == true then
		print("Draw Background")
	end

	local w2_old = w2
	local h2_old = h2

	--=================================================================
	-- Get the current Screen-Resolution from the system
	-- 800 x 458 --> Tandem X20 with "Title ON Option"
	-- 800 x 480 --> Tandem X20 with "Title OFF Option" aka. FullScreen
	-- 480 x 301 --> Tandem X18 with "Title ON Option"
	-- 480 x 320 --> Tandem X18 with "Title OFF Option" aka. FullScreen
	--=================================================================
	w2, h2 = lcd.getWindowSize()
	
	if Debug_Mode == true then	
		print(string.format("Horizontal Resolution = %s Pixels", w2))
		print(string.format("Vertical Resolution = %s Pixels", h2))
	end
	
	--=================================================================
	-- Check if someone has changed Resolution since last visit
	--=================================================================
	if w2 ~= w2_old or h2 ~= h2_old then
		DrawScreenTicker = 0
		Background = nil
	end

	--=================================================================
	-- After one CPU cycle we only draw the bitmap
	-- Sometimes it get not loaded at the first try --> load again 
	-- This is a major difference compared to loading it...
	--=================================================================
	if w2 == 480 and h2 == 301 then
		screenSize = "X18fullScreenWithTitle"
		
		if (DrawScreenTicker > 0) then
			lcd.drawText(70, 115, "Widget supports only Fullscreen without title!")
		end
	elseif w2 == 480 and h2 == 320 then
		screenSize = "X18fullScreenWithOutTitle"

		if (DrawScreenTicker > 0) then
			if (Background ~= nil) then
				lcd.drawBitmap(0, 0, Background)
			else
				---Background = lcd.loadBitmap(imagePath.."/M1_Yellow_Akku.bmp")
				lcd.drawBitmap(0, 0, Background)
			end
		end	
	end

	--=================================================================
	-- With the Resolution detected, we can choose our Image-Size
	-- Very important is to load the Bitmap only once !
	-- Loading it every cycle can block main function of the Tandems...
	--=================================================================

	if (screenSize == "X18fullScreenWithOutTitle") then
		if DrawScreenTicker == 0 then
			if (ModelChoice == nil) or (ModelChoice == 1) then
				Background = lcd.loadBitmap(imagePath.."/M1_Yellow_Akku.bmp")
			elseif (ModelChoice == 2) then
				Background = lcd.loadBitmap(imagePath.."/M1_Yellow_RxBatt.bmp")
			elseif (ModelChoice == 3) then
				Background = lcd.loadBitmap(imagePath.."/M1_Purple_Akku.bmp")
			elseif (ModelChoice == 4) then
				Background = lcd.loadBitmap(imagePath.."/M1_Purple_RxBatt.bmp")
			elseif (ModelChoice == 5) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Yellow_Akku.bmp")
			elseif (ModelChoice == 6) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Yellow_RxBatt.bmp")
			elseif (ModelChoice == 7) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Orange_Akku.bmp")
			elseif (ModelChoice == 8) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Orange_RxBatt.bmp")
			elseif (ModelChoice == 9) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Red_Akku.bmp")
			elseif (ModelChoice == 10) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_Red_RxBatt.bmp")
			elseif (ModelChoice == 11) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_White_Akku.bmp")
			elseif (ModelChoice == 12) then
				Background = lcd.loadBitmap(imagePath.."/M1_Evo_White_RxBatt.bmp")
			else
				Background = lcd.loadBitmap(imagePath.."/M1_Yellow_Akku.bmp")
			end
		end
	end

	DrawScreenTicker = DrawScreenTicker + 1
end


--===================================================
-- Here is all the stuff for pre-setting values
--===================================================
local function create()
    return {r=255, g=255, b=255, source=nil, value=0}
end

--===================================================
-- Here is all the stuff to keep widget alive
--===================================================
local function wakeup()
	newValue = os.clock()

	if newValue > Time_Temp then
		Time_Temp = newValue

		if RenderingDone then
			lcd.invalidate()
			RenderingDone = false
		end
	end
end

--===================================================
-- Here is all the stuff for handling the widget
--===================================================
local function paint(widget)
	--===================================================
	-- Load the different states of the Battery-Icon
	-- Very important is to load each Bitmap only once !
	-- Loading it every cycle can block main function of the Tandems...
	--===================================================
	
	if Debug_Mode == true then
		print("Paint Widget")
	end

	--===================================================
	-- Fetch the Model from Widget-Choice-Field
	--===================================================
	if widget.model ~= nil then
		ModelChoice = widget.model
	end
    
    --===================================================
	-- Fetch the Source-Name for RxBatt from Widget-Parameter
	--===================================================
	if widget.RxBattSource ~= nil then
		RxBattSource = widget.RxBattSource:name()
	end

	--===================================================
	-- Fetch the Source-Name for RxSignal from Widget-Parameter
	--===================================================
	if widget.RxSignalSource ~= nil then
		RxSignalSource = widget.RxSignalSource:name()
	end

	--===================================================
	-- Reset DrawScreenTicker after each 2 seconds
	--===================================================
	if (os.clock() > OS_CPU_Timer + 1) then
		DrawScreenTicker = 0		
	end

	draw_background()
	draw_Values()

	DrawCycleTicker = DrawCycleTicker + 1

	RenderingDone = true

	OS_CPU_Timer = os.clock()
end

--===================================================
-- Here is all the stuff for configuration of the widget
--===================================================
local function configure(widget)
	
	if Debug_Mode == true then
		print("Configure Widget")
	end
	
	-- Sensor Source configuration
	line = form.addLine("Telemetrie Einstellungen:")
	
	line = form.addLine("M1 Modellauswahl")
	form.addChoiceField(line, nil, {{"M1 Gelb --> Akku", 1}, {"M1 Gelb --> Rx", 2}, {"M1 Purple --> Akku", 3}, {"M1 Purple --> Rx", 4},
									{"M1 Evo Gelb --> Akku", 5}, {"M1 Evo Gelb --> Rx", 6} , {"M1 Evo Orange --> Akku", 7}, {"M1 Evo Orange --> Rx", 8},
									{"M1 Evo Rot --> Akku", 9}, {"M1 Evo Rot --> Rx", 10}, {"M1 Evo Weiß --> Akku", 11}, {"M1 Evo Weiß --> Rx", 12}
									}, function() return widget.model end, function(value) widget.model = value end)

	-- Field for Rx-Battery
	line = form.addLine("Empfänger Akkuspannung")
    form.addSourceField(line, nil, function() return widget.RxBattSource end, function(value) widget.RxBattSource = value end)
	
	-- Field for Rx-Signal
	line = form.addLine("Empfänger RSSI")
	form.addSourceField(line, nil, function() return widget.RxSignalSource end, function(value) widget.RxSignalSource = value end)
end

--===================================================
-- Here is all the stuff for reading from memory
--===================================================
local function read(widget)		
	widget.RxBattSource	        	= storage.read ("RxBattSource")
	widget.RxSignalSource	    	= storage.read ("RxSignalSource")
	widget.model					= storage.read ("ModelChoice")
end

--===================================================
-- Here is all the stuff for writing to memory
--===================================================
local function write(widget)	
	storage.write("RxBattSource"			, widget.RxBattSource)
	storage.write("RxSignalSource"			, widget.RxSignalSource)
	storage.write("ModelChoice"              , widget.model)
end

--===================================================
-- Here is all the stuff for starting up the widget
--===================================================
local function init()

	if Debug_Mode == true then
		print("May the Force be with you...")
	end
	
	DrawScreenTicker = 0	

	OS_CPU_Timer = 0

	SoftwareVersion = "V1.0.0"

	language = system.getLocale()

	system.registerWidget({key = "Gz_M1", name = "Gizmo M1", create = create, paint = paint, configure = configure, read = read, write = write, wakeup = wakeup})	
end

return {init=init}
