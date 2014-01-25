
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
    The MidiRules section is for modifying midi input from some other source.
    Alter these functions as required.
*/

; *** New rule handler functions ***
ProcessNote(device, channel, note, velocity, isNoteOn) {
    /* 
    Add your own note filters here.
    
    Example:
        if (isNoteOn and note == 20)
        {
            ; Clamp the velocity to 80
            if (velocity > 80) {
                velocity := 80
            }
            gosub, SendNote ; send the note out.
        }
    */
}

ProcessCC(device, channel, cc, value) {
    global AxisMax_X, max_cc_val, iInterface, HID_USAGE_X
    if (cc == 7) {
        new_axis_value := ConvertCCValueToAxis(value, 127, AxisMax_X)
        VJoy_SetAxis(new_axis_value, iInterface, HID_USAGE_X)
        DisplayOutput("Axis X", ConvertCCValue(value, 127))
    }
}

ProcessPC(device, channel, note, velocity) {
}

ProcessPitchBend(device, channel, value) {
    
}

