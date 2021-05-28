;MemCopyLong
;==========================================================
;Input requirements: hl = Source Address, bc = destination, de = data length
MemCopyLong:
	ld a,[hl+]
	ld [bc],a
	inc bc
	dec de
	xor a
	or e
	jp nz,MemCopyLong
	or d
	jp nz,MemCopyLong
	ret

;MemCopy
;==========================================================
;Input requirements: hl = Source Address, bc = destination, d = data length
MemCopy:
	ld a,[hl+]
	ld [bc],a
	inc bc
	dec d
	jp nz,MemCopy
	ret

  
;Load Standard DMG pallet
;============================================================
LoadNormalPallet:
	ld a,$E4
	ld [$FF47],a
	ret

;Wait for V/HBlank
;==========================================================
;Total time: 52 cycles
;stat %xxxxxx0x
WaitBlank:
	ld a,[rSTAT]    ;16C
	and 2						;8C
	jr	nz,WaitBlank;12 ~ 8C
	ret							;16C

;Wait for VBlank
;==========================================================
;wait for Beginning of vBlank
;holds for a long time
;stat %xxxxxx01
WaitVBlank:
	ld a,[rSTAT]
	bit 0,a
	jr nz,WaitVBlank;wait for non vBlankState
.waitforVBlank;
	ld a,[rSTAT]
	bit 0,a
	jr z,.waitforVBlank
	bit 1,a
	jr nz,.waitforVBlank
	ret


