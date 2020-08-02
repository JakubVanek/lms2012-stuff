interrupt table
---------------
RESET => startup       @0x99dc
TIM1  => us10_tick     @0x9a22
TIM2  => ms_tick       @0x9a48
TX_OK => uart_tx_done  @0x988d
RX_OK => uart_rx_done  @0x98e0
other => bad_irq       @0x9bba


global RAM variables
--------------------
; pseudo-variables
u8   callerSavedRegs[8] @ [$00]
u8   calleeSavedRegs[8] @ [$08]

; real variables
u8   lastColor    @ [$10]
u8   mainState    @ [$11]
u8   initState    @ [$12]
u8   rxBuffer[35] @ [$13]
u8   txBuffer[35] @ [$36]
u8   frame[35]    @ [$59]
f32  redFactor    @ [$7c]
f32  greenFactor  @ [$80]
f32  blueFactor   @ [$84]
u16  lastRefRawFg @ [$88]
u16  lastRefRawBg @ [$8a]
u16  lastRefRgbR  @ [$8c]
u16  lastRefRgbG  @ [$8e]
u16  lastRefRgbB  @ [$90]
u16  lastMsTick   @ [$92]
u16  eventTimer   @ [$94]
u16 *txTarget     @ [$96]
u16 *rxTarget     @ [$98]
u32 *eepromPtr    @ [$9a] ; never read
u16  msCounter    @ [$9c]
u8   firstSend    @ [$9e]
u8   calAuthOk    @ [$9f]
u8   lastAmbient  @ [$a0]
u8   lastReflect  @ [$a1]
u8   pauseCounter @ [$a2]
u8   syncAttempts @ [$a3]
u8   us10Counter  @ [$a4]
u8   ambientMode  @ [$a5]
u8   txRemaining  @ [$a6]
u8   txActive     @ [$a7]
u8   rxWritePtr   @ [$a8]
u8   rxReadPtr    @ [$a9]
u8   frameLength  @ [$aa]
u8   framePtr     @ [$ab]
u8   frameXor     @ [$ac]

EEPROM variables
----------------

u32 redCoefficient   @ [$4000] ; real value is /1000
u32 greenCoefficient @ [$4008] ; real value is /1000
u32 blueCoefficient  @ [$400c] ; real value is /1000


code
----

0x8092 loop():
  SP -= 0x61

  u16 currentMs = msCounter
  if (currentMs == lastMsTick)
    goto switchEnd
  lastMsTick = currentMs
  eventTimer++
  A = mainState
  if (A ==  1) goto $8106 ; UART restart
  if (A ==  2) goto $8110 ; UART start
  if (A ==  3) goto $8131 ; UART handshake
  if (A ==  4) goto $8671 ; COL-COLOR setup
  if (A ==  5) goto $867b ; COL-COLOR
  if (A ==  6) goto $86a0 ; COL-REFLECT setup
  if (A ==  7) goto $86aa ; COL-REFLECT
  if (A ==  8) goto $86d1 ; COL-AMBIENT setup
  if (A ==  9) goto $86db ; COL-AMBIENT
  if (A == 10) goto $8705 ; REF-RAW setup
  if (A == 11) goto $870e ; REF-RAW
  if (A == 12) goto $8771 ; RGB-RAW setup
  if (A == 13) goto $877f ; RGB-RAW
  if (A == 14) goto $881c ; COL-CAL setup
  if (A == 15) goto $884a ; COL-CAL
  goto switchEnd

0x8106:
; CASE A=1: restart UART
  uart_disable()
  mainState = 2
  eventTimer = 0
  goto switchEnd

0x8110:
; CASE A=2: wait for UART start
  if (eventTimer >= 501) {
    uart_start()
    eventTimer = 0
    syncAttempts = 0
    mainState = 3
    initState = 2
    wdg_refresh()
  }
  goto switchEnd

; CASE A=3: uart handshake
0x8131:
  A = initState
  if (A ==  1) goto $8227
  if (A ==  2) goto $8252
  if (A ==  3) goto $826e
  if (A ==  4) goto $828a
  if (A ==  5) goto $82a6
  if (A ==  6) goto $82c3
  if (A ==  7) goto $82dd
  if (A ==  8) goto $82f7
  if (A ==  9) goto $8313
  if (A == 10) goto $8322
  if (A == 11) goto $833f
  if (A == 12) goto $8359
  if (A == 13) goto $8373
  if (A == 14) goto $838f
  if (A == 15) goto $839e
  if (A == 16) goto $83bb
  if (A == 17) goto $83d5
  if (A == 18) goto $83f4
  if (A == 19) goto $8413
  if (A == 20) goto $8422
  if (A == 21) goto $8444
  if (A == 22) goto $8463
  if (A == 23) goto $8482
  if (A == 24) goto $84a1
  if (A == 25) goto $84c0
  if (A == 26) goto $84cf
  if (A == 27) goto $84f1
  if (A == 28) goto $8510
  if (A == 29) goto $852f
  if (A == 30) goto $854e
  if (A == 31) goto $856d
  if (A == 32) goto $857c
  if (A == 33) goto $859e
  if (A == 34) goto $85bd
  if (A == 35) goto $85dc
  if (A == 36) goto $85fb
  if (A == 37) goto $861e
  if (A == 38) goto $862d
  if (A == 39) goto $864a
  if (A == 40) goto $8659
  goto switchEnd


0x8227: ; sstate 1, receiver will transition this to 2
  if (eventTimer >= 7) {
    u8(SP+1) = 0x00 ; SYNC byte
    if (uartWrite(src=SP+1, len=1)) {
      eventTimer = 0
      syncAttempts++
    }
    if (syncAttempts >= 11) {
      mainState = 1
    }
  }
  goto switchEnd

0x8252: ; sstate 2
  memcpy(SP+1, 0x9bb7, 3)
  if (uartWrite(src=SP+1, len=3))
    initState = 3
  goto switchEnd

0x826e: ; sstate 3
  memcpy(SP+1, 0x9bb3, 4)
  if (uartWrite(src=SP+1, len=4))
    initState = 4
  goto switchEnd

0x828a: ; sstate 4
  memcpy(SP+1, 0x9b98, 6)
  if (uartWrite(src=SP+1, len=6))
    initState = 5
  goto switchEnd

0x82a6: ; sstate 5
  wdg_refresh()
  memcpy(SP+1, 0x9b05, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 6
  goto switchEnd

0x82c3: ; sstate 6
  memcpy(SP+1, 0x9b10, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 7
  goto switchEnd

0x82dd: ; sstate 7
  memcpy(SP+1, 0x9b1b, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 8
  goto switchEnd

0x82f7: ; sstate 8
  memcpy(SP+1, 0x9b83, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 9
    pauseCounter = 0
  }
  goto switchEnd

0x8313: ; sstate 9
  if (++pauseCounter >= 31)
    initState = 10
  goto switchEnd

0x8322: ; sstate 10
  wdg_refresh()
  memcpy(SP+1, 0x9ae4, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 11
  goto switchEnd

0x833f: ; sstate 11
  memcpy(SP+1, 0x9aef, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 12
  goto switchEnd

0x8359: ; sstate 12
  memcpy(SP+1, 0x9afa, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 13
  goto switchEnd

0x8373: ; sstate 13
  memcpy(SP+1, 0x9b7c, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 14
    pauseCounter = 0
  }
  goto switchEnd

0x838f: ; sstate 14
  if (++pauseCounter >= 31)
    initState = 15
  goto switchEnd

0x839e: ; sstate 15
  wdg_refresh()
  memcpy(SP+1, 0x9ac3, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 16
  goto switchEnd

0x83bb: ; sstate 16
  memcpy(SP+1, 0x9ace, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 17
  goto switchEnd

0x83d5: ; sstate 17
  memcpy(SP+1, 0x9ad9, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 18
  goto switchEnd

0x83f4: ; sstate 18
  memcpy(SP+1, 0x9b75, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 19
    pauseCounter = 0
  }
  goto switchEnd

0x8413: ; sstate 19
  if (++pauseCounter >= 31)
    initState = 20
  goto switchEnd

0x8422: ; sstate 20
  wdg_refresh()
  memcpy(SP+1, 0x99c9, 19)
  if (uartWrite(src=SP+1, len=19))
    initState = 21
  goto switchEnd

0x8444: ; sstate 21
  memcpy(SP+1, 0x9aa2, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 22
  goto switchEnd

0x8463: ; sstate 22
  memcpy(SP+1, 0x9aad, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 23
  goto switchEnd

0x8482: ; sstate 23
  memcpy(SP+1, 0x9ab8, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 24
  goto switchEnd

0x84a1: ; sstate 24
  memcpy(SP+1, 0x9b6e, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 25
    pauseCounter = 0
  }
  goto switchEnd

0x84c0: ; sstate 25
  if (++pauseCounter >= 31)
    initState = 26
  goto switchEnd

0x84cf: ; sstate 26
  wdg_refresh()
  memcpy(SP+1, 0x99b6, 19)
  if (uartWrite(src=SP+1, len=19))
    initState = 27
  goto switchEnd

0x84f1: ; sstate 27
  memcpy(SP+1, 0x9a81, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 28
  goto switchEnd

0x8510: ; sstate 28
  memcpy(SP+1, 0x9a8c, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 29
  goto switchEnd

0x852f: ; sstate 29
  memcpy(SP+1, 0x9a97, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 30
  goto switchEnd

0x854e: ; sstate 30
  memcpy(SP+1, 0x9b67, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 31
    pausecounter = 0
  }
  goto switchEnd

0x856d: ; sstate 31
  if (++pauseCounter >= 31)
    initState = 32
  goto switchEnd

0x857c: ; sstate 32
  wdg_refresh()
  memcpy(SP+1, 0x99a3, 19)
  if (uartWrite(src=SP+1, len=19))
    initState = 33
  goto switchEnd

0x859e: ; sstate 33
  memcpy(SP+1, 0x9a60, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 34
  goto switchEnd

0x85bd: ; sstate 34
  memcpy(SP+1, 0x9a6b, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 35
  goto switchEnd

0x85dc: ; sstate 35
  memcpy(SP+1, 0x9a76, 11)
  if (uartWrite(src=SP+1, len=11))
    initState = 36
  goto switchEnd

0x85fb: ; sstate 36
  memcpy(SP+1, 0x9b60, 7)
  if (uartWrite(src=SP+1, len=7)) {
    initState = 37
    pauseCounter = 0
  }
  goto switchEnd

0x861e: ; sstate 37
  if (++pauseCounter >= 31)
    initState = 38
  goto switchEnd

0x862d: ; sstate 38
  frameLength = 0
  u8(SP+1) = 0x04 ; ACK
  if (uartWrite(src=SP+1, len=1)) {
    initState = 39
    eventTimer = 0
  }
  goto switchEnd

0x864a: ; sstate 39, receiver will transition this to 40
  if (eventTimer >= 81) {
    mainState = 1
  }
  goto switchEnd

0x8659: ; sstate 40
  if (enter_high_baudrate()) {
    wdg_refresh()
    initState = 1
    mainState = 6
  }
  goto switchEnd
; end of setup


; CASE A=4 - COL-COLOR setup
0x8671:
  color_setup()
  mainState = 5
  firstSend = 1
  goto switchEnd

; CASE A=5 - COL-COLOR reading
0x867b:
  u8[$00] = measureColorCode()
  if (lastColor != u8[$00]) goto send_col_color
  if (firstSend == 1      ) goto send_col_color
  goto switchEnd
send_col_color:
  lastColor = u8[$00]
  u8(SP+1) = 0xC2
  u8(SP+2) = u8[$00]
  u8(SP+3) = 0xC2 ^ u8[$00] ^ 0xFF
  if (uartWrite(src=SP+1, len=3))
    firstSend = 0
  goto switchEnd


; CASE A=6 - COL-REFLECT setup
0x86a0:
  color_setup()
  mainState = 7
  firstSend = 1
  goto switchEnd

; CASE A=7 - COL-REFLECT reading
0x86aa:
  u8[$00] = measureReflectivity(channel=1)
  if (u8[$00]   != lastReflect) goto send_col_reflect
  if (firstSend == 1          ) goto send_col_reflect
  goto switchEnd
send_col_reflect:
  lastReflect = u8[$00]
  u8(SP+1) = 0xC0
  u8(SP+2) = u8[$00]
  u8(SP+3) = 0xC0 ^ u8[$00] ^ 0xFF
  if (uartWrite(src=SP+1, len=3))
    firstSend = 0
  goto switchEnd


; CASE A=8 - COL-AMBIENT setup
0x86d1:
  ambient_setup()
  mainState = 9
  firstSend = 1
  goto switchEnd

; CASE A=9 - COL-AMBIENT reading
0x86db:
  u8[$00] = measureAmbient()
  if (u8[$00] != lastAmbient) goto send_col_ambient
  if (firstSend == 1        ) goto send_col_ambient
  goto switchEnd
send_col_ambient:
  lastAmbient = u8[$00]
  u8(SP+1) = 0xC1
  u8(SP+2) = u8[$00]
  u8(SP+3) = 0xC1 ^ u8[$00] ^ 0xFF
  if (uartWrite(src=SP+1, len=3))
    firstSend = 0
  goto switchEnd


; CASE A=10 - REF-RAW setup
0x8705:
  color_setup()
  mainState = 11
  firstSend = 1
  goto switchEnd

; CASE A=11 - REF-RAW reading
0x870e: ; measure reflectivity
  measureSingleColor(mode=1, pColor=SP+0x2C, pBlack=SP+0x2A)
  if (u16(SP+0x2c) != lastRefRawFg) goto send_ref_raw
  if (u16(SP+0x2a) != lastRefRawBg) goto send_ref_raw
  if (firstSend    == 1           ) goto send_ref_raw
  goto switchEnd
send_ref_raw:
  lastRefRawFg = u16(SP+0x2c)
  lastRefRawBg = u16(SP+0x2a)
  u8(SP+1) = 0xD3
  u8(SP+2) = u8(SP+0x2d)
  u8(SP+3) = u8(SP+0x2c)
  u8(SP+4) = u8(SP+0x2b)
  u8(SP+5) = u8(SP+0x2a)
  u8(SP+6) = 0xD3 ^ u8(SP+2) ^ u8(SP+3) ^ u8(SP+4) ^ u8(SP+5) ^ 0xFF
  if (uartWrite(src=SP+1, len=6))
    firstSend = 0
  goto switchEnd


; CASE A=12 - RGB-RAW setup
0x8771:
  color_setup()
  mainState = 13
  firstSend = 1
  goto switchEnd

; CASE A=13 - RGB-RAW reading
0x877f: ; measure rgb
  measureAllColors(pRed=SP+0x28, pGreen=SP+0x26, pBlue=SP+0x24, pBlack=SP+0x2e)
  if (u16(SP+0x28) != lastRefRgbR) goto send_rgb_raw
  if (u16(SP+0x26) != lastRefRgbG) goto send_rgb_raw
  if (u16(SP+0x24) != lastRefRgbB) goto send_rgb_raw
  if (firstSend    == 1          ) goto send_rgb_raw
  goto switchEnd
send_rgb_raw:
  lastRefRgbR = u16(SP+0x28)
  lastRefRgbG = u16(SP+0x26)
  lastRefRgbB = u16(SP+0x24)
  u8(SP+1) = 0xDC
  u8(SP+2) = u8(SP+0x29)
  u8(SP+3) = u8(SP+0x28)
  u8(SP+4) = u8(SP+0x27)
  u8(SP+5) = u8(SP+0x26)
  u8(SP+6) = u8(SP+0x25)
  u8(SP+7) = u8(SP+0x24)
  u8(SP+8) = u8(SP+0x2f)
  u8(SP+9) = u8(SP+0x2e)
  u8(SP+10) = 0xDC ^ u8(SP+2) ^ u8(SP+3) \
                   ^ u8(SP+4) ^ u8(SP+5) \
                   ^ u8(SP+6) ^ u8(SP+7) \
                   ^ u8(SP+8) ^ u8(SP+9) \
                   ^ u8(SP+10) \
                   ^ 0xFF ; u8(SP+10) is uninitialized - this is the CRC bug
  if (uartWrite(src=SP+1, len=10))
    firstSend = 0
  goto switchEnd

; CASE A=14 - COL-CAL setup
0x881c:
  color_setup()
  u8(SP+1) = 0xDD
  u8(SP+2) = 0x00
  u8(SP+3) = 0x00
  u8(SP+4) = 0x00
  u8(SP+5) = 0x00
  u8(SP+6) = 0x00
  u8(SP+7) = 0x00
  u8(SP+8) = 0x00
  u8(SP+9) = 0x00
  u8(SP+10) = 0xDD ^ 0xFF
  if (uartWrite(src=SP+1, len=10)) {
    mainState = 15
  }
  goto switchEnd

; CASE A=15 - COL-CAL process
0x884a:
  if (calAuthOk != 1)
    goto switchEnd

  eeprom_export(dst=SP+0x33)
  eeprom_store(src=SP+0x33)
  A = eeprom_import(src=SP+0x33)
  if (!A) goto switchEnd

  u8(SP+1) = 0xDD
  u8(SP+2) = u8(SP+0x36)
  u8(SP+3) = u8(SP+0x35)
  u8(SP+4) = u8(SP+0x3A)
  u8(SP+5) = u8(SP+0x39)
  u8(SP+6) = u8(SP+0x3E)
  u8(SP+7) = u8(SP+0x3D)
  u8(SP+8) = 0x00
  u8(SP+9) = 0x00
  u8(SP+10) = 0xDD ^ u8(SP+2) ^ u8(SP+3) \
                   ^ u8(SP+4) ^ u8(SP+5) \
                   ^ u8(SP+6) ^ u8(SP+7) \
                   ^ 0xFF
  if (uartWrite(src=SP+1, len=10)) {
    calAuthOk = 0
    mainState = 16
  }
  goto switchEnd

; process received bytes
switchEnd:
  Y = SP+0x30
  uart_rx_process(pOut=SP+0x3F, out A)
  compare(A, 0)
  if (A == 0) goto exit

  A = u8(SP+0x3F)
  if (A == 0x02) { ; SYNC byte
    wdg_refresh()
    firstSend = 1
    goto exit
  }

  A = mainState
  if (A ==  3) goto sw2case1 ; handshake
  if (A ==  5) goto sw2case2 ; COL-COLOR
  if (A ==  7) goto sw2case2 ; COL-REFLECT
  if (A ==  9) goto sw2case2 ; COL-AMBIENT
  if (A == 11) goto sw2case2 ; REF-RAW
  if (A == 13) goto sw2case2 ; RGB-RAW
  if (A == 15) goto sw2case2 ; COL-CAL
  goto exit

sw2case1:
  if (initState == 0x01) {
    if (u8(SP+0x3F) == 0x00) ; SYNC
      initState = 2
    goto exit
  }
  if (initState == 0x27) {
    if (u8(SP+0x3F) == 0x04) ; ACK
      initState = 0x28
  }
  goto exit

sw2case2:
  if (u8(SP+0x3f) != 0x43) goto notSelect
  if (u8(SP+0x40) == 0   ) mainState =  6
  if (u8(SP+0x40) == 1   ) mainState =  8
  if (u8(SP+0x40) == 2   ) mainState =  4
  if (u8(SP+0x40) == 3   ) mainState = 10
  if (u8(SP+0x40) == 4   ) mainState = 12
  if (u8(SP+0x40) == 5   ) mainState = 14
  goto exit

notSelect:
  if (!(u8(SP+0x3f) & 0x44)) goto exit
  if (mainState     != 15)     goto exit
  if (u8(SP+0x40) != 'L')    goto exit
  if (u8(SP+0x41) != 'E')    goto exit
  if (u8(SP+0x42) != 'G')    goto exit
  if (u8(SP+0x43) != 'O')    goto exit
  if (u8(SP+0x44) != '-')    goto exit
  if (u8(SP+0x45) != 'F')    goto exit
  if (u8(SP+0x46) != 'A')    goto exit
  if (u8(SP+0x47) != 'C')    goto exit
  if (u8(SP+0x48) != '-')    goto exit
  if (u8(SP+0x49) != 'C')    goto exit
  if (u8(SP+0x4a) != 'A')    goto exit
  if (u8(SP+0x4b) != 'L')    goto exit
  if (u8(SP+0x4c) != '-')    goto exit
  if (u8(SP+0x4d) != '1')    goto exit
  calAuthOk = 1
exit:
  SP += 0x61
  return

0x8ed0 uart_rx_process(u8* pOut in X, ? in Y, u8 newFrame out A):
  u8 currentByte
  u8 xorBytes
  newFrame = 0

  while (rxReadPtr != rxWritePtr) {

    ; consume new byte
    currentByte = rxBuffer[rxReadPtr++]
    if (rxReadPtr == 35)
      rxReadPtr = 0

    ; initialize frame decoding if needed
    if (frameLength == 0) {
      ; system msgs      SYNC                   NACK                   ACK
      if (currentByte == 0x00 || currentByte == 0x02 || currentByte == 0x04) {
        ; => forward immediately
        pOut[0] = currentByte
        newFrame = 1
        continue
      }
      ; calculate expected frame length from first byte
      frameLength = 2 + 1 << ((currentByte >> 3) & 0x07)
      if (frameLength >= 36) {
        ; too long => ignore packet
        frameLength = 0
      } else {
        ; OK, initialize decoding
        frameXor = 0xFF
        frame[0] = currentByte
        framePtr = 1
      }
      continue
    }

    ; continue with reassembly
    frame[framePtr++] = currentByte
    if (framePtr < frameLength)
      continue

    ; reassembly complete
    ; calculate parity + copy to output buffer
    u8* xorPtr = &frame[0]
    for (xorBytes = 0, xorBytes < frameLength-1, xorBytes++) {
      frameXor ^= *xorPtr
      *pOut++   = *xorPtr++
    }

    ; reset frame decoding
    frameLength = 0

    ; check parity
    if (frameXor != frame[xorBytes]) {
      if (txActive)
        while(1) {} ; cannot send NACK, bye bye (= let the holy watchdog save us)

      txBuffer[0] = 0x02 ; NACK
      txTarget    = &txBuffer[0]
      UART1_DR    = txBuffer[0]
      txRemaining = 1
      continue
    }
    newFrame = 1
  }
  return (A = dataFinished)


0x8fbd measureAllColors(u16* pRed in X, u16* pGreen in Y, u16* pBlue in u16[$00], u16* pBlack in u16[$02]):
  u16 black1
  u16 black2

  measureADC(channel=4, dst=&black1, time=4)

  PA_ODR |= (1 << RED1)
  PA_ODR |= (1 << RED2)
  measureADC_timed(channel=4, dst=pRed, time=4)
  PA_ODR &= ~(1 << RED1)
  PA_ODR &= ~(1 << RED2)

  PA_ODR |=  (1 << GREEN1)
  PC_ODR |=  (1 << GREEN2)
  measureADC_timed(channel=4, dst=pGreen, time=4)
  PA_ODR &= ~(1 << GREEN1)
  PC_ODR &= ~(1 << GREEN2)

  PC_ODR |=  (1 << BLUE1)
  PC_ODR |=  (1 << BLUE2)
  measureADC_timed(channel=4, dst=pBlue, time=4)
  PC_ODR &= ~(1 << BLUE1)
  PC_ODR &= ~(1 << BLUE2)

  measureADC_timed(channel=4, dst=&black2, time=4)

  *pBlack = (black1 + black) / 2

  if (*pRed < *pBlack) {
    *pRed = *pBlack - *pRed
  } else {
    *pRed = 0
  }

  if (*pGreen < *pBlack) {
    *pGreen = *pBlack - *pGreen
  } else {
    *pGreen = 0
  }

  if (*pBlue < *pBlack) {
    *pBlue = *pBlack - *pBlue
  } else {
    *pBlue = 0
  }

  return

0x90a4 measureReflectivity(u8 mode in A):
  u16 color ; SP+1
  u16 black ; SP+3

  if (mode == 1) {
    PA_ODR |=  (1 << RED1)
    PA_ODR |=  (1 << RED2)
    measureADC_timed(channel=4, dst=&color, time=12)
    PA_ODR &= ~(1 << RED1)
    PA_ODR &= ~(1 << RED2)
    measureADC_timed(channel=4, dst=&black, time=4)

  } else if (mode == 2) {
    PC_ODR |=  (1 << GREEN1)
    PA_ODR |=  (1 << GREEN2)
    measureADC_timed(channel=4, dst=&color, time=12)
    PC_ODR &= ~(1 << GREEN1)
    PA_ODR &= ~(1 << GREEN2)
    measureADC_timed(channel=4, dst=&black, time=4)

  } else if (mode == 3) {
    PC_ODR |=  (1 << BLUE1)
    PC_ODR |=  (1 << BLUE2)
    measureADC_timed(channel=4, dst=&color, time=12)
    PC_ODR &= ~(1 << BLUE1)
    PC_ODR &= ~(1 << BLUE2)
    measureADC_timed(channel=4, dst=&black, time=4)
  }

  if (color >= black) {
    color = color - black
  } else {
    color = black - color
  }

  A = (u16)( (float) color * redFactor / 4.09f )
  if (A > 100) A = 100
  return

0x9169 gpio_setup():
  ; inputs
  PD_DDR &= ~(1 << COLOR)
  PD_CR1 &= ~(1 << COLOR)
  PD_CR2 &= ~(1 << COLOR)
  PD_DDR &= ~(1 << AMBIENT)
  PD_CR1 &= ~(1 << AMBIENT)
  PD_CR2 &= ~(1 << AMBIENT)

  ; measurement adjusting knobs
  PC_DDR |=  (1 << BRIGHT)
  PC_ODR &= ~(1 << BRIGHT)
  PC_CR1 |=  (1 << BRIGHT)
  PC_DDR &= ~(1 << CAP)
  PC_CR1 &= ~(1 << CAP)
  PC_CR2 &= ~(1 << CAP)

  ; blue led
  PC_DDR |=  (1 << BLUE1)
  PC_ODR &= ~(1 << BLUE1)
  PC_CR1 |=  (1 << BLUE1)
  PC_DDR |=  (1 << BLUE2)
  PC_ODR &= ~(1 << BLUE2)
  PC_CR1 |=  (1 << BLUE2)

  ; green led
  PC_DDR |=  (1 << GREEN1)
  PC_ODR &= ~(1 << GREEN1)
  PC_CR1 |=  (1 << GREEN1)
  PA_DDR |=  (1 << GREEN2)
  PA_ODR &= ~(1 << GREEN2)
  PA_CR1 |=  (1 << GREEN2)

  ; red led
  PA_DDR |=  (1 << RED1)
  PA_ODR &= ~(1 << RED1)
  PA_CR1 |=  (1 << RED1)
  PA_DDR |=  (1 << RED2)
  PA_ODR &= ~(1 << RED2)
  PA_CR1 |=  (1 << RED2)

  ; NC
  PB_DDR |=  (1 << PB4)
  PB_ODR &= ~(1 << PB4)
  PB_CR1 |=  (1 << PB4)

  ; NC
  PB_DDR |=  (1 << PB5)
  PB_ODR &= ~(1 << PB5)
  PB_CR1 |=  (1 << PB5)

  ; NC
  PD_DDR |=  (1 << PD4)
  PD_ODR &= ~(1 << PD4)
  PD_CR1 |=  (1 << PD4)

  ; ADC setup
  ADC_CSR  = 0x04 ; AIN4
  ADC_CR1  = 0x20 ; f_ADC = f_MASTER/4
  ADC_CR1 |= (1 << ADON)
  ADC_TDRL = 0x18 ; AIN3 | AIN4

  ; NC
  PD_DDR |=  (1 << PD4)
  PD_ODR &= ~(1 << PD4)
  PD_CR1 |=  (1 << PD4)
  return


0x9222 identifyColor(u16 red, u16 green, u16 blue, u8 code out A):
  float fRed   = (float) red
  float fGreen = (float) green

  if (red   < 11 && green < 11 && blue  < 11)
    return 0 ; unknown

  if ((fRed / fGreen) >= 2.5f)
    return 5 ; red

  if (red >= 150 && green >= 150 && blue >= 150)
    return 6; white

  if ((fGreen / fRed) >= 2.0f && blue < 101)
    return 3 ; green

  if (blue >= 100)
    return 2 ; blue

  if (red >= 130)
    return 4 ; yellow

  if (red >= 70)
    return 7 ; brown

  return 1 ; black


0x92d9 measureAmbient(u16 brightness out X):
  u16 measurement
  measureADC(channel=3, dst=&measurement)

  if (ambientMode == 1) {
    if (measurement >= 801) {
      PC_DDR |=  (1 << BRIGHT)
      PC_ODR &= ~(1 << BRIGHT)
      PC_CR1 |=  (1 << BRIGHT)
      ambientMode = 2
    }

    for (A = 0, A <= 60, A++) {
      if (LUT1[A] >= measurement)
        break
      brightness = A ; possible off-by-one error
    }

  } else if (ambientMode == 2) {
    if (measurement < 15) {
      PC_DDR &= ~(1 << BRIGHT)
      PC_CR1 &= ~(1 << BRIGHT)
      ambientMode = 1
    }

    for (A = 0, A <= 50, A++) {
      if (LUT2[A] >= measurement)
        break
      brightness = A + 50 ; possible off-by-one error
    }
  }

  PC_ODR |=  (1 << BLUE1)
  PC_ODR |=  (1 << BLUE2)
  measureADC_timed(channel=3, dst=&measurement, time=1)
  PC_ODR &= ~(1 << BLUE1)
  PC_ODR &= ~(1 << BLUE2)
  return

0x9373 measureADC_timed(channel in A, dst in X, time in u8[$00]):
  SP -= 3
  TIM1_IER  = UIE  ; overflow event
  TIM1_ARR  = 160  ; set overflow
  TIM1_CNTR = 0    ; reset counter
  TIM1_CR1  = CEN  ; enable
  us10Counter = 0x00

  while (us10Counter <= (time - 1)) {}

  ADC_CSR &= 0xF0 | channel
  ADC_CSR &= ~(1 << EOC)
  ADC_CR1 |=  (1 << ADON)

  while (us10Counter <= (time + 1)) {}

  TIM1_CR1 &= ~(1 << CEN)

  u16(dst) = (high << 2) | ( low & 0x03 )
  SP += 3
  return


0x940c measureSingleColor(u8 mode in A, u16 *pColor in X, u16 *pBlack in Y):
  if (mode == 1) {
    PA_ODR |=  (1 << RED1)
    PA_ODR |=  (1 << RED2)
    measureADC_timed(channel=4, dst=pColor, time=12)

    PA_ODR &= ~(1 << RED1)
    PA_ODR &= ~(1 << RED2)
    measureADC_timed(channel=4, dst=pBlack, time=4)

  } else if (mode == 2) {
    PC_ODR |=  (1 << GREEN1)
    PA_ODR |=  (1 << GREEN2)
    measureADC_timed(channel=4, dst=pColor, time=12)

    PC_ODR &= ~(1 << GREEN1)
    PA_ODR &= ~(1 << GREEN2)
    measureADC_timed(channel=4, dst=pBlack, time=4)

  } else if (mode == 3) {
    PC_ODR |=  (1 << BLUE1)
    PC_ODR |=  (1 << BLUE2)
    measureADC_timed(channel=4, dst=pColor, time=12)

    PC_ODR &= ~(1 << BLUE1)
    PC_ODR &= ~(1 << BLUE2)
    measureADC_timed(channel=4, dst=pBlack, time=4)
  }
  return

0x9493 eeprom_export(u32 *params):
  u16 red, green, blue, black

  measureAllColors(&red, &green, &blue, &black)

  params[0] = (u32)((409.0f / (float) red  ) * 1000.0f)
  params[1] = (u32)((409.0f / (float) green) * 1000.0f)
  params[2] = (u32)((409.0f / (float) blue ) * 1000.0f)
  return

0x9518 LUT1:
 - [ 0]: 0001
 - [ 1]: 0002
 - [ 2]: 0003
 - [ 3]: 0004
 - [ 4]: 0005
 - [ 5]: 0006
 - [ 6]: 0007
 - [ 7]: 0008
 - [ 8]: 0009
 - [ 9]: 000a
 - [10]: 000b
 - [11]: 000c
 - [12]: 000d
 - [13]: 000f
 - [14]: 0010
 - [15]: 0011
 - [16]: 0013
 - [17]: 0015
 - [18]: 0017
 - [19]: 0019
 - [20]: 001c
 - [21]: 001e
 - [22]: 0021
 - [23]: 0024
 - [24]: 0028
 - [25]: 002b
 - [26]: 0030
 - [27]: 0034
 - [28]: 0039
 - [29]: 003e
 - [30]: 0044
 - [31]: 004b
 - [32]: 0052
 - [33]: 0059
 - [34]: 0062
 - [35]: 006b
 - [36]: 0075
 - [37]: 0080
 - [38]: 008c
 - [39]: 0099
 - [40]: 00a7
 - [41]: 00b7
 - [42]: 00c8
 - [43]: 00db
 - [44]: 00ef
 - [45]: 0106
 - [46]: 011e
 - [47]: 0139
 - [48]: 0156
 - [49]: 0176
 - [50]: 0199
 - [51]: 01bf
 - [52]: 01e9
 - [53]: 0217
 - [54]: 0249
 - [55]: 0280
 - [56]: 02bb
 - [57]: 02fd
 - [58]: 0344
 - [59]: 0392

0x9590 LUT2:
 - [ 0]: 000B
 - [ 1]: 000C
 - [ 2]: 000D
 - [ 3]: 000F
 - [ 4]: 0010
 - [ 5]: 0012
 - [ 6]: 0013
 - [ 7]: 0015
 - [ 8]: 0017
 - [ 9]: 001A
 - [10]: 001C
 - [11]: 001F
 - [12]: 0022
 - [13]: 0025
 - [14]: 0029
 - [15]: 002D
 - [16]: 0031
 - [17]: 0036
 - [18]: 003C
 - [19]: 0041
 - [20]: 0048
 - [21]: 004F
 - [22]: 0056
 - [23]: 005F
 - [24]: 0068
 - [25]: 0072
 - [26]: 007D
 - [27]: 0089
 - [28]: 0097
 - [29]: 00A5
 - [30]: 00B5
 - [31]: 00C7
 - [32]: 00DA
 - [33]: 00EF
 - [34]: 0106
 - [35]: 0120
 - [36]: 013B
 - [37]: 015A
 - [38]: 017B
 - [39]: 01A0
 - [40]: 01C8
 - [41]: 01F4
 - [42]: 0225
 - [43]: 025A
 - [44]: 0294
 - [45]: 02D4
 - [46]: 031A
 - [47]: 0367
 - [48]: 03BB
 - [49]: 0400

0x95f4 eeprom_import(u32 *src):
  redFactor   = (float) src[0] / 1000.0f
  greenFactor = (float) src[1] / 1000.0f
  blueFactor  = (float) src[2] / 1000.0f
  return (A = 1)

0x9657 measureADC(channel in A, dst in X):
  ADC_CSR &= 0xF0
  ADC_CSR |= channel
  ADC_CSR &= (1 << EOC)

  ADC_CSR |= (1 << ADON)
  while (!(ADC_CSR & (1 << EOC))) {}

  u8 high = ADC_DRH
  u8 low  = ADC_DRL

  u16(dst) = (high << 2) | (low & 0x03)
  return

0x96ad adjustRGB(u16* pRed in X, u16* pGreen in Y, u16* pBlue in u16[$00]):
  *pRed   = (u16)( (float)(*pRed)   * redFactor   )
  *pGreen = (u16)( (float)(*pGreen) * greenFactor )
  *pBlue  = (u16)( (float)(*pBlue)  * blueFactor  )
  return

0x973b uartWrite(ptr in X, len in A, status out A):
  if (txActive) goto fail

  if (len > 0)
    memcpy(txBuffer, ptr, len)

  txTarget = &txBuffer[0]
  UART1_DR = txBuffer[0]
  txRemaining = len

  if (len >= 2):
    UART1_CR2 |= (1 << TIEN)
    txActive = 1
  A = 1
  return
fail:
  A = 0
  return


0x977c measureColorCode(out A):
  u16 red, green, blue, black

  measureAllColors(&red, &green, &blue, &black)
  adjustRGB(&red, &green, &blue)
  return identifyColor(red, green, blue)

0x97b8 ambient_setup():
  PA_ODR &= ~(1 << RED1)
  PA_ODR &= ~(1 << RED2)
  PA_ODR &= ~(1 << GREEN1)
  PC_ODR &= ~(1 << GREEN2)
  PC_ODR &= ~(1 << BLUE1)
  PC_ODR &= ~(1 << BLUE2)

  PC_DDR |=  (1 << CAP)
  PC_ODR |=  (1 << CAP)
  PC_CR1 |=  (1 << CAP)

  PC_DDR &= ~(1 << BRIGHT)
  PC_CR1 &= ~(1 << BRIGHT)
  ambientMode = 1
  return

0x97e9 eeprom_store(buf):
  FLASH_DUKR = 0xAE
  FLASH_DUKR = 0x56
  u32[$4000] = u32(buf+0)
  u32[$4004] = u32(buf+4)
  u32[$4008] = u32(buf+8)
  u16[$9a] = 0x4008
  FLASH_IAPSR &= ~(1 << EOP)
  return

0x9869 uart_start:
  UART1_DIV  = 0x1a0a ; 2400 baud
  UART1_CR1  = 0x00
  UART1_CR2  = 1 << TEN
  UART1_CR2 |= 1 << REN
  UART1_CR2 |= 1 << RIEN
  UART1_CR3  = 0
  call reset_rxbuf
  rxReadPtr = 0
  return

0x988d uart_tx_done():
  if (txRemaining == 0) {
    UART1_CR2 &= ~TIEN ; disable tx interrupt
    txActive = 0
    ireturn
  }
  txRemaining--
  if (txRemaining != 0) {
    txTarget++
    UART1_DR = *txTarget
  }
  ireturn

0x98e0 uart_rx_done():
  *rxTarget = UART1_DR
  rxTarget++
  rxWritePtr++
  if (rxWritePtr == 35)
    call reset_rxbuf
  ireturn

0x98fd eeprom_load(buf):
  u32(buf+0) = u32[$4000]
  u32(buf+4) = u32[$4004]
  u32(buf+8) = u32[$4008]
  u16[$9a] = 0x4008
  return

setup_tick():
  CLK_CKDIVR = 0 ; HSI clock = CPU clock = master clock = 16 MHz
  TIM2_CR1   = 1 ; ARPE = 0: do not buffer ARR
                 ; OPM  = 0: do not stop on update
                 ; URS  = 0: enable external update request sources (?)
                 ; UDIS = 0: do not disable update event
                 ; CEN  = 1: enable timer
  TIM2_IER   = 1 ; enable only overflow/update interrupt
  TIM2_PSCR  = 0 ; run at master clock
  TIM2_ARR   = 16000 ; 1 ms tick
  unmask_interrupts()
  return


0x9934 wdg_setup():
  IWDG_KR  = KEY_ENABLE
  IWDG_KR  = KEY_ACCESS
  IWDG_PR  = 0x06 ; /256 prescaler => 250 Hz clock
  IWDG_RLR = 0xFF ; ~ 1 second timeout
  IWDG_KR  = KEY_REFRESH
  IWDG_KR  = KEY_ENABLE
  return

void init_memory():
  memset(at 0x0013, 0x00, 154 bytes)
  lastColor = 0xFF
  mainState = 0x02
  initState = 0x01


0x9964 analog_setup():
  u32 buffer[3]

  call wdg_setup()
  call adc_setup()
  call eeprom_load(buffer)
  call eeprom_import(buffer)
  return

0x9979 adc_setup():
  ADC_CSR &= 0xF0
  ADC_CSR |= AIN4
  ADC_CSR &= ~(1 << EOC)
  ADC_CR1 |=  (1 << ADON)
  return

0x99dc startup():
  SP = 0x03FF
  init_memory()
  mainloop()
  abort_with_errorcode(X)

0x99ef enter_high_baudrate(out A):
  if (txActive) return false

  UART1_DIV = 0x115 ; 57600 baud
  return true


0x9a01 color_setup():
  PC_DDR &= ~(1 << CAP)
  PC_CR1 &= ~(1 << CAP)
  PC_DDR &= ~(1 << BRIGHT)
  PC_CR1 &= ~(1 << BRIGHT)
  return

0x9a12 uart_setup():
  setup_uart_tx_pins()
  PD_DDR &= ~(1 << UART_RX)
  PD_CR1 &= ~(1 << UART_RX)
  PD_CR2 &= ~(1 << UART_RX)
  return

0x9a22 us10_tick():
  TIM1_SR1 &= ~UIF
  us10Counter++
  ireturn

0x9a2f setup_uart_tx_pins():
  PD_DDR |=  (1 << UART_TX)
  PD_ODR &= ~(1 << UART_TX)
  PD_CR1 |=  (1 << UART_TX)
  return

0x9a48 ms_tick():
  TIM2_SR1 &= ~UIF
  msCounter++
  ireturn

0x9a54 main_init1():
  setup_tick()
  gpio_setup()
  analog_setup()
  return


0x9bb7 data: 40 1d a2          ; this is 29 = EV3 Color sensor
0x9bb3 data: 49 05 02 b1       ; 6 modes, 3 views
0x9b98 data: 52 00 e1 00 00 4c ; speed 57600 baud

0x99a3 data: a0 00 C  O  L  -  R  E  F  L  E  C  T  00 00 00 00 00 7d ; name
0x9a60 data: 98 01 00 00 00 00 00 00 c8 42 ec ; raw limits
0x9a6b data: 98 03 00 00 00 00 00 00 c8 42 ee ; si  limits
0x9a76 data: 98 04 p  c  t  00 00 00 00 00 04 ; symbol
0x9b60 data: 90 80 01 00 03 00 ed             ; 1 value, s8, 3 figures, 0 decimals

0x99b6 data: a1 00 C  O  L  -  A  M  B  I  E  N  T  00 00 00 00 00 6b ; name
0x9a81 data: 99 01 00 00 00 00 00 00 c8 42 ed ; raw limits
0x9a8c data: 99 03 00 00 00 00 00 00 c8 42 ef ; si  limits
0x9a97 data: 99 04 p  c  t  00 00 00 00 00 05 ; symbol
0x9b67 data: 91 80 01 00 03 00 ec             ; 1 value, s8, 3 figures, 0 decimals

0x99c9 data: a2 00 C  O  L  -  C  O  L  O  R  00 00 00 00 00 00 00 6d ; name
0x9aa2 data: 9a 01 00 00 00 00 00 00 00 41 25 ; raw limits
0x9aad data: 9a 03 00 00 00 00 00 00 00 41 27 ; si  limits
0x9ab8 data: 9a 04 c  o  l  00 00 00 00 00 01 ; symbol
0x9b6e data: 92 80 01 00 02 00 ee             ; 1 value, s8, 2 figures, 0 decimals

0x9ac3 data: 9b 00 R  E  F  -  R  A  W  00 5c ; name
0x9ace data: 9b 01 00 00 00 00 00 0c 7f 44 52 ; raw limits
0x9ad9 data: 9b 03 00 00 00 00 00 0c 7f 44 50 ; si  limits
0x9b75 data: 93 80 02 01 04 00 eb             ; 2 values, s16, 4 figures, 0 decimals

0x9ae4 data: 9c 00 R  G  B  -  R  A  W  00 5d ; name
0x9aef data: 9c 01 00 00 00 00 00 0c 7f 44 55 ; raw limits
0x9afa data: 9c 03 00 00 00 00 00 0c 7f 44 57 ; si  limits
0x9b7c data: 94 80 03 01 04 00 ed             ; 3 values, s16, 4 figures, 0 decimals

0x9b05 data: 9d 00 C  O  L  -  C  A  L  00 41 ; name
0x9b10 data: 9d 01 00 00 00 00 00 ff 7f 47 a4 ; raw limits
0x9b1b data: 9d 03 00 00 00 00 00 ff 7f 47 a6 ; si  limits
0x9b83 data: 95 80 04 01 05 00 ea             ; 4 values, s16, 5 figures, 0 decimals


0x9b26 reset_rxbuf():
  rxTarget = &rxBuffer[0]
  rxWritePtr = 0
  return

0x9b31 mainloop():
  main_init1()
  uart_setup()
  while (true)
    loop()

0x9b50 uart_disable():
  UART1_CR1 |= (1 << UARTD) ; disable uart
  setup_uart_tx_pins()
  return

0x9ba9 wdg_refresh():
  IWDG_KR = KEY_REFRESH
  return

0x9bba bad_irq():
  while(true) { nop() }

0x9bae abort_with_errorcode(X):
  push(X)
  pop(X)
  while(true) {}