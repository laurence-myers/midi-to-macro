#Requires AutoHotkey v2
#SingleInstance
#Warn
Persistent()

#Include Config.ahk
#Include Gui.ahk

Main() {
	global appConfig, currentMidiInputDeviceIndex
	OnExit(CloseMidiInput)
	A_TrayMenu.Add() ; Add a menu separator line
	A_TrayMenu.Add("MIDI Monitor", ShowMidiMonitor)
	ReadConfig()
	if (HasProp(appConfig, "midiInDevice")) {
		currentMidiInputDeviceIndex := appConfig.midiInDevice
	}
	ShowMidiMonitor()
}

Main()
