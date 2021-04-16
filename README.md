# -DeflemaskGBVGM-
Custom Deflemask .vgm based playback engine for the Nintendo Game Boy.

**this engine only works Deflemask generated .vgms and is not intended for other .vgms**

# Register Dump command format
Commands are formatted so that each bit is a flag that represents a command.
### Format Description

| Command Description  | Command Value | arg1 | arg2 |
| ------------- | ------------- | ------------- |  ------------- |
| Write 0xij to FFxy (LDH xy ij) | 0x80  | xy address value | Data ij |
| Wait for xy frames | 0x40 | wait time xy |  |
| Go to next ROM bank | 0x20 |  |  |
| Loop to (unfinished) | 0x10 |  |  |
| End song | 0x08 |  |  |

#### Sync command
Sync signals use the 0x80 (write high) command to write their values to the address specified in `DEFAULT_SYNC_HIGH_ADDRESS`in the converter (default `0xFA`). In deflemask use the `EExx` command to write the value xx to `DEFAULT_SYNC_HIGH_ADDRESS`.
