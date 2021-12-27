#generates the .gbs skeleton for patching

#all 2-byte (word) values are little-endian (least-significant byte first).


gbsHeader = [
    ord("G"), ord("B"), ord("S"),#Ident
    1,#version
    1,#number of songs
    1,#1st song
    0xF0, 0x3E,#load address ( start ofEngineCode)
    0xF0, 0x3E,#init address (gbs init)
    0x26, 0x3F,#play address (DMEngineUpdate label)
    0xFE,0xFF,#sp
    0x0,#modulo
    0x0#tac
    #title (32)
    #author (32)
    #copyright (32 )

] + [0] * 32 * 3 #title, author copyright padding


gbsHeaderBytes = bytearray(gbsHeader)

def manualPatch():#debug and testing
    INROM = "output.gb"
    f = open(INROM, "rb")
    inBuffer = f.read()
    f.close()
    finalGBS = gbsHeaderBytes + inBuffer[0x3EF0:]#YOU KEEP ON FORGETTING TO UPDATE THE ADDRESS PLEASE DO SO IF UPDATING MANUALLY
    f = open("test.gbs", "wb")
    f.write(finalGBS)
    f.close()

manualPatch()