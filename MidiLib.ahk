#Requires AutoHotkey v2

LoadMidiInputs() {
	midiInCapabilitiesSize := 50
	midiInCapabilities := Buffer(midiInCapabilitiesSize)
	portNameSize := 64
	portNameBuffer := Buffer(portNameSize)
	midiInputs := Array()

	numPorts := DllCall("winmm.dll\midiInGetNumDevs")

	; TODO: should we be calling the ANSI version directly, or let AHK decide on W vs A?
	; TODO: should we parse the port name in UTF-8, or is it some other encoding?
	Loop numPorts {
		result := DllCall("winmm.dll\midiInGetDevCapsA", "UInt", A_Index - 1, "Ptr", midiInCapabilities, "UInt", midiInCapabilitiesSize, "UInt")
		; result > 0 is an error
		If (result) {
			Continue
		}
		; Copy the device name out of the capabilities binary structs
		DllCall("RtlMoveMemory", "Ptr", portNameBuffer, "Ptr", midiInCapabilities.Ptr + 8, "UInt", portNameSize)
		; Convert the device name buffer to a string
		portName := StrGet(portNameBuffer, "UTF-8")
		midiInputs.Push(portName)
	}

	return midiInputs
}