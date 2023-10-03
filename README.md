# PISTIS
### Trusted Computing Architecture for Low-end Embedded Systems 
This repository includes all of the source files and helper scripts for **PISTIS**, a Trusted Execution Environment documented in the scientific paper "*PISTIS: Trusted Computing Architecture for Low-end Embedded Systems*" by Michele Grisafi, Mahmoud Ammar, Marco Roveri and Bruno Crispo. The article, presented at the USENIX Security '22 conference, discloses the content of this repository as an open source contribution to the scientific community.

If you have any questions on the content of the repository, feel free to contact the main author at michele.grisafi@unitn.it.

We highly recommend reading the scientific article before diving into this report!

Following, there is a list of instructions and broad guidelines on how to compile, run and test PISTIS. Depending on the board used for this evaluation, on the programming environment and the tools used, the behaviour of this implementation might change. 

**Disclaimer**: *The following is a working proof of concept. There might be bugs and inconsistencies which were not addressed. Furthermore, the code might damage your MCU board, erasing its memory or degrading its hardware. Use it at your own risk, we do not assume any responsibility for the use of this code, or for the damage it can cause.*

## Table of Content
- [PISTIS](#pistis)
   * [Content of this repository](#content-of-this-repository)
- [Introduction](#introduction)
   * [Isolation details](#isolation-details)
      + [Interrupts](#interrupts)
   * [Memory Map](#memory-map)
- [Running PISTIS](#running-pistis)
   * [Pre requisites](#pre-requisites)
   * [Loading PISTIS TCM (with the default untrusted application)](#loading-pistis-tcm-with-the-default-untrusted-application)
   * [Applications updates / Remote deployments](#applications-updates--remote-deployments)
      + [Compiling the update/application ](#compiling-the-updateapplication)
      + [Deploying untrusted update](#deploying-untrusted-update)
   * [LED signals](#led-signals)
   * [(optional) Loading the custom BSL](#optional-loading-the-custom-bsl)
      + [(optional) Loading the key](#optional-loading-the-key)
   * [Library instrumentation](#library-instrumentation)
      + [Optimisations](#optimisations)
      + [Debug and measurements](#debug-and-measurements)
- [APIs Description](#apis-description)
   * [Data Types](#data-types)
   * [Constants](#constants)
   * [Trusted Application APIs](#trusted-application-apis)
      + [Secure Remote Update](#secure-remote-update)
         - [**callReceiveUpdate**](#callreceiveupdate)
      + [Remote Attestation ](#remote-attestation)
         - [**callAttestCode**](#callattestcode)
   * [Private TCM APIs](#private-tcm-apis)
      + [Functions endpoints](#functions-endpoints)
         - [**launchAppCode**](#launchappcode)
         - [**verify_app_inst**](#verify_app_inst)
         - [**verify_app_cfi**](#verify_app_cfi)
         - [**isImmediateSafeValue**](#isimmediatesafevalue)
         - [**getSecureKey**](#getsecurekey)
         - [**setSecureKey**](#setsecurekey)
   * [Public TCM APIs](#public-tcm-apis)
      + [Assembly endpoints](#assembly-endpoints)
         - [**safe_br_fun**](#safe_br_fun)
         - [**safe_bra_fun**](#safe_bra_fun)
         - [**safe_call_fun**](#safe_call_fun)
         - [**safe_calla_fun**](#safe_calla_fun)
         - [**safe_ret_fun**](#safe_ret_fun)
         - [**safe_reta_fun**](#safe_reta_fun)
         - [**safe_reti_fun**](#safe_reti_fun)
         - [**write_mov_fun**](#write_mov_fun)
         - [**write_movx_fun**](#write_movx_fun)
         - [**write_xor_fun**](#write_xor_fun)
         - [**write_xorx_fun**](#write_xorx_fun)
         - [**write_add_fun**](#write_add_fun)
         - [**write_addx_fun**](#write_addx_fun)
         - [**write_addc_fun**](#write_addc_fun)
         - [**write_addcx_fun**](#write_addcx_fun)
         - [**write_dadd_fun**](#write_dadd_fun)
         - [**write_daddx_fun**](#write_daddx_fun)
         - [**write_sub_fun**](#write_sub_fun)
         - [**write_subx_fun**](#write_subx_fun)
         - [**write_subc_fun**](#write_subc_fun)
         - [**write_subcx_fun**](#write_subcx_fun)


## Content of this repository
- `BSL/`: this folder contains the files required for the modification of the BSL.
    - `IAR_BSL_Source/`: folder containing the IAR Workbench BSL project, used for flashing the new BSL into the device.
    - `modifiedFiles/`: folder containing the modified files used for PISTIS custom BSL.
        - `BSL430_Command_Interpreter.c`: file containing the command interpreter code, used to parse the BSL commands received. We are removing some of the functionalities of the BSL from this file to make room for our PISTIS Secure Storage.
        - `BSL430_Low_Level_Init.s43`: BSL interface for the program, containing the Z-area. We added some entries to this area, such as the BSL unlock function. This will be called by the TCM to enable write privileges over the BSL.
        - `lnk_msp430f5438a.ld`: BSL linker file.
    - `loadKey.c`: source file to load a custom cryptographic key onto PISTIS Safe Storage.
- `UpdateApplication/`: this folder contains all of the required files for compiling a single application for PISTIS. Specifically, it should be populated with the source files of the application.
    - `Makefile`: makefile for compiling the application to be deployed. The result is a file `deployable.out` which is ready for deployment.
    - `src/`: this folder should contain all of the source files of the user application to be compiled (both '.c' and '.s' files). 
- `TCM/`: this folder contains the source code of PISTIS TCM. Morevoer, it contains the source files of a user application (untrusted) that can be deployed alongside it without going over remote update.
    - `Makefile`: makefile for compiling both the untrusted application and the core of TCM. The result is the file `deployable.out` which is ready to be deployed on the MCU.
    - `app/`: folder containing all of the files required for the compilation of the untrusted application
        - `src/`: folder containing all of the source files, both '.c' and '.s' of the untrusted application
        - `Makefile.include`: makefile to be included, containing some directives for the compilation of the application by the main Makefile
    - `core/`: folder containing all of the files required for the PISTIS compilation.
        - `src/`: folder containing all of the source files, both '.c' and '.s' of PISTIS.
            - `core.c|.h`: file containing the source code for the main PISTIS functions.
            - `virt_fun.s`: assembly file containing the definitions of the various virtual functions.
            - `protected_isr.s`: assembly file containing the protected Interrupt Service Routines for the secure interrupt management.
            - `secureContextSwitch.c|.h`: source files for the secure context switch operations which allow the backup and restoration of the RAM, or any other hook operation during a safe context switch.
            - `TCMhook.h`: header file needed by the application (needs to be included in the source files with the '#include' directive) in order to call the secure update function. This file get automatically copied to the `app/src/` directory of the application.
        - `ext_modules/`: folder containing the source files of the various extensions. These files are copied in the `core/src/` folder by the makefile if specified.
            - `secureUpdate.c|.h`: source file for the secure update over serial communication.
            - `raHelper.c|.h`: source files for some backup/restore operations performed by the Remote Attestation.
            - `raHelperAsm.s`: assembly files for some backup/restore opearation performed by the Remote Attestation.
            - `remote_attestation/`: folder containing the HACL implementation of remote attestation.
                - `ra.c`: our implementation, leveraging the HACL library, of the remote attestation.
        
        - `Makefile.include`: makefile to be included, containing some directives for the compilation of the TCM by the main Makefile
- `toolchain/`: folder containing all of the scripts required by the makefile and the deployment process
    - `linkerScript.ld`: modified linker scripts containing the directives for the linker when compiling ONLY the application. Used exclusively by the Makefile.
    - `linkerScriptWithCore.ld`: modified linker scripts containing the directives for the linker when compiling both the application and the TCM. Used exclusively by the Makefile.
    - `loadProgram.py`: python script used to load the program onto the MCU via UART interface (serial port), in compliance with the PISTIS secure update protocol.
    - `metadata.py`: python script in charge of adding the required metadata to the output file. Used exclusively by the Makefile.
    - `modifier.py`: python script in charge of replacing unsafe instructions. Used exclusively by the Makefile.
    - `postprocessor.py`: python script in charge of rejecting the application in case of unsafe instructions (compile-time). Used exclusively by Makefile.
    - `gccLibraries/`: contains all of the statically linked libraries used by GCC and adapted to our toolchain (insertion of NOP slides and reserved registers). The `*.small` files inside refer to libraries using ret and call instead of reta and calla.
        - `libcrt.a`: statically linked library of gcc, compiled from the gcc source folder with the instrumented file `newlib/libgloss/msp430/crt0.S|crt_bss.S` which generates the compiled file `msp430-elf/large/full-memory-range/libgloss/msp430/libcrt.a`. The new file must be placed in `compilerGCCRoot/msp430-elf/lib/large/full-memory-range`. **crt0_movedata** and **crt0_init_bss** have been instrumented (adding the NOP slides). Others, such as call_main and call_exit are not but we should not need them.
        - `libgcc.a`: statically linked library compiled with a modified makefile (to prevent use of reserved registers '*-ffixed-r4 -ffixed-r5 -ffixed-r6*') `sourceGCC/gcc/libgcc/Makefile.in` yielding the file `build/gcc/msp430-elf/large/full-memory-range/libgcc/libgcc.a` to be placed in `compilerGCCRoot/lib/gcc/msp430-elf/9.2.0/large/full-memory-range`
        - `libnosys.a` and `libsim.a`: statically compiled files obtained from the modified makefile (to prevent use of reserved registers '*-ffixed-r4 -ffixed-r5 -ffixed-r6*') `sourceGCC/newlib/libgloss/msp430/Makefile.ini` yielding the files `build/gcc/msp430-elf/large/full-range-memory/libgloss/msp430/libnosys.a|libsim.a`. To be placed in `compiler//msp430-elf/lib/large/full-memory-range`
        - `libc.a`: statically linked library compiled with a modified makefiles (to prevent use of reserved registers '*-ffixed-r4 -ffixed-r5 -ffixed-r6*') `sourceGCC/newlib/newlib/libc/string/Makefile.in`,`sourceGCC/newlib/newlib/libc/string/Makefile.in`,`sourceGCC/newlib/newlib/libc/string/Makefile.in`  yielding the file `build/gcc/msp430-elf/large/full-memopry-range/newlib/libc.a`. 
        The new file must be placed in `compiler/msp430-elf/lib/large/full-memory-range`
    - `helperScripts/`: contains all of the scripts that are helpful in the creation of a proper application image
        - `auxGccPaser.py`: python script that parses a portion of mspdump code and performs the following operations:
            - Format the files to assembly standard.
            - Locates the relevant functions and labels, renaming them so that they can be compiled.
            - Replaces all of the jumps offsets, branches arguments and calla destinations with the correct label so that they can be relocated.
        - `getSizeData.py`: compiles every single test application and retrieves the size info of the various files.
        - `objToHex.py`: python script that parses an object file - created by the `metadata.py` script with the 'debugFiles' set to true - and outputs its content byte by byte so that it can be used in an `injectData.c` source file.
        - `runTimeEvaluation.c`: small C file containing the code used for the runTime evaluation. 
        - `powerConsumption/`: contains all of the scripts for getting the battery consumption with its graphs.
            - `Battery.java`: simulates the battery consumption at various execution rates.
            - `getConsumptions.sh`: script to get all of the power measures via the java script.
            - `getGraph.py`: script to generate graphs for the power measures obtained with the above script.
        - `remote_attestation/verifier/verifier.py`: python script acting simulating a verifier for the Remote Attestation. This script computes the HMAC of a block of data.     
    - `compiler/`: contains the various compilers used by PISTIS, with some compilation libraries and some backups.
        - `include_gcc/`: contains some of the includes files required by the compiler and provided by TI.
        - `msp430-gcc-9.2.0.50_linux64/`: contains the compiled GCC compiler used by PISTIS.
        - `msp430-gcc-9.2.0.50_linux64_backup/`: contains the backup of some of the files modified by our toolchain. These are required for the compilation of uninstrumented applications.
        - `msp430-gcc-9.2.0.50-source-full.tar.gz`: archive containing the modified source files (as described in the `gccLibraries/` folder) for the compilation of the desired libraries and executables.
- `TestApps/`: folder containing all of the test applications used during the evaluation of the proposed PISTIS implementation.
    - `ar-full/`: instrumented and correctly working
    - `bitcount/`: instrumented and correctly working
    - `SHA-256/`: instrumented and correctly working
    - `CopyCodeDMA/`: instrumented and correctly working. The Application copies the content of the flash into RAM with memcpy and with the DMA. In both cases, it checks whether the result is correct. The DMA triggers an interrupt when finished.
    - `CantorSet/`: instrumented and correctly working
    - `PolynomialAddiction/`: instrumented and correctly working
    - `CryptoCode/`: instrumented and correctly working
    - `Serial/`: instrumented and correctly working
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
        

# Introduction
Pistis is a bare-metal Trusted Execution Environment (TEE) for low-end embedded systems with no support to MMU/MPU. As a TEE, Pistis creates a new execution environments where secure software can run without interference from the untrusted software. We refer to these two environments as the TEE and the Unstrusted Environment (UE). These two environments coexist on the device and are separated by Pistis' software-based primitives, which ensure that the TEE is completely isolated from the UE. 
Being a software-based TEE, Pistis relies on a Trusted Computing Module (TCM) to enforce the isolation between the two environments. The TCM is a piece of software acting as Root of Trust (RoT) that is run in the TEE, alongside other Trusted Applications (TAs). 
These TAs can be deployed by security developers to implement some arbitrary security services. These services can then be leveraged by any software running on the UE using a set of registered APIs. 



## Isolation details
The TCM enforces a software-based separation on the memory and the pheripherals of the device. Similarly to a TrustZone-enabled environment, the TEE has complete control over the entire device, while the UE has only *limited* control over the UE-assigned resources. At boot, the control is given to the TEE, where the TCM performs an initialisation of the device and of the UE environment, afterwhich the control is given to the UE. From that moment onward, there is a master-slave relationship between the TEE and the UE, with the former that is executed only upon request of the UE. 
The UE supports up to one single application binary, which must include the so called Untrusted Application. This application must comply with the Pistis' security policy, which is enforced by the TCM. For instance, the UE is not allowed to access any resource outside of the ones assigned to it by the TCM. Any violation of these policy will be detected at deployment time or at run time, and it trigger a device reset.
Pistis offers a custom toolchain to the UE developers that transparently makes the application binary compliant with Pistis security policy.

### Interrupts
Interrupts are not shared among the UE and the TEE. Conceptually, the TEE has full control over the interrupts, and allows the UE to register its own interrupt handlers. When an interrupt is triggered, the TEE will look up the interrupt table and invoke the right handler. This handler will then be executed in the TEE, which will then return the control to the UE. It is up to the TEE to decide whether to allow the UE to register a handler for a given interrupt or not.

## Memory Map
The software-based isolation of Flash, RAM and MMIO is achieved by means of a custom memory map. The memory map is defined in the linker script and is shown in the following table.

|Address|Name|Description|
|------|-----|-----------|
|0x000-fff|MMIO|Registers for pheripherals|
|0x1000-17ff|BSL/TEE Safe Storage| BSL and PISTIS Secure Storage|
|0x1800-19ff|Information Memory|Hardware info used for calibration of the board|
|0x1c00-2aff|TEE Ram|Ram used by PISTIS Trusted Applications|
|0x2c00-43ff|App RAM|Ram used by the untrusted application |
|0x4400-c3ff|App Code|Where the untrusted yet verified code of the application resides|
|0xc400-f7ff|TEE code|Code of the TEE|
|0xf800-fbff|TEE Secure ISRs|Trampoline for App ISRs. Each entry will load the right App ISR pointer|
|0xfc00-ff7f|TEE virtual functions|Functions invoked by the untrusted app in replacement of the original unsafe instructions|
|0xff80-ffff|TEE ISRs trampoline|Trampoline for TEE ISRs. Interrupts will trigger a lookup of this table, which will lead to the TEE Secure ISRs entries.|
|0x10000-101ff| TEE backup data|Where the PC and status register are saved during interrupts |
|0x10200-103ff| TAs backup data|Where the CPU context (i.e. the registers) are saved during interrupts of TAs|
|0x10400-105ff| App ISRs | Where the app stores the pointers to the ISRs. Each entry stores the address of the APP ISR|
|0x10600-143ff|TEE code|Code of the TEE|
|0x14400-1c3ff|App RoData| Read Only data for the application|
|0x1c400-243ff|Reserved|Used for incoming data|


# Running PISTIS
## Pre requisites
- **linux**: build-essential python3 pip3
- **pip3**: pyserial [matplotlib] [pandas]
- MSP430F5529 board with USB cable (we use a MSP-EXP430F5529LP)
- Code Composer Studio with MSP430 libraries [official link](https://www.ti.com/tool/CCSTUDIO)
- (optional) MSP430 debugger (e.g. MSP430F5529Launchpad version) [board link](https://www.ti.com/tool/MSP-EXP430F5529LP)
- (optional) IAR workbench msp430 Kickstart edition [official link](https://www.iar.com/products/architectures/iar-embedded-workbench-for-msp430/#containerblock_3096)
- (optional) Java for the execution of powerConsumption measurement scripts.


## Loading PISTIS TCM (with the default untrusted application)
In order to secure the microcontroller, the TCM (i.e. the root of trust for our architecture) needs to be loaded before any other program. The folder `TCM/` contains all of the required files for the compilation of PISTIS TCM. Although it is possible to also load an untrusted application right away, to be loaded with the TCM, currently the toolchain does not fully support it. The first initialisation should be perfomed with the default application. 
The following steps must be performed:
- (optional) Copy all of the required untrusted application's source files inside the `TCM/app/src/` folder. The default application only calls the *receiveUpdate()* function from the TCMHooks to initiate a secure update. If such function is not required, or the secureupdate module is not loaded, it should be changed. If no application is loaded, the default one will be. This will initiate a secure update and thus wait for any deployable on the UART communication.
- (optional) Modify the `TCM/Makefile` file to update the binaries paths. By default the toolchain will use the self-contained compiler in this repository.
- Generate the secure deployable image of the TCM using the `make` command from inside the `TCM/` folder. This will generate a `deployable.out` binary (if curious, you can check it with *readelf* to see how it is structured).
- Load the `TCM/deployable.out` image on the device, e.g. using Code Composer Studio 'load' function. If everything was loaded correctly, you should see the following:
    1. The red LED blinks 10 times
    2. The red LED turns on for verification (a few seconds)
    3. The green LED turns on --> ready for incoming updates
- You can also reset the board to start the verification from the beginning.
If you see any other combination of LED check section "LED Signals" for debugging.

## Applications updates / Remote deployments
### Compiling the update/application 
In order to securely deploy an application via PISTIS, a properly crafted update must be compiled. To automate this process, PISTIS offers the folder `UpdateApplication/` which contains the Makefile that must be used. Precisely, the following steps are required to compile the untrusted update:
- Copy all of the source files of the application ('*.c' and '*.s') to the `UpdateApplication/src/` folder. If the folder does not exist it should be created. These are the files that will be compiled.
- Execute the `make` command. This will generate the first executable `deployable.out`. 
- Execute the `make libraries` command to generate some helper files for the instrumentation of the standard library code (check section "Library instrumentation" for more details).
- Execute the `make clean && make` command to generate the final executable `deployable.out` containing the instrumented code for both the application and the standard libraries used by it. NB: this executable is not an ELF file because it contains extra metadata added for PISTIS. To check the original ELF file you can inspect `appWithoutMetadata.out`.
- Proceed with the deployment



### Deploying untrusted update
An application update can only be performed if the MCU is in the receiving update state (see Section **LED signals**). In order to enter this state, the running program must call the `callReceiveUpdate()` function from the `TCMhook.h` header file (as is the case when loading the TCM with the default application). When the MCU is ready to receive the update execute the `/toolchain/loadProgram.py` python script, passing as arguments the final application binary (e.g. `deployable.out`) and the serial port name (e.g. `/dev/ttsyAC2` on Linux or `COM4` on Windows). NB: The serial port might change across executions or systems, please check the serial ports available on your system (especially those that become available as soon as the MCU board is plugged through the USB port).

If the serial port is correct, the script will start uploading the various chunks of the application, waiting for some acknowledgments. As soon as the upload is finished, the script will output a *File sent* to the terminal and the TCM will begin its deployment operations.
As soon as the TCM receives the image it will verify it. If the image is verified with success and the binary does not contain unsafe code (as should be the case if properly compiled using PISTIS toolchain), then it should be lunched by the TCM. Otherwise, the TCM will restart the update process and wait for another valid image. 


Be aware that the code in this repository is compatible with the MSP430 family of microcontroller. However, the code, along with some of the toolchain components, needs to be updated to work with anything different than an MSP430f5529 MCU.


## LED signals
The following table shows the current PISTIS' usage of the various LEDs.

| Green LED | Red LED | Description |
| --------- | ------- | ----------- |
|   blink*10 → ON      | OFF     | The TCM is waiting for an income update       |    
|   ON      | ON      | *reserved*       |
|   OFF     | OFF     | Application started       |
|   OFF     | ON      | Verification of code in progress       |
|   OFF     | blink*10 → ON     | MCU has been reset, starting secure boot       |



## (optional) Loading the custom BSL
Some functionalities of PISTIS are only available if we modify the BSL section of the FLASH. Specifically, we want to reduce some of its codebase in order to make room for the sensitive data. Moreover, we want to modify its interface (z-area) to allow the TCM to interact with it without restrictions. 
To modify the bootloader we need to use IAR workbench msp430, which is a closed-source IDE. Fortunately, we can use its free kickstart edition to modify part of the BSL to support our TCM safe Storage segment. 
The following steps must be be permed:
- Make a copy of the project `BSL/IAR_BSL_Source/IAR_v5_MSP430F552x_USB/` folder.
- Open the local copy with IAR workbench.
- Copy the files in the `BSL/modifiedFiles/` folder to the local copy of the project (these should be placed in the various subdirectories). 
- Compile the project and upload it to the MCU. 
After compiling and uploading the BSL, the MSP430 board will be equipped with the PISTIS Safe Storage segment.

### (optional) Loading the key
Before loading the TCM, we need to load a cryptographic key on the device so that it can be used by the various Trusted Applications (TAs). Note that this step is optional: a cryptographic key is only needed by some specific TAs, e.g. Remote Attestation. Still, the TCM offers some security guarantees which are independent of the PISTIS Safe Storage.
In order to load the key, we can use the `BSL/loadKey.c` application by flashing it on the device, e.g. via CCS Studio. This application will take care of unlocking the BSL and storing a pre-defined key (which can be modified in the source file) on it, locking the BSL afterwards.


## Library instrumentation
Applications using common libc functions, such as *memset*, *memcpy* and similar, need a few extra steps in order to correctly work. Since our untrusted toolchain (i.e. the prepocessor and modifier scripts) only works with source files, it cannot be used to instrument the statically linked binaries. Such binary code derives from statically linked libraries, e.g. the libc library, for instance whenever functions such as *malloc* are required. The binary code is therefore appended to the rest of the instrumented application binary whenever compiling with the GCC linker. The instrumentation of the binary code is automatically performed by our toolchain (althogh it might not be optimal in some cases).

In order to fully optimise the library code used by an application, the following steps should be performed, some of which are manual.
First, our modified linker script assigns the explicit application binary code (i.e. only the binary code derived from the files in `UpdateApplication/src/`, without the libc libraries) to the **.appText** code section. Code sections allow the code to be organised in the binary, allowing the linker to place them in the different parts of the memory. Although our custom .appText section is placed alongside the rest of the application code, which by default would be assigned to the **.text** section, this separation allows us to easily spot the statically linked code. More precisely, while **.appText** will contain our source code, **.text** and **.lower.text** will only contain the code of the libraries. We can therefore fetch it by extracting only the **.text** and the **.lower.text** sections from the assembly dump of the binary file. These sections will indeed only contain the code not derived from our source files, i.e. the statically linked binary code. 

To facilitate this process, we propose an auxiliary script **auxGccParser** that extracts the library code from the deployable and performs some optimisations. This will create the new file `UpdateApplication/src/helper.s` containing the **uninstrumented** code. 

### Optimisations
On top of creating a new assembly file, the **auxGccParser** script will output to console some possible optimisations, e.g. "Possible optimisation with calla r7 found". These are dynamic calls found in the binary code that could be replaced with some static calls, thus improving the performance of the code. With the current toolchain, such optimisations are mere suggestions that require manual verification and inspection. Beware that  some of them could not be valid! To figure out which are indeed valid and apply them, a manual inspection is required. Specifically, the following steps should/could be performed. Examining the newly created file `UpdateApplication/src/helper.s`, for each optimisation mentioned by the output of the above script, do the following:
- Find the dynamic call in question, e.g. `calla r7`, by searching the file.
- Look for the instruction that assign a value to the concerning register (e.g. `mova	#_sbrk_r,	r7`, which loads the address of `_sbrk_r` into `r7`). **NB:** this instruction must be looked for among the assembly instructions **preceding** the dynamic call.
- Replace the dynamic call (e.g. `calla r7`) with a call to the label used in the definition (e.g. `calla #_sbrk_r`).
- Remove the assignation (e.g. `mova	#_sbrk_r,	r7`) since no longer needed.

Note that it might not be trivial deciding whether the optimisation is valid or not: some might seem valid but might instead break the application. As a rule of thumb, the optimisation is valid as long as there is no other register assignation (e.g. for `r7`) between the dynamic call and the spotted assignation. This means that the call will indeed be only to that static address (e.g. `_sbrk_r`). 
**NB**: be aware of the jumps that might make the analysis of the code non-linear.


### Debug and measurements
In order to debug PISTIS or to run measurements, it might be useful to run PISTIS in Code Composer Studio (CCS). To facilitate this, the archive `debugCCSProject.zip` contains an exported CCS project. This can be imported in CCS and used to debug the various components of PISTIS.
Measurements can be computed using the internal clocks as well in debug mode, or with a logical analyser for a more accurate evaluation.



# APIs Description
PISTIS is a TEE composed of three different interfaces: the Trusted Applications APIs, the Private TCM APIs and the Public TCM APIs. The Trusted Applications APIs are endpoints offered by the various Trusted Applications deployed on Pistis. The Private TCM APIs are only exposed to Trusted Applications while the Public TCM APIs can be invoked by the Untrusted Application.


## Data Types
PISTIS uses custom defined data types (_some of these might also be defined by the standard lib_). These are accessible by the Trusted Applications, with the Untrusted Application having to rely on their own data types.

| **Type** | **Description**                      |
|--------------|----------------------------------|
| `uint8_t`      | Unsigned 8-bit integer |
| `int8_t`      | Signed 8-bit integer |
| `uint16_t`      | Unsigned 16-bit integer |
| `int16_t`      | Signed 16-bit integer |
| `uint32_t`      | Unsigned 32-bit integer |
| `int32_t`      | Signed 32-bit integer |
| `bool`      | Boolean type that is unsigned integer of max 255 |
| `char`      | Character type |

## Constants
PISTIS uses several constants that are accessible to its Trusted Applications. These are mostly used to hold the addresses of the memory map that is implemented. *These constants might change with different implementations on different MSP430 devices.*


| **Label** | **Value**  | **Description** |
|--------------|-----------------|-----------------|
| `true`      | `1` | True value|
| `false`      | `0` | False value |
| `REJECTED` | `1` | Indicates a rejected outcome of a verification |
| `VERIFIED` | `0` | Indicates a successful outcome of a verification |
| `KEY_SIZE` | `64` | Size of the secure key |
| `appTopRam` | `0x43FF` | Top adress for the unstrusted application RAM |
| `appBottomRam` | `0x2c00` | Bottom adress for the unstrusted application RAM |
| `appTopText` | `0xc3ff` | Top adress for the unstrusted application code section |
| `appBottomText` | `0x4400` | Bottom adress for the unstrusted application code section |
| `appBottomROdata` | `0x00014400` | Bottom adress for the unstrusted application Read-Only data section |
| `appTopROdata` | `0x0001c3ff` | Top adress for the unstrusted application Read-Only data section |
| `elfAddress` | `0x0001c400` | Address in which the ELF file should be stored during an remote update procedure |
| `bslTop` | `0x17ff` | Top address of the BSL section |
| `bslBottom` | `0x1000` | Bottom address of the BSL section |
| `flashTop` | `0x000243ff` | Top address of the Flash memory |
| `ramTop` | `0x43ff` | Top address of the RAM memory |
| `vectorTop` | `0x0001047c` | Top address of the IVT table in Flash memory |
| `vectorBottom` | `0x00010400` | Bottom address of the IVT table in Flash memory |



## Trusted Application APIs
Pistis comes with two Trusted Applications (TAs): *Secure Remote Update* and *Remote Attestation*. However, PISTIS supports the creation of custom TAs to boost the security guarantee of the system. Each TA can implement one or more security services, which are exposed to the Untrusted Application via a set of APIs. Furthermore, a TA can also call another TA service by using the same endpoints. Following is a list of the currently implemented APIs belonging to our two TAs.

### Secure Remote Update
Trusted Application that updates the entire application binary for the untrusted application. This can be requested by either the TCM or by the application itself. 

#### **callReceiveUpdate**
```c
void callReceiveUpdate();
```

**Description**
Initiate a secure remote update to update the entire untrusted application binary. Once called, this function will blink the green as soon as it is ready to receive the update.
This function does not have any return value because it will completely replace the application binary, thus the return value would not be consumed.

### Remote Attestation 
Trusted Application that attest the entire untrusted application code section. This can be requested by either the TCM or by the application itself. 

#### **callAttestCode**
```c
void callAttestCode(uint8_t * mac, uint8_t * nonce);
```

**Description**
Initiate a remote attestation procedure for the untrusted application code.

**Parameters**
- `uint8_t * mac`: pointer to a 64 bytes long buffer where the MAC will be stored.
- `uint8_t * nonce`: pointer to a 64 bytes long buffer containing the nonce to be used in the MAC computation.




## Private TCM APIs
On top of exposing some APIs to the untrusted domain, PISTIS also has a set of APIs that can be used only within Trusted Applications. These are C functions rather than assembly, and allow PISTIS to perform some privileged task on behalf of the TAs.

### Functions endpoints
#### **launchAppCode**
```c
void launchAppCode();
```
**Description**
Locks the memory controller, enables the interrupts and then executes the application code by jumping to the first untrusted application instruction. This function can be called at the end of a successful verification to start the untrusted application. **If this function is called after a unsuccessful verification, i.e. PISTIS detected some unsafe instructions in the untrusted application, it will lead to an unsafe execution with a potential breach of the system security.**


#### **verify_app_inst**
```c
bool verify_app_inst(uint16_t address, uint16_t lastAddress);
```
**Description**
Lunch the instruction verification for a certain untrusted section of code to detect the presece of unsafe instructions. This function can be used by any Trusted Application that wants to make sure that a specific portion of untrusted code is safe to be executed. **It should be called before `verify_app_cfi`.**

**Parameters**
- `uint16_t address`: address from which the verification should start, e.g. the first instruction of the application.
- `uint16_t lastAddress`: address that the verification should reach, after which the verification ends, e.g. the last instruction of the application.

**Return Value**
Upon successful verification and if the code does not contain unsafe instruction, the return value is `VERIFIED`, otherwise it is `REJECTED`.

#### **verify_app_cfi**
```c
bool verify_app_cfi(uint16_t address, uint16_t lastAddress);
```
**Description**
Lunch the instruction verification for a certain untrusted section of code to detect violation of the control flow. This function can be used by any Trusted Application that wants to make sure that a specific portion of untrusted code is safe to be executed. **It should be called after with `verify_app_`. It does not validate the control flow of the application (whether the application will function correctly), but rather if the control flow of the application can violate the security of the system.**

**Parameters**
- `uint16_t address`: address from which the verification should start, e.g. the first instruction of the application.
- `uint16_t lastAddress`: address that the verification should reach, after which the verification ends, e.g. the last instruction of the application.

**Return Value**
Upon successful verification and if the code does not contain unsafe instruction, the return value is `VERIFIED`, otherwise it is `REJECTED`.



#### **isImmediateSafeValue**
```c
bool isImmediateSafeValue(uint32_t destination);
```
**Description**
Check whether a certain address is safe to be called from the untrusted code. This will perform several checks, mainly comparing the given address with the memory boundaries and with the various public TCM APIs.

**Parameters**
- `uint32_t destination`: destination address to be checked, where the code should jump to.

**Return Value**
Upon successful verification, the return value is `true`, indicating that it is a static safe value, or `false` indicating that the address is unsafe to jump to.

#### **getSecureKey**
```c
void getSecureKey(uint8_t * key);
```

**Description**
Contrarily to many TEE environments, PISTIS does not handle feature-rich secure storage. Instead, it merely offers a small protected memory segment where the Trusted Applications can store a *shared* 64 Bytes cryptographic key. This key can only be set and retrieved by the Trusted Applications. To retrieve it, the `getSecureKey` can be used.

**Parameters**
- `uint8_t * key`: pointer to a buffer where the key will be stored.

#### **setSecureKey**
```c
void setSecureKey(uint8_t * key);
```

**Description**
Contrarily to many TEE environments, PISTIS does not handle a feature-rich secure storage. Instead, it merely offers a small protected memory segment where the Trusted Applications can store a *shared* 64 Bytes cryptographic key. This key can only be set and retrieved by the Trusted Applications. To store it, the `setSecureKey` can be used.

**Parameters**
- `uint8_t * key`: pointer to a buffer containing the 64 Bytes encryption key.


## Public TCM APIs
In order to enforce its access control policy, PISTIS requires the untrusted applications to comply with a strict memory layout (enforced automatically and transparently by Pistis toolchain). In practice, this means that PISTIS does not accept applications that use instructions that violate such memory policy, i.e. unsafe instructions. To assert the application compliance, PISTIS performs a binary verification of the application code to make sure no unsafe instruction is used. We define as unsafe instruction all those that explicitly try to violate the memory layout, e.g. a jump in a forbidden area, and also some dynamic instructions whose safety cannot be verified at deployment time, e.g. dynamic jumps. To support the latter instructions, PISTIS offers a set of APIs to emulate them. For instance, dynamic jumps can, and must, be replaced with a call to the APIs that virtualise them. Ultimately, these APIs virtualise the unsafe instruction making sure they comply with the access control policy.

These public TCM APIs are assembly functions and cannot be called from C. They require the manual setting of some parameters in some specific registries. Moreover, any call of these APIs should be preceded by the disabling of the interrupts to guarantee the application's correct functioning (NB: it is not a security requirement!).

*These APIs are automatically and trasparently called by the Pistis Toolchain available to the Untrusted Application developers. These should not be invoked manually.*

### Assembly endpoints
#### **safe_br_fun**
**Description**
The `safe_br_fun` function virtualises a branch `br`, i.e. a dynamic jump to an address dependent from a register.


**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R6           | Destination address for the jump |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV R8 R6   ; R8 contains the destination
BRA safe_br_fun
```

#### **safe_bra_fun**
**Description**
The `safe_bra_fun` function virtualises a branch `bra`, i.e. a dynamic jump to an address dependent from a register.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R6           | Destination address for the jump |
| R4           | Status Register (SR) content     |

**Example**
```
MOV SR R4
DINT
NOP
MOVX.A R8 R6    ; R8 contains the destination
BRA safe_bra_fun
```

#### **safe_call_fun**
**Description**
The `safe_call_fun` function virtualises a call `call` to a function, i.e. a dynamic call to a function whose address is dependent from a register.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R6           | Destination address for the jump |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV R8 R6   ; R8 contains the destination
CALL safe_call_fun
```

#### **safe_calla_fun**
**Description**
The `safe_calla_fun` function virtualises a call `calla` to a function, i.e. a dynamic call to a function whose address is dependent from a register.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R6           | Destination address for the jump |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX.A R8 R6  ; R8 contains the destination
CALLA safe_calla_fun
```

#### **safe_ret_fun**
**Description**
The `safe_ret_fun` function virtualises a return `ret` from a function, i.e. a jump to an address stored on the stack.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
BRA safe_ret_fun
```

#### **safe_reta_fun**
**Description**
The `safe_reta_fun` function virtualises a return `reta` from a function, i.e. a jump to an address stored on the stack.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
BRA safe_reta_fun
```


#### **safe_reti_fun**
**Description**
The `safe_reti_fun` function virtualises a return from interrupts `reti`, i.e. a jump to an address stored on the stack.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
BRA safe_reti_fun
```

#### **write_mov_fun**
**Description**
The `write_mov_fun` function virtualises a write `MOV` to a dynamic address, i.e. contained in a register. 

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The content to be written |
| R6           | The destination for the write |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be written
MOV R9 R5   ; R9 contains the destination address
CALL write_mov_fun
```

#### **write_movx_fun**
**Description**
The `write_movx_fun` function virtualises a write `MOVX` to a dynamic address, i.e. contained in a register.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The content to be written |
| R6           | The destination for the write |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be written
MOVX R9 R5   ; R9 contains the destination address
CALL write_movx_fun
```

#### **write_xor_fun**
**Description**
The `write_xor_fun` function virtualises a bitwise XOR `XOR` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be xored  |
| R6           | The destination operand to be xored |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be xored
MOV R9 R5   ; R9 contains the destination address
CALL write_xor_fun
```

#### **write_xorx_fun**
**Description**
The `write_xorx_fun` function virtualises a bitwise XOR `XORX` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be xored  |
| R6           | The destination operand to be xored |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be xored
MOVX R9 R5   ; R9 contains the destination address
CALL write_xorx_fun
```

#### **write_add_fun**
**Description**
The `write_add_fun` function virtualises a ADD `ADD` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be added
MOV R9 R5   ; R9 contains the destination address
CALL write_add_fun
```

#### **write_addx_fun**
**Description**
The `write_addx_fun` function virtualises a ADD `ADDX` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be added
MOVX R9 R5   ; R9 contains the destination address
CALL write_addx_fun
```

#### **write_addc_fun**
**Description**
The `write_addc_fun` function virtualises a ADD with carry bit `ADDC` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be added
MOV R9 R5   ; R9 contains the destination address
CALL write_addc_fun
```

#### **write_addcx_fun**
**Description**
The `write_addcx_fun` function virtualises a ADD `ADDCX` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |

**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be added
MOVX R9 R5   ; R9 contains the destination address
CALL write_addcx_fun
```

#### **write_dadd_fun**
**Description**
The `write_dadd_fun` function virtualises a decimal ADD with carry bit `DADD` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be added
MOV R9 R5   ; R9 contains the destination address
CALL write_dadd_fun
```

#### **write_daddx_fun**
**Description**
The `write_daddx_fun` function virtualises a decimal ADD `DADDX` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be added  |
| R6           | The destination operand to be added |
| R4           | Status Register (SR) content     |

**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be added
MOVX R9 R5   ; R9 contains the destination address
CALL write_daddx_fun
```

#### **write_sub_fun**
**Description**
The `write_sub_fun` function virtualises a subtraction `SUB` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be subtracted  |
| R6           | The destination operand to be subtracted |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be subtracted
MOV R9 R5   ; R9 contains the destination address
CALL write_sub_fun
```

#### **write_subx_fun**
**Description**
The `write_subx_fun` function virtualises a subtraction `SUBX` operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be subtracted  |
| R6           | The destination operand to be subtracted |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be subtracted
MOVX R9 R5   ; R9 contains the destination address
CALL write_subx_fun
```

#### **write_subc_fun**
**Description**
The `write_subc_fun` function virtualises a subtraction `SUB` with carry operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be subtracted  |
| R6           | The destination operand to be subtracted |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOV #0x4323 R5  ;  #0x4323 is the content to be subtracted
MOV R9 R5   ; R9 contains the destination address
CALL write_subc_fun
```

#### **write_subcx_fun**
**Description**
The `write_subcx_fun` function virtualises a subtraction `SUBCX` with carry operation with a dynamic destination.

**Parameters**
| **Register** | **Content**                      |
|--------------|----------------------------------|
| R5           | The source operand to be subtracted  |
| R6           | The destination operand to be subtracted |
| R4           | Status Register (SR) content     |


**Example**
```
MOV SR R4
DINT
NOP
MOVX #0x14323 R5  ;  #0x14323 is the content to be subtracted
MOVX R9 R5   ; R9 contains the destination address
CALL write_subcx_fun
```
