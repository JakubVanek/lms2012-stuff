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
u8   forceSend    @ [$9e]
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

#include "program.h"

void stateMachine() {
  u16 currentMs = msCounter;
  u8 received[?];
  u8 transmit[?];

  if (currentMs == lastMsTick)
    goto switchEnd;

  lastMsTick = currentMs;
  eventTimer++;

  switch((main_state_t) mainState) {
    // disable UART pins to allow the EV3 to detect this sensor using autoid
    case STATE_RESTART:
      uart_disable();
      mainState  = STATE_WAIT_FOR_AUTOID;
      eventTimer = 0;
      break;

    // wait until detection is done; then enable UART and start the handshake
    case STATE_WAIT_FOR_AUTOID:
      if (eventTimer > AUTOID_DELAY) {
        uart_start();
        eventTimer   = 0;
        syncAttempts = 0;
        mainState    = STATE_UART_HANDSHAKE;
        initState    = 2;
        wdg_refresh();
      }
      break;

    // send sensor information to the brick
    case STATE_UART_HANDSHAKE:
      switch ((init_state_t) initState) {

        // wait for sync from brick
        // this state is exited through from the command processing code below the main switch
        case INIT_WAIT_FOR_SYNC:
          if (eventTimer > DELAY_BETWEEN_SYNCS) {
            transmit[0] = MSG_SYS | SYS_SYNC;
            if (uartWrite(transmit, 1) == TX_OK) {
              eventTimer = 0;
              syncAttempts++;
            }
            if (syncAttempts > MAX_SYNC_ATTEMPTS) {
              mainState = STATE_RESTART;
            }
          }
          break;

        // send global sensor information
        case INIT_SENSOR_ID:
          memcpy(transmit, 0x9bb7, 3);
          if (uartWrite(transmit, 3) == TX_OK) initState = INIT_MODES;
          break;

        case INIT_MODES:
          memcpy(transmit, 0x9bb3, 4);
          if (uartWrite(transmit, 4) == TX_OK) initState = INIT_SPEED;
          break;

        case INIT_SPEED:
          memcpy(transmit, 0x9b98, 6);
          if (uartWrite(transmit, 6) == TX_OK) initState = INIT_COL_CAL_NAME;
          break;


        // send COL-CAL info
        case INIT_COL_CAL_NAME:
          wdg_refresh();
          memcpy(transmit, 0x9b05, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_CAL_RAW;
          break;

        case INIT_COL_CAL_RAW:
          memcpy(transmit, 0x9b10, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_CAL_SI;
          break;

        case INIT_COL_CAL_SI:
          memcpy(transmit, 0x9b1b, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_CAL_FORMAT;
          break;

        case INIT_COL_CAL_FORMAT:
          memcpy(transmit, 0x9b83, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_COL_CAL_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_COL_CAL_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_RGB_RAW_NAME;
          break;


        // send RGB-RAW info
        case INIT_RGB_RAW_NAME:
          wdg_refresh();
          memcpy(transmit, 0x9ae4, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_RGB_RAW_RAW;
          break;

        case INIT_RGB_RAW_RAW:
          memcpy(transmit, 0x9aef, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_RGB_RAW_SI;
          break;

        case INIT_RGB_RAW_SI:
          memcpy(transmit, 0x9afa, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_RGB_RAW_FORMAT;
          break;

        case INIT_RGB_RAW_FORMAT:
          memcpy(transmit, 0x9b7c, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_RGB_RAW_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_RGB_RAW_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_REF_RAW_NAME;
          break;


        // send REF-RAW info
        case INIT_REF_RAW_NAME:
          wdg_refresh();
          memcpy(transmit, 0x9ac3, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_REF_RAW_RAW;
          break;

        case INIT_REF_RAW_RAW:
          memcpy(transmit, 0x9ace, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_REF_RAW_SI;
          break;

        case INIT_REF_RAW_SI:
          memcpy(transmit, 0x9ad9, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_REF_RAW_FORMAT;
          break;

        case INIT_REF_RAW_FORMAT:
          memcpy(transmit, 0x9b75, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_REF_RAW_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_REF_RAW_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_COL_COLOR_NAME;
          break;


        // send COL-COLOR info
        case INIT_COL_COLOR_NAME:
          wdg_refresh();
          memcpy(transmit, 0x99c9, 19);
          if (uartWrite(transmit, 19) == TX_OK) initState = INIT_COL_COLOR_RAW;
          break;

        case INIT_COL_COLOR_RAW:
          memcpy(transmit, 0x9aa2, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_COLOR_SI;
          break;

        case INIT_COL_COLOR_SI:
          memcpy(transmit, 0x9aad, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_COLOR_SYMBOL;
          break;

        case INIT_COL_COLOR_SYMBOL:
          memcpy(transmit, 0x9ab8, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_COLOR_FORMAT;
          break;

        case INIT_COL_COLOR_FORMAT:
          memcpy(transmit, 0x9b6e, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_COL_COLOR_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_COL_COLOR_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_COL_AMBIENT_NAME;
          break;


        // send COL-AMBIENT info
        case INIT_COL_AMBIENT_NAME:
          wdg_refresh();
          memcpy(transmit, 0x99b6, 19);
          if (uartWrite(transmit, 19) == TX_OK) initState = INIT_COL_AMBIENT_RAW;
          break;

        case INIT_COL_AMBIENT_RAW:
          memcpy(transmit, 0x9a81, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_AMBIENT_SI;
          break;

        case INIT_COL_AMBIENT_SI:
          memcpy(transmit, 0x9a8c, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_AMBIENT_SYMBOL;
          break;

        case INIT_COL_AMBIENT_SYMBOL:
          memcpy(transmit, 0x9a97, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_AMBIENT_FORMAT;
          break;

        case INIT_COL_AMBIENT_FORMAT:
          memcpy(transmit, 0x9b67, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_COL_AMBIENT_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_COL_AMBIENT_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_COL_REFLECT_NAME;
          break;


        // send COL-REFLECT info
        case INIT_COL_REFLECT_NAME:
          wdg_refresh();
          memcpy(transmit, 0x99a3, 19);
          if (uartWrite(transmit, 19) == TX_OK) initState = INIT_COL_REFLECT_RAW;
          break;

        case INIT_COL_REFLECT_RAW:
          memcpy(transmit, 0x9a60, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_REFLECT_SI;
          break;

        case INIT_COL_REFLECT_SI:
          memcpy(transmit, 0x9a6b, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_REFLECT_SYMBOL;
          break;

        case INIT_COL_REFLECT_SYMBOL:
          memcpy(transmit, 0x9a76, 11);
          if (uartWrite(transmit, 11) == TX_OK) initState = INIT_COL_REFLECT_FORMAT;
          break;

        case INIT_COL_REFLECT_FORMAT:
          memcpy(transmit, 0x9b60, 7);
          if (uartWrite(transmit, 7) == TX_OK) {
            initState    = INIT_COL_REFLECT_PAUSE;
            pauseCounter = 0;
          } break;

        case INIT_COL_REFLECT_PAUSE:
          if (++pauseCounter > INTERMODE_PAUSE) initState = INIT_SEND_ACK;
          break;


        // finalize handshake - send ACK
        case INIT_SEND_ACK:
          frameLength = 0; // initialize incoming frame decoding

          transmit[0] = MSG_ACK;
          if (uartWrite(transmit, 1) == TX_OK) {
            initState  = INIT_WAIT_FOR_ACK;
            eventTimer = 0;
          }
          break;

        // wait for ACK reploy
        // this state is exited through the command processing code below the main switch
        case INIT_WAIT_FOR_ACK:
          if (eventTimer > ACK_TIMEOUT) {
            mainState = STATE_RESTART;
          }
          break;

        case INIT_START_DATA:
          if (enter_high_baudrate() == TX_OK) {
            wdg_refresh();
            initState = INIT_WAIT_FOR_SYNC;
            mainState = STATE_REFLECT_SETUP;
          }
          break;
      }
      break;

    // prepare COL-COLOR mode
    case STATE_COLORID_SETUP: {
      color_setup();
      mainState = STATE_COLORID_RUNNING;
      forceSend = true;
      break;
    }

    // do measurements in COL-COLOR mode
    case STATE_COLORID_RUNNING: {
      u8 newColor = measureColorCode();
      if (newColor != lastColor || forceSend) {

        lastColor = newColor;
        transmit[0] = DATA_MSG(COL_CAL) | MSGLEN_1;
        transmit[1] = newColor;
        transmit[2] = transmit[0] ^ transmit[1] ^ 0xFF;

        if (uartWrite(transmit, 3) == TX_OK) {
          forceSend = false;
        }
      }
      break;
    }

    // prepare COL-REFLECT mode
    case STATE_REFLECT_SETUP: {
      color_setup();
      mainState = STATE_REFLECT_RUNNING;
      forceSend = true;
      break;
    }

    // do measurements in COL-REFLECT mode
    case STATE_REFLECT_RUNNING: {
      u8 newReflect = measureReflectivity(LED_RED);
      if (newReflect != lastReflect || forceSend) {

        lastReflect = newReflect;
        transmit[0] = DATA_MSG(COL_REFLECT) | MSGLEN_1;
        transmit[1] = newReflect;
        transmit[2] = transmit[0] ^ transmit[1] ^ 0xFF;

        if (uartWrite(transmit, 3) == TX_OK) {
          forceSend = false;
        }
      }
      break;
    }

    // prepare COL-AMBIENT mode
    case STATE_AMBIENT_SETUP: {
      ambient_setup();
      mainState = STATE_AMBIENT_RUNNING;
      forceSend = true;
      break;
    }

    // do measurements in COL-AMBIENT mode
    case STATE_AMBIENT_RUNNING: {
      u8 newAmbient = measureAmbient();
      if (newAmbient != lastAmbient || forceSend) {

        lastAmbient = newAmbient;
        transmit[0] = DATA_MSG(COL_AMBIENT) | MSGLEN_1;
        transmit[1] = newAmbient;
        transmit[2] = transmit[0] ^ transmit[1] ^ 0xFF;

        if (uartWrite(transmit, 3) == TX_OK) {
          forceSend = false;
        }
      }
      break;
    }

    // prepare REF-RAW mode
    case STATE_REFRAW_SETUP: {
      color_setup();
      mainState = STATE_REFRAW_RUNNING;
      forceSend = true;
      break;
    }

    // do measurements in REF-RAW mode
    case STATE_REFRAW_RUNNING: {
      u16 reflect, background;
      measureSingleColor(LED_RED, &reflect, &background);

      if (reflect != lastRefRawFg || reflect != lastRefRawBg || forceSend) {
        lastRefRawFg = reflect;
        lastRefRawBg = background;

        transmit[0] = DATA_MSG(REF_RAW) | MSGLEN_4;
        transmit[1] = reflect     & 0xFF;
        transmit[2] = reflect    >> 8;
        transmit[3] = background  & 0xFF;
        transmit[4] = background >> 8;
        transmit[5] = transmit[0] ^ transmit[1] ^ transmit[2] ^ transmit[3] ^ transmit[4] ^ 0xFF;

        if (uartWrite(transmit, 6) == TX_OK) {
          forceSend = false;
        }
      }
      break;
    }

    // prepare RGB-RAW mode
    case STATE_RGBRAW_SETUP: {
      color_setup();
      mainState = STATE_RGBRAW_RUNNING;
      forceSend = true;
      break;
    }

    // do measurements in RGB-RAW mode
    case STATE_RGBRAW_RUNNING: {
      u16 red, green, blue, background;
      measureAllColors(&red, &green, &blue, &background);

      if (red != lastRefRgbR || green != lastRefRgbG || blue != lastRefRgbB || forceSend) {
        lastRefRgbR = red;
        lastRefRgbG = green;
        lastRefRgbB = blue;

        transmit[0] = DATA_MSG(RGB_RAW) | MSGLEN_8;
        transmit[1] = red    & 0xFF;
        transmit[2] = red   >> 8;
        transmit[3] = green  & 0xFF;
        transmit[4] = green >> 8;
        transmit[5] = blue   & 0xFF;
        transmit[6] = blue  >> 8;
        transmit[7] = black  & 0xFF;
        transmit[8] = black >> 8;
        transmit[9] = transmit[0] ^ transmit[1] ^
                      transmit[2] ^ transmit[3] ^
                      transmit[4] ^ transmit[5] ^
                      transmit[6] ^ transmit[7] ^ // this is the checksum bug:
                      transmit[8] ^ transmit[9] ^ // transmit[9] is not initialized to zero
                      0xFF;                       // instead it contains the old check byte

        if (uartWrite(transmit, 10) == TX_OK) {
          forceSend = false;
        }
      }
      break;
    }

    // answer calibration request
    case STATE_CALIBRATE_SETUP: {
      color_setup();

      transmit[0] = DATA_MSG(COL_CAL) | MSGLEN_8;
      transmit[1] = 0x00;
      transmit[2] = 0x00;
      transmit[3] = 0x00;
      transmit[4] = 0x00;
      transmit[5] = 0x00;
      transmit[6] = 0x00;
      transmit[7] = 0x00;
      transmit[8] = 0x00;
      transmit[9] = transmit[0] ^ 0xFF;

      if (uartWrite(transmit, 10) == TX_OK) {
        mainState = STATE_CALIBRATE_RUNNING;
      }
      break;
    }

    // calibrate after a valid authentication message is received
    case STATE_CALIBRATE_RUNNING: {
      if (!calAuthOk)
        break;

      u32 params[3];

      // calibrate
      doCalibration(params);
      // store
      saveEeprom(params);
      // reload
      u8 ok = importCalibration(params);
      if (!ok)
        break;

      transmit[0] = DATA_MSG(COL_CAL) | MSGLEN_8;
      transmit[1] = (params[0]     ) & 0xFF;
      transmit[2] = (params[0] >> 8) & 0xFF;
      transmit[3] = (params[1]     ) & 0xFF;
      transmit[4] = (params[1] >> 8) & 0xFF;
      transmit[5] = (params[2]     ) & 0xFF;
      transmit[6] = (params[2] >> 8) & 0xFF;
      transmit[7] = 0x00;
      transmit[8] = 0x00;
      transmit[9] = transmit[0] ^ transmit[1] ^
                    transmit[2] ^ transmit[3] ^
                    transmit[4] ^ transmit[5] ^
                    transmit[6] ^ 0xFF; // zero bytes are not XORed

      if (uartWrite(transmit, 10) == TX_OK) {
        calAuthOk = false;
        mainState = STATE_CALIBRATE_DONE;
      }
    }
  }

switchEnd:

  bool hasNewData = uart_rx_process(received);
  if (!hasNewData)
    return;

  // NACK => resend data + refresh watchdog
  if (received[0] == NACK_MSG) {
    wdg_refresh();
    forceSend = true;
    return;
  }

  switch ((main_state_t) mainState) {
    // handle brick messages in handshake
    case STATE_UART_HANDSHAKE: {
      if (initState == INIT_WAIT_FOR_SYNC && received[0] == SYNC_MSG) {
        initState = INIT_SENSOR_ID;
      }
      if (initState == INIT_WAIT_FOR_ACK  && received[0] == ACK_MSG) {
        initState = INIT_START_DATA;
      }
      break;
    }

    // handle brick messages in running condition
    case STATE_COLORID_RUNNING:
    case STATE_REFLECT_RUNNING:
    case STATE_AMBIENT_RUNNING:
    case STATE_REFRAW_RUNNING:
    case STATE_RGBRAW_RUNNING:
    case STATE_CALIBRATE_RUNNING: {
      // modeswitch
      if (received[0] == SELECT_MSG) {
        if (received[1] == COL_REFLECT) mainState = STATE_REFLECT_SETUP;
        if (received[1] == COL_AMBIENT) mainState = STATE_AMBIENT_SETUP;
        if (received[1] == COL_COLOR)   mainState = STATE_COLORID_SETUP;
        if (received[1] == REF_RAW)     mainState = STATE_REFRAW_SETUP;
        if (received[1] == RGB_RAW)     mainState = STATE_RGBRAW_SETUP;
        if (received[1] == COL_CAL)     mainState = STATE_CALIBRATE_SETUP;

      } else if ((received[0] & WRITE_MSG) == WRITE_MSG) {
        // check for calibration authentication message
        if (mainState == STATE_CALIBRATE_RUNNING &&
              memcmp(&received[1], "LEGO-FAC-CAL-1", 14) == 0) {
          calAuthOk = 1;
        }
      }
      break;
    }
  }
  return;
}

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
  u16 color
  u16 black

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

// at address 0x9493
void doCalibration(u32 *params) {
  u16 red, green, blue, black;

  measureAllColors(&red, &green, &blue, &black);

  params[0] = (u32)((409.0f / (float) red  ) * 1000.0f);
  params[1] = (u32)((409.0f / (float) green) * 1000.0f);
  params[2] = (u32)((409.0f / (float) blue ) * 1000.0f);
  return;
}

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

// at address 0x95f4
u8 importCalibration(u32 *params) {
  redFactor   = (float) params[0] / 1000.0f;
  greenFactor = (float) params[1] / 1000.0f;
  blueFactor  = (float) params[2] / 1000.0f;
  return true;
}

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

// at address 0x97e9
void saveEeprom(u32 *params) {
  FLASH_DUKR = 0xAE;
  FLASH_DUKR = 0x56;

  *((u32*) 0x4000) = params[0];
  *((u32*) 0x4004) = params[1];
  *((u32*) 0x4008) = params[2];

  FLASH_IAPSR &= ~(1 << EOP);
  return;
}

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

// at address 0x98fd
void loadEeprom(u32 *params) {
  params[0] = *((u32*) 0x4000);
  params[1] = *((u32*) 0x4004);
  params[2] = *((u32*) 0x4008);
  eepromPtr = (u32*) 0x4008; // unused
  return;
}

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
  u32 params[3];

  call wdg_setup()
  call adc_setup()
  loadEeprom(params);
  importCalibration(params);
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
    stateMachine()

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
