
;*************************************************
;*          RULES - MIDI FILTERS
;*************************************************

/* 
      The MidiRules section is for modifying midi input from some other source.
        *See hotkeys below if you wish to generate midi messages from hotkeys.
      
      Write your own MidiRules and put them in this section.
      Keep rules together under proper section, notes, cc, program change etc.
      Keep them after the statusbyte has been determined.
      Examples for each type of rule will be shown. 
      The example below is for note type message.
      
      Remember byte1 for a noteon/off is the note number, byte2 is the velocity of that note.
      example
      ifequal, byte1, 20 ; if the note number coming in is note # 20
        {
          byte1 := (do something in here) ; could be do something to the velocity(byte2)
          gosub, SendNote ; send the note out.
        }
  */

MidiRules: ; write your own rules in here, look for : ++++++ for where you might want to add
           ; stay away from !!!!!!!!!!

  ; =============== Is midi input a Note On or Note off message?  =============== 
  if statusbyte between 128 and 159 ; see range of values for notemsg var defined in autoexec section. "in" used because ranges of note on and note off
	{ ; beginning of note block
 
  ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! above  end of no edit
     
  ; =============== add your note MidiRules here ==; =============== 

  /* 
      Write your own note filters and put them in this section.
      Remember byte1 for a noteon/off is the note number, byte2 is the velocity of that note.
      example
      ifequal, byte1, 20 ; if the note number coming in is note # 20
        {
          byte1 := (do something in here) ; could be do something to the velocity(byte2)
          gosub, SendNote ; send the note out.
        }
  */
  ; ++++++++++++++++++++++++++++++++ examples of note rules ++++++++++ feel free to add more.
     
    ; ++++++++++++++++++++++++++++++++ End of examples of note rules  ++++++++++ 
    } ; end of note block
  
; =============== all cc detection ---- 
  ; is input cc?
  
  if statusbyte between 176 and 191 ; check status byte for cc 176-191 is the range for CC messages ; !!!!!!!! no edit this line, uykwyad
    ;gosub, sendcc
    
    {
    ; ++++++++++++++++++++++++++++++++ examples of CC rules ++++++++++ feel free to add more.  
		if byte1 not in %cc_msg% ; if the byte1 value is one of these...
          { 
            tmp_axis_val := Floor((byte2 / 112) * AxisMax_X)
            VJoy_SetAxis(tmp_axis_val, iInterface, HID_USAGE_X)
                        
            cc := byte1 ; pass them as is, no change.
            gosub, ShowMidiInMessage
			GuiControl,12:, MidiMsOut, CC %statusbyte% %chan% %cc% %byte2% 
            gosub, ShowMidiOutMessage
            ;gosub, sendCC 
          }  
    ; ++++++++++++++++++++++++++++++++ examples of cc rules ends ++++++++++++ 
    }
  
  ; Is midi input a Program Change?
  if statusbyte between 192 and 208  ; check if message is in range of program change messages for byte1 values. ; !!!!!!!!!!!! no edit
    {
    ; ++++++++++++++++++++++++++++++++ examples of program change rules ++++++++++  
      ; Sorry I have not created anything for here nor for pitchbends....
      
      ;GuiControl,12:, MidiMsOut, ProgC:%statusbyte% %chan% %byte1% %byte2% 
          ;gosub, ShowMidiInMessage
		  gosub, sendPC
          ; need something for it to do here, could be converting to a cc or a note or changing the value of the pc
          ; however, at this point the only thing that happens is the gui change, not midi is output here.
          ; you may want to make a SendPc: label below
    ; ++++++++++++++++++++++++++++++++ examples of program change rules ++++++++++   
    }
  ;msgbox filter triggered
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  end of edit section
Return

;*************************************************
;*          MIDI OUTPUT LABELS TO CALL
;*************************************************

SendNote: ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh.
  ;{
  
 
  ;GuiControl,12:, MidiMsOutSend, NoteOut:%statusbyte% %chan% %byte1% %byte2% 
    ;global chan, EventType, NoteVel
    ;MidiStatus := 143 + chan
    note = %byte1%                                      ; this var is added to allow transpostion of a note
    midiOutShortMsg(h_midiout, statusbyte, note, byte2) ; call the midi funcitons with these params.
     gosub, ShowMidiOutMessage
Return
  
SendCC: ; not sure i actually did anything changing cc's here but it is possible.

   
	;GuiControl,12:, MidiMsOutSend, CCOut:%statusbyte% %chan% %cc% %byte2%
    midiOutShortMsg(h_midiout, statusbyte, cc, byte2)
     
     ;MsgBox, 0, ,sendcc triggered , 1
 Return
 
SendPC:
    gosub, ShowMidiOutMessage
	;GuiControl,12:, MidiMsOutSend, ProgChOut:%statusbyte% %chan% %byte1% %byte2%
    midiOutShortMsg(h_midiout, statusbyte, pc, byte2)
 /* 
  COULD BE TRANSLATED TO SOME OTHER MIDI MESSAGE IF NEEDED.
 */
Return



