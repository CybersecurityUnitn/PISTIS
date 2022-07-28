/*******************************************************************************
**
Name : Whetstone
* Purpose : Benchmark the Whetstone code. The code focuses on scientific
* functions such as sine, cosine, exponents and logarithm on
* fixed and floating point numbers.
*
*******************************************************************************/
#include <math.h>
#include <msp430.h>
#include <stdio.h>

PA(float E[5]);
P0(void);
P3(float * X, float * Y, float * Z_var);
float T, T1, T2, E1[5];
int J, K, L;
float X1, X2, X3, X4;
long ptime, time0;

PA(float E[5]){
    int J1;
    J1 = 0;
    L10: E[1] = (E[1] + E[2] + E[3] - E[4]) * T;
    E[2] = (E[1] + E[2] - E[3] + E[4]) * T;
    E[3] = (E[1] - E[2] + E[3] + E[4]) * T;
    E[4] = (-E[1] + E[2] + E[3] + E[4]) / T2;
    J1 = J1 + 1;
    if ((J1 - 6) < 0) goto L10;
    return;
}
P0() {
    E1[J] = E1[K];
    E1[K] = E1[L];
    E1[L] = E1[J];
    return;
}
P3(float * X, float * Y, float * Z_var){
    float Y1;
    X1 = * X;
    Y1 = * Y;
    X1 = T * (X1 + Y1);
    Y1 = T * (X1 + Y1);
    * Z_var = (X1 + Y1) / T2;
    return;
}



void main() {
    /****************** GENERAL DEBUG SET-UP *******************/
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    // Setup leds
    //P1DIR |= BIT0;
    //P4DIR |= BIT7;
    //P4OUT &= 0x7f;
    //P1OUT &= 0xfe;

    //P4OUT |= BIT7; //Green led is the first verification

    //TA0CTL = TASSEL_1 + ID_3 + MC_2; // Start the timer
    /****************** START APPLICATION ********************/
    int LOOP, I, II, JJ, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11;
    float X, Y, Z_var;
    T = .499975;
    T1 = 0.50025;
    T2 = 2.0;
    LOOP = 1;
    II = 1;
    for (JJ = 1; JJ <= II; JJ++) {
        N1 = 0;
        N2 = 2 * LOOP;
        N3 = 2 * LOOP;
        N4 = 2 * LOOP;
        N5 = 0;
        N6 = 2 * LOOP;
        N7 = 2 * LOOP;
        N8 = 2 * LOOP;
        N9 = 2 * LOOP;
        N10 = 0;
        N11 = 2 * LOOP;
        /* Module 1: Simple identifiers */
        __asm("nop");
        X1 = 1.0;
        X2 = -1.0;
        X3 = -1.0;
        X4 = -1.0;
        if (N1 != 0) {
            for (I = 1; I <= N1; I++) {
                X1 = (X1 + X2 + X3 - X4) * T;
                X2 = (X1 + X2 - X3 + X4) * T;
                X3 = (X1 - X2 + X3 + X4) * T;
                X4 = (-X1 + X2 + X3 + X4) * T;
            };
        };
        /* Module 2: Array elements */
        __asm("nop");
        E1[1] = 1.0;
        E1[2] = -1.0;
        E1[3] = -1.0;
        E1[4] = -1.0;
        if (N2 != 0) {
            for (I = 1; I <= N2; I++) {
                E1[1] = (E1[1] + E1[2] + E1[3] - E1[4]) * T;
                E1[2] = (E1[1] + E1[2] - E1[3] + E1[4]) * T;
                E1[3] = (E1[1] - E1[2] + E1[3] + E1[4]) * T;
                E1[4] = (-E1[1] + E1[2] + E1[3] + E1[4]) * T;
            }
        }
        /* Module 3: Array as parameter */
        __asm("nop");
        if (N3 != 0) {
            for (I = 1; I <= N3; I++) {
                PA(E1);
            }
        }
        /* Module 4: Conditional jumps */
        __asm("nop");
        J = 1;
        if (N4 != 0) {
            for (I = 1; I <= N4; I++) {
                if (J == 1) goto L51;
                J = 3;
                goto L52;
                L51: J = 2;
                L52: if (J > 2) goto L53;
                J = 1;
                goto L54;
                L53: J = 0;
                L54: if (J < 1) goto L55;
                J = 0;
                goto L60;
                L55: J = 1;
                L60: __asm("nop");
            }
        }
        /* Module 5: Integer arithmetic */
        __asm("nop");
        J = 1;
        K = 2;
        L = 3;
        if (N6 != 0) {
            for (I = 1; I <= N6; I++) {
                J = J * (K - J) * (L - K);
                K = L * K - (L - J) * K;
                L = (L - K) * (K + J);
                E1[L - 1] = J + K + L;
                E1[K - 1] = J * K * L;
            }
        }
        /* Module 6: Trigonometric functions */
        __asm("nop");
        X = 0.5;
        Y = 0.5;
        if (N7 != 0) {
            for (I = 1; I <= N7; I++) {
                X = T * atan(T2 * sin(X) * cos(X) / (cos(X + Y) + cos(X - Y) - 1.0));
                Y = T * atan(T2 * sin(Y) * cos(Y) / (cos(X + Y) + cos(X - Y) - 1.0));
            }
        }
        /* Module 7: Procedure calls */
        __asm("nop");
        X = 1.0;
        Y = 1.0;
        Z_var = 1.0;
        if (N8 != 0) {
            for (I = 1; I <= N8; I++) {
                P3( & X, & Y, & Z_var);
            }
        }
        /* Module 8: Array references */
        __asm("nop");
        J = 1;
        K = 2;
        L = 3;
        E1[1] = 1.0;
        E1[2] = 2.0;
        E1[3] = 3.0;
        if (N9 != 0) {
            for (I = 1; I <= N9; I++) {
                P0();
            }
        }
        /* Module 9: Integer arithmetic */
        __asm("nop");
        J = 2;
        K = 3;
        if (N10 != 0) {
            for (I = 1; I <= N10; I++) {
                J = J + K;
                K = J + K;
                J = K - J;
                K = K - J - J;
            }
        }
        /* Module 10: Standard functions */
        __asm("nop");
        X = 0.75;
        if (N11 != 0) {
            for (I = 1; I <= N11; I++) {
                X = sqrt(exp(log(X) / T1));
            }
        }
    }
    /**************** END OF APP ***************************/
    //register unsigned int stop = TA0R; // Stop timer
    //P1OUT |= BIT0; // Red light
    //while(1);
    return 0;
}
