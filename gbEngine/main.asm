;Engine Skeleton ROM
include "hardware.asm"
include "soundEngineConstants.asm"
include "soundEngineVars.asm"
include "vars.asm"
SECTION "TMA VALUES",ROM0[$1]
;use patcher to change these values, set tmaTac to 0 to disable timer
tmaMod: db $C3 
;tmaTac: db %100;4096 hz
tmaTac: db 0
;change these to add looping to song
loopAddress: db 0,0
loopBank: db 0, 0


db "DMGBVGM by Pegmode"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "Timer IRQ",ROM0[$50]
timerIRQ:
    jp timerRoutine

SECTION "MBCDefinition",ROM0[$147]
    dw CART_MBC5

SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
codeInit:
    ld a, [tmaTac]
    bit 2,a
    jr nz, .setTMAMode
.setvBlankMode
    ld a, %1;enable vblank
    jr .continueInit
.setTMAMode
    ld [rTAC],a
    ld a, [tmaMod]
    ld [rTMA],a
    ld a, %100;enable timer
.continueInit
    ld [rIE], a
    call loadText
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
    ei

main:;main loop
    halt
    jp main

vBlankRoutine:
    call DMEngineUpdate
    call checkButtonInput
    reti

timerRoutine:
    call DMEngineUpdate
    call checkButtonInput
    reti

loadText:
    call WaitVBlank
    xor a
    ld [rLCDC], a
    call LoadNormalPallet
    ld hl,defleFont
    ld bc, $8000
    ld de, $600
    call MemCopyLong
    ld bc,textData1
    ld hl,$9C00
    call writeText
    ld bc,textData2
    ld hl,$9C00 + $20
    call writeText
    ld bc,textData3
    ld hl,$9C00 + $60
    call writeText
    ld bc,textData4
    ld hl,$9C00 + $80
    call writeText
    ld bc,textData5
    ld hl,$9C00 + $C0
    call writeText
    ld bc,textData6
    ld hl,$9C00 + $E0
    call writeText
    ld a, %10011001
    ld [rLCDC], a
    ret

;hl = write address, bc = source
writeText:
    ld a,[bc]
    cp 0
    jr z,.endWriteText
    sub 32
    ld [hl+], a
    inc bc
    jr writeText
.endWriteText
    ret

textData1:
    db "DeflemaskGBVGM v0.6"
    db 0

textData2:
    db "Hardware Player"
    db 0

textData3:
    db "A - Restart Track"
    db 0

textData4:
    db "B - Stop Track"
    db 0

textData5:;title
    db "                    ";ds not working
    db 0

textData6:;artist
    db "                    "
    db 0

checkButtonInput:
    call ReadJoy
    ld a, [NewJoyData]
.checkRestart
    cp 1;A button
    jr nz, .checkEnd
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
    jr nz, .exit
.checkEnd
    cp 2;b
    jr nz, .exit
    call stopMusic  
.exit
    ret

include "DMGBVGM.asm"
include "utils.asm"
defleFont: incbin "graphics/DefleFont.bin"



