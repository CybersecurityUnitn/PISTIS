#include <msp430.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>






/** structure to define Cantor set */
typedef struct _cantor_set
{
    double start;             /**< start of interval */
    double end;               /**< end of interval */
    struct _cantor_set *next; /**< pointer to next set */
} CantorSet;




/** Iterative constructor of all sets in the current level. This function
 * dynamically allocates memory when creating new sets. These are freed by the
 * function ::free_memory.
 * @param head pointer to interval set instance to update
 */
void propagate(CantorSet *head)
{
    // if input is NULL, ignore the process
    if (head == NULL)
        return;

    CantorSet *temp = head;  // local pointer to track propagation

    // create new node for the new set
    CantorSet *newNode = (CantorSet *)malloc(sizeof(CantorSet));

    // get 1/3rd of interval
    double diff = (((temp->end) - (temp->start)) / 3);

    // update interval ranges
    newNode->end = temp->end;
    temp->end = ((temp->start) + diff);
    newNode->start = (newNode->end) - diff;

    // update pointer to next set in this level
    newNode->next = temp->next;

    // point to next set
    temp->next = newNode;

    // create next set
    propagate(temp->next->next);
}


/** Clear memory allocated by ::propagate function.
 * @param head pointer to first allocated instance.
 */
void free_memory(CantorSet *head)
{
    if (!head)
        return;

    if (head->next)
        free_memory(head->next);

    free(head);
}

/** Main function */
int main(int argc, char const *argv[])
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    // Setup leds
    P1DIR |= BIT0;
    P4DIR |= BIT7;
    P4OUT &= 0x7f;
    P1OUT &= 0xfe;

    P4OUT |= BIT7; //Green led is the first verification

    //TA0CTL = TASSEL_2 + ID_3 + MC_2; // Start the timer with frequency of 32768 Hz


    int start_num = 50, end_num = 2531, levels = 2;


    CantorSet head = {.start = start_num, .end = end_num, .next = NULL};

    // loop to propagate each level from top to bottom
    for (int i = 0; i < levels; i++)
    {
        //printf("Level %d\t", i);

        //print(&head);
        propagate(&head);
        //printf("\n");
    }
    //printf("Level %d\t", levels);
    //print(&head);

    // delete all memory allocated
    free_memory(head.next);
    //register unsigned int stop = TA0R; // Stop timer
    P1OUT |= BIT0; // Red light
    while(1);
    return 0;
}
