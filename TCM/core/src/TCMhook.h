/**
 * This file contains all of the hooks which should be callable from the untrusted application
 **/
#ifndef HEADER_FILE_TCM_HOOK
#define HEADER_FILE_TCM_HOOK

#define callReceiveUpdate() ({asm("CALL #receiveUpdate");})

//typedef void func(void);
//func* callReceiveUpdate = (func*)0xFE3E; /* This needs to be synchronised with the linker scripts */


#endif