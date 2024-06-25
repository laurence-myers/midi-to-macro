#Requires AutoHotkey v2
#include CommonFunctions.ahk
#include MidiLib.ahk
#include MidiRules.ahk

global midiMonitor, lvInEvents, lvOutEvents

; Adds a row to the MIDI input log
AppendMidiInputRow(description, statusByte, channel, byte1, byte2) {
	global midiMonitor, lvInEvents
	lvInEvents.Add("", description, statusByte, channel, byte1, byte2)
	if (lvInEvents.GetCount() > 10) {
		lvInEvents.Delete(1)
	}
	Loop lvInEvents.GetCount("Column") {
		lvInEvents.ModifyCol(A_Index, "Center")
	}
}

; Adds a row to the MIDI output log
AppendMidiOutputRow(description, value) {
	global midiMonitor, lvOutEvents
	lvOutEvents.Add("", description, value)
	if (lvOutEvents.GetCount() > 10) {
		lvOutEvents.Delete(1)
	}
	Loop lvOutEvents.GetCount("Column") {
		lvOutEvents.ModifyCol(A_Index, "Center")
	}
}

; Alias, for backwards compatibility
DisplayOutput(event, value) {
	AppendMidiOutputRow(event, value)
}

; Callback from winmm.dll for any MIDI message
OnMidiData(hInput, midiMessage, *) {
	statusByte := midiMessage & 0xFF
	channel := (statusByte & 0x0f) + 1
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
		ProcessNote(channel, byte1, byte2, isNoteOn)
	} else if (statusByte >= 176 and statusByte <= 191) { ; CC
		ProcessCC(channel, byte1, byte2)
	} else if (statusByte >= 192 and statusByte <= 208) { ; PC
		ProcessPC(channel, byte1, byte2)
	} else if (statusByte >= 224 and statusByte <= 239) { ; Pitch bend
		pitchBend := (byte2 << 7) | byte1
		ProcessPitchBend(channel, pitchBend)
	}
}

; Callback for the MIDI input dropdown list
OnMidiInputChange(control, *) {
	OpenMidiInput(control.Value - 1, OnMidiData)
}

; Entry point
ShowMidiMonitor() {
	global midiMonitor, lvInEvents, lvOutEvents
	midiInputOptions := LoadMidiInputs()
	; Init GUI
	midiMonitor := Gui(, "MIDI Monitor")
	; Label and dropdown
	midiMonitor.Add("Text", "X80 Y5", "MIDI Input")
	ddlMidiInput := midiMonitor.Add("DropDownList", "X40 Y20 W140", midiInputOptions)
	ddlMidiInput.OnEvent("Change", OnMidiInputChange)
	; List views
	listViewStyle := "R11 BackgroundBlack Count10"
	; List view - MIDI input
	lvInEvents := midiMonitor.Add("ListView", listViewStyle . " " . "X5 cAqua", ["EventType", "StatB", "Ch", "Byte1", "Byte2"])
	; List view - output
	lvOutEvents := midiMonitor.Add("ListView", listViewStyle . " " . "X+5 cYellow", ["Event", "Value"])
	; Set column sizes for the output list view
	lvOutEvents.ModifyCol(1, 105)
	lvOutEvents.ModifyCol(2, 110)
	; Show the GUI
	midiMonitor.Show("AutoSize xCenter Y5")
}
