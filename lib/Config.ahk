#Requires AutoHotkey v2

global appConfig

configFileName := "MidiToMacro.ini"

Class MidiToMacroConfig {
	__New() {
		this.midiInDevice := unset
	}
}

appConfig := MidiToMacroConfig()

ReadConfig() {
	if (FileExist(configFileName)) {
		midiInDevice := IniRead(configFileName, "Settings", "MidiInDevice", unset)
		appConfig.midiInDevice := midiInDevice
	}
}

WriteConfig(midiInDevice) {
	IniWrite(midiInDevice, configFileName, "Settings", "MidiInDevice")
	appConfig.midiInDevice := midiInDevice
}
