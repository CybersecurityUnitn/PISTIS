/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#include <msp430.h>

const char key[] = "fioeosijiefi435jf394f93c9m3m9230cm293e48";
void encrypt(char* str, int length);

#define KEY_LENGTH 40
/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    P4DIR |= BIT2; //Set up also analyser
    P4OUT |= BIT2; //Start logical analyser
    long encodings = 10;
    char str1[] = "Hi, this is a test string. It's purpose is to test the functionig of the xor function";//String of length 245 chars + terminating char
    //char str3[] = "01234567890123456789";
    char str2[] = "GoodEvening, this is yet another test string. As for the other string, also this one must be used to test the crypto function";
    int len1 = 85; //characters
    //int len3 = 20;
    int len2 = 125; //chars
    long i = 0;
    while(i<encodings){

        //Encrypt 1
        encrypt(str1,len1);
        /*for(int j = 0; j < len1; j++){
            str1[j] ^= key[j%KEY_LENGTH];
        }*/
        //Encrypt 2
        encrypt(str2,len2);
        i++;
    }
    P4OUT &= (~BIT2); //Stop analyser
    return 0;
}

void encrypt(char* str, int length){
    for(int j = 0; j < length; j++){
        str[j] ^= key[j%KEY_LENGTH];
    }
    return;
}
