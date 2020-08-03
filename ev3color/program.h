#ifndef EV3_COLOR_HEADER
#define EV3_COLOR_HEADER

#include <stdint.h>

// basic types
#define true  1
#define false 0
typedef uint8_t  bool;
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint16_t u32;
typedef int8_t   s8;
typedef int16_t  s16;
typedef int16_t  s32;
typedef float    f32;

// primary state machine
typedef enum {
  STATE_RESTART           =  1,
  STATE_WAIT_FOR_AUTOID   =  2,
  STATE_UART_HANDSHAKE    =  3,
  STATE_COLORID_SETUP     =  4,
  STATE_COLORID_RUNNING   =  5,
  STATE_REFLECT_SETUP     =  6,
  STATE_REFLECT_RUNNING   =  7,
  STATE_AMBIENT_SETUP     =  8,
  STATE_AMBIENT_RUNNING   =  9,
  STATE_REFRAW_SETUP      = 10,
  STATE_REFRAW_RUNNING    = 11,
  STATE_RGBRAW_SETUP      = 12,
  STATE_RGBRAW_RUNNING    = 13,
  STATE_CALIBRATE_SETUP   = 14,
  STATE_CALIBRATE_RUNNING = 15,
  STATE_CALIBRATE_DONE    = 16,
} main_state_t;

// uart handshake state machine
typedef enum {
  INIT_WAIT_FOR_SYNC  =  1,

  INIT_SENSOR_ID =  2,
  INIT_MODES     =  3,
  INIT_SPEED     =  4,

  INIT_COL_CAL_NAME   =  5,
  INIT_COL_CAL_RAW    =  6,
  INIT_COL_CAL_SI     =  7,
  INIT_COL_CAL_FORMAT =  8,
  INIT_COL_CAL_PAUSE  =  9,

  INIT_RGB_RAW_NAME   = 10,
  INIT_RGB_RAW_RAW    = 11,
  INIT_RGB_RAW_SI     = 12,
  INIT_RGB_RAW_FORMAT = 13,
  INIT_RGB_RAW_PAUSE  = 14,

  INIT_REF_RAW_NAME   = 15,
  INIT_REF_RAW_RAW    = 16,
  INIT_REF_RAW_SI     = 17,
  INIT_REF_RAW_FORMAT = 18,
  INIT_REF_RAW_PAUSE  = 19,

  INIT_COL_COLOR_NAME   = 20,
  INIT_COL_COLOR_RAW    = 21,
  INIT_COL_COLOR_SI     = 22,
  INIT_COL_COLOR_SYMBOL = 23,
  INIT_COL_COLOR_FORMAT = 24,
  INIT_COL_COLOR_PAUSE  = 25,

  INIT_COL_AMBIENT_NAME   = 26,
  INIT_COL_AMBIENT_RAW    = 27,
  INIT_COL_AMBIENT_SI     = 28,
  INIT_COL_AMBIENT_SYMBOL = 29,
  INIT_COL_AMBIENT_FORMAT = 30,
  INIT_COL_AMBIENT_PAUSE  = 31,

  INIT_COL_REFLECT_NAME   = 32,
  INIT_COL_REFLECT_RAW    = 33,
  INIT_COL_REFLECT_SI     = 34,
  INIT_COL_REFLECT_SYMBOL = 35,
  INIT_COL_REFLECT_FORMAT = 36,
  INIT_COL_REFLECT_PAUSE  = 37,

  INIT_SEND_ACK     = 38,
  INIT_WAIT_FOR_ACK = 39,
  INIT_START_DATA   = 40,

} init_state_t;

// led mode for measurement
typedef enum {
  LED_RED   = 1,
  LED_GREEN = 2,
  LED_BLUE  = 3,
} led_t;

// ambient mode for measurement
typedef enum {
  AMBIENT_DARK   = 1,
  AMBIENT_BRIGHT = 2,
} ambient_mode_t;

// ADC channel for measurements
typedef enum {
  ADC_AMBIENT = 3, // AIN3
  ADC_COLOR   = 4, // AIN4
} adc_channel_t;

// EV3 color code
typedef enum {
  COLOR_NONE   = 0,
  COLOR_BLACK  = 1,
  COLOR_BLUE   = 2,
  COLOR_GREEN  = 3,
  COLOR_YELLOW = 4,
  COLOR_RED    = 5,
  COLOR_WHITE  = 6,
  COLOR_BROWN  = 7,
} color_code_t;

// transmission result
typedef enum {
  TX_BUSY = false,
  TX_OK   = true,
} tx_status_t;

// magic constants (tm)
#define AUTOID_DELAY        500 // ms
#define DELAY_BETWEEN_SYNCS   6 // ms
#define MAX_SYNC_ATTEMPTS    10
#define INTERMODE_PAUSE      30 // ms
#define ACK_TIMEOUT          80 // ms

// UART protocol
#define MSG_SYS    0x00
#define MSG_CMD    0x40
#define MSG_INFO   0x80
#define MSG_DATA   0xC0

#define SYS_SYNC   0x00
#define SYS_NACK   0x02
#define SYS_ACK    0x04

#define CMD_TYPE   0x00
#define CMD_MODES  0x01
#define CMD_SPEED  0x02
#define CMD_SELECT 0x03
#define CMD_WRITE  0x04

#define INFO_NAME    0x00
#define INFO_RAW     0x01
#define INFO_PCT     0x02
#define INFO_SI      0x03
#define INFO_SYMBOL  0x04
#define INFO_FORMAT  0x80

#define COL_REFLECT 0
#define COL_AMBIENT 1
#define COL_COLOR   2
#define REF_RAW     3
#define RGB_RAW     4
#define COL_CAL     5

#define MSGLEN_1  0x00
#define MSGLEN_2  0x08
#define MSGLEN_4  0x10
#define MSGLEN_8  0x18
#define MSGLEN_16 0x20
#define MSGLEN_32 0x28

#define MSG_MASK 0xC0
#define SYS_MASK 0x07
#define CMD_MASK 0x07
#define INFO_MODE_MASK 0x07
#define MSGLEN_MASK 0x38

#define ACK_MSG    (MSG_SYS | SYS_ACK)
#define NACK_MSG   (MSG_SYS | SYS_NACK)
#define SYNC_MSG   (MSG_SYS | SYS_SYNC)
#define SELECT_MSG (MSG_CMD | CMD_SELECT)
#define WRITE_MSG  (MSG_CMD | CMD_WRITE)

#define DEVICE_ID_COLOR_SENSOR 29

#endif
