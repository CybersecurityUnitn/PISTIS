/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#ifndef HEADER_FILE_PISTIS
#define HEADER_FILE_PISTIS


#define REJECTED 1
#define VERIFIED 0
#define MAX_BUFFER 256
#define true 1
#define false 0
#define KEY_SIZE 64
#define KEY_LOCATION 0x1400


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long uint32_t;
typedef signed long int32_t;
typedef signed int int16_t;
typedef signed char int8_t;
typedef unsigned char bool;

#define verify_app_inst(address, lastAddress) verify(address, lastAddress, false)
#define verify_app_cfi(address, lastAddress) verify(address, lastAddress, true)


//Functions
static void secureBoot();
void launchAppCode();
bool verify(uint16_t address, uint16_t lastAddress,bool cfi);
static bool cfiCheck(uint32_t destination);
static int8_t binarySearch(int16_t low, int16_t high, uint16_t key);
bool isImmediateSafeValue(uint32_t destination);
static void flushBufferToFlash();
void getSecureKey(uint8_t * key);
void setSecureKey(uint8_t * key);

/* VIRTUAL FUNCTIONS */
//They are declared in assembly in the virt_fun.s file
extern void safe_br_fun();
extern void safe_bra_fun();
extern void safe_call_fun();
extern void safe_calla_fun();
extern void safe_ret_fun();
extern void safe_reti_fun();
extern void safe_reta_fun();

extern void write_mov_fun();
extern void write_movx_fun();
extern void write_xor_fun();
extern void write_xorx_fun();
extern void write_add_fun();
extern void write_addx_fun();
extern void write_addc_fun();
extern void write_addcx_fun();
extern void write_dadd_fun();
extern void write_daddx_fun();
extern void write_sub_fun();
extern void write_subx_fun();
extern void write_subc_fun();
extern void write_subcx_fun();

/** CONSTANTS **/
/** These constants need to be synchronised with the linker script and the various toolchain scripts **/
extern const uint16_t appTopRam;
extern const uint16_t appBottomRam;
extern const uint16_t appBottomText;
extern const uint16_t appTopText;
extern const uint32_t appBottomROdata;
extern const uint32_t appTopROdata;

/** This address is used to store the temporary unverified untrusted application during updates **/
extern const uint32_t elfAddress;



/** These addresses need to be syncrhonised with the memory layout of the target device **/
extern const uint16_t bslTop;
extern const uint16_t bslBottom;
extern const uint32_t flashTop;
extern const uint16_t flashBottom;
extern const uint16_t ramBottom;
extern const uint16_t ramTop;
extern const uint32_t vectorTop;
extern const uint32_t vectorBottom;

/** Entry points for virtual functions, which need to be synch with the linker and python scripts **/
extern const uint16_t safe_br;
extern const uint16_t safe_bra;
extern const uint16_t safe_call;
extern const uint16_t safe_calla;
extern const uint16_t safe_ret;
extern const uint16_t safe_reti;
extern const uint16_t safe_reta;

extern const uint16_t safe_mov;
extern const uint16_t safe_movx;
extern const uint16_t safe_xor;
extern const uint16_t safe_xorx;
extern const uint16_t safe_add;
extern const uint16_t safe_addx;
extern const uint16_t safe_addc;
extern const uint16_t safe_addcx;
extern const uint16_t safe_dadd;
extern const uint16_t safe_daddx;
extern const uint16_t safe_sub;
extern const uint16_t safe_subx;
extern const uint16_t safe_subc;
extern const uint16_t safe_subcx;

extern const uint16_t receive_update_address;
#endif
