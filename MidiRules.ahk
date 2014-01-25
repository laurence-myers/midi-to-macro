
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
    The MidiRules section is for modifying midi input from some other source.
    Alter the ProcessNote, ProcessCC, or ProcessPC functions as desired.
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
        tmp_axis_val := Floor((value / max_cc_val) * AxisMax_X)
        VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_X)
        DisplayOutput("Axis X", value)
    }
}

ProcessPC(device, channel, note, velocity) {
}

MidiRules:
    if (statusbyte between 128 and 143) { ; Note off
        ProcessNote(0, statusbyte - 127, byte1, byte2, false)
    }
    if (statusbyte between 144 and 159) { ; Note on
        ProcessNote(0, statusbyte - 127, byte1, byte2, true)
    }
    if (statusbyte between 176 and 191) { ; CC
        ProcessCC(0, statusbyte - 175, byte1, byte2)
    } 
    if (statusbyte between 192 and 208) { ; PC
        ProcessPC(0, statusbyte - 191, byte1, byte2)
    }
    ; Maybe TODO: Key aftertouch, channel aftertouch, pitch wheel
Return

;*************************************************
;*          MIDI OUTPUT LABELS TO CALL
;*************************************************

SendNote: ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton
    note = %byte1%                                      ; this var is added to allow transpostion of a note
    midiOutShortMsg(h_midiout, statusbyte, note, byte2) ; call the midi funcitons with these params.
    gosub, ShowMidiOutMessage
Return
  
SendCC:   
    midiOutShortMsg(h_midiout, statusbyte, cc, byte2)
Return
 
SendPC:
    gosub, ShowMidiOutMessage
    midiOutShortMsg(h_midiout, statusbyte, pc, byte2)
Return

