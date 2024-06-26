#Requires AutoHotkey v2

global appConfig

configFileName := "MidiToMacro.ini"

Class MidiToMacroConfig {
	__New() {
		this.midiInDevice := unset
		this.showOnStartup := false
	}
}

appConfig := MidiToMacroConfig()

ReadConfig() {
	if (FileExist(configFileName)) {
		appConfig.midiInDevice := IniRead(configFileName, "Settings", "MidiInDevice", unset)
		appConfig.showOnStartup := IniRead(configFileName, "Settings", "ShowOnStartup", true)
	}
}

WriteConfig(midiInDevice) {
	IniWrite(midiInDevice, configFileName, "Settings", "MidiInDevice")
	appConfig.midiInDevice := midiInDevice
}

WriteConfigShowOnStartup(showOnStartup) {
	IniWrite(showOnStartup, configFileName, "Settings", "ShowOnStartup")
	appConfig.showOnStartup := showOnStartup
}
