# MidiToMacro

This is an AutoHotKey script for Windows, to map MIDI input values to hotkeys or macros.

You can use this script to bind CC messages to media keys (play/pause/next), volume sliders, or unusual keyboard combinations (ctrl+shift+alt+F13) which you can assign in programs like StreamLabs OBS.

It's cobbled together from scripts found on the AHK forums. It originally supported mapping MIDI inputs to a virtual joystick using vJoy, and to MIDI outputs; this functionality has been removed. All credit goes to the original authors.

## Running

Double click on `MidiToMacro.ahk`.

To launch the program when Windows starts, you can add a shortcut to the file in your Start Menu\Startup folder.

The first time you launch the script, you will be prompted to choose a MIDI input device. If you need to change it later, you can right click on the system tray icon and click `MidiSet`. Or, you can open the `MidiMon`, and change the input in the "Midi Input" dropdown menu; the script will automatically reload.

To see a log of recent MIDI input messages and any output events, right click on the system tray icon and click `MidiMon`. You can close this window, and the script will keep running in the background.

## Adding rules

You can add rules to the file `MidiRules.ahk`.

There are four handler functions you can modify:

- `ProcessNote`: handles note on/off events
- `ProcessCC`: handles CC (Control Change, or Continuous Control) events
- `ProcessPC`: handles patch change events
- `ProcessPitchBend`: handle pitch bend events

Within each function, you can have a series of `if/else` blocks.

```
if (cc = 21) {
    ; ...
} else if (cc = 51) {
    ; ...
} else if (cc = 52 and value != 0) {
    ; ...
}
```

A rule to toggle the mute button when receiving CC 51 might look like this:

```
if (cc = 51) {
    Send {Volume_Mute}
    DisplayOutput("Volume", "Mute")
}
```

`Send {Volume_Mute}` simulates pressing the "mute" button on your keyboard. `DisplayOutput("Volume", "Mute")` logs a message to the MidiMon GUI.

A rule to press the play/pause button might look like this:

```
if (cc = 54 and value != 0) {
    Send {Media_Play_Pause}
    DisplayOutput("Media", "Play/Pause")
}
```

`value != 0` lets us detect button presses, and ignores button releases, on our MIDI controller. (Without this clause, we'd send the keyboard macro twice; once for the button press, and agin for the button release.) 

Here's a rule to map a continuous control from a slider to the main Windows mixer volume:

```
if (cc = 21 or cc = 29) {
    scaled_value := ConvertCCValueToScale(value, 0, 127)
    vol := scaled_value * 100
    SoundSet, vol
    DisplayOutput("Volume", vol)
}
```

`ConvertCCValueToScale` is a utility function from `CommonFunctions.ahk`. It converts a value within a give range into a floating point number between 0 and 1.

Here's a rule to trigger a keyboard shortcut in a specific application; in this example, Sound Forge 9:

```
if (cc = 58 and value != 0) {
    ; Place a cue marker in Sound Forge 9
    ControlSend, , {Alt down}m{Alt up}, ahk_class #32770
    DisplayOutput("Sound Forge", "Place Cue Marker")
}
```

You can use AutoHotKey's "WindowSpy" script to identify windows, or controls within an application, for use with `ahk_class`.

You can find [a list of standard CC messages online](https://www.midi.org/specifications-old/item/table-3-control-change-messages-data-bytes-2). You could use any control number without a specified control function, including numbers between 20-31, 52-63, and 102-119. But, any control number should work fine.
