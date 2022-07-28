/*
 * cc1101.h
 *
 *  Created on: 22 Nov 2019
 *      Author: sinanyil81
 */

#ifndef CC1101_H_
#define CC1101_H_

#define WRITE_BURST         0x40                        //write burst
#define READ_SINGLE         0x80                        //read single
#define READ_BURST          0xC0                        //read burst
#define BYTES_IN_RXFIFO     0x7F                        //uint8_t number in RXfifo

#define CC1101_SRES              0x30        // Reset CC1101 chip
#define CC1101_SFSTXON           0x31        // Enable and calibrate frequency synthesizer (if MCSM0.FS_AUTOCAL=1). If in RX (with CCA):
// Go to a wait state where only the synthesizer is running (for quick RX / TX turnaround).
#define CC1101_SXOFF             0x32        // Turn off crystal oscillator
#define CC1101_SCAL              0x33        // Calibrate frequency synthesizer and turn it off. SCAL can be strobed from IDLE mode without
// setting manual calibration mode (MCSM0.FS_AUTOCAL=0)
#define CC1101_SRX               0x34        // Enable RX. Perform calibration first if coming from IDLE and MCSM0.FS_AUTOCAL=1
#define CC1101_STX               0x35        // In IDLE state: Enable TX. Perform calibration first if MCSM0.FS_AUTOCAL=1.
// If in RX state and CCA is enabled: Only go to TX if channel is clear
#define CC1101_SIDLE             0x36        // Exit RX / TX, turn off frequency synthesizer and exit Wake-On-Radio mode if applicable
#define CC1101_SWOR              0x38        // Start automatic RX polling sequence (Wake-on-Radio) as described in Section 19.5 if
// WORCTRL.RC_PD=0
#define CC1101_SPWD              0x39        // Enter power down mode when CSn goes high
#define CC1101_SFRX              0x3A        // Flush the RX FIFO buffer. Only issue SFRX in IDLE or RXFIFO_OVERFLOW states
#define CC1101_SFTX              0x3B        // Flush the TX FIFO buffer. Only issue SFTX in IDLE or TXFIFO_UNDERFLOW states
#define CC1101_SWORRST           0x3C        // Reset real time clock to Event1 value
#define CC1101_SNOP              0x3D        // No operation. May be used to get access to the chip status byte

/**
 * CC1101 configuration registers
 */
#define CC1101_IOCFG2            0x00        // GDO2 Output Pin Configuration
#define CC1101_IOCFG1            0x01        // GDO1 Output Pin Configuration
#define CC1101_IOCFG0            0x02        // GDO0 Output Pin Configuration
#define CC1101_FIFOTHR           0x03        // RX FIFO and TX FIFO Thresholds
#define CC1101_SYNC1             0x04        // Sync Word, High Byte
#define CC1101_SYNC0             0x05        // Sync Word, Low Byte
#define CC1101_PKTLEN            0x06        // Packet Length
#define CC1101_PKTCTRL1          0x07        // Packet Automation Control
#define CC1101_PKTCTRL0          0x08        // Packet Automation Control
#define CC1101_ADDR              0x09        // Device Address
#define CC1101_CHANNR            0x0A        // Channel Number
#define CC1101_FSCTRL1           0x0B        // Frequency Synthesizer Control
#define CC1101_FSCTRL0           0x0C        // Frequency Synthesizer Control
#define CC1101_FREQ2             0x0D        // Frequency Control Word, High Byte
#define CC1101_FREQ1             0x0E        // Frequency Control Word, Middle Byte
#define CC1101_FREQ0             0x0F        // Frequency Control Word, Low Byte
#define CC1101_MDMCFG4           0x10        // Modem Configuration
#define CC1101_MDMCFG3           0x11        // Modem Configuration
#define CC1101_MDMCFG2           0x12        // Modem Configuration
#define CC1101_MDMCFG1           0x13        // Modem Configuration
#define CC1101_MDMCFG0           0x14        // Modem Configuration
#define CC1101_DEVIATN           0x15        // Modem Deviation Setting
#define CC1101_MCSM2             0x16        // Main Radio Control State Machine Configuration
#define CC1101_MCSM1             0x17        // Main Radio Control State Machine Configuration
#define CC1101_MCSM0             0x18        // Main Radio Control State Machine Configuration
#define CC1101_FOCCFG            0x19        // Frequency Offset Compensation Configuration
#define CC1101_BSCFG             0x1A        // Bit Synchronization Configuration
#define CC1101_AGCCTRL2          0x1B        // AGC Control
#define CC1101_AGCCTRL1          0x1C        // AGC Control
#define CC1101_AGCCTRL0          0x1D        // AGC Control
#define CC1101_WOREVT1           0x1E        // High Byte Event0 Timeout
#define CC1101_WOREVT0           0x1F        // Low Byte Event0 Timeout
#define CC1101_WORCTRL           0x20        // Wake On Radio Control
#define CC1101_FREND1            0x21        // Front End RX Configuration
#define CC1101_FREND0            0x22        // Front End TX Configuration
#define CC1101_FSCAL3            0x23        // Frequency Synthesizer Calibration
#define CC1101_FSCAL2            0x24        // Frequency Synthesizer Calibration
#define CC1101_FSCAL1            0x25        // Frequency Synthesizer Calibration
#define CC1101_FSCAL0            0x26        // Frequency Synthesizer Calibration
#define CC1101_RCCTRL1           0x27        // RC Oscillator Configuration
#define CC1101_RCCTRL0           0x28        // RC Oscillator Configuration
#define CC1101_FSTEST            0x29        // Frequency Synthesizer Calibration Control
#define CC1101_PTEST             0x2A        // Production Test
#define CC1101_AGCTEST           0x2B        // AGC Test
#define CC1101_TEST2             0x2C        // Various Test Settings
#define CC1101_TEST1             0x2D        // Various Test Settings
#define CC1101_TEST0             0x2E        // Various Test Settings

/**
 * Status registers
 */
#define CC1101_PARTNUM           0x30        // Chip ID
#define CC1101_VERSION           0x31        // Chip ID
#define CC1101_FREQEST           0x32        // Frequency Offset Estimate from Demodulator
#define CC1101_LQI               0x33        // Demodulator Estimate for Link Quality
#define CC1101_RSSI              0x34        // Received Signal Strength Indication
#define CC1101_MARCSTATE         0x35        // Main Radio Control State Machine State
#define CC1101_WORTIME1          0x36        // High Byte of WOR Time
#define CC1101_WORTIME0          0x37        // Low Byte of WOR Time
#define CC1101_PKTSTATUS         0x38        // Current GDOx Status and Packet Status
#define CC1101_VCO_VC_DAC        0x39        // Current Setting from PLL Calibration Module
#define CC1101_TXBYTES           0x3A        // Underflow and Number of Bytes
#define CC1101_RXBYTES           0x3B        // Overflow and Number of Bytes
#define CC1101_RCCTRL1_STATUS    0x3C        // Last RC Oscillator Calibration Result
#define CC1101_RCCTRL0_STATUS    0x3D        // Last RC Oscillator Calibration Result

/**
 * PATABLE & FIFO's
 */
#define CC1101_PATABLE           0x3E        // PATABLE address
#define CC1101_TXFIFO            0x3F        // TX FIFO address
#define CC1101_RXFIFO            0x3F        // RX FIFO address

/** If clocking in a lot of data over SPI bus, clock speed of MCU needs to be higher */
/** Otherwise data will be lost */
// 0-10 data rates, 0-2 only use if in high speed mode on MCU
static const uint8_t rate_MDMCFG3[] = { 0x3b, // 499.590 kBaud
        0x3b, // 249.795 kBaud
        0x83, // 153.252 kBaud
        0x83, //  76.626 kBaud /* This setting works well, and any data rates below it */
        0x83, //  38.313 kBaud
        0x8b, //  19.355 kBaud
        0x83, //   9.288 kBaud
        0x83, //   4.644 kBaud
        0x83, //   2.322 kBaud
        0x83, //   1.161 kBaud
        0x43  //   0.969 kBaud
        };

static const uint8_t rate_MDMCFG4[] = { 0x8e, // 499.590 kBaud
        0x8d, // 249.795 kBaud
        0x8c, // 153.252 kBaud
        0x8b, //  76.626 kBaud
        0x8a, //  38.313 kBaud
        0x89, //  19.355 kBaud
        0x88, //   9.288 kBaud
        0x87, //   4.644 kBaud
        0x86, //   2.322 kBaud
        0x85, //   1.161 kBaud
        0x85  //   0.969 kBaud
        };

static const uint8_t rfPowerTable[] = {
/* 10 dBm */0xC0, // 29.1 mA
        /* 7 dBm */0xC8, // 24.2 mA
        /* 5 dBm */0x84, // 19.4 mA
        /* 0 dBm */0x60, // 15.9 mA
        /* -10 dBm */0x34, // 14.4 mA
        /* -15 dBm */0x1D, // 13.1 mA
        /* -20 dBm */0x0E, // 12.4 mA
        /* -30 dBm */0x12, // 11.9 mA
        };

#define __mrfi_NUM_LOGICAL_CHANS__      25
static const uint8_t mrfiLogicalChanTable[] = // randomized version
        { 90, 105, 40, 45, 70, 80, 100, 5, 60, 115, 15, 125, 120, 50, 95, 30,
          75, 10, 25, 55, 110, 65, 85, 35, 20 };

/* MARC STATES */
#define CC1101_MARCSTATE_SLEEP 0x00
#define CC1101_MARCSTATE_IDLE 0x01
#define CC1101_MARCSTATE_RX 0x0D
#define CC1101_MARCSTATE_RXFIFO_UNDERFLOW 0x11
#define CC1101_MARCSTATE_TX 0x13
#define CC1101_MARCSTATE_TXFIFO_UNDERFLOW 0x16

#endif /* CC1101_H_ */
