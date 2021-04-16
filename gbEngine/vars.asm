SECTION "vgmEngineVariables",wram0
vgmVars:
SoundStatus:         ds 1;play,stop,pause state
CurrentSoundBank:    ds 1;current song data bank
VgmLookupPointer:    ;current frame pointer
VgmLookupPointerHigh:ds 1
VgmLookupPointerLow: ds 1
SoundWaitFrames:     ds 1;number of frames to currently wait
