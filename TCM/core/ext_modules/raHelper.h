/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#ifndef HEADER_FILE_RA_HELPER
#define HEADER_FILE_RA_HELPER
#include "core.h"
const uint32_t backupAddress;

/**
 * Save the content of the RAM to a safe flash location for later restoring.
 * PARAMS:
 * - from: the address the RAM should start being copied from
 * - to: the address the RAM should end being copied from
 * RETURN:
 * - 0: there was an error during the copy process
 * - 1: the content was successfully copied
 */
bool backupRam(uint16_t from, uint16_t to);

/**
 * Restore the content of the RAM previously saved to flash location.
 * PARAMS:
 * - from: the address the RAM should start being restored to
 * - to: the address the RAM should end being restored to
 * RETURN:
 * - 0: there was an error during the restoration process
 * - 1: the content was successfully restored
 */
bool restoreRam(uint16_t from, uint16_t to);


/**
 * Save the content of the registers to a safe flash location for later restoring.
 */
extern void raRegBackup(void);

/**
 * Restore the content of the registers after a raRegBackup invokation.
 */
extern void raRegRestore(void);  



#endif