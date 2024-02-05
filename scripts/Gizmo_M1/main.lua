-- ********************************************************************************
-- **  Gizmo-Labs® Widget OMP Hobby M1                                           **
-- ********************************************************************************
-- **  Author: Marco Staab (Gizmo-Labs)®  January 2024                           **
-- ********************************************************************************

-- ********************************************************************************
-- **  Erklärung der Ticker-Variablen            			                     **
-- **  DrawScreenTicker: 														 **
-- **  Initialisiert mit Wert 0													 **
-- **  Wenn Wert 0   --> LADE Bitmap für Hintergrund, zähle um 1 hoch	     	 **
-- **  Wenn Wert > 0 --> ZEICHNE Bitmap für Hintergrund                          **
-- **  Zurücksetzen auf Wert 0 --> Wenn sich Bildschirm-Auflösung ändert ODER    **
-- **                              OS_CPU_Timer zu lange braucht    			 **
-- **																			 **
-- **  DrawCycleTicker: 														 **
-- **  Initialisiert mit Wert 0													 **
-- **  Wenn Wert 0   --> LADE Bitmap für Hintergrund, zähle um 1 hoch	     	 **
-- **  Wenn Wert > 0 --> ZEICHNE Bitmap für Hintergrund              			 **
-- **  Zurücksetzen auf Wert 0 --> Wenn sich Bildschirm-Auflösung ändert ODER    **
-- **                              OS_CPU_Timer zu lange braucht    			 **
-- **																			 **
-- **  OS_CPU_Timer: 															 **
-- **  Initialisiert mit Wert 0 beim Programmstart						   		 **
-- **  Bekommt die Programmlaufzeit in Sekunden zugewiesen				     	 **
-- **  Wird während der Laufzeit nicht zurückgesetzt   							 **
-- ********************************************************************************

local imagePath = "/scripts/Gizmo_M1/img"
local screenSize

--===================================================
-- Lokale Variablen Stoppuhr
--===================================================
local FlightTimer

--===================================================
-- Lokale Variablen Empfänger (RX)
--===================================================
local RxBatt
local RxBattValue
local RxBattSource

local RxSignal
local RxSignalValue
local RxSignalSource

--===================================================
-- Lokale Variablen Allgemein
--===================================================

local DrawCycleTicker = 0
local Time_Temp = 0
local Debug_Mode = false
local ModelChoice

--===================================================
-- Konvertiere Timer-Sekunden in Timer-Minuten + Sekunden
--===================================================
local function convert_Timer(val)

    local hour = math.floor(val / 3600)
    local minute = math.floor((val - hour * 3600) / 60)
    local second = val - hour * 3600 - minute * 60
    local timerStrg = string.format("%02d:%02d:%02d", hour, minute, second) -- format decimals

    return timerStrg
end

--===================================================
-- Diese Funktion behandelt die Anzeigewerte
--===================================================
local function draw_Values(widget)

    if Debug_Mode == true then
        print("Zeichne Anzeigewerte")
    end

    ---===================================================
    -- Anzeige für Tandem X18 und X18s mit Titel auf AUS
    --===================================================
    if (screenSize == "X18fullScreenWithOutTitle") then

        DrawScreenTicker = DrawScreenTicker + 1

        --=================================================================
        -- Zeige die Flugphasen an
        -- falls keine vorhanden sind zeige "----" in der Anzeige an
        --=================================================================
        lcd.font(FONT_ITALIC)
        lcd.color(fontcolor)

        CurrentFlightMode = system.getSource({ category = CATEGORY_FLIGHT_VALUE, member = CURRENT_FLIGHT_MODE }):stringValue()

        if CurrentFlightMode ~= nil then
            lcd.drawText(160, 23, string.format("%s", CurrentFlightMode), CENTERED)
        end

        --=================================================================
        -- Zeige die erste Stoppuhr an
        -- falls keine vorhanden ist zeige "----" in der Anzeige an
        --=================================================================
        FlightTimer = system.getSource({ category = CATEGORY_TIMER, member = 0, options = 0 })

        if FlightTimer ~= nil then
            lcd.drawText(152, 50, convert_Timer(FlightTimer:value()), 0, 0, CENTERED)
        else
            lcd.drawText(152, 48, "----")
        end

        --=================================================================
        -- Lese den Systemwert für Sender-Akkuspannung aus
        --=================================================================
        TxBatt = system.getSource({ category = CATEGORY_SYSTEM, member = MAIN_VOLTAGE })

        if TxBatt ~= nil then
            TxBattValue = TxBatt:value()
            lcd.drawNumber(378, 198, TxBattValue, 0, 2, CENTERED)
        else
            lcd.drawText(368, 198, "----")
        end

        --=================================================================
        -- Wenn ein Sensor für Empfänger-Akkuspannung definiert ist zeige den Wert an
        -- alternativ wird die Flugakkuspannung angezeigt, wenn der Empfänger am Flugakku hängt
        -- falls nicht zeige "----" in der Anzeige an
        --=================================================================
        if RxBattSource ~= nil then
            RxBatt = system.getSource(RxBattSource)
        else
            RxBatt = nil
        end

        if RxBatt ~= nil then
            RxBattValue = RxBatt:value()
            lcd.drawNumber(378, 224, RxBattValue, 0, 2, CENTERED)
        else
            lcd.drawText(370, 224, "----")
        end

        --=================================================================
        -- Wenn ein Sensor für Empfänger RSSI definiert ist zeige den Wert an
        -- falls nicht zeige "----" in der Anzeige an
        --=================================================================
        if RxSignalSource ~= nil then
            RxSignal = system.getSource(RxSignalSource)
        else
            RxSignal = nil
        end

        if RxSignal ~= nil then
            RxSignalValue = RxSignal:value()
            lcd.drawNumber(152, 261, RxSignalValue, 0, 0, CENTERED)
        else
            lcd.drawText(144, 260, "----")
        end
    end

    ---===================================================
    -- Anzeige für Tandem X20 und X20s mit Titel auf AUS
    --===================================================
    if (screenSize == "X20fullScreenWithOutTitle") then

        DrawScreenTicker = DrawScreenTicker + 1

        --=================================================================
        -- Zeige die Flugphasen an
        -- falls keine vorhanden sind zeige "----" in der Anzeige an
        --=================================================================
        lcd.font(FONT_L)
        lcd.color(fontcolor)

        CurrentFlightMode = system.getSource({ category = CATEGORY_FLIGHT_VALUE, member = CURRENT_FLIGHT_MODE }):stringValue()

        if CurrentFlightMode ~= nil then
            lcd.drawText(280, 30, string.format("%s", CurrentFlightMode), CENTERED)
        end

        --=================================================================
        -- Zeige die erste Stoppuhr an
        -- falls keine vorhanden ist zeige "----" in der Anzeige an
        --=================================================================
        FlightTimer = system.getSource({ category = CATEGORY_TIMER, member = 0, options = 0 })

        if FlightTimer ~= nil then
            lcd.drawText(260, 362, convert_Timer(FlightTimer:value()), 0, 0, CENTERED)
        else
            lcd.drawText(302, 360, "----", CENTERED)
        end

        --=================================================================
        -- Lese den Systemwert für Sender-Akkuspannung aus
        --=================================================================
        TxBatt = system.getSource({ category = CATEGORY_SYSTEM, member = MAIN_VOLTAGE })

        if TxBatt ~= nil then
            TxBattValue = TxBatt:value()
            lcd.drawNumber(640, 274, TxBattValue, 0, 2, CENTERED)

        else
            lcd.drawText(640, 272, "----", CENTERED)
        end

        --=================================================================
        -- Wenn ein Sensor für Empfänger-Akkuspannung definiert ist zeige den Wert an
        -- alternativ wird die Flugakkuspannung angezeigt, wenn der Empfänger am Flugakku hängt
        -- falls nicht zeige "----" in der Anzeige an
        --=================================================================
        if RxBattSource ~= nil then
            RxBatt = system.getSource(RxBattSource)
        else
            RxBatt = nil
        end

        if RxBatt ~= nil then
            RxBattValue = RxBatt:value()
            lcd.drawNumber(640, 319, RxBattValue, 0, 2, CENTERED)
        else
            lcd.drawText(640, 317, "----", CENTERED)
        end

        --=================================================================
        -- Wenn ein Sensor für Empfänger RSSI definiert ist zeige den Wert an
        -- falls nicht zeige "----" in der Anzeige an
        --=================================================================
        if RxSignalSource ~= nil then
            RxSignal = system.getSource(RxSignalSource)
        else
            RxSignal = nil
        end

        if RxSignal ~= nil then
            RxSignalValue = RxSignal:value()
            lcd.drawNumber(222, 408, RxSignalValue, 0, 0, CENTERED)
        else
            lcd.drawText(222, 406, "----", CENTERED)
        end
    end
end

--===================================================
-- Diese Funktion behandelt den Bildschirmhintergrund
--===================================================
local function draw_background(widget)

    if Debug_Mode == true then
        print("Zeichne Bildhintergrund")
    end

    local w2_old = w2
    local h2_old = h2

    --=================================================================
    -- Lesen der aktuellen Auflösung
    -- 800 x 458 --> Tandem X20 mit "Title EIN Option"
    -- 800 x 480 --> Tandem X20 mit "Title AUS Option" aka. FullScreen
    -- 480 x 301 --> Tandem X18 mit "Title EIN Option"
    -- 480 x 320 --> Tandem X18 mit "Title AUS Option" aka. FullScreen
    --=================================================================
    w2, h2 = lcd.getWindowSize()

    if Debug_Mode == true then
        print(string.format("Horizontal Resolution = %s Pixels", w2))
        print(string.format("Vertical Resolution = %s Pixels", h2))
    end

    --=================================================================
    -- Schauen ob jemand die Auflösung geändert hat
    --=================================================================
    if w2 ~= w2_old or h2 ~= h2_old then
        DrawScreenTicker = 0
        Background = nil
    end

    --=================================================================
    -- Auflösung ermitteln
    --=================================================================
    if w2 == 480 and h2 == 301 then
        screenSize = "X18fullScreenWithTitle"

        if (DrawScreenTicker > 0) then
            lcd.drawText(80, 145, "Widget funktioniert nur mit Titel auf AUS!")
        end
    elseif w2 == 480 and h2 == 320 then
        screenSize = "X18fullScreenWithOutTitle"

        if (DrawScreenTicker > 0) then
            lcd.drawBitmap(0, 0, Background)
        end
    elseif w2 == 800 and h2 == 458 then
        screenSize = "X20fullScreenWithTitle"

        if (DrawScreenTicker > 0) then
            lcd.drawText(200, 200, "Widget funktioniert nur mit Titel auf AUS!")
        end
    elseif w2 == 800 and h2 == 480 then
        screenSize = "X20fullScreenWithOutTitle"

        if (DrawScreenTicker > 0) then
            lcd.drawBitmap(0, 0, Background)
        end
    end

    --=================================================================
    -- Wenn wir die Auflösung wissen können wir das passende Bild wählen
    -- Sehr wichtig ist dass Bitmap nur EINMAL zu laden!
    -- Deshalb tun wir das nur im ersten CPU-Zyklus!
    -- Dauerhaftes laden kann andere wichtige Funktionen stören!
    --=================================================================
    if (screenSize == "X18fullScreenWithOutTitle") then
        if DrawScreenTicker == 0 then
            if (ModelChoice == nil) or (ModelChoice == 1) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_Akku_X18.bmp")
            elseif (ModelChoice == 2) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_RxBatt_X18.bmp")
            elseif (ModelChoice == 3) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Purple_Akku_X18.bmp")
            elseif (ModelChoice == 4) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Purple_RxBatt_X18.bmp")
            elseif (ModelChoice == 5) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Yellow_Akku_X18.bmp")
            elseif (ModelChoice == 6) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Yellow_RxBatt_X18.bmp")
            elseif (ModelChoice == 7) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Orange_Akku_X18.bmp")
            elseif (ModelChoice == 8) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Orange_RxBatt_X18.bmp")
            elseif (ModelChoice == 9) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Red_Akku_X18.bmp")
            elseif (ModelChoice == 10) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Red_RxBatt_X18.bmp")
            elseif (ModelChoice == 11) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_White_Akku_X18.bmp")
            elseif (ModelChoice == 12) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_White_RxBatt_X18.bmp")
            else
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_Akku_X18.bmp")
            end
        end
    end

    if (screenSize == "X20fullScreenWithOutTitle") then
        if DrawScreenTicker == 0 then
            if (ModelChoice == nil) or (ModelChoice == 1) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_Akku_X20.bmp")
            elseif (ModelChoice == 2) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_RxBatt_X20.bmp")
            elseif (ModelChoice == 3) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Purple_Akku_X20.bmp")
            elseif (ModelChoice == 4) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Purple_RxBatt_X20.bmp")
            elseif (ModelChoice == 5) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Yellow_Akku_X20.bmp")
            elseif (ModelChoice == 6) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Yellow_RxBatt_X20.bmp")
            elseif (ModelChoice == 7) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Orange_Akku_X20.bmp")
            elseif (ModelChoice == 8) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Orange_RxBatt_X20.bmp")
            elseif (ModelChoice == 9) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Red_Akku_X20.bmp")
            elseif (ModelChoice == 10) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_Red_RxBatt_X20.bmp")
            elseif (ModelChoice == 11) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_White_Akku_X20.bmp")
            elseif (ModelChoice == 12) then
                Background = lcd.loadBitmap(imagePath .. "/M1_Evo_White_RxBatt_X20.bmp")
            else
                Background = lcd.loadBitmap(imagePath .. "/M1_Yellow_Akku_X20.bmp")
            end
        end
    end

    DrawScreenTicker = DrawScreenTicker + 1
end

--===================================================
-- Startwerte initialisieren
--===================================================
local function create()
    return {
        source = nil,
        value = 0,
        model = 1,
        fontsize = FONT_STD,
        fontcolor = lcd.RGB(0xF8, 0x00, 0x00)
    }
end

--===================================================
-- Display zyklisch auffrischen
--===================================================
local function wakeup(widget)
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
-- Diese Funktion handelt die Darstellung vom Widget
--===================================================
local function paint(widget)
    --===================================================
    -- Sehr wichtig ist dass Bitmap nur EINMAL zu laden!
    -- Deshalb tun wir das nur im ersten CPU-Zyklus!
    -- Dauerhaftes laden kann andere wichtige Funktionen stören!
    --===================================================

    if Debug_Mode == true then
        print("Zeichne Widget")
    end

    --===================================================
    -- Liest die Schriftfarbe ein
    --===================================================
    if widget.fontColor ~= nil then
      fontcolor = widget.fontColor
    end

    --===================================================
    -- Liest den Modell-Typ ein
    --===================================================
    if widget.model ~= nil then
        ModelChoice = widget.model
    end

    --===================================================
    -- Liest den Telemetrie-Sensor für Empfänger-Akkuspannung ein
    --===================================================
    if widget.RxBattSource ~= nil then
        RxBattSource = widget.RxBattSource:name()
    end

    --===================================================
    -- Liest den Telemetrie-Sensor für RSSI ein
    --===================================================
    if widget.RxSignalSource ~= nil then
        RxSignalSource = widget.RxSignalSource:name()
    end

    --===================================================
    -- Laufzeitüberwachung
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
-- Diese Funktion enthält das Konfigurations-Menü vom Widget
--===================================================
local function configure(widget)

    if Debug_Mode == true then
        print("Configure Widget")
    end

    -- Schriftfarbe
    line = form.addLine("Schriftfarbe")
    form.addColorField(line, nil, function()
        if widget.fontcolor == nil then
            return BLACK
        else
            return widget.fontColor
        end
    end, function(fontcolor)
        widget.fontColor = fontcolor
    end)

    -- Telemetrie
    line = form.addLine("Telemetrie Einstellungen:")

    -- Modelltyp auswählen
    line = form.addLine("M1 Modellauswahl")
    form.addChoiceField(line, nil, { { "M1 Gelb --> Akku", 1 }, { "M1 Gelb --> Rx", 2 }, { "M1 Purple --> Akku", 3 }, { "M1 Purple --> Rx", 4 },
                                     { "M1 Evo Gelb --> Akku", 5 }, { "M1 Evo Gelb --> Rx", 6 }, { "M1 Evo Orange --> Akku", 7 }, { "M1 Evo Orange --> Rx", 8 },
                                     { "M1 Evo Rot --> Akku", 9 }, { "M1 Evo Rot --> Rx", 10 }, { "M1 Evo Weiß --> Akku", 11 }, { "M1 Evo Weiß --> Rx", 12 }
    }, function()
        if widget.model == nil then
            return 1
        else
            return widget.model
        end
    end, function(value)
        widget.model = value
    end)

    -- Sensor für Emfänger-Akkuspannung oder alternativ Flugakkuspannung
    line = form.addLine("Empfänger Akkuspannung")
    form.addSourceField(line, nil, function()
        return widget.RxBattSource
    end, function(value)
        widget.RxBattSource = value
    end)

    -- Sensor Empfänger RSSI
    line = form.addLine("Empfänger RSSI")
    form.addSourceField(line, nil, function()
        return widget.RxSignalSource
    end, function(value)
        widget.RxSignalSource = value
    end)
end

--===================================================
-- Lese die Parameter aus dem Speicher
--===================================================
local function read(widget)
    widget.RxBattSource = storage.read("RxBattSource")
    widget.RxSignalSource = storage.read("RxSignalSource")
    widget.model = storage.read("ModelChoice")
    widget.fontColor = storage.read("fontColor")
end

--===================================================
-- Schreibe die Parameter in den Speicher
--===================================================
local function write(widget)
    storage.write("RxBattSource", widget.RxBattSource)
    storage.write("RxSignalSource", widget.RxSignalSource)
    storage.write("ModelChoice", widget.model)
    storage.write("fontColor", widget.fontColor)
end

--===================================================
-- Initalisierung
--===================================================
local function init()

    if Debug_Mode == true then
        print("Das M1-Widget startet jetzt...")
    end

    DrawScreenTicker = 0

    OS_CPU_Timer = 0

    SoftwareVersion = "V1.0.0"

    language = system.getLocale()

    system.registerWidget({ key = "Gz_M1", name = "Gizmo M1", create = create, paint = paint, configure = configure, read = read, write = write, wakeup = wakeup })
end

return { init = init }
