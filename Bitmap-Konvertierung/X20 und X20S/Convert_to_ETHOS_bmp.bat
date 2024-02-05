@echo off
REM ######################################################################### 
REM #                                                                       #
REM # Copyright (C) Ceeb182@laposte.net                                     #
REM #                                                                       #
REM # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               #
REM #                                                                       #
REM # This program is free software; you can redistribute it and/or modify  #
REM # it under the terms of the GNU General Public License version 2 as     #
REM # published by the Free Software Foundation.                            #
REM #                                                                       #
REM # This program is distributed in the hope that it will be useful        #
REM # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
REM # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
REM # GNU General Public License for more details.                          #
REM #                                                                       #
REM ######################################################################### 
setlocal DisableDelayedExpansion
set ResultDirName=UmgewandelteBitmaps
set Mypath=%cd%\%ResultDirName%\
set cnt=0
set ValidFile=false
set ImageMagickExist=false
set OnlyConvert=true
set MyChoice=e

if "%~1" == "" (
	set OnlyConvert=true
	set MyChoice=c
) else (
	if "%~1" == "-m" (
		set OnlyConvert=false
	) else (
		echo Unbekannter Befehl
		echo Nutze -m als Argument um den Scriptnamen anzuzeigen
		exit /b
	)
)

echo *********************************************************
echo * Skript fuer Windows OS um JEGLICHE Bilder             *
echo * (unabhaengig von Dateiformat, Groesse und Codierung)  *
echo * in das FrSky Ethos OS Bitmat Format zu wandeln        *
echo *                                                       *
echo * 32bits BMP Format / 8 Bit pro Farbe + Alpha Kanal     *
echo *                   size : 800x480px                    *
echo *                                                       *
echo * Version 1.1                                by Gizmo   *
echo *********************************************************
echo *
rem >> Test if ImageMagick exist
magick -version >nul 2>&1 && (set ImageMagickExist=true) 
if 	%ImageMagickExist%==true (
	echo * Programm ImageMagick gefunden !
) else (
	echo * Bitte installiere zuerst ImageMagick von https://www.imagemagick.org	
	echo *
	set /p DUMMY=* Enter zum fortsetzen...
	exit /b
)
rem >> Command list
if %OnlyConvert%==false (
	echo *
	echo * Auswahl treffen :
	echo *   c  : um die Bilder in Bitmaps fuer FrSky Ethos OS umzuwandeln
	echo *   d  : um ein vorheriges Ergebnis zu loeschen
	set /p MyChoice=* Auswahl eingeben :
)

if %MyChoice%==c (
	echo *
	echo * Starte umwandeln in Bitmap
	echo *
    rem >> Check and count files to convert
	setlocal EnableDelayedExpansion
	for %%f in (*.*) do (
		set ValidFile=false
		for %%g in (.jpg,.jpeg,.png,.bmp,.gif,.webp,.svg,.tiff,.ico) do if %%g==%%~xf set ValidFile=yes
		if !ValidFile!==yes set /a cnt+=1
	)	
	rem >> Create directory for results
	if not !cnt!==0 if not exist "%Mypath%" (	
		mkdir "%Mypath%"
		echo * Erstelle Verzeichnis: %ResultDirName% : Erfolgreich abgeschlossen !
		echo *
	)
	rem >> Convert all picture	
	echo * Anzahl der umzuwandelnden Bilder = !cnt!
	echo *
	set cnt=0
    for %%f in (*.*) do (
		set ValidFile=false
		for %%g in (.jpg,.jpeg,.png,.bmp,.gif,.webp,.svg,.tiff,.ico) do if %%g==%%~xf set ValidFile=yes
		if !ValidFile!==yes (
			set /a cnt+=1
			magick "%%f" -resize 800x480 -alpha Set -depth 8 -compose Copy -gravity center -extent 800x480 "%Mypath%%%~nf.bmp"
			echo * Umwandlung #!cnt! : %%f
		)
	)
	echo *
	if not !cnt!==0 echo * Ergebnischeck in %Mypath%
	endlocal
	set /p DUMMY=* Enter zum fortsetzen...
	exit /b
)
if %MyChoice%==d (
	echo *
	echo * COMMAND : Vorheriges Ergebnis loeschen
	if exist "%Mypath%" (
		echo * %ResultDirName% Verzeichnis gefunden.
		rmdir /q /s "%Mypath%"
		echo * Loesche vorheriges Ergebnis : Erfolgreich abgeschlossen !
	) else (
		echo * %ResultDirName% Verzeichnis nicht gefunden. Nichts da zum loeschen.
	)
	echo *
	set /p DUMMY=* Enter zum fortsetzen...
	exit /b
)