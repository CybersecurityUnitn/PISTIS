## List of applications

- `ar-full/`: instrumented and correctly working
    - Execution time: 
- `bitcount/`: instrumented and correctly working
- `SHA-256/`: instrumented and correctly working
- `CopyCodeDMA/`: instrumented and correctly working. The Application copies the content of the flash into RAM with memcpy and with the DMA. In both cases it checks whether the result is correct. The DMA triggers an interrupt when finished.
    - Execution time: 
- `CantorSet/`: instrumented and correctly working
- `PolynomialAddiction/`: instrumented and correctly working
- `CryptoCode/`: instrumented and correctly working
- `SerialMSP/`: Set up an UART connection with a terminal and initiate the download of chunks of
data to be stored on the RAM.
    - Status: instrumented and correctly working
    - Execution time: 338.64ms
    - Instrumented time: 334ms

- `CartesianToPolar/`: instrumented and correctly working
- `LargeSubsequence/`: instrumented and correctly working
- `PrimeFactorisation/`: instrumented and correctly working
- `SudokuSolver/`: LINKER problem
- `TiBenchmark/`: folder containing all of the benchmark applications used by TI and during the evalution of the proposed PISTIS implementation.
    - `whet/`: instrumented and correctly working.
    - `matrixMultiplication/`: instrumented and correctly working.
    - `floatingPointMath/`: instrumented and correctly working.
    - `firFilter/`: instrumented and correctly working.
    - `dhry/`: instrumented and correctly working. NOT WORKING IN CCS
    - `8bitSwitchCase/`: instrumented and correctly working.
    - `16bitSwitchCase/`: instrumented and correctly working.
    - `8bitMath/`: instrumented and correctly working.
    - `16bitMath/`: instrumented and correctly working.
    - `32bitMath/`: instrumented and correctly working.
    - `8bit2dimMatrix/`: instrumented and correctly working.
    - `16bit2dimMatrix/`: instrumented and correctly working.
        

### Test code
```
    TA0CTL = TASSEL_2 + ID_0 + MC_2; // Start the timer with frequency of 32768 Hz

    ....


    /* end runtime measurement */
    register unsigned int stop = TA0R; // Stop timer
    while(1);
```