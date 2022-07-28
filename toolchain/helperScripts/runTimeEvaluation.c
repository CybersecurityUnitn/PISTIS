    /****************** GENERAL DEBUG SET-UP *******************/
    TA0CTL = TASSEL_1 + ID_0 + MC_2; // Start the timer with frequency of 32768 Hz
    //TA0CTL = TASSEL_2 + ID_0 + MC_2; // Start the timer with Frequency of 1Mhz

    /****************** START APPLICATION ********************/

    /**************** END OF APP ***************************/
    register unsigned int stop = TA0R; // Stop timer