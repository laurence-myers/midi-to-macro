#Requires AutoHotkey v2

GetMidiDeviceName(deviceIndex) {
	; TODO: should we be calling the ANSI version directly, or let AHK decide on W vs A?
	; TODO: should we parse the port name in UTF-8, or is it some other encoding?
	midiInCapabilitiesSize := 50
	midiInCapabilities := Buffer(midiInCapabilitiesSize)
	result := DllCall("winmm.dll\midiInGetDevCapsA", "UInt", deviceIndex, "Ptr", midiInCapabilities, "UInt", midiInCapabilitiesSize, "UInt")
	; result > 0 is an error
	If (result) {
		return
	}
	; Copy the device name out of the capabilities binary struct
	portName := StrGet(midiInCapabilities.Ptr + 8, "UTF-8")
	return portName
}

LoadMidiInputs() {
	midiInputs := Array()
	numPorts := DllCall("winmm.dll\midiInGetNumDevs")

	Loop numPorts {
		portName := GetMidiDeviceName(A_Index - 1)
		if (portName) {
			midiInputs.Push(portName)
		}
	}

	return midiInputs
}

OnMidiData(hInput, midiMsg, wMsg, hWnd) {
	ListVars()
}

OpenMidiInput(midiInputDeviceId) {
	CALLBACK_WINDOW := 0x10000

	numPorts := DllCall("winmm.dll\midiInGetNumDevs")

	hMidiIn := Buffer(8)
	result := DllCall("winmm.dll\midiInOpen", "Ptr", hMidiIn, "UInt", midiInputDeviceId, "UInt", A_ScriptHwnd, "UInt", 0, "UInt", CALLBACK_WINDOW, "UInt")

	if (result) {
		MsgBox("Failed to call midiInOpen for device ID " . midiInputDeviceId)
		Return
	}

	result := DllCall("winmm.dll\midiInStart", "UInt", NumGet(hMidiIn, 0, "UInt"), "UInt")

	if (result) {
		MsgBox("Failed to call midiInStart for device ID " . midiInputDeviceId)
		Return
	}

	OnMessage(0x3C3, OnMidiData) ; MM_MIM_DATA, https://learn.microsoft.com/en-us/windows/win32/multimedia/mm-mim-data
}
