#include <msp430.h>
#include <stdint.h>
#include "pinsConfig.h"
#include "pinsUtil.h"

#define ADXL_CMD_WRITE_REG      0x0A
#define ADXL_CMD_READ_REG       0x0B
#define ADXL_CMD_READ_FIFO      0x0D
#define ADXL_REG_DEVID_AD       0x00
#define ADXL_REG_DEVID_MST      0x01
#define ADXL_REG_PARTID         0x02
#define ADXL_REG_REVID          0x03
#define ADXL_REG_XDATA          0x08
#define ADXL_REG_YDATA          0x09
#define ADXL_REG_ZDATA          0x0A
#define ADXL_REG_STATUS         0x0B
#define ADXL_REG_FIFO_ENTRIES_L 0x0C
#define ADXL_REG_FIFO_ENTRIES_H 0x0D
#define ADXL_REG_XDATA_L        0x0E
#define ADXL_REG_XDATA_H        0x0F
#define ADXL_REG_YDATA_L        0x10
#define ADXL_REG_YDATA_H        0x11
#define ADXL_REG_ZDATA_L        0x12
#define ADXL_REG_ZDATA_H        0x13
#define ADXL_REG_TEMP_L         0x14
#define ADXL_REG_TEMP_H         0x15
#define ADXL_REG_Reserved0      0x16
#define ADXL_REG_Reserved1      0x17
#define ADXL_REG_SOFT_RESET     0x1F
#define ADXL_REG_THRESH_ACT_L   0x20
#define ADXL_REG_THRESH_ACT_H   0x21
#define ADXL_REG_TIME_ACT       0x22
#define ADXL_REG_THRESH_INACT_L 0x23
#define ADXL_REG_THRESH_INACT_H 0x24
#define ADXL_REG_TIME_INACT_L   0x25
#define ADXL_REG_TIME_INACT_H   0x26
#define ADXL_REG_ACT_INACT_CTL  0x27
#define ADXL_REG_FIFO_CONTROL   0x28
#define ADXL_REG_FIFO_SAMPLES   0x29
#define ADXL_REG_INTMAP1        0x2A
#define ADXL_REG_INTMAP2        0x2B
#define ADXL_REG_FILTER_CTL     0x2C
#define ADXL_REG_POWER_CTL      0x2D
#define ADXL_REG_SELF_TEST      0x2E

uint8_t const ADXL_READ_PARTID[]    = { ADXL_CMD_READ_REG, ADXL_REG_PARTID, 0x00 };
uint8_t const ADXL_READ_DEVID[]     = { ADXL_CMD_READ_REG, ADXL_REG_DEVID_AD, 0x00 };
uint8_t const ADXL_READ_STATUS[]    = { ADXL_CMD_READ_REG, ADXL_REG_STATUS, 0x00 };
uint8_t const ADXL_READ_XYZ_8BIT[]  = { ADXL_CMD_READ_REG, ADXL_REG_XDATA, 0x00, 0x00, 0x00 };
uint8_t const ADXL_READ_XYZ_16BIT[] = { ADXL_CMD_READ_REG, ADXL_REG_XDATA_L, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
uint8_t const ADXL_CONFIG_MEAS[]    = { ADXL_CMD_WRITE_REG, ADXL_REG_POWER_CTL, 0x02 }; // Put the ADXL into measurement mode
uint8_t const ADXL_CONFIG_STBY[]    = { ADXL_CMD_WRITE_REG, ADXL_REG_POWER_CTL, 0x00 }; // Put the ADXL into standby mode
uint8_t const ADXL_CONFIG_RESET[]   = { ADXL_CMD_WRITE_REG, ADXL_REG_SOFT_RESET, 0x52 };
uint8_t const ADXL_CONFIG_FILTER[]  = { ADXL_CMD_WRITE_REG, ADXL_REG_FILTER_CTL, 0x17 };

#define SPI_GP_RXBUF_SIZE 20
static uint8_t gpRxBuf[SPI_GP_RXBUF_SIZE];

#define CS_HIGH()   POUT_ADXL_CS |= PIN_ADXL_CS;
#define CS_LOW()    POUT_ADXL_CS &= ~PIN_ADXL_CS;

void adxl_on(){
    POUT_ADXL_EN |= PIN_ADXL_EN;
}

void adxl_off(){
    POUT_ADXL_EN &= ~PIN_ADXL_EN;
}

static void adxl_spi_config(){

    /* configure msp430fr5989 pins for SPI */
    PADXL_SCLKSEL0 |= PIN_ADXL_SCLK;
    PADXL_MOSISEL0 |= PIN_ADXL_MOSI;
    PADXL_MISOSEL0 |= PIN_ADXL_MISO;
    PADXL_SCLKSEL1 &= ~PIN_ADXL_SCLK;
    PADXL_MOSISEL1 &= ~PIN_ADXL_MOSI;
    PADXL_MISOSEL1 &= ~PIN_ADXL_MISO;

    /* set output ports */
    PDIR_ADXL_EN |= PIN_ADXL_EN;
    POUT_ADXL_EN &= ~PIN_ADXL_EN;
    PDIR_ADXL_CS |= PIN_ADXL_CS;
    POUT_ADXL_CS &= ~PIN_ADXL_CS;

    /* set CS pin */
    CS_HIGH();

    /* ADXL362 MSP430 UCB0 spi config */
    UCB0CTLW0 = UCSWRST;
    UCB0CTLW0 |= UCMST | UCSYNC | UCCKPH | UCMSB | UCSSEL__SMCLK;
    UCB0BRW = 0;
    UCB0IFG = 0;
    UCB0CTLW0 &= ~UCSWRST;
}

void adxl_mode_measure(){
    CS_LOW();
    SPI_transaction(gpRxBuf, (uint8_t*) ADXL_CONFIG_MEAS,sizeof(ADXL_CONFIG_MEAS));
    CS_HIGH();
}

uint8_t adxl_deviceID(){
    CS_LOW();
    SPI_transaction(gpRxBuf, (uint8_t*) ADXL_READ_DEVID,sizeof(ADXL_READ_DEVID));
    CS_HIGH();

    return gpRxBuf[2];
}

uint8_t adxl_partID(){
    CS_LOW();
    SPI_transaction(gpRxBuf, (uint8_t*) ADXL_READ_PARTID,sizeof(ADXL_READ_DEVID));
    CS_HIGH();

    return gpRxBuf[2];
}


uint8_t adxl_status(){
    CS_LOW();
    SPI_transaction(gpRxBuf, (uint8_t*) ADXL_READ_STATUS,sizeof(ADXL_READ_STATUS));
    CS_HIGH();
    return gpRxBuf[2];
}

void adxl_sample(uint8_t *x, uint8_t *y, uint8_t *z)
{
    CS_LOW();
    SPI_transaction(gpRxBuf, (uint8_t*) ADXL_READ_XYZ_8BIT,sizeof(ADXL_READ_XYZ_8BIT));
    CS_HIGH();

   *x = gpRxBuf[2];
   *y = gpRxBuf[3];
   *z = gpRxBuf[4];
}

void adxl_start(){
    /* configure msp430fr5989 ports for spi */
    adxl_spi_config();
    /* turn on ADXL362 */
    adxl_on();
    __delay_cycles(1000);
    /* init adxl */
    adxl_mode_measure();
    /* check if ADXL is properly working */
    if (adxl_partID() != 0xf2){
        printf("error ADXL part ID \n");
        exit(-1);
    }
    if (adxl_deviceID()!=0xAD){
        printf("error ADXL device  ID \n");
                exit(-1);
    }
}
