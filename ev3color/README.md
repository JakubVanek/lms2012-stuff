# EV3 Color Sensor #exposed

This folder contains findings from firmware reverse engineering of the EV3 color sensor.
C pseudocode of the firmware can be found in [`program.c`](program.c).

## Why?

Mostly for the challenge, but there was also another reason.

The firmware running on the AM1808 CPU of the EV3 brick was published a
long time ago, but this never happened for the small MCUs running inside
the EV3 sensors.

Having the source code in itself is not that useful (I do not want to make
clone sensors or anything like that), but knowing if there are some
hidden features is. The goal was to find out if it is possible to read
the internal calibration parameters stored inside the sensor EEPROM.
If that was the case, it would be possible to obtain accurate colour
information from the RGB-RAW mode without any additional data.

Another aspect of interest was if it is possible to upgrade the sensor
firmware using the EV3 brick. This would allow for patching bugs and adding
features to the sensor without physically opening it to access the SWIM
programmer pins.

## Findings

Unfortunately, the calibration coefficients for color measurements cannot
be read without factory-calibrating the sensor or reading the EEPROM
through a SWIM programmer. The coefficients are only ever sent to the brick
via the UART protocol when a COL-CAL recalibration is finished.

Firmware upgrades from the EV3 are not possible either. There is no
"firmware download" mode inside the sensor state machine that would allow
the brick to reprogram its flash.

This is understandable - there is likely not enough flash to fit an
immutable bootloader next to the upgradeable firmware, so it would not be
possible to perform upgrades safely. If someone unplugged the sensor
during the upgrade process, the result would likely be a bricked sensor.

It may still be possible to trigger a overflow over the UART protocol
and deploy a temporary firmware to RAM. However, I don't think this is
possible as the firmware uses circular buffers and checks for receive
buffer overflows.

## Interesting bits

 - It was *almost* possible to have green and blue COL-REFLECT and REF-RAW
   modes. The function that does the sampling has a `mode` argument that
   selects the LED to swithc on. Unfortunately, the sensor state machine
   has this argument hardcoded to `1`, always opting for the red LED.

 - The blue LED that glows when the COL-AMBIENT mode is active has zero effect
   on the measurements. The measurement is done with the LED off and only
   then the LED is briefly flashed.

 - The reason why COL-COLOR performs poorly is that is does not use HSV or
   similar hue-centric color model to perform the identification. Instead,
   it compares the color reflection intensities directly in the RGB model.

   The intensities are mostly compared to some predefined thresholds.
   However, in the case of red and green, it also checks the ratio of their
   intensities.

 - There is some difference between REF-RAW and RGB-RAW modes. The measurement
   in both cases should take 160 microseconds. The difference is that for
   RGB-RAW, each LED is activated for 40 microseconds and then a measurement
   is made. For REF-RAW, the red LED is active for 120 microseconds. The
   remaining 40 microseconds are used for the ambient correction measurement.
   However, the extent to which this affects the measurement electronics and
   the measured values is unknown to me.

 - The RGB-RAW checksum bug is indeed real. The problem is that the old
   check byte is included the XOR calculation for the next check byte.

 - Engineers at LEGO likely wrote the firmware in C, as there were patterns
   of code looking very much like automatic code generation.

   I have one particular example of such a unnecessarily complex code.
   To get the second least significant byte of a 32bit unsigned integer,
   the firmware calls a function that performs a variable-length shift on
   the original 32bit integer. However, the same thing could be achieved
   by directly accessing the third byte of the integer (STM8 is big endian).

 - Parts of the firmware use IEEE-754 single precision floating-point math.
   I have found float-integer conversion, float multiplication, division and
   comparison routines. They are used for two purposes:

   - Calibrating COL-REFLECT and COL-COLOR readings,
   - Comparing color magnitudes in COL-COLOR identification code.

## Files

 - `program.c`                 - C pseudocode reverse-engineered from the flash image
 - `binaries/flash.bin`        - 8 KiB internal flash image (only the first 7116 bytes are used)
 - `binaries/eeprom.bin`       - 640 B internal EEPROM image (only the first 12 bytes are used)
 - `binaries/ram.bin`          - 1 KiB internal RAM image (first 173 bytes are used for global variables, last ? bytes are used for stack)
 - `binaries/option-bytes.bin` - 64 B internal option bytes image (?)

## Tools used

 - HW: [LEGO #45506](https://www.lego.com/cs-cz/product/ev3-color-sensor-45506)
       with revision code 20N7.
 - HW: [ST-Link/V2](https://www.st.com/en/development-tools/st-link-v2.html)
       as an ISP programmer.
 - SW: [stm8flash](https://github.com/vdudouyt/stm8flash)
       for downloading the flash under Linux.
 - SW: [naken_asm](https://github.com/mikeakohn/naken_asm)
       as a disassembler.
 - SW: [Geany](https://www.geany.org/)
       as a text editor.
 - SW: [Okteta](https://kde.org/applications/en/utilities/org.kde.okteta)
       as a hex editor.

## Documents used

 - [STM8S103F3 datasheet](https://www.st.com/resource/en/datasheet/stm8s103f2.pdf)
   for general information about the MCU and its memory map.
 - [STM8S reference datasheet](https://www.st.com/resource/en/reference_manual/cd00190271-stm8s-series-and-stm8af-series-8bit-microcontrollers-stmicroelectronics.pdf)
   for information about the MCU subsystems (e.g. ADC, UART, GPIO).
 - [STM8 CPU programming manual](https://www.st.com/resource/en/programming_manual/cd00161709-stm8-cpu-programming-manual-stmicroelectronics.pdf)
   for information about the instruction set.
 - [EV3 Hardware Developer Kit](https://education.lego.com/en-us/support/mindstorms-ev3/developer-kits)
   for the sensor schematics and the MCU model.
