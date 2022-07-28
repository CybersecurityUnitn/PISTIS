#ifndef PINSCONFIG_H_
#define PINSCONFIG_H_

/* LEDs */
#define LED1                    BIT0
#define LED1_OUT                PJOUT
#define LED1_DIR                PJDIR
#define LED2                    BIT1
#define LED2_OUT                PJOUT
#define LED2_DIR                PJDIR

/* ADXL362 pins */
#define PIN_ADXL_SCLK          (BIT4)
#define PDIR_ADXL_SCLK         (P1DIR)
#define PADXL_SCLKSEL0         (P1SEL0)
#define PADXL_SCLKSEL1         (P1SEL1)

#define PIN_ADXL_MOSI          (BIT6)
#define PDIR_ADXL_MOSI         (P1DIR)
#define PADXL_MOSISEL0         (P1SEL0)
#define PADXL_MOSISEL1         (P1SEL1)

#define PIN_ADXL_MISO          (BIT7)
#define PDIR_ADXL_MISO         (P1DIR)
#define PADXL_MISOSEL0         (P1SEL0)
#define PADXL_MISOSEL1         (P1SEL1)

#define PIN_ADXL_CS            BIT5
#define POUT_ADXL_CS           P1OUT
#define PDIR_ADXL_CS           P1DIR
/* to turn on and off adxl */
#define PIN_ADXL_EN            BIT4
#define POUT_ADXL_EN           P2OUT
#define PDIR_ADXL_EN           P2DIR

/* CC1101 pins */
#define PIN_CC1101_SCLK         (BIT0)
#define PDIR_CC1101_SCLK        (P3DIR)
#define PCC1101_SCLKSEL0        (P3SEL0)
#define PCC1101_SCLKSEL1        (P3SEL1)

#define PIN_CC1101_MOSI         (BIT1)
#define PDIR_CC1101_MOSI        (P3DIR)
#define PCC1101_MOSISEL0        (P3SEL0)
#define PCC1101_MOSISEL1        (P3SEL1)

#define PIN_CC1101_MISO         (BIT2)
#define PDIR_CC1101_MISO        (P3DIR)
#define P_IN_CC1101_MISO        (P3IN)
#define PCC1101_MISOSEL0        (P3SEL0)
#define PCC1101_MISOSEL1        (P3SEL1)

#define PIN_CC1101_CSN          BIT3
#define POUT_CC1101_CSN         P5OUT
#define PDIR_CC1101_CSN         P5DIR

/* bu pin farkli port olmali, interrupt yok burda :( */
#define PIN_CC1101_GDO0         (BIT2)
#define PDIR_CC1101_GDO0        (P5DIR)
#define P_IN_CC1101_GDO0        (P5IN)
#define PSEL0_CC1101_GDO0       (P5SEL0)
#define PSEL1_CC1101_GDO0       (P5SEL1)

#define PIN_CC1101_GDO2         (BIT1)
#define PDIR_CC1101_GDO2        (P5DIR)
#define P_IN_CC1101_GDO2        (P5IN)
#define PSEL0_CC1101_GDO2       (P5SEL0)
#define PSEL1_CC1101_GDO2       (P5SEL1)

#endif /* PINSCONFIG_H_ */
