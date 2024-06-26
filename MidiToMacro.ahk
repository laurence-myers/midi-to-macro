#Requires AutoHotkey v2
#SingleInstance
#Warn
Persistent()

#Include lib\Config.ahk
#Include lib\Gui.ahk

Main() {
	global appConfig, currentMidiInputDeviceIndex
	OnExit(CloseMidiInput)
	A_TrayMenu.Add() ; Add a menu separator line
	A_TrayMenu.Add("Show on Startup", ToggleShowOnStartup)
	A_TrayMenu.Add("MIDI Monitor", ShowMidiMonitor)
	ReadConfig()
	if (HasProp(appConfig, "midiInDevice")) {
		; TODO: store last MIDI device name. If name changed, don't try opening or selecting the device.
		OpenMidiInput(appConfig.midiInDevice, OnMidiData)
	}
	if (appConfig.showOnStartup) {
		A_TrayMenu.Check("Show on Startup")
		ShowMidiMonitor()
	} else {
		A_TrayMenu.Uncheck("Show on Startup")
	}
}

Main()
