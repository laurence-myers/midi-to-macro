
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
    The MidiRules section is for mapping MIDI input to actions.
    Alter these functions as required.
*/

ProcessNote(device, channel, note, velocity, isNoteOn) {

}

ProcessCC(device, channel, cc, value) {
    if (cc = 21 or cc = 29) {
        scaled_value := ConvertCCValueToScale(value, 0, 127)
        vol := scaled_value * 100
        SoundSet, vol
        DisplayOutput("Volume", vol)
    } else if (cc = 51) {
        Send {Volume_Mute}
        DisplayOutput("Volume", "Mute")
    } else if (cc = 52 and value != 0) {
        Send {Volume_Down}
        DisplayOutput("Volume", "Down")
    } else if (cc = 53 and value != 0) {
        Send {Volume_Up}
        DisplayOutput("Volume", "Up")
    } else if (cc = 54 and value != 0) {
        Send {Media_Play_Pause}
        DisplayOutput("Media", "Play/Pause")
    } else if (cc = 55 and value != 0) {
        Send {Media_Stop}
        DisplayOutput("Media", "Stop")
    } else if (cc = 56 and value != 0) {
        Send {Media_Prev}
        DisplayOutput("Media", "Previous")
    } else if (cc = 57 and value != 0) {
        Send {Media_Next}
        DisplayOutput("Media", "Next")
    } else if (cc = 58 and value != 0) {
        ; Place a cue marker in Sound Forge 9
        ControlSend, , {Alt down}m{Alt up}, ahk_class #32770
        DisplayOutput("Sound Forge", "Place Cue Marker")
    }
}

ProcessPC(device, channel, note, velocity) {
    
}

ProcessPitchBend(device, channel, value) {
    
}

