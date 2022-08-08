/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#include <stdint.h>
#include "Hacl_HMAC.h"
#include <msp430.h>

#define KEY_LEN 32
#define MAC_LEN 32
#define NONCE_LEN 64
#define HASH_BLOCK_SIZE 64
#define PAGE_SIZE 512


__attribute__((section(".tcm:rodata"))) static const uint8_t key_attest_key[] = {0x6e, 0x26, 0x88, 0x6e,
    0x4e, 0x07, 0x07, 0xe1, 0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12,
    0xe4, 0x61, 0xc4, 0x24, 0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12,
    0xe4, 0x61, 0xc4, 0x24};


/* Load 'length' bytes of the key into the 'dest' buffer */
__attribute__((section(".tcm:codeUpper"))) void loadKey(uint8_t * dest, uint8_t length){
    /* Unlock the BSL by jumping to its entry points after the proper configuration */
    /* The current implementation works but testing it incurs in buggy behaviour on the CCS IDE */
    /*__asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x01, R12"); //unlock
    __asm("CALLA #0x1002");*/
    
    /* Copy the key from the now-readable BSL. The key was loaded at pos 0x1400 */
    //memcpy(dest,(uint8_t * ) 0x1400,length); //Load the key from the BSL
    memcpy(dest,key_attest_key,length);
    
    /* Lock the BSL by jumping to its entry points after the proper configuration */
    /*__asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x02, R12"); //lock
    __asm("CALLA #0x1002");*/
    __eint(); //TODO: check whether interrupts were enabled before --> only enable them if they are supposed to be enabled
    return;
}



/* offset is the start address, size is the end address */
__attribute__((section(".tcm:codeUpper"))) void compute_HMAC(uint8_t *dst, uint8_t *key_buff, uint8_t* addr, uint32_t size){

	uint8_t page_buff[PAGE_SIZE]; // MSP430 page_size

  /* Taken from Hacl_HMAC.c */
	uint32_t l = (uint32_t)64U;
	KRML_CHECK_SIZE(sizeof (uint8_t), l);
	uint8_t key_block[l];
	memset(key_block, 0U, l * sizeof (uint8_t));
	uint32_t i0;
	if (KEY_LEN <= (uint32_t)64U){
		i0 = KEY_LEN;
	}
	else{
		i0 = (uint32_t)32U;
	}
	uint8_t *nkey = key_block;
	if (KEY_LEN <= (uint32_t)64U){
	  memcpy(nkey, key_buff, KEY_LEN * sizeof (uint8_t));
	}
	else{
	  Hacl_Hash_SHA2_hash_256(key_buff, KEY_LEN, nkey);
	}
	KRML_CHECK_SIZE(sizeof (uint8_t), l);
	uint8_t ipad[l];
	memset(ipad, (uint8_t)0x36U, l * sizeof (uint8_t));
	for (uint32_t i = (uint32_t)0U; i < l; i++){
    uint8_t xi = ipad[i];
    uint8_t yi = key_block[i];
    ipad[i] = xi ^ yi;
	}
	KRML_CHECK_SIZE(sizeof (uint8_t), l);
	uint8_t opad[l];
	memset(opad, (uint8_t)0x5cU, l * sizeof (uint8_t));
	for (uint32_t i = (uint32_t)0U; i < l; i++){
    uint8_t xi = opad[i];
    uint8_t yi = key_block[i];
    opad[i] = xi ^ yi;
	}
	uint32_t s[8U] =
	{
	  (uint32_t)0x6a09e667U, (uint32_t)0xbb67ae85U, (uint32_t)0x3c6ef372U, (uint32_t)0xa54ff53aU,
	  (uint32_t)0x510e527fU, (uint32_t)0x9b05688cU, (uint32_t)0x1f83d9abU, (uint32_t)0x5be0cd19U
	};

	Hacl_Hash_Core_SHA2_init_256(s);
	Hacl_Hash_SHA2_update_multi_256(s, ipad, (uint32_t)1U);

	/* This part is added to the Hacl part */

  /******************** Start of Update *************************************/

  // hash the 64-byte nonce first
  Hacl_Hash_SHA2_update_multi_256(s, dst, (uint32_t)1U);

  //hash the data
  uint32_t num_data_blocks = size/HASH_BLOCK_SIZE;
  Hacl_Hash_SHA2_update_multi_256(s, addr, num_data_blocks);

  //Add the padding and finish
  Hacl_Hash_SHA2_update_last_256(s, (uint64_t)(uint32_t)((2+num_data_blocks)*64U), addr, 0);

  /******************** End of Update *************************************/

  /* Finalize */
  
  uint8_t *dst1 = ipad;
  Hacl_Hash_Core_SHA2_finish_256(s, dst1);
  uint8_t *hash1 = ipad;
  Hacl_Hash_Core_SHA2_init_256(s);
  Hacl_Hash_SHA2_update_multi_256(s, opad, (uint32_t)1U);
  Hacl_Hash_SHA2_update_last_256(s, (uint64_t)(uint32_t)64U, hash1, (uint32_t)32U);

  Hacl_Hash_Core_SHA2_finish_256(s, dst);

}

/* Perform remote attestation using the 'mac' buffer */
__attribute__((section(".tcm:codeUpper"))) void remote_attestation(uint8_t* mac){
  uint8_t key_buff[KEY_LEN]; // = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00  };
  uint32_t offset;
  uint32_t size;
  //Perform the attestation of the app code
  uint8_t * buff_data = 0x4400; 
  
  // load the attestation key
  loadKey(key_buff,KEY_LEN);
  
  //Size to attest
  size = 1024;

  compute_HMAC(mac, key_buff, buff_data, size);
}

/* Prototype and demo of the attestation. This method is only a proof of work and is missing
some features to make it fully functional in a remote environment. For simplicity, the attestation
will use a costant nonce and a confidentiality unprotected key (BSL interaction is buggy). All of
the helper functions to clear and secure the RAM are skipped. */
__attribute__((section(".tcm:codeUpper"))) int attest_appcode(void) {
  

  // TODO: design the stack
  __dint();

  //Costant NONCE --> in a realistic scenario we receive it
  uint8_t nonce_buf[NONCE_LEN] = {0xFF, 0x2B, 0xA8, 0x3e,
      0x4e, 0x07, 0x07, 0xe1, 0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12,
      0xe4, 0x61, 0xc4, 0x24, 0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12,
      0xe4, 0x61, 0xc4, 0x4C, 0xFF, 0x2B, 0xA8, 0x6e, 0x4e, 0x07, 0x07, 0xe1, 
      0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12, 0xe4, 0x61, 0xc4, 0x24, 
      0xb3, 0x0f, 0x24, 0x16, 0x0e, 0x99, 0xb9, 0x12, 0xe4, 0x61, 0xc4, 0x4C}; 
  
  
  //assuming the receive of the nonce
  //memcpy(nonce_buf, nonce, NONCE_LEN);

  //Perform attestation
  remote_attestation(nonce_buf);

  //End of attestation --> to be used as breakpoint to retrieve the result
  __asm("nop");
  
  return 0;
}
