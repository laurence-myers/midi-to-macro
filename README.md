# MidiToMacro

This is an AutoHotKey v2 script for Windows, to map MIDI input values to hotkeys or macros.

You can use this script to bind CC messages to media keys (play/pause/next), volume sliders, or unusual keyboard combinations (CTRL+SHIFT+ALT+F13) which you can assign in programs like StreamLabs OBS.

## Running

Double click on `MidiToMacro.ahk`.

To launch the program when Windows starts, you can add a shortcut to the file in your Start Menu\Startup folder. (Get there quickly by pressing WIN+R, then typing `shell:startup` and ENTER.)

When you run the script, it will show the "MIDI Monitor" GUI. Choose your MIDI input from the dropdown list. Incoming MIDI messages will be shown in the left list, and triggered events will be shown on the right.

You can close the "MIDI Monitor" window, and the script will keep running in the background. To see it again, right click on the tray icon and click "MIDI Monitor".

By default, the "MIDI Monitor" GUI will be shown every time you run the script. This can be disabled by right clicking on the tray icon, and unticking the "Show on Startup" option.

When the script starts, it will try to open your chosen MIDI input device. If your MIDI devices change (by adding or removing a device), the MIDI device might not be opened. The GUI will be shown (even if "Show on Startup" is off), and you'll need to select the MIDI device again.

## Configuration

The script can be configured via `MidiToMacro.ini`. This file will be created in the same directory as the script, when you select a MIDI device, or toggle the "Show on Startup" tray menu option. You can also create and edit the file manually.

```ini
; How many log lines to show in the GUI. Defaults to 10.
MaxLongLines=10
; The selected MIDI input device. This is an index starting from 0.
MidiInDevice=0
; The name of the selected MIDI input device. This is used to check if the attached MIDI devices has changed.
MidiInDeviceName=Automap MIDI
; Set this to 0 to disable the GUI when the script starts.
ShowOnStartup=1
```

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
    Send("{Volume_Mute}")
    DisplayOutput("Volume", "Mute")
}
```

`Send("{Volume_Mute}")` simulates pressing the "mute" button on your keyboard. `DisplayOutput("Volume", "Mute")` logs a message to the MidiMon GUI.

A rule to press the play/pause button might look like this:

```
if (cc = 54 and value != 0) {
    Send("{Media_Play_Pause}")
    DisplayOutput("Media", "Play/Pause")
}
```

`value != 0` lets us detect button presses, and ignores button releases, on our MIDI controller. (Without this clause, we'd send the keyboard macro twice; once for the button press, and agin for the button release.) 

Here's a rule to map a continuous control from a slider to the main Windows mixer volume:

```
if (cc = 21 or cc = 29) {
    scaledValue := ConvertCCValueToScale(value, 0, 127)
    volume := scaledValue * 100
    SoundSetVolume(volume)
    DisplayOutput("Volume", Format('{1:.2f}', volume))
}
```

`ConvertCCValueToScale` is a utility function from `lib\CommonFunctions.ahk`. It converts a value in a given range, into a floating point number between 0 and 1.

Here's a rule to trigger a keyboard shortcut in a specific application; in this example, Sound Forge 9:

```
if (cc = 58 and value != 0) {
    ; Place a cue marker in Sound Forge 9
    try {
        ControlSend("{Alt down}m{Alt up}", , "ahk_class #32770")
        DisplayOutput("Sound Forge", "Place Cue Marker")
    } catch TargetError {
        ; Window doesn't exist, oh well
    }
}
```

You can use AutoHotKey's "WindowSpy" script to identify windows, or controls within an application, for use with `ahk_class`.

You can find [a list of standard CC messages online](https://web.archive.org/web/20231215150816/https://www.midi.org/specifications-old/item/table-3-control-change-messages-data-bytes-2). You could use any control number without a specified control function, including numbers between 20-31, 52-63, and 102-119. But, any control number should work fine.

## AutoHotKey version support

This script requires AutoHotKey v2. If you still need v1 support, please use [an older version of this script](https://github.com/laurence-myers/midi-to-macro/tree/ahk-v1).

## Migrating to v2

If you have an existing `MidiRules.ahk` written before MidiToMacro v2, just [update it to support
AHK v2 syntax](https://www.autohotkey.com/docs/v2/v2-changes.htm). Some basic changes required:

- Change function calls: `Send, ...` -> `Send(...)`
- Quote strings: `Send, {Volume_up}` -> `Send("{Volume_up}")`

There are no changes to the functions supplied by MidiToMacro, like `DisplayOutput()`.

## Credits

This script was, in various forms and evolutions, originally based on work by AHK forum members, including (in no particular order):

- genmce
- Orbik
- TomB
- Lazslo

Thanks to [William Wong](https://github.com/compulim), for his implementation of `OpenMidiInput`. (See [autohotkey-boss-fs-1-wl](https://github.com/compulim/autohotkey-boss-fs-1-wl)).
