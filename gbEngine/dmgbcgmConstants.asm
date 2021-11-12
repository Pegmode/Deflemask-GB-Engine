DMVGM_SYNC_HIGH_ADDRES EQU $80;address $FFxx that the sync command writes to. Do not implement this as var so that the C conversion side knows this address as well
DMVGM_START_BANK EQU 1


;Sound engine commands
;===============================================================
;https://github.com/Pegmode/-DeflemaskGBVGM-/wiki/Current-Command-Format
DMVGM_CMD_2 EQU $80 ;wait for x frames
DMVGM_CMD_3 EQU $A0 ;go to next bank
DMVGM_CMD_4 EQU $B0 ;write data to 0xFFxy
DMVGM_CMD_5 EQU $C0 ;Loop to loop address and bank
DMVGM_CMD_6 EQU $D0 ;End song
