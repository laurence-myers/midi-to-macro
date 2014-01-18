; VJoy_Test.ahk

#include %A_ScriptDir%\VJoy_lib.ahk

    VJoy_Init()
    nButtons := VJoy_GetVJDButtonNumber(iInterface)

    cbtn := 1

    StatStr :=  (status = VJD_STAT_OWN) ? "OWN" : "FREE" ; only FREE state required.

    AxisMax_X  := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_X)
    AxisMax_Y  := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_Y)
    AxisMax_Z  := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_Z)
    AxisMax_RX := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_RX)
    AxisMax_RY := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_RY)
    AxisMax_RZ := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_RZ)
    AxisMax_SL0 := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_SL0)
    AxisMax_SL1 := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_SL1)
    AxisMax_WHL := VJoy_GetVJDAxisMax(iInterface, HID_USAGE_WHL)

    ; build gui
    Gui, Add, Text, w80 , Status: %StatStr%
    Gui, add, Button, x100 y5 Default gBtnReset, Re&set
    Gui, add, Button, x150 y5 gBtnReload, &Reload
    Gui, add, Button, x200 y5 gBtnjoycpl, Open &cpl
    Gui, Add, Text,  x10, %nButtons% Buttons supported
    Gui, Add, Button, x140 y30 gBtnTestAllON, Test all On
    Gui, Add, Button, x210 y30 gBtnTestAllOFF, Off

    Loop, %nButtons%
    {
        bX := ((Mod((A_Index-1), 8)) * 30 )  + 10
        bY := FLOOR((A_Index-1) / 8) * 24 + 70
        Gui, add, Button, h5 x%bx% y%by% gBtn%A_Index%, %A_Index%
    }

    nexty := 180
    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_X)) {
        Gui, Add, Text,   x10 w130  y%nexty%, Axis X: 0 / %AxisMax_X%
        Gui, Add, Slider, x140 y%nexty% vAxisX gSliderXChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_Y)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Axis Y: 0 / %AxisMax_Y%
        Gui, Add, Slider, x140 y%nexty% vAxisY gSliderYChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_Z)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Axis Z: 0 / %AxisMax_Z%
        Gui, Add, Slider, x140 y%nexty% vAxisZ gSliderZChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_RX)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Axis RX: 0 / %AxisMax_RX%
        Gui, Add, Slider, x140 y%nexty%  vAxisRX gSliderRXChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_RY)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Axis RY: 0 / %AxisMax_RY%
        Gui, Add, Slider, x140 y%nexty%  vAxisRY gSliderRYChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_RZ)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Axis RZ: 0 / %AxisMax_RZ%
        Gui, Add, Slider, x140 y%nexty%  vAxisRZ gSliderRZChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_SL0)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Slider0: 0 / %AxisMax_SL0%
        Gui, Add, Slider, x140 y%nexty%  vAxisSL0 gSliderSL0Changed
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_SL1)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Slider1: 0 / %AxisMax_SL1%
        Gui, Add, Slider, x140 y%nexty%  vAxisSL1 gSliderSL1Changed
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (VJoy_GetVJDAxisExist(iInterface,  HID_USAGE_WHL)) {
        Gui, Add, Text,   x10 w130 y%nexty%, Wheel: 0 / %AxisMax_WHL%
        Gui, Add, Slider, x140 y%nexty%  vAxisWHL gSliderWHLChanged
        nexty += 40
    } else {
        Gui, Add, Text, x0 y0
    }

    if (ContPovNumber) {
        Gui, Add, Text, x10 y%nexty%,Number of Continuous POVs: %ContPovNumber%
        nexty += 20
        Gui, Add, Text,    x10  y%nexty%, Continuous Pov test
        Gui, Add, Slider,  x140 y%nexty% vPovValSlider gSliderContPov
        nexty+=40
        Gui, Add, Edit,    x10 w80 y%nexty% vPovValDirect gEditContPov, -1
        Loop, %ContPovNumber%
        {
            _contpov_listing := % _contpov_listing . A_Index
            if (A_Index < ContPovNumber) {
                _contpov_listing := % _contpov_listing . "|"
            }
        }
        Gui, Add, ListBox, x140 w40 y%nexty% vContPovChoice gContPovChoose, %_contpov_listing%
        nexty += 30
    }

    if (DiscPovNumber) {
        Gui, Add, Text, x10 y%nexty%,Number of Descrete POVs: %DiscPovNumber%
        nexty += 20

        tmpy := nexty
        Gui, Add, Button, x160 y%tmpy% gBtnPovN, N
        tmpy := nexty + 30
        Gui, Add, Button, x155 y%tmpy% gBtnPovNeu, Neu
        tmpy := nexty + 60
        Gui, Add, Button, x160 y%tmpy% gBtnPovS, S
        tmpy := nexty + 30
        Gui, Add, Button, x120 y%tmpy% gBtnPovW, W
        Gui, Add, Button, x200 y%tmpy% gBtnPovE, E

        Loop, %DiscPovNumber%
        {
            _contpov_listing := % _contpov_listing . A_Index
            if (A_Index < DiscPovNumber) {
                _contpov_listing := % _contpov_listing . "|"
            }
        }
        Gui, Add, ListBox, x10 w40 y%nexty% vDiscPovChoice gDiscPovChoose, %_contpov_listing%

        nexty += 100
    }
    GetKeyState, _JoyStat, JoyInfo
    Gui, Add, Text, x10 y%nexty%, JoyInfo: %_JoyStat%
    Gui, Show

return

SliderXChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_X * AxisX / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_X)
    ControlSetText, Static3, Axis X %tmp_axis_val% / %AxisMax_X%
return

SliderYChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_Y * AxisY / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_Y)
    ControlSetText, Static4, Axis Y %tmp_axis_val% / %AxisMax_Y%
return

SliderZChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_Z * AxisZ / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_Z)
    ControlSetText, Static5, Axis Z %tmp_axis_val% / %AxisMax_Z%
return

SliderRXChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_RX * AxisRX / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_RX)
    ControlSetText, Static6, Axis RX %tmp_axis_val% / %AxisMax_RX%
return

SliderRYChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_RY * AxisRY / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_RY)
    ControlSetText, Static7, Axis RY %tmp_axis_val% / %AxisMax_RY%
return

SliderRZChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_RZ * AxisRZ / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_RZ)
    ControlSetText, Static8, Axis RZ %tmp_axis_val% / %AxisMax_RZ%
return

SliderSL0Changed:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_SL0 * AxisSL0 / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_SL0)
    ControlSetText, Static9, Slider0 %tmp_axis_val% / %AxisMax_SL0%
return

SliderSL1Changed:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_SL1 * AxisSL1 / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_SL1)
    ControlSetText, Static10, Slider1 %tmp_axis_val% / %AxisMax_SL1%
return

SliderWHLChanged:
    Gui, Submit, NoHide
    tmp_axis_val := Floor(AxisMax_WHL * AxisWHL / 100)
    VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_WHL)
    ControlSetText, Static11, Wheel %tmp_axis_val% / %AxisMax_WHL%
return

BtnReload:
F12::
    VJoy_Close(iInterface)
    Reload
return

;GuiClose:
;    ExitApp
;return

OnExit:
    VJoy_Close(iInterface)
return

; GUIBtn test all buttons
BtnTestAllON:
    Loop, %nButtons%
    {
        VJoy_SetBtn(1, iInterface, A_Index)
    }
return
BtnTestAllOFF:
    Loop, %nButtons%
    {
        VJoy_SetBtn(0, iInterface, A_Index)
    }
return

BtnTest(id, btn) {
    VJoy_SetBtn(1, id, btn)
    Sleep, 100
    VJoy_SetBtn(0, id, btn)    ; Release button 1
}

; GUIBtn1 for test button1
Btn1:
    BtnTest(iInterface, 1)
return
Btn2:
    BtnTest(iInterface, 2)
return
Btn3:
    BtnTest(iInterface, 3)
return
Btn4:
    BtnTest(iInterface, 4)
return
Btn5:
    BtnTest(iInterface, 5)
return
Btn6:
    BtnTest(iInterface, 6)
return
Btn7:
    BtnTest(iInterface, 7)
return
Btn8:
    BtnTest(iInterface, 8)
return
Btn9:
    BtnTest(iInterface, 9)
return
Btn10:
    BtnTest(iInterface, 10)
return
Btn11:
    BtnTest(iInterface, 11)
return
Btn12:
    BtnTest(iInterface, 12)
return
Btn13:
    BtnTest(iInterface, 13)
return
Btn14:
    BtnTest(iInterface, 14)
return
Btn15:
    BtnTest(iInterface, 15)
return
Btn16:
    BtnTest(iInterface, 16)
return
Btn17:
    BtnTest(iInterface, 17)
return
Btn18:
    BtnTest(iInterface, 18)
return
Btn19:
    BtnTest(iInterface, 19)
return
Btn20:
    BtnTest(iInterface, 20)
return
Btn21:
    BtnTest(iInterface, 21)
return
Btn22:
    BtnTest(iInterface, 22)
return
Btn23:
    BtnTest(iInterface, 23)
return
Btn24:
    BtnTest(iInterface, 24)
return
Btn25:
    BtnTest(iInterface, 25)
return
Btn26:
    BtnTest(iInterface, 26)
return
Btn27:
    BtnTest(iInterface, 27)
return
Btn28:
    BtnTest(iInterface, 28)
return
Btn29:
    BtnTest(iInterface, 29)
return
Btn30:
    BtnTest(iInterface, 30)
return
Btn31:
    BtnTest(iInterface, 31)
return
Btn32:
    BtnTest(iInterface, 32)
return

; Open Game Control Panel
Btnjoycpl:
    RunWait %ComSpec% /C start joy.cpl,, Hide
return

BtnReset:
    AxisX := AxisY := AxisZ := AxisRX := AxisRY := AxisRZ := Slider0 := Slider1 := 0
    Gui, Submit, NoHide

    VJoy_Close(iInterface)
    VJoy_Init()
return

EditContPov:
    Gui, Submit, NoHide

    GuiControlGet, ContPovChoice
    if (ContPovChoice < 1 or ContPovChoice > ContPovNumber) {
        MsgBox, Please select a pov
        return
    }

    if (PovValDirect < -1) {
        PovValDirect := -1
        Gui, Submit, NoHide
        return
    }
    if (PovValDirect > 35999) {
        PovValDirect := 35999
        Gui, Submit, NoHide
        return
    }
    VJoy_SetContPov(PovValDirect, iInterface, ContPovChoice)
return

SliderContPov:
    Gui, Submit, NoHide
    GuiControlGet, ContPovChoice
    if (ContPovChoice < 1 or ContPovChoice > ContPovNumber) {
        MsgBox, Please select a pov
        return
    }
    PovValDirect := Floor(35999 * PovValSlider / 100)
    ControlSetText, Edit1, %PovValDirect%
    VJoy_SetContPov(PovValDirect, iInterface, ContPovChoice)
return

ContPovChoose:
    Gui, Submit, NoHide
    GuiControlGet, ContPovChoice
return

BtnPovNeu:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
    if (DiscPovChoice < 1 or DiscPovChoice > DiscPovNumber) {
        MsgBox, Please select a pov
        return
    }
    VJoy_SetDiscPov(-1, iInterface, DiscPovChoice)
return

BtnPovN:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
    if (DiscPovChoice < 1 or DiscPovChoice > DiscPovNumber) {
        MsgBox, Please select a pov
        return
    }
    VJoy_SetDiscPov(0, iInterface, DiscPovChoice)
return

BtnPovE:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
    if (DiscPovChoice < 1 or DiscPovChoice > DiscPovNumber) {
        MsgBox, Please select a pov
        return
    }
    VJoy_SetDiscPov(1, iInterface, DiscPovChoice)
return

BtnPovS:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
    if (DiscPovChoice < 1 or DiscPovChoice > DiscPovNumber) {
        MsgBox, Please select a pov
        return
    }
    VJoy_SetDiscPov(2, iInterface, DiscPovChoice)
return

BtnPovW:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
    if (DiscPovChoice < 1 or DiscPovChoice > DiscPovNumber) {
        MsgBox, Please select a pov
        return
    }
    VJoy_SetDiscPov(3, iInterface, DiscPovChoice)
return

DiscPovChoose:
    Gui, Submit, NoHide
    GuiControlGet, DiscPovChoice
return