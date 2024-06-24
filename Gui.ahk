#Requires AutoHotkey v2
#include MidiLib.ahk

OnMidiInputChange(control, *) {
	selectedText := control.Text
	selectedValue := control.Value
	OpenMidiInput(control.Value - 1)
}

ShowMidiMonitor() {
	midiInputOptions := LoadMidiInputs()
	; Init GUI
	midiMon := Gui(, "MIDI Monitor")
	; Label and dropdown
	midiMon.Add("Text", "X80 Y5", "MIDI Input")
	ddlMidiInput := midiMon.Add("DropDownList", "X40 Y20 W140", midiInputOptions)
	ddlMidiInput.OnEvent("Change", OnMidiInputChange)
	; List views
	listViewStyle := "R11 BackgroundBlack Count10"
	; List view - MIDI input
	midiMon.Add("ListView", listViewStyle . " " . "X5 cAqua", ["EventType", "StatB", "Ch", "Byte1", "Byte2"])
	; List view - output
	lvOut := midiMon.Add("ListView", listViewStyle . " " . "X+5 cYellow", ["Event", "Value"])
	; Set column sizes for the output list view
	lvOut.ModifyCol(1, 105)
	lvOut.ModifyCol(2, 110)
	; Show the GUI
	midiMon.Show("AutoSize xCenter Y5")
}
