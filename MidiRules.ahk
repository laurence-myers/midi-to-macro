
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
    The MidiRules section is for modifying midi input from some other source.
    See hotkeys below if you wish to generate midi messages from hotkeys.
  
    Write your own MidiRules and put them in this section.
    Keep rules together under proper section, notes, cc, program change etc.
    Keep them after the statusbyte has been determined.
    Examples for each type of rule will be shown. 
    The example below is for note type message.

    Remember byte1 for a noteon/off is the note number, byte2 is the velocity of that note.
    
    Example:
    
        ifequal, byte1, 20 ; if the note number coming in is note # 20
        {
            byte1 := (do something in here) ; could be do something to the velocity(byte2)
            gosub, SendNote ; send the note out.
        }
*/

MidiRules:

    ; =============== Note On/Off ===============
    if statusbyte between 128 and 159
    { 
        /* 
        Add your own note filters here.
        byte1 is the note number, byte2 is the velocity.
        
        Example:
        
            ifequal, byte1, 20 ; if the note number coming in is note # 20
            {
                byte1 := (do something in here) ; could be do something to the velocity(byte2)
                gosub, SendNote ; send the note out.
            }
        */    
    } ; end of note block

    ; =============== CCs (continuous controllers) ===============
    if statusbyte between 176 and 191
    { 
        tmp_axis_val := Floor((byte2 / max_cc_val) * AxisMax_X)
        VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_X)
        
        ; Default action code below
        cc := byte1 ; pass them as is, no change.
        ;gosub, ShowMidiInMessage
        GuiControl,12:, MidiMsOut, CC %statusbyte% %chan% %cc% %byte2% 
        gosub, ShowMidiOutMessage
        ;gosub, sendCC 
    }
  
    ; Is midi input a Program Change?
    if statusbyte between 192 and 208
    {
        gosub, sendPC  
    }
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



