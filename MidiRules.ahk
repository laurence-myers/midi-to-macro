
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
    The MidiRules section is for mapping MIDI input to actions.
    Alter these functions as required.
*/

ProcessNote(device, channel, note, velocity, isNoteOn) {
    global iInterface

    if (note >= 1 and note <= 32) {
        VJoy_SetBtn(isNoteOn, iInterface, note)
        button_state_text := isNoteOn ? "On" : "Off"
        DisplayOutput("Button " + button_state_text, note)
    }
}

ProcessCC(device, channel, cc, value) {
    global iInterface, HID_USAGE_X, HID_USAGE_Y, AxisMax_X, AxisMax_Y
    if (cc == 7) {
        scaled_value := ConvertCCValueToScale(value, 8, 120)
        new_axis_value := ConvertToAxis(scaled_value, AxisMax_X)
        VJoy_SetAxis(new_axis_value, iInterface, HID_USAGE_X)
        DisplayOutput("Axis X", scaled_value)
    } else if (cc == 27) {
        scaled_value := ConvertCCValueToScale(value, 8, 112)
        new_axis_value := ConvertToAxis(scaled_value, AxisMax_Y)
        VJoy_SetAxis(new_axis_value, iInterface, HID_USAGE_Y)
        DisplayOutput("Axis Y", scaled_value)
    }
}

ProcessPC(device, channel, note, velocity) {
    
}

ProcessPitchBend(device, channel, value) {
    
}

