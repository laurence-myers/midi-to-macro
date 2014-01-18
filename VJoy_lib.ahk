;VJoy_lib.ahk

    iInterface = 2							; Default target vJoy device

    ; ported from VjdStat in vjoyinterface.h
    VJD_STAT_OWN := 0   ; The  vJoy Device is owned by this application.
    VJD_STAT_FREE := 1  ; The  vJoy Device is NOT owned by any application (including this one).
    VJD_STAT_BUSY := 2  ; The  vJoy Device is owned by another application. It cannot be acquired by this application.
    VJD_STAT_MISS := 3  ; The  vJoy Device is missing. It either does not exist or the driver is down.
    VJD_STAT_UNKN := 4  ; Unknown

    ;HID Descriptor definitions(ported from public.h
    HID_USAGE_X		:= 0x30
    HID_USAGE_Y		:= 0x31
    HID_USAGE_Z		:= 0x32
    HID_USAGE_RX	:= 0x33
    HID_USAGE_RY	:= 0x34
    HID_USAGE_RZ	:= 0x35
    HID_USAGE_SL0	:= 0x36
    HID_USAGE_SL1	:= 0x37
    HID_USAGE_WHL	:= 0x38
    HID_USAGE_POV	:= 0x39

VJoy_init() {
    Global iInterface, VJD_STAT_OWN, VJD_STAT_FREE, VJD_STAT_BUSY, VJD_STAT_MISS, VJD_STAT_UNKN, ContPovNumber, DiscPovNumber, hDLL

    SetWorkingDir, %A_ScriptDir%
    curdir:=A_WorkingDir

    if (!hDLL) {
        dllpath = %A_ScriptDir%\vJoyInterface.dll
        hDLL := DLLCall("LoadLibrary", "Str", dllpath)
        if (!hDLL) {
            MsgBox, LoadLibrary %dllpath% fail
        }
    }

    result := DllCall("vJoyInterface.dll\vJoyEnabled", "Int")
    if (ErrorLevel = 4) {
        MsgBox, Error! VJoy library "vJoyInterface.dll" is not found!`nErrorLevel:%ErrorLevel%
        ExitApp
    }
    if (!result) {
        MsgBox, Error! VJoy interface is not installed!`nErrorLevel:%ErrorLevel%
        ExitApp
    }

    status := DllCall("vJoyInterface\GetVJDStatus", "Int", iInterface)
	if (status = VJD_STAT_OWN)	{
		ToolTip, vJoy Device %iInterface% is already owned by this feeder
	} else if (status = VJD_STAT_FREE) {
		ToolTip, vJoy Device %iInterface% is free
	} else if (status = VJD_STAT_BUSY) {
		MsgBox vJoy Device %iInterface% is already owned by another feeder`nCannot continue`n
        ExitApp
	} else if (status = VJD_STAT_MISS) {
        MsgBox vJoy Device %iInterface% is not installed or disabled`nCannot continue`n
        ExitApp
    } else {
        MsgBox vJoy Device %iInterface% general error`nCannot continue`n
        ExitApp
    }
    Sleep, 50
    ToolTip

    ; Get the number of buttons and POV Hat switchessupported by this vJoy device
    ContPovNumber := DllCall("vJoyInterface\GetVJDContPovNumber", "UInt", iInterface, "Int")
    DiscPovNumber := DllCall("vJoyInterface\GetVJDDiscPovNumber", "UInt", iInterface, "Int")

    ; Acquire the target device
    if (status = VJD_STAT_FREE) {
        ac_jvd := VJoy_AcquireVJD(iInterface)
    }
    if ((status = VJD_STAT_OWN) || ((status = VJD_STAT_FREE) && (!ac_jvd))) {
        MsgBox % "Failed to acquire vJoy device number % iInterface "
        ExitApp
    } else {
        ToolTip, Acquired: vJoy device number %iInterface%
    }
    Sleep, 50
    ToolTip

   VJoy_ResetVJD(iInterface)

;    VJoy_RelinquishVJD(iInterface)

    return
}

VJoy_AcquireVJD(id) {
    return DllCall("vJoyInterface\AcquireVJD", "UInt", id)
}


VJoy_GetVJDStatus(id) {
    status := DllCall("vJoyInterface\GetVJDStatus", "UInt", id)
    return status
}

VJoy_GetVJDButtonNumber(id) {
    res := DllCall("vJoyInterface\GetVJDButtonNumber", "Int", id)
    return res
}

VJoy_SetBtn(sw, id, btn_id) {
    res := DllCall("vJoyInterface\SetBtn", "Int", sw, "UInt", id, "UChar", btn_id)
    if (!res) {
        MsgBox, SetBtn(%sw%, %id%, %btn_id%) err: %ErrorLevel%`nnLastError: %A_LastError%
    }
    return res
}

VJoy_ResetAll() {
    res := DllCall("vJoyInterface\ResetAll")
    return res
}

VJoy_ResetVJD(id) {
    res := DllCall("vJoyInterface\ResetVJD", "UInt", id)
    return res
}

VJoy_GetVJDAxisMax(id, usage) {
    res := DllCall("vJoyInterface\GetVJDAxisMax", "Int", id, "Int", usage, "IntP", Max_Axis)
    return Max_Axis
}

VJoy_GetVJDAxisExist(id, usage) {
    Axis_t := DllCall("vJoyInterface\GetVJDAxisExist", "UInt", id, "UInt", usage)
    if (!Axis_t) {
;       MsgBox, GetVJDAxisExist Error!`nErrorLevel:%ErrorLevel%
    }
    if (ErrorLevel) {
        ToolTip, GetVJDAxisExist Warning!`nErrorLevel:%ErrorLevel%
        ToolTip
    }
    return Axis_t
}

VJoy_SetAxis(axis_val, id, usage) {
    res := DllCall("vJoyInterface\SetAxis", "Int", axis_val, "UInt", id, "UInt", usage)
    if (!res) {
        MsgBox, SetAxis Error!`nErrorLevel:%ErrorLevel%
    }
    return res
}

VJoy_RelinquishVJD(id) {
    DllCall("vJoyInterface\RelinquishVJD", "UInt", id)
}

VJoy_Close(id) {
    VJoy_ResetAll()
    VJoy_RelinquishVJD(id)
    if (hDLL) {
        DLLCall("FreeLibraly", "Ptr", hDLL)
        hDLL:=
    }
}

VJoy_SetDiscPov(Value, id, nPov) {
    _res := DllCall("vJoyInterface\SetDiscPov", "Int", Value, "UInt", id, "UChar", nPov)
    if (!_res) {
        MsgBox, SetDiscPov err: %ErrorLevel%
    }
    return _ef_res
}

VJoy_SetContPov(Value, id, nPov) {
    _res := DllCall("vJoyInterface\SetContPov", "Int", Value, "UInt", id, "UChar", nPov)
    if (!_res) {
        MsgBox, SetContPov err: %ErrorLevel%
    }
    return _ef_res
}