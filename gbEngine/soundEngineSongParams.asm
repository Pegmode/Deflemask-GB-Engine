;use patcher to change these values, set tmaTac to 0 to disable timer
;If you are using this engine in a custom ROM then you need to update these by hand
tmaMod: db $C3 
;tmaTac: db %100;4096 hz
tmaTac: db 0
;change these to add looping to song
loopAddress: dw $4000; Address High, Low
loopBank: db 1, 0 ;Bank Val: High, Low





    