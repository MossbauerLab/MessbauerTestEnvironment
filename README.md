# MessbauerTestEnvironment
FPGA Messbauer hardware (generator, emulation of signal from gamma-source registered and amplified.

Gamma optics scheme: S* ------> [A, Modulated with Doppler] ------> D-A, where:
- S* - gamma radiation source
- A - absorber under modulation 
- D-A - Detector + Amplifier

This project 
- Generates signals for Messbauer Driver Modulator (saw tooth generation)but without peak aliasing (PROPRIETARY algorithm)
- Generates signals for accumulation: Start and Channel
- Generate decay signal emulation (means gamma quants that were registered and pass amplification to diff discriminator)

This hardware project is a Spartan6 AX309 Board (ALINX) include following features:
1. Messbauer saw-tooth generator:
![Saw tooth gen file](https://github.com/MossbauerLab/MessbauerTestEnvironment/blob/master/docs/messbauer_generator/saw_tooth_generator.png)


2. Messbauer generator: Start and Channel signal with adjustable Start duration and Channel number, relation between Start and Channel:
![Start and Channel relations](https://github.com/MossbauerLab/MessbauerTestEnvironment/blob/master/docs/messbauer_generator/channel_after/period_begin.png)

3. Testing signal for differential discriminator: 17 impulses total: 5 must be counted, others not:

![Signal for diff discriminator](https://github.com/MossbauerLab/MessbauerTestEnvironment/blob/master/docs/messbauer_diff_discriminator/diff_discriminator_emulation_enlarged.png)

