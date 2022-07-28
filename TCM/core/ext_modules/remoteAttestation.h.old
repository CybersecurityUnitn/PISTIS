#ifndef REMOTE_ATTESTATION_HEADER
#define REMOTE_ATTESTATION_HEADER
#define BLOCK_SIZE 512 //Could be up to 1024
#define NONCE_SIZE 32
#include "core.h"
typedef struct {
    uint8_t     hash[32];   
    uint32_t    buffer[16]; 
    uint32_t    state[8];   
    uint8_t     length[8];  
} sha256;

typedef struct _hmac_sha256 {
    uint8_t digest[32]; 
    uint8_t key[64];   
    sha256  sha;
} hmac_sha256;

hmac_sha256 compute_appCode_hash(uint8_t * key, uint8_t keyLength, uint8_t * nonce);
void helperHMAC(uint8_t * nonce);
#endif