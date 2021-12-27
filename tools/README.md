# tools
Tools to make life a little easier. Some are required for building the project. Mainly for updating intermediate data between asm and C code.
### bankCodeGenerator.py
generates asm code for storing music data in separate ROM banks when
including the sound engine in your own ASM project

### generateRomPointers.py
generates pre-compiler ROM address constants from the ASM ROM .sym file.

### rom2CArr.py
generates a char array from the asm ROM for the C converter