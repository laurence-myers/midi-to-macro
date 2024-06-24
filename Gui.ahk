#Requires AutoHotkey v2
#include MidiLib.ahk

global midiMonitor, lvInEvents

OnMidiData(hInput, midiMessage, *) {
	global midiMonitor, lvInEvents
	statusByte := midiMessage & 0xFF
    channel := (statusByte & 0x0f) + 1
    byte1 := (midiMessage >> 8) & 0xFF	; Note/CC number
    byte2 := (midiMessage >> 16) & 0xFF	; Note Velocity, or CC value

	description := ""
	if statusByte >= 176 and statusByte <= 191
		description := "CC"
	if statusByte >= 144 and statusByte <= 159 
		description := "NoteOn"
	if statusByte >= 128 and statusByte <= 143 
		description := "NoteOff"
	if statusByte >= 224 and statusByte <= 239
		description := "PitchBend"

	lvInEvents.Add("", description, statusByte, channel, byte1, byte2)
	if (lvInEvents.GetCount() > 10) {
		lvInEvents.Delete(1)
	}
	Loop lvInEvents.GetCount("Column") {
		lvInEvents.ModifyCol(A_Index, "Center")
	}
}

OnMidiInputChange(control, *) {
	selectedText := control.Text
	selectedValue := control.Value
	OpenMidiInput(control.Value - 1, OnMidiData)
}

ShowMidiMonitor() {
	global midiMonitor, lvInEvents
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
