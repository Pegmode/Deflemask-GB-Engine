;ENGINE CODE
DMEngineInit:
    ld a,DMVGM_START_BANK
    ld [CurrentSoundBankLow],a
    ld a,$40;load $4000 in pointer
    ld [VgmLookupPointerHigh],a

    ld a,1
    ld [SoundWaitFrames],a;set to not waiting any frames
    xor a
    ld [SoundStatus],a;set engine to not playing status
    ld [VgmLookupPointerLow],a
    ld [CurrentSoundBankHigh],a
    ret

DMEngineUpdate:
.checkEngineStatus;check if the engine is currently playing a song
    ld a,[SoundStatus]
    cp 1
    jr z,.checkIsWaitFrame
    ret
.checkIsWaitFrame;check if the engine is currently in a wait state
    ld a,[SoundWaitFrames]
    cp 1
    jr z,.loadCurrentBank
    dec a
    ld [SoundWaitFrames],a
    ret
.loadCurrentBank
    ld a ,[CurrentSoundBankHigh]
    ld b,a
    ld a ,[CurrentSoundBankLow]
    ld [rROMB0],a
    ld a,b
    ld [rROMB1],a
    
.commandCheckInit
    ld hl,VgmLookupPointer;load data pointer
    ld b,[hl]
    inc hl
    ld c,[hl]
    ld h,b
    ld l,c
.commandCheck
    ld a,[hl];load data at data pointer, don't inc hl here because it may not be needed for current command
.checkWriteCmd
    bit 7,a
    jr z,.checkWaitCmd
    inc hl
    ld a, [hl+]
    ld b, $FF
    ld c, a
    ld a, [hl+]
    ld [bc], a
    jr .commandCheck
.checkWaitCmd
    bit 6,a
    jr z,.checkNextBank
    inc hl
    ld a,[hl+]
    ld [SoundWaitFrames],a
    jr .endFrame
.checkNextBank
    bit 5,a
    jr z,.checkLoop
    ld bc, $4000
    ld hl, VgmLookupPointer 
    ld [hl], b
    inc hl
    ld [hl], c
    ld a,[CurrentSoundBankHigh]
    ld b,a
    ld a,[CurrentSoundBankLow]
    ld c, a
    inc bc
    ld a, b
    ld [CurrentSoundBankHigh],a
    ld a, c
    ld [CurrentSoundBankLow],a
    ret;DO NOT END FRAME NORMALLY
.checkLoop;unimplemented
    bit 4,a
    jr z,.checkEndSong
    ;load new bank
    ld hl, loopBank
    ld a, [hl+]
    ld [CurrentSoundBankLow],a
    ld a, [hl]
    ld [CurrentSoundBankHigh],a
    ;load new Address
    ld hl, loopAddress
    ld a, [hl+]
    ld [VgmLookupPointerLow],a
    ld a, [hl]
    ld [VgmLookupPointerHigh],a
    ret
.checkEndSong
    bit 3,a
    jr z,.errorInCheck
    ;No need to set up registers for quiet status. should be done in tracker via envelopes, OFF or ECxx
    xor a
    ld [SoundStatus],a
    jr .endFrame
.errorInCheck
    ;handle stuff
    ld b,b;debug breakpoint
.endFrame
    ld a, h
    ld [VgmLookupPointerHigh],a
    ld a, l
    ld [VgmLookupPointerLow],a
    ret