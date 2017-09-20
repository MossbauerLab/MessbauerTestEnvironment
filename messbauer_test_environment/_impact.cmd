setMode -bs
setMode -bs
setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 1 -file "E:/PLD/MessbauerTestEnvironment/messbauer_test_environment/messbauer_test_environment.bit"
attachflash -position 1 -spi "M25P16"
assignfiletoattachedflash -position 1 -file "E:/PLD/MessbauerTestEnvironment/messbauer_test_environment/Untitled.mcs"
attachflash -position 1 -spi "M25P16"
Program -p 1 -dataWidth 1 -spionly -e -v 
setMode -bs
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
