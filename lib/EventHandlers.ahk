#Requires AutoHotkey v2.0

; Callback from winmm.dll for any MIDI message
OnMidiData(hInput, midiMessage, *) {
	global currentMidiInputDeviceIndex

	statusByte := midiMessage & 0xFF
	channel := (statusByte & 0x0F) + 1
	byte1 := (midiMessage >> 8) & 0xFF	; Note/CC number
	byte2 := (midiMessage >> 16) & 0xFF	; Note Velocity, or CC value

	description := ""
	if (statusByte >= 128 and statusByte <= 143) {
		description := "NoteOff"
	} else if (statusByte >= 144 and statusByte <= 159) {
		description := "NoteOn"
	} else if (statusByte >= 176 and statusByte <= 191) {
		description := "CC"
	} else if (statusByte >= 224 and statusByte <= 239) {
		description := "PitchBend"
	}

	AppendMidiInputRow(description, statusByte, channel, byte1, byte2)

	if (statusByte >= 128 and statusByte <= 159) { ; Note off/on
		isNoteOn := (statusByte >= 144 and byte2 > 0)
		ProcessNote(currentMidiInputDeviceIndex, channel, byte1, byte2, isNoteOn)
	} else if (statusByte >= 176 and statusByte <= 191) { ; CC
		ProcessCC(currentMidiInputDeviceIndex, channel, byte1, byte2)
	} else if (statusByte >= 192 and statusByte <= 208) { ; PC
		ProcessPC(currentMidiInputDeviceIndex, channel, byte1, byte2)
	} else if (statusByte >= 224 and statusByte <= 239) { ; Pitch bend
		pitchBend := (byte2 << 7) | byte1
		ProcessPitchBend(currentMidiInputDeviceIndex, channel, pitchBend)
	}
}

; Callback for the MIDI input dropdown list
OnMidiInputChange(control, *) {
	deviceIndex := control.Value - 1
	OpenMidiInput(deviceIndex, OnMidiData)
	deviceName := GetMidiDeviceName(deviceIndex)
	WriteConfigMidiDevice(deviceIndex, deviceName)
	AppendMidiOutputRow("Device", deviceName)
}

ToggleShowOnStartup(*) {
	WriteConfigShowOnStartup(!appConfig.showOnStartup)
	A_TrayMenu.ToggleCheck("Show on Startup")
}
