// interrupt table
// ---------------
// RESET          =>  startup       @0x99dc
// TIM1 overflow  =>  us10_tick     @0x9a22
// TIM2 overflow  =>  ms_tick       @0x9a48
// UART byte TX   =>  uart_tx_done  @0x988d
// UART byte RX   =>  uart_rx_done  @0x98e0
// all other      =>  bad_irq       @0x9bba

#include "program.h"
#include "io.h"

// global RAM variables
// --------------------
// pseudo-variables
// u8 callerSavedRegs[8]; // @ [$00]
// u8 calleeSavedRegs[8]; // @ [$08]

// real variables
u8   lastColor;    // @ [$10]
u8   mainState;    // @ [$11]
u8   initState;    // @ [$12]
u8   rxBuffer[35]; // @ [$13]
u8   txBuffer[35]; // @ [$36]
u8   frame[35];    // @ [$59]
f32  redFactor;    // @ [$7c]
f32  greenFactor;  // @ [$80]
f32  blueFactor;   // @ [$84]
u16  lastRefRawFg; // @ [$88]
u16  lastRefRawBg; // @ [$8a]
u16  lastRefRgbR;  // @ [$8c]
u16  lastRefRgbG;  // @ [$8e]
u16  lastRefRgbB;  // @ [$90]
u16  lastMsTick;   // @ [$92]
u16  eventTimer;   // @ [$94]
u16 *txTarget;     // @ [$96]
u16 *rxTarget;     // @ [$98]
u32 *eepromPtr;    // @ [$9a] ; never read
u16  msCounter;    // @ [$9c]
u8   forceSend;    // @ [$9e]
u8   calAuthOk;    // @ [$9f]
u8   lastAmbient;  // @ [$a0]
u8   lastReflect;  // @ [$a1]
u8   pauseCounter; // @ [$a2]
u8   syncAttempts; // @ [$a3]
u8   us10Counter;  // @ [$a4]
u8   ambientMode;  // @ [$a5]
u8   txRemaining;  // @ [$a6]
u8   txActive;     // @ [$a7]
u8   rxWritePtr;   // @ [$a8]
u8   rxReadPtr;    // @ [$a9]
u8   frameLength;  // @ [$aa]
u8   framePtr;     // @ [$ab]
u8   frameXor;     // @ [$ac]

// EEPROM variables
// ----------------

#define EEPROM_RED_COEF (*((u32*) 0x4000))
#define EEPROM_GRN_COEF (*((u32*) 0x4004))
#define EEPROM_BLU_COEF (*((u32*) 0x400c))

// code
// ----

// todos:
// - convert data to C syntax
// - reorder functions for better readability
// - unify naming convention
// - check if this thing compiles

void stateMachine() {
  u16 currentMs = msCounter;
  u8 received[35];
  u8 transmit[35];

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
            transmit[0] = SYNC_MSG;
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
        transmit[0] = MSG_DATA | COL_COLOR | MSGLEN_1;
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
        transmit[0] = MSG_DATA | COL_REFLECT | MSGLEN_1;
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
        transmit[0] = MSG_DATA | COL_AMBIENT | MSGLEN_1;
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

      if (reflect != lastRefRawFg || background != lastRefRawBg || forceSend) {
        lastRefRawFg = reflect;
        lastRefRawBg = background;

        transmit[0] = MSG_DATA | REF_RAW | MSGLEN_4;
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

        transmit[0] = MSG_DATA | RGB_RAW | MSGLEN_8;
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

      transmit[0] = MSG_DATA | COL_CAL | MSGLEN_8;
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

      transmit[0] = MSG_DATA | COL_CAL | MSGLEN_8;
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
}

// at address 0x8ed0
u8 uart_rx_process(u8* pOut) {
  u8 newFrame = false;

  while (rxReadPtr != rxWritePtr) {

    // consume new byte
    u8 received = rxBuffer[rxReadPtr++];
    if (rxReadPtr == 35) {
      rxReadPtr = 0;
    }

    // initialize frame decoding if needed
    if (frameLength == 0) {
      // forward short SYS messages
      if (received == SYNC_MSG || received == NACK_MSG || received == ACK_MSG) {
        pOut[0] = received;
        newFrame = true;
        continue;
      }

      // calculate expected frame length from first byte
      frameLength = 2 + 1 << ((received >> 3) & 0x07);
      if (frameLength >= 36) { // too long
        frameLength = 0;
      } else {
        // OK, initialize decoding
        frameXor = 0xFF;
        frame[0] = received;
        framePtr = 1;
      }
      // look for more bytes
      continue;
    }

    // continue with reassembly
    frame[framePtr++] = received;
    if (framePtr < frameLength)
      continue;

    // reassembly complete
    // calculate check byte + copy to output buffer
    u8* xorPtr = &frame[0];
    u8 xorCount;
    for (xorCount = 0, xorCount < frameLength-1, xorCount++) {
      frameXor ^= *xorPtr;
      *pOut++   = *xorPtr++;
    }

    // reset frame decoding
    frameLength = 0;

    // verify check byte
    if (frameXor != frame[xorCount]) {
      if (txActive) {
        while(1) {} // cannot send NACK, let the watchdog expire
      }

      txBuffer[0] = NACK_MSG;
      txTarget    = &txBuffer[0];
      UART1_DR    = txBuffer[0];
      txRemaining = 1;
      continue;
    }
    newFrame = true;
  }
  return newFrame;
}

// at address 0x8fbd
void measureAllColors(u16* pRed, u16* pGreen, u16* pBlue, u16* pBlack) {
  u16 black1, black2;

  measureADC(ADC_COLOR, &black1, 4);

  PA_ODR |= (1 << RED1);
  PA_ODR |= (1 << RED2);
  measureADC_timed(ADC_COLOR, pRed, 4);
  PA_ODR &= ~(1 << RED1);
  PA_ODR &= ~(1 << RED2);

  PA_ODR |=  (1 << GREEN1);
  PC_ODR |=  (1 << GREEN2);
  measureADC_timed(ADC_COLOR, pGreen, 4);
  PA_ODR &= ~(1 << GREEN1);
  PC_ODR &= ~(1 << GREEN2);

  PC_ODR |=  (1 << BLUE1);
  PC_ODR |=  (1 << BLUE2);
  measureADC_timed(ADC_COLOR, pBlue, 4);
  PC_ODR &= ~(1 << BLUE1);
  PC_ODR &= ~(1 << BLUE2);

  measureADC_timed(ADC_COLOR, &black2, 4);

  *pBlack = (black1 + black) / 2;

  if (*pRed < *pBlack) {
    *pRed = *pBlack - *pRed;
  } else {
    *pRed = 0;
  }

  if (*pGreen < *pBlack) {
    *pGreen = *pBlack - *pGreen;
  } else {
    *pGreen = 0;
  }

  if (*pBlue < *pBlack) {
    *pBlue = *pBlack - *pBlue;
  } else {
    *pBlue = 0;
  }
}

// at address 0x90a4
u8 measureReflectivity(led_t mode) {
  u16 color, black;

  if (mode == LED_RED) {
    PA_ODR |=  (1 << RED1);
    PA_ODR |=  (1 << RED2);
    measureADC_timed(ADC_COLOR, &color, 12);
    PA_ODR &= ~(1 << RED1);
    PA_ODR &= ~(1 << RED2);
    measureADC_timed(ADC_COLOR, &black, 4);

  } else if (mode == LED_GREEN) {
    PC_ODR |=  (1 << GREEN1);
    PA_ODR |=  (1 << GREEN2);
    measureADC_timed(ADC_COLOR, &color, 12);
    PC_ODR &= ~(1 << GREEN1);
    PA_ODR &= ~(1 << GREEN2);
    measureADC_timed(ADC_COLOR, &black, 4);

  } else if (mode == LED_BLUE) {
    PC_ODR |=  (1 << BLUE1);
    PC_ODR |=  (1 << BLUE2);
    measureADC_timed(ADC_COLOR, &color, 12);
    PC_ODR &= ~(1 << BLUE1);
    PC_ODR &= ~(1 << BLUE2);
    measureADC_timed(ADC_COLOR, &black, 4);
  }

  if (color >= black) {
    color = color - black;
  } else {
    color = black - color;
  }

  u8 result  = (u16)( (float) color * redFactor / 4.09f );
  if (result > 100)
    result = 100;

  return result;
}

// at address 0x9169
void gpio_setup() {
  // inputs
  PD_DDR &= ~(1 << COLOR);
  PD_CR1 &= ~(1 << COLOR);
  PD_CR2 &= ~(1 << COLOR);
  PD_DDR &= ~(1 << AMBIENT);
  PD_CR1 &= ~(1 << AMBIENT);
  PD_CR2 &= ~(1 << AMBIENT);

  // measurement adjusting knobs
  PC_DDR |=  (1 << BRIGHT);
  PC_ODR &= ~(1 << BRIGHT);
  PC_CR1 |=  (1 << BRIGHT);
  PC_DDR &= ~(1 << CAP);
  PC_CR1 &= ~(1 << CAP);
  PC_CR2 &= ~(1 << CAP);

  // blue led
  PC_DDR |=  (1 << BLUE1);
  PC_ODR &= ~(1 << BLUE1);
  PC_CR1 |=  (1 << BLUE1);
  PC_DDR |=  (1 << BLUE2);
  PC_ODR &= ~(1 << BLUE2);
  PC_CR1 |=  (1 << BLUE2);

  // green led
  PC_DDR |=  (1 << GREEN1);
  PC_ODR &= ~(1 << GREEN1);
  PC_CR1 |=  (1 << GREEN1);
  PA_DDR |=  (1 << GREEN2);
  PA_ODR &= ~(1 << GREEN2);
  PA_CR1 |=  (1 << GREEN2);

  // red led
  PA_DDR |=  (1 << RED1);
  PA_ODR &= ~(1 << RED1);
  PA_CR1 |=  (1 << RED1);
  PA_DDR |=  (1 << RED2);
  PA_ODR &= ~(1 << RED2);
  PA_CR1 |=  (1 << RED2);

  // NC
  PB_DDR |=  (1 << PB4);
  PB_ODR &= ~(1 << PB4);
  PB_CR1 |=  (1 << PB4);

  // NC
  PB_DDR |=  (1 << PB5);
  PB_ODR &= ~(1 << PB5);
  PB_CR1 |=  (1 << PB5);

  // NC
  PD_DDR |=  (1 << PD4);
  PD_ODR &= ~(1 << PD4);
  PD_CR1 |=  (1 << PD4);

  // ADC setup
  ADC_CSR  = 0x04;        // AIN4
  ADC_CR1  = 0x20;        // f_ADC = f_MASTER/4
  ADC_CR1 |= (1 << ADON); // enable
  ADC_TDRL = 0x18;        // AIN3 | AIN4

  // NC
  PD_DDR |=  (1 << PD4);
  PD_ODR &= ~(1 << PD4);
  PD_CR1 |=  (1 << PD4);
}

// at address 0x9222
color_code_t identifyColor(u16 red, u16 green, u16 blue) {
  float fRed   = (float) red;
  float fGreen = (float) green;

  if (red < 11 && green < 11 && blue < 11)
    return COLOR_NONE;

  if ((fRed / fGreen) >= 2.5f)
    return COLOR_RED;

  if (red >= 150 && green >= 150 && blue >= 150)
    return COLOR_WHITE;

  if ((fGreen / fRed) >= 2.0f && blue < 101)
    return COLOR_GREEN;

  if (blue >= 100)
    return COLOR_BLUE;

  if (red >= 130)
    return COLOR_YELLOW;

  if (red >= 70)
    return COLOR_BROWN;

  return COLOR_BLACK;
}

// at address 0x92d9
u16 measureAmbient(u16 brightness out X) {
  u16 measurement;
  measureADC(ADC_AMBIENT, &measurement);

  if (ambientMode == AMBIENT_DARK) {
    if (measurement >= 801) {
      PC_DDR |=  (1 << BRIGHT);
      PC_ODR &= ~(1 << BRIGHT);
      PC_CR1 |=  (1 << BRIGHT);
      ambientMode = AMBIENT_BRIGHT;
    }

    brightness = 0;
    for (u8 i = 0, i <= 60, i++) {
      if (LUT1[i] >= measurement)
        break;
      brightness = i; // possible off-by-one error in translation to C
    }

  } else if (ambientMode == AMBIENT_BRIGHT) {
    if (measurement < 15) {
      PC_DDR &= ~(1 << BRIGHT);
      PC_CR1 &= ~(1 << BRIGHT);
      ambientMode = AMBIENT_DARK;
    }

    brightness = 50;
    for (u8 i = 0, i <= 50, i++) {
      if (LUT2[i] >= measurement)
        break;
      brightness = i + 50; // possible off-by-one error in translation to C
    }
  }

  // dummy measurement for blue glow
  PC_ODR |=  (1 << BLUE1);
  PC_ODR |=  (1 << BLUE2);
  measureADC_timed(ADC_AMBIENT, &measurement, 1);
  PC_ODR &= ~(1 << BLUE1);
  PC_ODR &= ~(1 << BLUE2);
}

// at address 0x9373
void measureADC_timed(adc_channel_t channel, u16 *pDst, u8 time) {
  TIM1_IER  = UIE;  // overflow event
  TIM1_ARR  = 160;  // set overflow
  TIM1_CNTR = 0;    // reset value
  TIM1_CR1  = CEN;  // enable timer
  us10Counter = 0;

  while (us10Counter <= (time - 1)) {}

  ADC_CSR &= 0xF0;         // unset channel
  ADC_CSR |= channel;      // set channel
  ADC_CSR &= ~(1 << EOC);  // clear end-of-conversion
  ADC_CR1 |=  (1 << ADON); // start new conversion

  while (us10Counter <= (time + 1)) {}

  TIM1_CR1 &= ~(1 << CEN); // disable timer

  u8 high = ADC_DRH;
  u8 low  = ADC_DRL;
  *pDst = (high << 2) | ( low & 0x03 );
}


// at address 0x940c
void measureSingleColor(led_t mode, u16 *pColor, u16 *pBlack) {
  if (mode == LED_RED) {
    PA_ODR |=  (1 << RED1);
    PA_ODR |=  (1 << RED2);
    measureADC_timed(ADC_COLOR, pColor, 12);

    PA_ODR &= ~(1 << RED1);
    PA_ODR &= ~(1 << RED2);
    measureADC_timed(ADC_COLOR, pBlack, 4);

  } else if (mode == LED_GREEN) {
    PC_ODR |=  (1 << GREEN1);
    PA_ODR |=  (1 << GREEN2);
    measureADC_timed(ADC_COLOR, pColor, 12);

    PC_ODR &= ~(1 << GREEN1);
    PA_ODR &= ~(1 << GREEN2);
    measureADC_timed(ADC_COLOR, pBlack, 4);

  } else if (mode == LED_BLUE) {
    PC_ODR |=  (1 << BLUE1);
    PC_ODR |=  (1 << BLUE2);
    measureADC_timed(ADC_COLOR, pColor, 12);

    PC_ODR &= ~(1 << BLUE1);
    PC_ODR &= ~(1 << BLUE2);
    measureADC_timed(ADC_COLOR, pBlack, 4);
  }
}

// at address 0x9493
void doCalibration(u32 *params) {
  u16 red, green, blue, black;

  measureAllColors(&red, &green, &blue, &black);

  params[0] = (u32)((409.0f / (float) red  ) * 1000.0f);
  params[1] = (u32)((409.0f / (float) green) * 1000.0f);
  params[2] = (u32)((409.0f / (float) blue ) * 1000.0f);
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

// at address 0x9657
void measureADC(adc_channel_t channel, u16 *pDst) {
  ADC_CSR &= 0xF0;        // unset channel
  ADC_CSR |= channel;     // set channel
  ADC_CSR &= (1 << EOC);  // clear end-of-conversion
  ADC_CSR |= (1 << ADON); // start conversion

  // wait until done
  while (!(ADC_CSR & (1 << EOC))) {}

  u8 high = ADC_DRH;
  u8 low  = ADC_DRL;

  *pDst = (high << 2) | (low & 0x03);
}

// at address 0x96ad
void adjustRGB(u16* pRed, u16* pGreen, u16* pBlue) {
  *pRed   = (u16)( (float)(*pRed)   * redFactor   );
  *pGreen = (u16)( (float)(*pGreen) * greenFactor );
  *pBlue  = (u16)( (float)(*pBlue)  * blueFactor  );
}

// at address 0x973b
tx_status_t uartWrite(u8 *data, u8 length) {
  if (txActive)
    return TX_BUSY;

  if (length > 0)
    memcpy(txBuffer, data, length);

  // prepare circular buffer for transmission
  txTarget = &txBuffer[0];
  UART1_DR = txBuffer[0];
  txRemaining = length;

  // only enable interrupt if there are >1 bytes to send
  if (length >= 2) {
    UART1_CR2 |= (1 << TIEN);
    txActive = 1;
  }

  return TX_OK;
}

// at address 0x977c
color_code_t measureColorCode() {
  u16 red, green, blue, black;

  measureAllColors(&red, &green, &blue, &black);
  adjustRGB(&red, &green, &blue);
  return identifyColor(red, green, blue);
}

// at address 0x97b8
void ambient_setup() {
  PA_ODR &= ~(1 << RED1);
  PA_ODR &= ~(1 << RED2);
  PA_ODR &= ~(1 << GREEN1);
  PC_ODR &= ~(1 << GREEN2);
  PC_ODR &= ~(1 << BLUE1);
  PC_ODR &= ~(1 << BLUE2);

  PC_DDR |=  (1 << CAP);
  PC_ODR |=  (1 << CAP);
  PC_CR1 |=  (1 << CAP);

  PC_DDR &= ~(1 << BRIGHT);
  PC_CR1 &= ~(1 << BRIGHT);
  ambientMode = AMBIENT_DARK;
}

// at address 0x97e9
void saveEeprom(u32 *params) {
  FLASH_DUKR = 0xAE;
  FLASH_DUKR = 0x56;

  EEPROM_RED_COEF = params[0];
  EEPROM_GRN_COEF = params[1];
  EEPROM_BLU_COEF = params[2];

  FLASH_IAPSR &= ~(1 << EOP);
}

// at address 0x9869
void uart_start() {
  // 2400 baud
  UART1_BRR2 = 0x1A;
  UART1_BRR1 = 0xA0;
  UART1_CR1  = 0x00;
  UART1_CR2  = 1 << TEN;
  UART1_CR2 |= 1 << REN;
  UART1_CR2 |= 1 << RIEN;
  UART1_CR3  = 0x00;
  reset_rxbuf();
  rxReadPtr = 0;
}

// at address 0x988d
void uart_tx_done() {
  if (txRemaining == 0) {
    UART1_CR2 &= ~(1 << TIEN); // disable tx interrupt
    txActive = 0;
    return;
  }
  txRemaining--;
  if (txRemaining != 0) {
    txTarget++;
    UART1_DR = *txTarget;
  }
}


// at address 0x98e0
void uart_rx_done() {
  *rxTarget = UART1_DR;
  rxTarget++;
  rxWritePtr++;
  if (rxWritePtr == 35) {
    reset_rxbuf();
  }
}

// at address 0x98fd
void loadEeprom(u32 *params) {
  params[0] = EEPROM_RED_COEF;
  params[1] = EEPROM_GRN_COEF;
  params[2] = EEPROM_BLU_COEF;
  eepromPtr = &EEPROM_GRN_COEF; // unused
}

// at address 0x991a
void setup_tick() {
  CLK_CKDIVR = 0; // HSI clock = CPU clock = master clock = 16 MHz
  TIM2_CR1   = 1;
    // ARPE = 0: do not buffer ARR
    // OPM  = 0: do not stop on update
    // URS  = 0: enable external update request sources (?)
    // UDIS = 0: do not disable update event
    // CEN  = 1: enable timer
  TIM2_IER   = 1;     // enable only overflow/update interrupt
  TIM2_PSCR  = 0;     // run at master clock
  TIM2_ARR   = 16000; // 1 ms tick
  enableInterrupts(); // unmask interrupts
}

// at address 0x9934
void wdg_setup() {
  IWDG_KR  = KEY_ENABLE;
  IWDG_KR  = KEY_ACCESS;
  IWDG_PR  = 0x06; // /256 prescaler => 250 Hz clock
  IWDG_RLR = 0xFF; // ~ 1 second timeout
  IWDG_KR  = KEY_REFRESH;
  IWDG_KR  = KEY_ENABLE;
}

// at forgotten address
// (however this function is synthesized from sub-functions anyway)
void init_memory() {
  // memset(0x0013, 0x00, 154); // implicit in C
  lastColor = 0xFF;
  mainState = 0x02;
  initState = 0x01;
}

// at address 0x9964
void analog_setup() {
  u32 params[3];

  wdg_setup();
  adc_setup();
  loadEeprom(params);
  importCalibration(params);
}

// at address 0x9979
void adc_setup() {
  ADC_CSR &= 0xF0; // reset channel
  ADC_CSR |= AIN4; // set channel to color
  ADC_CSR &= ~(1 << EOC);  // clear end of conversion
  ADC_CR1 |=  (1 << ADON); // start dummy conversion
}

// at address 0x99dc
void startup() {
  setStackPointer(0x03ff);

  init_memory();
  mainloop();
  abort();
}

// at address 0x99ef
tx_status_t enter_high_baudrate() {
  if (txActive)
    return TX_BUSY;

  // 57600 baud
  UART1_BRR2 = 0x05;
  UART1_BRR1 = 0x11;
  return TX_OK;
}

// at address 0x9a01
void color_setup() {
  PC_DDR &= ~(1 << CAP);
  PC_CR1 &= ~(1 << CAP);
  PC_DDR &= ~(1 << BRIGHT);
  PC_CR1 &= ~(1 << BRIGHT);
}

// at address 0x9a12
void uart_setup() {
  setup_uart_tx_pins();
  PD_DDR &= ~(1 << UART_RX);
  PD_CR1 &= ~(1 << UART_RX);
  PD_CR2 &= ~(1 << UART_RX);
}

// at address 0x9a22
void us10_tick() {
  TIM1_SR1 &= ~UIF;
  us10Counter++;
}

// at address 0x9a2f
void setup_uart_tx_pins() {
  PD_DDR |=  (1 << UART_TX);
  PD_ODR &= ~(1 << UART_TX);
  PD_CR1 |=  (1 << UART_TX);
}

// at address 0x9a48
void ms_tick() {
  TIM2_SR1 &= ~UIF;
  msCounter++;
}

// at address 0x9a54
void main_init1() {
  setup_tick();
  gpio_setup();
  analog_setup();
}


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

// at address 0x9b26
void reset_rxbuf() {
  rxTarget = &rxBuffer[0];
  rxWritePtr = 0;
}

// at address 0x9b31
void mainloop() {
  main_init1();
  uart_setup();
  while (true)
    stateMachine();
}

// at address 0x9b50
void uart_disable() {
  UART1_CR1 |= (1 << UARTD); // disable uart
  setup_uart_tx_pins();
}

// at address 0x9ba9
void wdg_refresh() {
  IWDG_KR = KEY_REFRESH;
}

// at address 0x9bba
void bad_irq() {
  while (true) {
    asm("nop");
  }
}

// at address 0x9bae
void abort() {
  while(true) {}
}
