# MessbauerTestEnvironment
FPGA Messbauer hardware (generator, emulation of signal from gamma-source registered and amplified

This hardware project is a Spartan6 AX309 Board (ALINX) include following features:

1. Messbauer generator: Start and Channel signal with adjustable Start duration and Channel number.

2. Emulation of signal gathered from gamma radiation source (registered in detector) transmitted from absorber and amplified finally 
in following scheme: S* ------> [A, Modulated with Doppler] ------> D-A, where:
S* - gamma radiation source
A - absorber under modulation 
D-A - Detector + Amplifier
