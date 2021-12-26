;ENGINE CODE
engineID:
    dw "DMGBVGM 0.6 PEGMODE"
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
    ld a ,[CurrentSoundBankLow]
    ld b,a
    ld a ,[CurrentSoundBankHigh]
    ld [rROMB1],a;note: changed order for GBS support
    ld a,b
    ld [rROMB0],a

    
.commandCheckInit
    ld hl,VgmLookupPointer;load data pointer
    ld b,[hl]
    inc hl
    ld c,[hl]
    ld h,b
    ld l,c
.commandCheck
    ld a,[hl];load data at data pointer, don't inc hl here because it may not be needed for current command
.checkWriteNRCmd;check noise register write
    bit 7,a
    jr nz,.checkWaitCmd;first command is a special case! We check bit 7 for a mask for cmd1
    ld b, $FF
    ld c, a
    inc hl
    ld a, [hl+]
    ld [bc], a
    jr .commandCheck
.checkWaitCmd
    cp DMVGM_CMD_2
    jr nz,.checkNextBank
    inc hl
    ld a,[hl+]
    ld [SoundWaitFrames],a
    jr .endFrame
.checkNextBank
    cp DMVGM_CMD_3
    jr nz,.checkHWrite
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
.checkHWrite;normal H write
    cp DMVGM_CMD_4
    jr nz,.checkLoop
    inc hl
    ld a, [hl+]
    ld b, $FF
    ld c, a
    ld a, [hl+]
    ld [bc], a
    jr .commandCheck

.checkLoop
    cp DMVGM_CMD_5
    jr nz,.checkEndSong
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
    cp DMVGM_CMD_6
    jr nz,.errorInCheck
    ;No need to set up registers for quiet status. should be done in tracker via envelopes, OFF or ECxx
    call stopMusic
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

stopMusic:
    xor a
    ld [SoundStatus],a
    call resetSound
    ret

resetSound:
    xor a
    ldh [$10], a
    ldh [$12], a
    ldh [$17], a
    ldh [$22], a
    ldh [$11], a
    ldh [$11], a
    ldh [$16], a
    ldh [$1A], a
    ldh [$21], a
    ld a, $8f
    ldh [$26], a
    ld a, $FF
    ldh [$25], a
    ld a, $77
    ldh [$24], a
    ld a, $20
    ldh [$1C], a
    ld a, $F7
    ldh [$21], a
    ret