#Requires AutoHotkey v2
#SingleInstance
#Warn
Persistent()

#Include Gui.ahk

Main() {
	OnExit(CloseMidiInput)
	ShowMidiMonitor()
}

Main()
