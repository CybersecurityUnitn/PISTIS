#include <msp430.h> 

#include <stdio.h>
#include <stdlib.h>

void longestSub(int *ARRAY, int ARRAY_LENGTH, int **RESULT, int *RESULT_LENGTH)
{  // RESULT and RESULT_LENGTH will be modified by their pointers

    if (ARRAY_LENGTH <= 1)
    {
        *RESULT = ARRAY;
        *RESULT_LENGTH = ARRAY_LENGTH;
    }
    else
    {
        int PIVOT = ARRAY[0];
        int *LONGEST_SUB = NULL;
        int i, j, LONGEST_SUB_LENGTH = 0;
        int TEMPORARY_ARRAY_LENGTH = 0, *TEMPORARY_ARRAY = NULL;

        for (i = 1; i < ARRAY_LENGTH; i++)
        {
            if (ARRAY[i] < PIVOT)
            {
                TEMPORARY_ARRAY_LENGTH = 0;
                TEMPORARY_ARRAY = NULL;

                for (j = i + 1; j < ARRAY_LENGTH; j++)
                {
                    if (ARRAY[j] >= ARRAY[i])
                    {
                        TEMPORARY_ARRAY_LENGTH++;
                        TEMPORARY_ARRAY = (int *)realloc(
                            TEMPORARY_ARRAY,
                            TEMPORARY_ARRAY_LENGTH * sizeof(int));
                        TEMPORARY_ARRAY[TEMPORARY_ARRAY_LENGTH - 1] = ARRAY[j];
                    }
                }

                longestSub(TEMPORARY_ARRAY, TEMPORARY_ARRAY_LENGTH,
                           &TEMPORARY_ARRAY, &TEMPORARY_ARRAY_LENGTH);
                if (LONGEST_SUB_LENGTH < TEMPORARY_ARRAY_LENGTH + 1)
                {
                    LONGEST_SUB_LENGTH = TEMPORARY_ARRAY_LENGTH + 1;
                    LONGEST_SUB = (int *)realloc(
                        LONGEST_SUB, LONGEST_SUB_LENGTH * sizeof(int));
                    LONGEST_SUB[0] = ARRAY[i];

                    for (i = 1; i < LONGEST_SUB_LENGTH; i++)
                        LONGEST_SUB[i] = TEMPORARY_ARRAY[i - 1];
                }
            }
        }

        TEMPORARY_ARRAY = NULL;
        TEMPORARY_ARRAY_LENGTH = 0;
        for (i = 1; i < ARRAY_LENGTH; i++)
        {
            if (ARRAY[i] >= PIVOT)
            {
                TEMPORARY_ARRAY_LENGTH++;
                TEMPORARY_ARRAY = (int *)realloc(
                    TEMPORARY_ARRAY, TEMPORARY_ARRAY_LENGTH * sizeof(int));
                TEMPORARY_ARRAY[TEMPORARY_ARRAY_LENGTH - 1] = ARRAY[i];
            }
        }

        longestSub(TEMPORARY_ARRAY, TEMPORARY_ARRAY_LENGTH, &TEMPORARY_ARRAY,
                   &TEMPORARY_ARRAY_LENGTH);
        if (TEMPORARY_ARRAY_LENGTH + 1 > LONGEST_SUB_LENGTH)
        {
            LONGEST_SUB_LENGTH = TEMPORARY_ARRAY_LENGTH + 1;
            LONGEST_SUB =
                (int *)realloc(LONGEST_SUB, LONGEST_SUB_LENGTH * sizeof(int));
            LONGEST_SUB[0] = PIVOT;
            for (i = 1; i < LONGEST_SUB_LENGTH; i++)
                LONGEST_SUB[i] = TEMPORARY_ARRAY[i - 1];
        }
        *RESULT = LONGEST_SUB;
        *RESULT_LENGTH = LONGEST_SUB_LENGTH;
    }
}

int main()
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    P1DIR |= BIT0;
    P4DIR |= BIT7;
    P4OUT &= 0x7f;
    P1OUT &= 0xfe;
    P1OUT |= BIT0;

    P4OUT |= BIT7; //Green led is the first verification
    //TA0CTL = TASSEL_1 + ID_0 + MC_2; // Start the timer with frequency of 32768 Hz
    int EXAMPLE_LENGTH = 30;
    int EXAMPLE[] = {3493, 4554, 4994, 3055, 3386, 4911, 241, 338, 3472, 4438, 55, 4183, 4716, 4926, 1869, 2092, 2518, 671, 3486, 320, 3049, 108, 71, 2968, 4457, 3513, 2398, 4819, 3718, 3236};

    int *RESULT = NULL;
    int RESULT_LENGTH, i;

    longestSub(EXAMPLE, EXAMPLE_LENGTH, &RESULT, &RESULT_LENGTH);

    //register unsigned int stop = TA0R; // Stop timer
    P1OUT |= BIT0; // Red light
    while(1);
}
