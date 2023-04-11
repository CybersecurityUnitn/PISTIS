/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
/**
 * This file contains all of the hooks which should be callable from the untrusted application
 **/
#ifndef HEADER_FILE_TCM_HOOK
#define HEADER_FILE_TCM_HOOK

//This address must be synched with #receiveUpdate in the rest of the repository
#define callReceiveUpdate() ({asm("BR #0xfe3e");})


#endif