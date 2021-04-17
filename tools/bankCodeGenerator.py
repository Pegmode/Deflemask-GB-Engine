#generate vgm player asm code formatROM banks

#User Variables
#========================================================================================
basepath = "ExampleData/ahoy/"
songName = "ahoy"
dataFileExtension = "bin"

#Code
#========================================================================================
asmBankDefSkeleton =\
'''SECTION "SoundData{}",ROMX,BANK[{}]
incbin "{}{}{}.{}"'''#i,i+1,basepath,songName,i,dataFileExtension

bankCount = int(input("how many banks does the song use?: "))
for i in range(bankCount):
  cAsmString = asmBankDefSkeleton.format(i,i+1,basepath,songName,i,dataFileExtension)
  print(cAsmString)