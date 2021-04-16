;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine

SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
codeInit:
    ld a, $01
    ld [rIE], a;enable Vblank interupt
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
    ei

main:;main loop
    nop
    jp main

vBlankRoutine:
    call DMEngineUpdate
    reti

;ENGINE CODE
DMEngineInit:
    ld a,DMVGM_START_BANK
    ld [CurrentSoundBank],a
    ld a,$40;load $4000 in pointer
    ld [VgmLookupPointerHigh],a
    xor a
    ld [VgmLookupPointerLow],a
    ld a,1
    ld [SoundWaitFrames],a;set to not waiting any frames
    xor a
    ld [SoundStatus],a;set engine to not playing status
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
    jr z,.commandCheckInit
    dec a
    ld [SoundWaitFrames],a
    ret
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
    ld b,b
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
    ld a,[CurrentSoundBank]
    inc a
    ld [CurrentSoundBank],a
    jr .endFrame
.checkLoop;unimplemented
    bit 4,a
    jr z,.checkEndSong
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

SECTION "SoundData",ROMX,BANK[1]
incbin "ExampleData/scaleTestData.bin"