#include <msp430.h>
#include <TCMhook.h>

int ciao(int a, int b) {
    return a + b;
}

int main(void){
    int a = 1;
    int b = 2;
    int c = ciao(a, b);
    callReceiveUpdate();

    return 0;
}