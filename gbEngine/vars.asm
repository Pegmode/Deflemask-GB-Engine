SECTION "vgmEngineVariables",wram0
vgmVars:
    SoundStatus         ds 1;play,stop,pause state
    CurrentSoundBank    ds 1;current song data bank
    VgmLookupPointer    ds 2;current frame pointer
    SoundWaitFrames     ds 1;number of frames to currently wait