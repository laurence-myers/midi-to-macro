#Requires AutoHotkey v2
#SingleInstance
#Warn
Persistent()

#Include Gui.ahk

MidiMain() {
	CALLBACK_WINDOW := 0x10000

  numPorts := DllCall("winmm.dll\midiInGetNumDevs")

  Loop numPorts {
		hMidiIn := Buffer(8)
		midiDeviceID := A_Index - 1

		result := DllCall("winmm.dll\midiInOpen", "Ptr", hMidiIn, "UInt", midiDeviceID, "UInt", A_ScriptHwnd, "UInt", 0, "UInt", CALLBACK_WINDOW, "UInt")

		if (result) {
			MsgBox("Failed to call midiInOpen for device ID " . midiDeviceID)
			Return
		}

		result := DllCall("winmm.dll\midiInStart", "UInt", NumGet(hMidiIn, 0, "UInt"), "UInt")

		if (result) {
			MsgBox("Failed to call midiInStart for device ID " . midiDeviceID)
			Return
		}
  }

  OnMessage(0x3C3, OnMidiData) ; MM_MIM_DATA, https://learn.microsoft.com/en-us/windows/win32/multimedia/mm-mim-data
}

OnMidiData(hInput, midiMsg, wMsg, hWnd) {

}

Main() {
	ShowMidiMonitor()
}

Main()