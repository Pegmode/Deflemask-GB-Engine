# DeflemaskGBVGMConverter
Converts a Deflemask genrated .vgm in to .bin files containing bank separated custom register dump.

#Usage
`DeflemaskGBVGMConverter <.vgm file>`
**REQUIRES patchROM.gb**
### arguments
* `-r <engine rate>` set the engine rate in Hz (Clock value in Deflemask)
* `-o <output path>` set the output filename (defaults to "out")
* `-asm` export song data as .bin to include in a GB rom.

#### .bin export
include all exported .bin files in your asm ROM. Each .bin takes up an entire ROM bank. See /gbEngine for more info\

example:
```
SECTION "SoundData0",ROMX,BANK[1]
incbin "ExampleData/ahoy/ahoy0.bin
....
....
SECTION "SoundData9",ROMX,BANK[10]
incbin "ExampleData/ahoy/ahoy9.bin"
```

#Build Instructions
## Windows
run minGW make.
## Linux
not yet supported
