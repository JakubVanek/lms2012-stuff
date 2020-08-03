#ifndef EV3_COLOR_IO_HEADER
#define EV3_COLOR_IO_HEADER

#define PA_ODR (*((u8*) 0x5000))
#define PA_IDR (*((u8*) 0x5001))
#define PA_DDR (*((u8*) 0x5002))
#define PA_CR1 (*((u8*) 0x5003))
#define PA_CR2 (*((u8*) 0x5004))
#define PB_ODR (*((u8*) 0x5005))
#define PB_IDR (*((u8*) 0x5006))
#define PB_DDR (*((u8*) 0x5007))
#define PB_CR1 (*((u8*) 0x5008))
#define PB_CR2 (*((u8*) 0x5009))
#define PC_ODR (*((u8*) 0x500a))
#define PC_IDR (*((u8*) 0x500b))
#define PC_DDR (*((u8*) 0x500c))
#define PC_CR1 (*((u8*) 0x500d))
#define PC_CR2 (*((u8*) 0x500e))
#define PD_ODR (*((u8*) 0x500f))
#define PD_IDR (*((u8*) 0x5010))
#define PD_DDR (*((u8*) 0x5011))
#define PD_CR1 (*((u8*) 0x5012))
#define PD_CR2 (*((u8*) 0x5013))

#define FLASH_DUKR  (*((u8*) 0x5064))
#define FLASH_IAPSR (*((u8*) 0x505f))
#define EOP 2

#define CLK_CKDIVR  (*((u8*) 0x50c6))

#define IWDG_KR  (*((u8*) 0x50e0))
#define IWDG_PR  (*((u8*) 0x50e1))
#define IWDG_RLR (*((u8*) 0x50e2))
#define KEY_ENABLE  0xCC
#define KEY_ACCESS  0x55
#define KEY_REFRESH 0xAA

#define UART1_DR   (*((u8*) 0x5231))
#define UART1_BRR1 (*((u8*) 0x5232))
#define UART1_BRR2 (*((u8*) 0x5233))
#define UART1_CR1  (*((u8*) 0x5234))
#define UART1_CR2  (*((u8*) 0x5235))
#define UART1_CR3  (*((u8*) 0x5236))
#define UARTD 5
#define TIEN  7
#define RIEN  5
#define TEN   3
#define REN   2

#define TIM1_CR1   (*((u8*) 0x5250))
#define TIM1_IER   (*((u8*) 0x5254))
#define TIM1_SR1   (*((u8*) 0x5255))
#define TIM1_CNTR (*((u16*) 0x525e))
#define TIM1_ARR  (*((u16*) 0x5262))
#define UIF 0
#define UIE 0
#define CEN 0

#define TIM2_CR1  (*((u8*) 0x5300))
#define TIM2_IER  (*((u8*) 0x5303))
#define TIM2_SR1  (*((u8*) 0x5304))
#define TIM2_PSCR (*((u8*) 0x530e))
#define TIM2_ARR (*((u16*) 0x530f))

#define ADC_CSR  (*((u8*) 0x5400))
#define ADC_CR1  (*((u8*) 0x5401))
#define ADC_DRH  (*((u8*) 0x5404))
#define ADC_DRL  (*((u8*) 0x5405))
#define ADC_TDRL (*((u8*) 0x5407))
#define ADON 0
#define AIN3 3
#define AIN4 4
#define EOC  7


#define RED1    1
#define RED2    2
#define GREEN1  3
#define GREEN2  3
#define BLUE1   4
#define BLUE2   5
#define BRIGHT  7
#define CAP     6
#define COLOR   3
#define AMBIENT 2
#define UART_TX 6
#define UART_RX 5
#define PB4     4
#define PB5     5
#define PD4     4

inline void enableInterrupts(void) {}
inline void setStackPointer(u16 value) {}

#endif
