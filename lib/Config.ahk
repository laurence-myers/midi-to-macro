#Requires AutoHotkey v2

global appConfig

configFileName := "MidiToMacro.ini"

Class MidiToMacroConfig {
	__New() {
		this.maxLogLines := 10
		this.midiInDevice := -1
		this.midiInDeviceName := ""
		this.showOnStartup := true
	}
}

appConfig := MidiToMacroConfig()

ReadConfig() {
	if (FileExist(configFileName)) {
		appConfig.maxLogLines := IniRead(configFileName, "Settings", "MaxLogLines", 10)
		appConfig.midiInDevice := IniRead(configFileName, "Settings", "MidiInDevice", -1)
		appConfig.midiInDeviceName := IniRead(configFileName, "Settings", "MidiInDeviceName", "")
		appConfig.showOnStartup := IniRead(configFileName, "Settings", "ShowOnStartup", true)
	}
}

WriteConfigMidiDevice(midiInDevice, midiInDeviceName) {
	IniWrite(midiInDevice, configFileName, "Settings", "MidiInDevice")
	IniWrite(midiInDeviceName, configFileName, "Settings", "MidiInDeviceName")
	appConfig.midiInDevice := midiInDevice
	appConfig.midiInDeviceName := midiInDeviceName
}

WriteConfigShowOnStartup(showOnStartup) {
	IniWrite(showOnStartup, configFileName, "Settings", "ShowOnStartup")
	appConfig.showOnStartup := showOnStartup
}
