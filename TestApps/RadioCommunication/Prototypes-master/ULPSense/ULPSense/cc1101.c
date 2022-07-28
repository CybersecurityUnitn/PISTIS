#include <msp430.h>
#include <stdint.h>
#include <stdio.h>
#include "pinsConfig.h"
#include "pinsUtil.h"
#include "cc1101.h"

uint8_t PaTabel[8] = {0xC0 ,0xC0 ,0xC0 ,0xC0 ,0xC0 ,0xC0 ,0xC0 ,0xC0};

#define CSN_HIGH()   POUT_CC1101_CSN |= PIN_CC1101_CSN;
#define CSN_LOW()    POUT_CC1101_CSN &= ~PIN_CC1101_CSN;
#define SPI_SO_IS_HIGH() (P_IN_CC1101_MISO & PIN_CC1101_MISO)
#define GDO0_PIN_IS_HIGH() (P_IN_CC1101_GDO0 & PIN_CC1101_GDO0)
#define GDO2_PIN_IS_HIGH() (P_IN_CC1101_GDO2 & PIN_CC1101_GDO2)

static void cc1101_spi_config(){

    /* configure msp430fr5989 pins for SPI */
    PCC1101_SCLKSEL0 |= PIN_CC1101_SCLK;
    PCC1101_MOSISEL0 |= PIN_CC1101_MOSI;
    PCC1101_MISOSEL0 |= PIN_CC1101_MISO;
    PCC1101_SCLKSEL1 &= ~PIN_CC1101_SCLK;
    PCC1101_MOSISEL1 &= ~PIN_CC1101_MOSI;
    PCC1101_MISOSEL1 &= ~PIN_CC1101_MISO;

    /* set output ports */
    PDIR_CC1101_CSN |= PIN_CC1101_CSN;
    POUT_CC1101_CSN &= ~PIN_CC1101_CSN;

    /* set input ports */
    PDIR_CC1101_GDO0 &= ~PIN_CC1101_GDO0;
    PSEL0_CC1101_GDO0 &= ~PIN_CC1101_GDO0;
    PSEL1_CC1101_GDO0 &= ~PIN_CC1101_GDO0;

    PDIR_CC1101_GDO2 &= ~PIN_CC1101_GDO2;
    PSEL0_CC1101_GDO2 &= ~PIN_CC1101_GDO2;
    PSEL1_CC1101_GDO2 &= ~PIN_CC1101_GDO2;

    /* set CSN pin */
    CSN_HIGH();

    /* CC1101 MSP430 UCB1 spi config */
    UCB1CTLW0 = UCSWRST;
    UCB1CTLW0 |= UCMST | UCSYNC | UCCKPH | UCMSB | UCSSEL__SMCLK;
    UCB1BRW = 0;
    UCB1IFG = 0;
    UCB1CTLW0 &= ~UCSWRST;
}

static uint8_t __spi_write(uint8_t value){
    uint8_t ret;

    UCB1TXBUF = value;
    while(!(UCB1IFG & UCRXIFG));
    ret = UCB1RXBUF;

    return ret;
}

static uint8_t _spi_write(uint8_t value){
    uint8_t ret;

    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    ret = __spi_write(value);
    CSN_HIGH();
    return ret;
}

static uint8_t _spi_write_reg(uint8_t reg,uint8_t value){
    uint8_t ret;
    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    ret = __spi_write(reg);
    ret = __spi_write(value);
    CSN_HIGH();

    return ret;
}

static void _spi_write_burst(uint8_t addr,uint8_t *buffer, uint8_t size){
    uint8_t i;
    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    __spi_write(addr | WRITE_BURST);
    for(i = 0; i< size; i++){
        __spi_write(buffer[i]);
    }
    CSN_HIGH();

}

static uint8_t _spi_read_reg(uint8_t reg){
    uint8_t ret;

    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    __spi_write(reg|READ_SINGLE);
    ret = __spi_write(0);
    CSN_HIGH();

    return ret;
}

static uint8_t _spi_read_status_reg(uint8_t addr){
    uint8_t ret;

    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    __spi_write(addr|READ_BURST);
    ret = __spi_write(0);
    CSN_HIGH();

    return ret;
}

static void _spi_read_burst(uint8_t addr,uint8_t *buffer, uint8_t size){
    uint8_t i;
    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    __spi_write(addr | READ_BURST);
    for(i = 0; i< size; i++){
        buffer[i] = __spi_write(0);
    }
    CSN_HIGH();
}

void cc1101_reset(){
    CSN_LOW();
    __delay_cycles(1);
    CSN_HIGH();
    __delay_cycles(4);
    CSN_LOW();
    while (SPI_SO_IS_HIGH());
    __spi_write(CC1101_SRES);
    while (SPI_SO_IS_HIGH());
    CSN_HIGH();
}

static void _configure_registers(void)
{
    _spi_write_reg(CC1101_FSCTRL1,  0x08);
    _spi_write_reg(CC1101_FSCTRL0,  0x00);
    _spi_write_reg(CC1101_FREQ2,    0x10);
    _spi_write_reg(CC1101_FREQ1,    0xA7);
    _spi_write_reg(CC1101_FREQ0,    0x62);
    _spi_write_reg(CC1101_MDMCFG4,  rate_MDMCFG4[9]); // CHANBW_E[1:0], CHANBW_M[1:0], DRATE_E[3:0], Reset is B10001100, 0x56 is 1.5kBaud, 0x55 is around 0.6kBaud
    _spi_write_reg(CC1101_MDMCFG3,  rate_MDMCFG3[9]); // DRATE_M[7:0], Reset is 0x22, 0x00 with above setting is 1.5kBaud
    _spi_write_reg(CC1101_MDMCFG2,  0x03);
    _spi_write_reg(CC1101_MDMCFG1,  0x22);
    _spi_write_reg(CC1101_MDMCFG0,  0xF8);
    _spi_write_reg(CC1101_CHANNR,   0x00);
    _spi_write_reg(CC1101_DEVIATN,  0x47);
    _spi_write_reg(CC1101_FREND1,   0xB6);
    _spi_write_reg(CC1101_FREND0,   0x10);
    _spi_write_reg(CC1101_MCSM0 ,   0x18);
    _spi_write_reg(CC1101_FOCCFG,   0x1D);
    _spi_write_reg(CC1101_BSCFG,    0x1C);
    _spi_write_reg(CC1101_AGCCTRL2, 0xC7);
    _spi_write_reg(CC1101_AGCCTRL1, 0x00);
    _spi_write_reg(CC1101_AGCCTRL0, 0xB2);
    _spi_write_reg(CC1101_FSCAL3,   0xEA);
    _spi_write_reg(CC1101_FSCAL2,   0x2A);
    _spi_write_reg(CC1101_FSCAL1,   0x00);
    _spi_write_reg(CC1101_FSCAL0,   0x11);
    _spi_write_reg(CC1101_FSTEST,   0x59);
    _spi_write_reg(CC1101_TEST2,    0x81);
    _spi_write_reg(CC1101_TEST1,    0x35);
    _spi_write_reg(CC1101_TEST0,    0x09);
    _spi_write_reg(CC1101_IOCFG2,   0x06);     //serial clock.synchronous to the data in synchronous serial mode
    _spi_write_reg(CC1101_IOCFG0,   0x06);     //asserts when sync word has been sent/received, and de-asserts at the end of the packet
    _spi_write_reg(CC1101_PKTCTRL1, 0x04);     //two status uint8_ts will be appended to the payload of the packet,including RSSI LQI and CRC OK, no address check
    /* variable len packet mode with CRC is selected */
    _spi_write_reg(CC1101_PKTCTRL0, 0x05);     //whitening off;CRC Enable, fixed length packets set by PKTLEN reg
    _spi_write_reg(CC1101_ADDR,     0x00);     //address used for packet filtration.
    _spi_write_reg(CC1101_PKTLEN,   0xFF);     //61 uint8_ts max length
}

uint8_t cc1101_MARCState(){
    return _spi_read_status_reg(CC1101_MARCSTATE) & 0x1F;
}

void cc1101_send(uint8_t *txBuffer,uint8_t size)
{
    uint8_t MARCstate;

    _spi_write_reg(CC1101_TXFIFO,size); // Send size first in variable length mode (always be in var length mode)
    _spi_write_burst(CC1101_TXFIFO,txBuffer,size);          //write data to send
    _spi_write(CC1101_STX);                                  //start send

    /* wait SYNC word to be sent */
    while (!GDO0_PIN_IS_HIGH());
    while (GDO0_PIN_IS_HIGH());

    /* check if there is a TXFIFO underflow */
    while ((MARCstate = cc1101_MARCState()) != CC1101_MARCSTATE_IDLE){
        printf("%d \n",(uint16_t)MARCstate);

        if(MARCstate == CC1101_MARCSTATE_TXFIFO_UNDERFLOW){
            cc1101_txflush();
        }
    }
}

uint8_t cc1101_receive(uint8_t *rxBuffer)
{
    uint8_t length;
    uint8_t status[2];
    uint8_t MARCstate;

    cc1101_rx_mode();

    /* data while the pin is low */
    while(!GDO2_PIN_IS_HIGH());
    while(GDO2_PIN_IS_HIGH());

    if(_spi_read_status_reg(CC1101_RXBYTES) & BYTES_IN_RXFIFO)
    {
        length=_spi_read_reg(CC1101_RXFIFO);

        if(length > 0){
            _spi_read_burst(CC1101_RXFIFO,rxBuffer,length);
            _spi_read_burst(CC1101_RXFIFO,status,2);

            /* check if there is a TXFIFO underflow */
            while ((MARCstate = cc1101_MARCState()) != CC1101_MARCSTATE_IDLE){
                printf("%d \n",(uint16_t)MARCstate);

                if(MARCstate == CC1101_MARCSTATE_TXFIFO_UNDERFLOW){
                    cc1101_rxflush();
                }
            }

            return length;
        }
        else{
            cc1101_idle();
            cc1101_rxflush();
        }
    }

    return 0;
}

void cc1101_idle(){

    /* send IDLE command */
    _spi_write(CC1101_SIDLE);

    /* check if IDLE state is entered */
    while ( cc1101_MARCState() != CC1101_MARCSTATE_IDLE);
}

void cc1101_rxflush(){
    _spi_write(CC1101_SFRX);
}

void cc1101_txflush(){
    _spi_write(CC1101_SFTX);
}

void cc1101_rx_mode(){

    /* send RX command */
    _spi_write(CC1101_SRX);

    /* wait till chip enters RX mode */
    while (cc1101_MARCState() != CC1101_MARCSTATE_RX);
}

void cc1101_rx_off(){
    _spi_write(CC1101_SIDLE);
    while (_spi_write(CC1101_SNOP) & 0xF0);
    _spi_write(CC1101_SFRX);
}

void cc1101_start(){
    /* configure msp430fr5989 ports for spi */
    cc1101_spi_config();
    cc1101_reset();
    _configure_registers();
    _spi_write_burst(CC1101_PATABLE,PaTabel,8);

}

void cc1101_data_rate(uint8_t rate_ndx) {
    _spi_write_reg(CC1101_MDMCFG4, rate_MDMCFG4[rate_ndx]);
    _spi_write_reg(CC1101_MDMCFG3, rate_MDMCFG3[rate_ndx]);
}

void cc1101_channel(uint8_t channel) {
   if (channel >= __mrfi_NUM_LOGICAL_CHANS__) return;
   _spi_write_reg(CC1101_CHANNR, mrfiLogicalChanTable[channel]);
}

void cc1101_tx_power(uint8_t powrset) {
    uint8_t i;
    for(i=0;i<8;i++)
        PaTabel[i] = rfPowerTable[powrset];
    _spi_write_burst(CC1101_PATABLE,PaTabel,8);
}


