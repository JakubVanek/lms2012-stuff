# EV3 sensor communication on a logic analyzer

Here you can find various communication traces of EV3 UART sensors.
They were captured in Pulseview using a Saleae Logic 8 clone.

## Handshake & mode 0

These traces contain the initial sensor communication, the ACK handshake
and a part of mode 0 communicaitons.

 - EV3 Ultrasonic Sensor w/ date code 50N3: see `ultrasonic.sr`
 - EV3 Gyro Sensor w/ date code 49N3: see `gyro.sr`
 - EV3 Color Sensor 45506 w/ date code 47N3: see `color.sr`
 - EV3 Infrared Sensor 45509 w/ date code 36N8: see `infrared.sr`
