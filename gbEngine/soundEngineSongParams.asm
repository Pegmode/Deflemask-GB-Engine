;use patcher to change these values, set tmaTac to 0 to disable timer
tmaMod: db $C3 
;tmaTac: db %100;4096 hz
tmaTac: db 0
;change these to add looping to song
loopAddress: dw $0; Address High, Low
loopBank: db 0, 0 ;Bank Val: High, Low
