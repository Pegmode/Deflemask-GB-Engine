;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine

SECTION "code",ROM0[$150]
entryPoint:
    ld [rIE], $01;enable Vblank interupt
    ei

main:;main loop
    nop
    jp main

vBlankRoutine:

    reti

;ENGINE CODE
DMEngineInit:
    ld a,DMVGM_START_BANK
    ld [CurrentSoundBank],a
    ld hl,$4000;bankX start address
    ld [VgmLookupPointer],hl
    ld a,1
    ld [SoundWaitFrames],a;set to not waiting any frames
    xor a
    ld [SoundStatus],a;set engine to not playing status
    ret

DMEngineUpdate:
.checkEngineStatus;check if the engine is currently playing a song
    ld a,[SoundStatus]
    cp 1
    jr nz,.exitCurrentFrame
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
    ld hl,bc
.commandCheck
    ld a,[hl];load data at data pointer, don't inc hl here because it may not be needed for current command
.checkWriteCmd
    bit 7,a
    jr nz,.checkWaitCmd
    inc hl
    ld a, [hl+]
    ld b, $FF
    ld c, a
    ld a, [hl+]
    ld [bc], a
    jr .commandCheck
.checkWaitCmd
    bit 6,a
    jr nz,.checkNextBank
    inc hl
    ld a,[hl+]
    ld [SoundWaitFrames],a
    ret
.checkNextBank
    bit 5,a
    jr nz,.checkLoop
    ld bc, $4000
    ld hl, VgmLookupPointer 
    ld [hl], b
    inc hl
    ld [hl], c
    ld a,[CurrentSoundBank]
    inc a
    ld [CurrentSoundBank],a
    ret
.checkLoop;unimplemented
    bit 4,a
    jr nz,.checkEndSong
.checkEndSong
    bit 3,a
    jr nz,.errorInCheck
    ;No need to set up registers for quiet status. should be done in tracker via envelopes, OFF or ECxx
    xor a
    ld [SoundStatus],a

.errorInCheck
    ;handle stuff
    ld b,b;debug breakpoint

SECTION "SoundData",ROM1[$4000]
include "ExampleData/scaleTestData.bin"