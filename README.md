# -DeflemaskGBVGM-
Custom Deflemask .vgm based playback engine for the Nintendo Game Boy. Now the official Deflemask ROM exporter as of v1.0.3.

**this engine only works Deflemask generated .vgms and is not intended for other .vgms**

supports `EExx` event commands from Delfemask and uses proper engine timings instead of .vgm update timings. Converter converts .vgm to either .bin or .gb.

*"High on time efficentcy, low on space efficiency."*

## Usage
1. Download the latest release [here](https://github.com/Pegmode/-DeflemaskGBVGM-/releases)  
2. run DeflemaskGBVGMConverter.exe like this  
`DeflemaskGBVGMConverter.exe <.vgm file> [arguments...]`  
### arguments
* `-r <engine rate>` set the engine rate in Hz (Clock value in Deflemask). Required if you use a engine tick speed other than NTSC.
* `-o <output path>` set the output filename (defaults to "out")
* `-bin` export song data as .bin to include in a GB rom.
* `-ti <offset>` increase tma offset timing (speed up song if using custom engine speed).
* `-td <offset>` decrease tma offset timing (slow down song if using custom engine speed).

#### .bin export
include all exported .bin files in your asm ROM. Each .bin takes up an entire ROM bank. Make sure each sound bank is beside another (eg: ahoy1 should be one bank after ahoy0).

example:
```
SECTION "SoundData0",ROMX,BANK[1]
incbin "ExampleData/ahoy/ahoy0.bin
....
....
SECTION "SoundData9",ROMX,BANK[10]
incbin "ExampleData/ahoy/ahoy9.bin"
```


## Register Dump command format
Commands are formatted so that each bit is a flag that represents a command.
### Format Description

| Command Description  | Command Value | arg1 | arg2 |
| ------------- | ------------- | ------------- |  ------------- |
| Write 0xij to FFxy (LDH xy ij) | 0x80  | xy address value | Data ij |
| Wait for xy frames | 0x40 | wait time xy |  |
| Go to next ROM bank | 0x20 |  |  |
| Loop to loop adddress and bank | 0x10 |  |  |
| End song | 0x08 |  |  |

#### Sync command
Sync signals write to HRAM with the address specified in `DEFAULT_SYNC_HIGH_ADDRESS` in the converter (default `0x80`). In deflemask use the `EExx` command to write the value xx to `DEFAULT_SYNC_HIGH_ADDRESS`.

