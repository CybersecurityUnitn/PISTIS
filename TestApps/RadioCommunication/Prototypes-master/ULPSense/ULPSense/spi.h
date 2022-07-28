#ifndef LIBADXL_SPI_H
#define LIBADXL_SPI_H

#include <stdint.h>
#include <stdbool.h>

#define FAIL            (0)
#define SUCCESS         (1)

bool SPI_transaction(uint8_t* rxBuf, uint8_t* txBuf, uint16_t size);

#endif // LIBADXL_SPI_H
