#Requires AutoHotkey v2
#include CommonFunctions.ahk
#include MidiLib.ahk
#include ..\MidiRules.ahk
#include EventHandlers.ahk

global lvInEvents, lvOutEvents, midiMonitor

; Adds a row to the MIDI input log
AppendMidiInputRow(description, statusByte, channel, byte1, byte2) {
	if (!IsSet(midiMonitor)) {
		return
	}
	global lvInEvents
	AppendRow(lvInEvents, statusByte, channel, byte1, byte2)
}

; Adds a row to the MIDI output log
AppendMidiOutputRow(description, value) {
	if (!IsSet(midiMonitor)) {
		return
	}
	global lvOutEvents
	AppendRow(lvOutEvents, description, value)
}

; Generic base function to append a row to a list view
AppendRow(listView, values*) {
	global appConfig
	listView.Add("", values*)
	if (listView.GetCount() > appConfig.maxLogLines) {
		listView.Delete(1)
	}
}

; Alias, for backwards compatibility
DisplayOutput(event, value) {
	AppendMidiOutputRow(event, value)
}

; Entry point
ShowMidiMonitor(*) {
	global lvInEvents, lvOutEvents, midiMonitor

	if (IsSet(midiMonitor)) {
		midiMonitor.Show()
		return
	}

	midiInputOptions := LoadMidiInputs()
	; Init GUI
	midiMonitor := Gui(, "MIDI Monitor")
	; Label and dropdown
	midiMonitor.Add("Text", "X80 Y5", "MIDI Input")
	ddlMidiInput := midiMonitor.Add("DropDownList", "X40 Y20 W140", midiInputOptions)
	if (IsSet(currentMidiInputDeviceIndex)) {
		ddlMidiInput.Value := currentMidiInputDeviceIndex + 1
	}
	ddlMidiInput.OnEvent("Change", OnMidiInputChange)
	; List views
	listViewStyle := "W220 R11 BackgroundBlack Count10"
	; List view - MIDI input
	lvInEvents := midiMonitor.Add("ListView", listViewStyle . " " . "X5 cAqua", ["EventType", "StatB", "Ch", "Byte1", "Byte2"])
	Loop lvInEvents.GetCount("Column") {
		lvInEvents.ModifyCol(A_Index, "Center")
	}
	; List view - output
	lvOutEvents := midiMonitor.Add("ListView", listViewStyle . " " . "X+5 cYellow", ["Event", "Value"])
	Loop lvOutEvents.GetCount("Column") {
		lvOutEvents.ModifyCol(A_Index, "Center")
	}
	; Set column sizes for the output list view
	lvOutEvents.ModifyCol(1, 105)
	lvOutEvents.ModifyCol(2, 110)
	; Show the GUI
	midiMonitor.Show("AutoSize xCenter Y5")
}
