{ ;Download
downlgif := "https://github.com/rqvm/Cristalix/raw/master/cristall.gif"
IfnotExist, %A_temp%
FileCreateDir, %A_temp%
FileDelete, %a_temp%/verlen.ini
IfNotExist, C:\cristall.gif
    URLDownloadToFile, %downlgif%, C:\cristall.gif
FileDelete, %a_temp%/lickey.txt
URLDownloadToFile, https://github.com/rqvm/Cristalix/raw/master/lickey.txt, %a_temp%/lickey.txt
}
strComputer := "."
objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . strComputer . "\root\cimv2")
colSettings := objWMIService.ExecQuery("Select * from Win32_OperatingSystem")._NewEnum
While colSettings[objOSItem]
{
Key := objOSItem.SerialNumber
}
;===========================================================================
fileread, read, %a_temp%/lickey.txt
if read contains %Key%
goto true
Gui, Font, S16 CRed Bold, Arial
Gui, Add, Text, x80 y0 w113 h30 , Ключ:
Gui, Font, , 
Gui, Add, Edit, x43 y27 w140 h21 ReadOnly vEdit,
Gui, Add, Button, x37 y56 w153 h24 gClip , Копировать и закрыть
Gui, Add, Text, x70 y85 w113 h30 , vk.com/daqovich
Gui, Show, w221 h105, Key
GuiControl, , Edit, % Key
return
Clip:
Gui, Submit, NoHide
Clipboard := Edit
FileDelete, %a_temp%/lickey.txt
ExitApp
true:
msgbox, Индентификация прошла успешно.
FileDelete, %a_temp%/lickey.txt

{ ;AutoUpdate
buildscr = 1 ;версия для сравнения, если меньше чем в verlen.ini - обновляем
downlurl := "https://github.com/rqvm/Cristalix/blob/master/updt.exe?raw=true"
downllen := "https://github.com/rqvm/Cristalix/raw/master/verlef.ini"

Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff
}
{ ;Gif
pic := "C:\cristall.gif"
width := 150, height := 150

html := "<body style=""overflow: hidden; margin: 0px""><img src=" pic " width=" width "px></body>" 
Gui, -DPIScale 
Gui, Margin, 0, 0
Gui, Add, ActiveX,x390 y135 w%width% h%height% voHTML, HTMLFile 
oHTML.Write(html)
}
{ ;GUI
Gui, +hwndhGui1
Menu, Tray, Icon, C:\cristall.gif
Gui, 1:Add, CheckBox, x12 y25 w80 h20 vCheck1, 2.1 Выдача
Gui, 1:Add, Button, x95 y25 w30 h18 , Тык ;Выдача
Gui, 1:Add, CheckBox, x12 y50 w115 h20 vCheck2, 2.2 Выпрашивание
Gui, 1:Add, Button, x130 y50 w30 h18 , Тык ;Выпрашивание
Gui, 1:Add, CheckBox, x12 y70 w115 h30 vCheck3, 2.3 Обсужд. действ. персонала
Gui, 1:Add, Button, x129 y81 w30 h18 , Тык ;действ. персонала
Gui, 1:Add, CheckBox, x12 y105 w120 h20 vCheck4, 2.4 Дискриминация
Gui, 1:Add, Button, x133 y105 w30 h18 , Тык ;Дискримин
Gui, 1:Add, CheckBox, x12 y130 w95 h20 vCheck5 , 2.5 Пропаганда
Gui, 1:Add, Button, x109 y130 w30 h18 , Тык ;Пропаг
Gui, 1:Add, CheckBox, x12 y150 w120 h30 vCheck6, 2.6 Обсужд. политики и религии
Gui, 1:Add, Button, x133 y157 w30 h18 , Тык ;обсужд политики
Gui, 1:Add, CheckBox, x12 y180 w150 h30 vCheck7, 2.7 Нец. Лексика`,Завуал мат`,Нец символы
Gui, 1:Add, Button, x165 y184 w30 h18 , Тык ;мат
Gui, 1:Add, CheckBox, x143 y19 w15 h20 vCheck8,
Gui, 1:Add, GroupBox, x162 y20 w243 h58, 2.8 Оск`,Угрозы`,Нахальн. повед.
Gui, 1:Add, CheckBox, x168 y34 w55 h20 vCheck9, Игрока
Gui, 1:Add, Button, x230 y34 w30 h18 , Тык ;игрок
Gui, 1:Add, CheckBox, x270 y34 w100 h20 vCheck10, Персонала/Адм
Gui, 1:Add, Button, x370 y34 w30 h18 , Тык ;персонала
Gui, 1:Add, CheckBox, x188 y54 w120 h20 vCheck11, Родителей/Сервера
Gui, 1:Add, Button, x310 y54 w30 h18 , Тык ;родителей
Gui, 1:Add, CheckBox, x170 y78 w130 h20 vCheck12, 2.9 Троллинг и флейм
Gui, 1:Add, Button, x302 y79 w30 h18 , Тык ;тролл
Gui, 1:Add, CheckBox, x170 y101 w70 h20 vCheck13, 2.10 Флуд
Gui, 1:Add, Button, x245 y100 w30 h18, Тык ;Флуд
Gui, 1:Add, CheckBox, x170 y123 w100 h20 vCheck14, 2.11 Орг. Флуда
Gui, 1:Add, Button, x275 y123 w30 h18, Тык ;орг
Gui, 1:Add, CheckBox, x279 y100 w69 h20 vCheck15, 2.12 Капс
Gui, 1:Add, Button, x348 y100 w30 h18, Тык ;Капс
Gui, 1:Add, CheckBox, x170 y145 w146 h20 vCheck16, 2.13 Неадекват`, грубость
Gui, 1:Add, Button, x318 y145 w30 h18 , Тык ;неадекв
Gui, 1:Add, GroupBox, x30 y210 w110 h42, 2.14 Реклама
Gui, 1:Add, CheckBox, x12 y210 w17 h20 vCheck17,
Gui, 1:Add, Button, x143 y210 w30 h18, Тык ;реклама
Gui, 1:Add, CheckBox, x199 y170 w90 h18 vCheck18, 2.15 Дезинфа
Gui, 1:Add, Button, x290 y170 w30 h18 , Тык ;дезинф
Gui, 1:Add, CheckBox, x40 y225 w60 h20 vCheck19, Упомин.
Gui, 1:Add, Button, x104 y225 w30 h18, Тык ;упомин
Gui, 1:Add, CheckBox, x199 y190 w95 h20 vCheck20, 4.4 Конкурс JC
Gui, 1:Add, Button, x295 y190 w30 h18 , Тык ;конкурс
Gui, 1:Add, CheckBox, x180 y210 w105 h20 vCheck21, 1.3 Вред онлайну
Gui, 1:Add, Button, x287 y210 w30 h18 , Тык ;вред
Gui, 1:Add, Button, x505 y29 w40 h25 gTwoGui, Ban ->
Gui, 1:Add, Button, x425 y80 w40 h25 gR, =
Gui, 1:Add, Button, x480 y80 w60 h25 gJb, Жалоба
Gui, 1:Add, GroupBox, x2 y9 w555 h310, Муты
Gui, 1:Show, h572 w562, Menu
Gui, 1:Color, Silver
Gui, 1:Font, cGray
Gui, 1:Font, S9 CDefault, Verdana
Gui, 1:Add, GroupBox, x2 y319 w371 h250 , Команды
Gui, 1:Add, Button, x275 y340 w90 h40 gLobby, Lobby
Gui, 1:Add, Button, x5 y340 w110 h40 gScreen1 , Скрин 1 экрана
Gui, 1:Add, Button, x5 y380 w110 h40 gScreen2, Скрин 2 экрана
Gui, 1:Add, Button, x115 y380 w80 h40 gCheckM, Check mute
Gui, 1:Add, Button, x115 y340 w80 h40 gCheckB, Check ban
Gui, 1:Add, Button, x195 y340 w80 h40 gStaff, Staff
Gui, 1:Add, Button, x275 y380 w90 h40 gHub, Hub
Gui, 1:Add, Button, x195 y380 w80 h40 gSc, Staff CHAT
Gui, 1:Add, Button, x5 y440 w80 h40 gOrg, 2.11 Орг.флуда
Gui, 1:Add, Button, x85 y440 w80 h40 gConk, 4.4 Конкурс
Gui, 1:Add, Button, x5 y480 w80 h40 gCaps, 2.12 Капс
Gui, 1:Add, Button, x85 y480 w80 h40 gFlood, 2.10 Флуд
Gui, 1:Add, Button, x165 y480ф w90 h40 gCapsFlood, Капс+Флуд
Gui, 1:Add, CheckBox, x290 y440 w80 h40 gStaffCheck, Staff
Gui, 1:Add, CheckBox, x290 y470 w80 h40 gVIPCheck, VIP
Gui, 1:Add, CheckBox, x290 y500 w80 h40 gMutesCheck, Mutes
Gui, 1:Add, Button, x5 y520 w80 h40 gMat, 2.7 Мат
Gui, 1:Add, Button, x85 y520 w80 h40 gOsk, 2.8 Оск
Gui, 1:Add, Button, x165 y520 w90 h40 gMatOsk, Мат+Оск
arr := [60, 60, 30, 240, 360, 180, 120, 120, 120, 180, 720, 120, 30, 60, 30, 60, 1440, 60, 360, 60, 120]
reason := ["2.1", "2.2", "2.3", "2.4", "2.5", "2.6", "2.7", "2.8", "2.8", "2.8", "2.8", "2.9", "2.10", "2.11", "2.12", "2.13", "2.14", "2.15", "2.14", "4.4", "1.3"]
Gui, 1:Font, cGray
Gui, 1:Font, S9 CDefault, Verdana
Gui, 1:Add, GroupBox, x382 y319 w177 h250 , Кики/Баны
Gui, 1:Add, GroupBox, x385 y334 w150 h50 , Флуд в репорт
Gui, 1:Add, Button, x395 y354 w50 h24 gNeKick, Кик
Gui, 1:Add, Button, x470 y354 w50 h24 grepNeBan, Бан
Gui, 1:Add, GroupBox, x385 y385 w150 h50 , Дебил в репорте
Gui, 1:Add, Button, x395 y405 w50 h25 gKick, Кик
Gui, 1:Add, Button, x470 y405 w50 h25 gDebBan, Бан
Gui, 1:Add, GroupBox, x385 y435 w150 h50 , Злоуп. Лс
Gui, 1:Add, Button, x395 y455 w50 h25 gZloup, Кик
Gui, 1:Add, Button, x470 y455 w50 h25 gBanZloup, Бан


Gui, 2:Add, Button, x455 y29 w45 h25 gOneGui, <- Mute
Gui, 2:Add, Button, x40 y50 w60 h25 gnick, Тык
Gui, 2:Add, Button, x40 y95 w60 h25 gvred1, Мут
Gui, 2:Add, Button, x120 y95 w60 h25 gvred2, Бан
Gui, 2:Add, Button, x40 y139 w60 h25 gprodaja2, 2h
Gui, 2:Add, Button, x120 y141 w60 h25 gprodaja1, 0s
Gui, 2:Add, Button, x65 y185 w90 h25 gneto4n, Тык
Gui, 2:Add, Button, x65 y230 w90 h25 gpodstava, Тык
Gui, 2:Add, Button, x40 y330 w60 h25 g4iti, Бан
Gui, 2:Add, Button, x120 y330 w60 h25 gne4iti, Xray
Gui, 2:Add, Button, x40 y380 w60 h25 gkick3.2, Кик
Gui, 2:Add, Button, x120 y380 w60 h25 gban3.2, Бан
Gui, 2:Add, Button, x65 y430 w90 h25 gcrossteam, Тык
Gui, 2:Add, Button, x40 y480 w60 h25 gteamgrief, Тык
Gui, 2:Add, Button, x120 y480 w60 h25 gteamgrief2, х2
Gui, 2:Add, Button, x40 y530 w60 h25 gbagouse, Тык
Gui, 2:Add, Button, x120 y530 w60 h25 gbagouse2, Prison
Gui, 2:Add, Button, x245 y330 w90 h25 gincorrpostr, Тык
Gui, 2:Add, Button, x205 y380 w50 h25 gmnogokr, 4
Gui, 2:Add, Button, x262 y380 w50 h25 gmnp6, 6
Gui, 2:Add, Button, x320 y380 w50 h25 gmnp8, 8
Gui, 2:Add, Button, x245 y430 w90 h25 gobxod, Тык
Gui, 2:Add, Button, x215 y480 w60 h25 gauckick, Кик->
Gui, 2:Add, Button, x295 y480 w60 h25 gaucban, Бан
Gui, 2:Add, Button, x215 y530 w60 h25 gbansb, Убийство
Gui, 2:Add, Button, x295 y530 w60 h25 , Ловушка
Gui, 2:Color, Silver
Gui, 2:Font, cGray
Gui, 2:Add, GroupBox, x5 y9 w210 h270, Основные положения
Gui, 2:Add, GroupBox, x20 y35 w100 h45 , 1.2 Некорр. ник
Gui, 2:Add, GroupBox, x20 y80 w175 h45 , 1.3 Причинение вреда проекту
Gui, 2:Add, GroupBox, x20 y125 w175 h45 , 1.5 Продажа за реал
Gui, 2:Add, GroupBox, x20 y170 w175 h45 , 1.6 Исп. Неточностей
Gui, 2:Add, GroupBox, x20 y215 w175 h45 , 1.8 Подстава/проверка персонала
Gui, 2:Add, GroupBox, x5 y295 w553 h275, Правила игрового процесса	
Gui, 2:Add, GroupBox, x20 y315 w175 h45, 3.1 Использование ПО
Gui, 2:Add, GroupBox, x20 y365 w175 h45, 3.2 Некорр скин/плащ
Gui, 2:Add, GroupBox, x20 y415 w175 h45, 3.3 Кросстим
Gui, 2:Add, GroupBox, x20 y465 w175 h45, 3.4 Тимгриф
Gui, 2:Add, GroupBox, x20 y515 w175 h45, 3.5 Багоюз
Gui, 2:Add, GroupBox, x200 y315 w175 h45, 3.6 Некорр. постройки
Gui, 2:Add, GroupBox, x200 y365 w175 h45, 3.7 МНП
Gui, 2:Add, GroupBox, x200 y415 w175 h45, 3.8 Обход наказаний
Gui, 2:Add, GroupBox, x200 y465 w175 h45, 3.9 Засорение аукциона Prison
Gui, 2:Add, GroupBox, x200 y515 w175 h45, Убийство/ловушка на острове
Gui, 2:Add, Button, x505 y29 w50 h25 gGuiThree, Forum ->
Gui, 3:Add, Button, x455 y29 w45 h25 gFourGui, <- Bans

Gui, 3:Font, cGray
Gui, 3:Font, S9 CDefault, Verdana
Gui, 3:Add, GroupBox, x382 y319 w177 h250 , Форум
Gui, 3:Add, Button, x385 y339 w144 h30 gNakazan1, Игрок будет наказан
Gui, 3:Add, Button, x527 y339 w30 h30 gNakazan11, Ы
Gui, 3:Add, Button, x385 y369 w144 h30 gNakazan2, Игрок уже наказан
Gui, 3:Add, Button, x527 y369 w30 h30 gNakazan22, Ы
Gui, 3:Add, Button, x385 y399 w160 h30 gNakazan3, Требуется дата
Gui, 3:Add, Button, x385 y429 w160 h30 gNakazan33, Требуется дата2
Gui, 3:Add, Button, x385 y459 w160 h30 gNakazan4, Скриншот обрезан
Gui, 3:Add, Button, x385 y489 w160 h30 gNakazan5, Ответ дан
Gui, 3:Add, Button, x385 y519 w160 h30 gWablon, Шаблон
Return

}
{ ;commands
Hub:
Gui, 1:Hide
WinActivate Cristalix
SendInput {sc14}
Sleep 60
SendRaw /hub
SendInput {Enter}
return
Lobby:
Gui, 1:Hide
WinActivate Cristalix
SendInput {sc14}
Sleep 60
SendRaw /lobby
SendInput {Enter}
return
Staff:
Gui, 1:Hide
WinActivate Cristalix
SendInput {sc14}
Sleep 60
SendRaw /staff
SendInput {Enter}
return
Sc:
WinActivate Cristalix
SendInput {sc14}
Sleep 60
SendRaw /sc
SendInput {sc39}
return
Screen1:
Gui, 1:Hide
Sleep 60
SendInput, {PrintScreen}
Sleep 400
MouseMove 1919, 1079, 1
Sleep 60
SendInput, {LButton Down}
Sleep 60
MouseMove 0, 0, 1
Sleep 60
SendInput, {LButton Up}
Sleep 60
SendInput {sc1D Down}
Sleep 60
SendInput {sc1F}
Sleep 100
SendInput {sc1D Up}
Sleep 100
MouseMove 1000, 500, 1
return
Screen2:
Gui, 1:Hide
Sleep 60
SendInput, {PrintScreen}
Sleep 400
Sleep 60
MouseMove 2023, 430, 1
Sleep 60
MouseMove 3285, 1069, 1
Sleep 60
SendInput, {LButton Down}
Sleep 60
MouseMove, 1920, 141, 1
Sleep 60
SendInput, {LButton Up}
Sleep 60
SendInput, {sc1D Down}
Sleep 60
SendInput, {sc1F}
Sleep 60
SendInput, {sc1D Up}
Sleep 100
MouseMove 1000, 500, 1
return
CheckM:
WinActivate Cristalix
SendInput {LCtrl Down}
SendInput {Left 3}
sleep 60
SendInput {LCtrl Up}
SendInput /Check mute{sc39}{Enter}
return
CheckB:
WinActivate Cristalix
SendInput {LCtrl Down}
SendInput {Left 3}
sleep 60
SendInput {LCtrl Up}
SendInput /Check ban{sc39}{Enter}
return
StaffCheck:
Gosub % "Key" a := (!a || a = 2) ? 1 : a+1
KeyWait, % A_ThisHotkey
return
Key1:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle sc{Enter}
Sleep, 10
WinActivate, Menu
Return
Key2:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle sc{Enter}
Sleep, 10
WinActivate, Menu
Return
VIPCheck:
Gosub % "Gey" a := (!a || a = 2) ? 1 : a+1
KeyWait, % A_ThisHotkey
return
Gey1:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle vc{Enter}
Sleep, 10
WinActivate, Cristalix
Return
Gey2:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle vc{Enter}
Sleep, 10
WinActivate, Cristalix
Return
MutesCheck:
Gosub % "Vey" a := (!a || a = 2) ? 1 : a+1
KeyWait, % A_ThisHotkey
return
Vey1:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle pt{Enter}
Sleep, 10
WinActivate, Menu
Return
Vey2:
WinActivate, Cristalix
sleep, 10
SendInput, {sc14}
sleep, 60
SendInput, /toggle pt{Enter}
Sleep, 10
WinActivate, Menu
Return
Zloup:
WinActivate Cristalix
SendInput {vk20}
Sleep 60
SendInput Злоупотребление личными сообщениями.
Sleep 60
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
sleep 60
SendInput /Kick{vk20}
sleep 90
SendInput {vkD}
return
Ban:
WinActivate Cristalix
SendInput {sc39}
SendRaw 2h 2.16
SendInput {LCtrl Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {LCtrl Up}
sleep 60
SendInput /Ban{sc39}{Enter}
return
Kick:
WinActivate Cristalix
SendInput {sc39}2.17
SendInput {LCtrl Down}
sleep 60
SendInput {Left 4}
sleep 60
SendInput {LCtrl Up}
sleep 60
SendInput /Kick{sc39}
sleep 60
SendInput, {Enter}
return
NeKick:
WinActivate Cristalix
SendInput, {vk20}
SendRaw, Флуд в репорт.
SendInput, {vkA2 Down}
sleep 60
SendInput, {Left 4}
sleep 60
SendInput, {vkA2 Up}
sleep 60
SendInput, /Kick{vk20}
sleep 90
SendInput, {vkD}
return
repNeBan:
WinActivate Cristalix
SendInput, {vk20}1h{vk20}
SendRaw, Флуд в репорт.
SendInput, {vkA2 Down}
sleep 60
SendInput, {Left 5}
sleep 60
SendInput, {vkA2 Up}
sleep 60
SendInput, /Ban{vk20}
sleep 90
SendInput, {vkD}
return
DebBan:
WinActivate Cristalix
SendInput, {vk20}12h{vk20}2.17
SendInput, {vkA2 Down}
sleep 60
SendInput, {Left 4}
sleep 60
SendInput, {vkA2 Up}
sleep 60
SendInput, /Ban{vk20}
sleep 90
SendInput, {vkD}
return
BanZloup:
WinActivate Cristalix
SendInput {vk20}
Sleep 60
SendInput Злоупотребление личными сообщениями.
Sleep 60
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
sleep 60
SendInput /Ban{vk20}
sleep 90
SendInput {vkD}
return
Nakazan1:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Благодарим за жалобу, игрок будет наказан.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan11:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Благодарим за жалобу, игроки будут наказаны.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan2:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Благодарим за жалобу, игрок уже был наказан.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan22:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Благодарим за жалобу, игроки уже были наказаны.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan3:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Не по форме, на скриншоте нужна системная дата и время.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan33:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Не по форме, на скриншоте нужна системная дата и время.
SendInput, {sc1C}
SendInput, Принимаются доказательства только вот с такими датами на скриншоте:
SendInput, {sc1C}
SendRaw, [IMG]https://i.imgur.com/mVYHvqJ.png[/IMG]
SendInput, {sc1C}
SendRaw, [IMG]https://i.imgur.com/pEGVyXT.png[/IMG]
SendInput, {sc1C}
SendRaw, [IMG]https://i.imgur.com/XQqivGk.png[/IMG]
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return

Nakazan4:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Не по форме, скриншот обрезан или замазан.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Nakazan5:
Gui, 1:Hide
WinActivate chrome.exe
SendRaw, [B][I][COLOR=#336600]Ответ дан.
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
return
Wablon:
Gui, 1:Hide
WinActivate, chrome.exe
SendRaw, [B][I][COLOR=#336600]
SendInput, {sc1C}
SendRaw, Закрыто.[/COLOR][/I][/B]
SendInput, {Up}
return
}
{ ;GUI Ban
nick:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 0s Некорректный ник.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 4}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
vred1:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}2h 1.3
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
SendInput /mute{vk20}
return
vred2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}0s 1.3
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
prodaja1:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}0s 1.5
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
prodaja2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}2h 1.5
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
neto4n:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}7d 1.6
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
podstava:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}7d 1.8
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
4iti:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}0s 3.1
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
ne4iti:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}5d{vk20}
SendRaw, Xray
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
kick3.2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}3.2
SendInput {vkA2 Down}
sleep 60
SendInput {Left 2}
sleep 60
SendInput {vkA2 Up}
SendInput /Kick{vk20}
return
ban3.2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}1d 3.2
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
crossteam:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 1h Кросстим.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
teamgrief:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 1d Тимгриф.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
teamgrief2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 2d Тимгриф.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
bagouse:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 5d Багоюз.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 4}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
bagouse2:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 2d Багоюз.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 4}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
incorrpostr:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 3d Некорректная постройка.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
mnogokr:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 12h 3.7 Многократное нарушение правил.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 6}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
mnp6:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 1d 3.7 Многократное нарушение правил.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 6}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
mnp8:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 2d 3.7 Многократное нарушение правил.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 6}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
obxod:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw, 3d 3.8 Обход наказаний.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
auckick:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}3.9
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Kick{vk20}
return
aucban:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}45m 3.9
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
bansb:
Gui, 2:Hide
WinActivate Cristalix
SendInput {vk20}7d{sc39}
SendRaw, Убийство на острове.
SendInput {vkA2 Down}
sleep 60
SendInput {Left 5}
sleep 60
SendInput {vkA2 Up}
SendInput /Ban{vk20}
return
}
{ ;Gui buttons 
R:
res := 0 
str := "" 
Gui, Submit, NoHide 
Loop 21 {
    if (Check%A_Index%) { 
        res += arr[A_Index] 
        if (!str) { 
            str .= reason[A_Index] 
			} else {
			str .= "+" reason[A_Index] "" 
        }
    }
}
if (str) { 
	res .= "m " str ""
}
Gui, 1:Hide
WinActivate Cristalix
SendInput {vk20}
SendRaw % res
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
sleep 60
SendInput /mute{vk20}
return

Jb:
res := 0 
str := "" 
Gui, Submit, NoHide 
Loop 21 {
    if (Check%A_Index%) { 
        res += arr[A_Index] 
        if (!str) { 
            str .= reason[A_Index] 
			} else {
			str .= "+" reason[A_Index] "" 
        }
    }
}
if (str) { 
	res .= "m " str ""
}
WinActivate Cristalix
SendInput {vk20}
SendRaw % res 
SendRaw (Жалоба)
SendInput {vkA2 Down}
sleep 60
SendInput {Left 3}
sleep 60
SendInput {vkA2 Up}
sleep 60
SendInput /mute{vk20}
return
FourGui:
Gui, 3:Hide
Gui, 2:Show,
WinActivate, Ban
return
GuiThree:
Gui, 2:Hide
Gui, 3:Show, h572 w562, Forum
WinActivate, Forum
return
TwoGui:
Gui, 1:Hide
Gui, 2:Show, h572 w562, Ban
WinActivate, Ban
return
OneGui:
Gui, 2:Hide
Gui, 1:Show,
WinActivate, Menu
return
LCtrl & Alt::
Gui, Show, 
;xCenter - по центру
return
F4::
Reload
return
}
{ ;Fast Mute Numpad etc
^vk4D::
WinActivate, Cristalix
Sleep 60
SendInput, {vkA2 Down}
Sleep 60
SendInput, {Left 1}
Sleep 60
SendInput, {vkA2 Up}
sleep 60
SendRaw, /tp
SendInput, {vk20}
sleep 120
SendInput, {vkD}
return
+PrintScreen::
Gui, 1:Hide
Sleep, 150
SendInput, {PrintScreen}
Sleep, 450
MouseMove, 1919, 1079, 1
Sleep, 60
SendInput, {LButton Down}
Sleep, 150
MouseMove 0, 0, 1
Sleep, 60
SendInput, {LButton Up}
Sleep, 300
Send {vkA2 Down}{vk44}{vkA2 Up}
Sleep, 300
WinActivate, Cristalix
Send, {vk54}
Sleep 60
Send, {vk26}
Sleep 60
Send, {vkA2 Down}
Sleep 120
Send, {vk41}
Sleep 120
Send, {vk43}
Sleep 120
Send, {vkA2 Up}
Sleep, 120
WinActivate, Ban.txt
Sleep, 120
Send, {Enter}
Sleep, 120
SendInput, {vkA2 Down}{vk56}{vkA2 Up}
Sleep, 120
Send, {vk20}
Sleep, 2000
SendInput, {vkA2 Down}{vk56}{vkA2 Up}
WinActivate, Cristalix
SendInput, {vk1B}
MouseMove, 1000, 500, 1
return
^PrintScreen::
Gui, 1:Hide
Sleep 60
SendInput, {PrintScreen}
Sleep 400
Sleep 60
MouseMove 2023, 430, 1
Sleep 60
MouseMove 3285, 1069, 1
Sleep 60
SendInput, {LButton Down}
Sleep 60
MouseMove, 1920, 141, 1
Sleep 60
SendInput, {LButton Up}
Sleep, 300
Send {vkA2 Down}{vk44}{vkA2 Up}
Sleep, 300
WinActivate, Cristalix
Send, {vk54}
Sleep 60
Send, {vk26}
Sleep 60
Send, {vkA2 Down}
Sleep 120
Send, {vk41}
Sleep 120
Send, {vk43}
Sleep 120
Send, {vkA2 Up}
Sleep, 120
WinActivate, Ban.txt
Sleep, 120
Send, {Enter}
Sleep, 120
SendInput, {vkA2 Down}{vk56}{vkA2 Up}
Sleep, 120
Send, {vk20}
Sleep, 2000
SendInput, {vkA2 Down}{vk56}{vkA2 Up}
WinActivate, Cristalix
SendInput, {vk1B}
MouseMove, 1000, 500, 1
return
Numpad6::
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 4h 2.7+2.8
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Numpad3::
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 2h 2.8
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput,{vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
NumpadDot::
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 2h 2.7
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
MatOsk:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 4h 2.7+2.8
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Osk:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 2h 2.8
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput,{vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Mat:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 2h 2.7
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Numpad1::
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 30m 2.10
SendInput {vkA2 Down}
SendInput {Left 3}
Sleep 60
SendInput {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep 120
SendInput, {vkD}
return
Numpad0::
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 1h 2.10+2.12
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep, 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Numpad2::
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 30m 2.12
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep, 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Flood:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 30m 2.10
SendInput {vkA2 Down}
SendInput {Left 3}
Sleep 60
SendInput {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep 120
SendInput, {vkD}
return
Org:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 1h 2.11
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Conk:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 1h 4.4
SendInput, {vkA2 Down}
SendInput, {Left 3}
sleep 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
CapsFlood:
Gui, 1:Hide
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 1h 2.10+2.12
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep, 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
Caps:
WinActivate, Cristalix
SendInput, {vk20}
SendRaw, 30m 2.12
SendInput, {vkA2 Down}
SendInput, {Left 3}
Sleep, 60
SendInput, {vkA2 Up}
SendRaw, /mute
SendInput, {vk20}
Sleep, 120
SendInput, {vkD}
return
}



