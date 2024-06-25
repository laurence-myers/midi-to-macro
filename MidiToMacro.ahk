#Requires AutoHotkey v2
#SingleInstance
#Warn
Persistent()

#Include Gui.ahk

Main() {
	OnExit(CloseMidiInput)
	A_TrayMenu.Add() ; Add a menu separator line
	A_TrayMenu.Add("MIDI Monitor", ShowMidiMonitor)
	ShowMidiMonitor()
}

Main()
