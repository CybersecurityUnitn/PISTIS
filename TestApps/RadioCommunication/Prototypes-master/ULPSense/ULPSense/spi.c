#include <msp430.h>
#include <spi.h>

#include <stdint.h>
#include <stdbool.h>

static struct {
    unsigned int uiCurRx;
    unsigned int uiCurTx;
    unsigned int uiBytesToSend;
    uint8_t *pcRxBuffer;
    uint8_t *pcTxBuffer;
} spiSM;

bool SPI_transaction(uint8_t* rxBuf, uint8_t* txBuf, uint16_t size) {

    if(size==0) return FAIL; // If we aren't sending anything, fail!

    spiSM.uiCurRx = 0;
    spiSM.uiCurTx = 0;
    spiSM.uiBytesToSend = size;

    spiSM.pcRxBuffer = rxBuf;
    spiSM.pcTxBuffer = txBuf;

    for (; spiSM.uiBytesToSend > 0; --spiSM.uiBytesToSend) {

        // Start transmission
        UCB0TXBUF = spiSM.pcTxBuffer[spiSM.uiCurTx];
        while(!(UCB0IFG & UCRXIFG));
        spiSM.pcRxBuffer[spiSM.uiCurRx] = UCB0RXBUF;
        // UCB0IFG &= ~UCRXIFG;
        // UCB0IFG &= ~UCTXIFG;
        // Move to next TX and RX index
        spiSM.uiCurTx++;
        spiSM.uiCurRx++;
    }

    return SUCCESS;
}

