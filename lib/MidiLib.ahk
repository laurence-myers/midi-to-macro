#Requires AutoHotkey v2

global currentMidiInputDeviceHandle, currentMidiInputDeviceIndex

CloseMidiInput(*) {
	global currentMidiInputDeviceHandle, currentMidiInputDeviceIndex

	if (IsSet(currentMidiInputDeviceHandle)) {
		DllCall("winmm.dll\midiInReset", "UInt", currentMidiInputDeviceHandle)
		DllCall("winmm.dll\midiInClose", "UInt", currentMidiInputDeviceHandle)
	}
	currentMidiInputDeviceHandle := unset
	currentMidiInputDeviceIndex := unset
}

GetMidiDeviceName(deviceIndex) {
	; TODO: should we be calling the ANSI version directly, or let AHK decide on W vs A?
	; TODO: should we be parsing the port name in UTF-8, or is it some other encoding?
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

OpenMidiInput(midiInputDeviceIndex, onMidiMessageCallback) {
	global currentMidiInputDeviceHandle, currentMidiInputDeviceIndex
	CloseMidiInput()

	CALLBACK_WINDOW := 0x10000
	hMidiIn := Buffer(8)
	result := DllCall("winmm.dll\midiInOpen", "Ptr", hMidiIn, "UInt", midiInputDeviceIndex, "UInt", A_ScriptHwnd, "UInt", 0, "UInt", CALLBACK_WINDOW, "UInt")

	if (result) {
		MsgBox("Failed to call midiInOpen for device ID " . midiInputDeviceIndex)
		Return
	}

	currentMidiInputDeviceHandle := NumGet(hMidiIn, 0, "UInt")
	result := DllCall("winmm.dll\midiInStart", "UInt", currentMidiInputDeviceHandle, "UInt")

	if (result) {
		MsgBox("Failed to call midiInStart for device ID " . midiInputDeviceIndex)
		Return
	}

	OnMessage(0x3C3, onMidiMessageCallback) ; MM_MIM_DATA, https://learn.microsoft.com/en-us/windows/win32/multimedia/mm-mim-data
	
	currentMidiInputDeviceIndex := midiInputDeviceIndex
}
