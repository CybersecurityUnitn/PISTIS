#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
GCC_TOOL_ROOT := ../toolchain/compiler/msp430-gcc-9.2.0.50_linux64
LIBRARIES_BACKUP_DIR = $(GCC_TOOL_ROOT)/../msp430-gcc-9.2.0.50_linux64_backup
COMPILER := $(GCC_TOOL_ROOT)/bin/msp430-elf-gcc-9.2.0
#COMPILER := ../toolchain/compiler/msp430-gcc-9.3.0.31_linux64/bin/msp430-elf-gcc-9.3.0
OBJ_COPY := $(GCC_TOOL_ROOT)/bin/msp430-elf-objcopy
COMP_INCLUDE := $(GCC_TOOL_ROOT)/msp430-elf/include
INCLUDE_GCC := $(GCC_TOOL_ROOT)/../include_gcc

#Python 3 executable
PYTHON := python3

#Override paths
#include paths.mk

#Add to the PATH the various binaries
export PATH := $(PATH):$(GCC_TOOL_ROOT)/bin/:$(GCC_TOOL_ROOT)/libexec/gcc/msp430-elf/9.2.0:$(GCC_TOOL_ROOT)/msp430-elf/bin/


ROOT_DIR := .

TOOLCHAIN_DIR = ../toolchain

VERIFIER := $(TOOLCHAIN_DIR)/postprocessor.py
MODIFIER := $(TOOLCHAIN_DIR)/modifier.py
METADATA := $(TOOLCHAIN_DIR)/metadata.py

RM := rm -rf

#GCC optimisation level for user application
OPTIMISATION := 3

#Additional flags to be used in compilation
EXTRA_FLAGS := #-fno-peel-loops #-fpeel-loops #-fgcse-after-reload -fipa-cp-clone -floop-interchange -floop-unroll-and-jam -fpredictive-commoning -fsplit-loops -fsplit-paths -ftree-loop-distribution -ftree-loop-vectorize -ftree-partial-pre -ftree-slp-vectorize -funswitch-loops -fvect-cost-model -fvect-cost-model=dynamic -fversion-loops-for-strides -fpeel-loops 

# variable used for the verification process
VERIFY:=1

# use addresses rather than variables for the virtual functions
VIRTUAL_LABELS = 0

# use modified gcc libraries #TODO: set to 0 when verify = 0?
USE_NEW_LIB := 1

# replace reta and calla with ret and ret
SMALL_MEMORY=1

#Enable debug info for the post processor script
DEBUG_POST_PROCESSOR=0

#The base name of the final files
FILE_NAME := deployable

#This will be the file that can be deployed
OUTPUT_FILE := $(FILE_NAME).out

#This will be the file without initial metadata
OUTPUT_FILE_NO_METADATA := appWithNoMetadata.out

#Output map file
OUTPUT_MAP := $(FILE_NAME).map

#Formatting:
GREEN=\033[32m
BLUE=\033[34m
ORANGE=\033[33m
DEFAULT=\033[0m

# Linker script
LD_SRCS += $(TOOLCHAIN_DIR)/linkerScript.ld

############# THE FOLLOWING FILES DETERMINE THE SOURCE FILES TO BE COMPILED

# These will be the folders created by the compiler
APPASM_DIR = ./asm
APPOBJ_DIR = ./obj
APPSRC_DIR = ./src

#The hook for the various PISTIS functions
PISTIS_HOOK = ../TCM/core/src/TCMhook.h

###### Load all the modified libraries
LIBRARIES_NEW_DIR = ../toolchain/gccLibraries

#Determine which version of LIBCRT to use depending on choosen memory layout
ifeq ($(SMALL_MEMORY), 1)
	LIBCRT_NEW = $(LIBRARIES_NEW_DIR)/libcrt.a.small 
else
	LIBCRT_NEW = $(LIBRARIES_NEW_DIR)/libcrt.a.large 
endif
LIBC_NEW = $(LIBRARIES_NEW_DIR)/libc.a 
LIBGCC_NEW = $(LIBRARIES_NEW_DIR)/libgcc.a 
LIBNOSYS_NEW = $(LIBRARIES_NEW_DIR)/libnosys.a 
LIBSIM_NEW = $(LIBRARIES_NEW_DIR)/libsim.a 
LIBM_NEW = $(LIBRARIES_NEW_DIR)/libm.a 


LIBCRT_OLD = $(LIBRARIES_BACKUP_DIR)/msp430-elf/lib/large/full-memory-range/libcrt.a 
LIBC_OLD = $(LIBRARIES_BACKUP_DIR)/msp430-elf/lib/large/full-memory-range/libc.a 
LIBGCC_OLD = $(LIBRARIES_BACKUP_DIR)/lib/gcc/msp430-elf/9.2.0/large/full-memory-range/libgcc.a 
LIBNOSYS_OLD = $(LIBRARIES_BACKUP_DIR)/msp430-elf/lib/large/full-memory-range/libnosys.a 
LIBSIM_OLD = $(LIBRARIES_BACKUP_DIR)/msp430-elf/lib/large/full-memory-range/libsim.a 
LIBM_OLD = $(LIBRARIES_BACKUP_DIR)/msp430-elf/lib/large/full-memory-range/libm.a 


LIBCRT_DIR = $(GCC_TOOL_ROOT)/msp430-elf/lib/large/full-memory-range
LIBC_DIR = $(GCC_TOOL_ROOT)/msp430-elf/lib/large/full-memory-range
LIBGCC_DIR = $(GCC_TOOL_ROOT)/lib/gcc/msp430-elf/9.2.0/large/full-memory-range
LIBNOSYS_DIR = $(GCC_TOOL_ROOT)/msp430-elf/lib/large/full-memory-range
LIBSIM_DIR = $(GCC_TOOL_ROOT)/msp430-elf/lib/large/full-memory-range
LIBM_DIR = $(GCC_TOOL_ROOT)/msp430-elf/lib/large/full-memory-range


####### Load the files to be compiled
APPSRC_FILES := $(wildcard $(APPSRC_DIR)/*.c)
APP_OR_ASM_FILES := $(wildcard $(APPSRC_DIR)/*.s)
APPASM_FILES := $(patsubst $(APPSRC_DIR)/%.c,$(APPASM_DIR)/%.s,$(APPSRC_FILES))
APPASM_FILES += $(wildcard $(APPASM_DIR)/*.s)
APPASM_FILES += $(patsubst $(APPSRC_DIR)%,$(APPASM_DIR)%,$(APP_OR_ASM_FILES))

##### Compiler arguments
LIBS := -lgcc -lc -lm 

# '-mhwmult' and '-mmcu' model dependent
# '-Wall' most warnings
# '-mcode-region=none' both the compiler and the linker do not make any changes to section names
# '-mlarge' use large 20 bit address mode
# '-Wl,-Map,"$(OUTPUT_MAP)" -Wl' pass the address map to the linker
# '--gc-sections' garbage collection on unused sections
# '--no-relax' disable linker relaxation
# '--disable-sec-transformation' Prevent the transformation of sections as specified by the --code-region and --data-region options
# '--allow-multiple-definition' Allow multiple definition of functions, so that the custom ones replace the default ones.
LINKER_ARGS := -mhwmult=f5series -mmcu=msp430f5529 -O$(OPTIMISATION) -w -mcode-region=none -mdata-region=none -mlarge -T"$(LD_SRCS)" \
-Wl,-Map,"$(OUTPUT_MAP)" -L"$(INCLUDE_GCC)" -Wl,--no-relax -Wl,--disable-sec-transformation -Wl,--allow-multiple-definition \


# '-c' Compile and assemble, but do not link.
# '-mdata-region=lower' the compiler assumes data is in the lower region of memory
# '-ffixed-R4 -ffixed-R5 -ffixed-R6' prevent the use of R4, R5 and R6 registers
# '-fno-function-cse' Reduce number of dynamic calls
ASSEMBLER_ARGS_APP := -c -mmcu=msp430f5529 -mhwmult=f5series -I"$(INCLUDE_GCC)" -I"$(ROOT_DIR)" -I"$(APPSRC_DIR)" \
-I"$(COMP_INCLUDE)" -O$(OPTIMISATION) -w -mlarge -mcode-region=none -mdata-region=none \
-ffixed-R4 -ffixed-R5 -ffixed-R6 -fno-function-cse $(EXTRA_FLAGS)


# All Target
all: verification

#Original application without any modification
original:
	$(COMPILER) -mhwmult=f5series -mmcu=msp430f5529 -O$(OPTIMISATION) -w -mlarge -T"$(LD_SRCS)" -Wl,-Map,"$(OUTPUT_MAP)" -I"$(INCLUDE_GCC)" -Wl,--no-relax -Wl,--disable-sec-transformation -Wl,--allow-multiple-definition $(APPSRC_FILES) $(LIBS) -o"$(OUTPUT_FILE_NO_METADATA)"
	$(MAKE) addMeta 

#$(eval FILE_LENGTH := $(shell stat -c "%s" $(OUTPUT_FILE_NO_METADATA)))
#Add metadata to output file
addMeta: $(OUTPUT_FILE_NO_METADATA)
	@echo -e '${BLUE}Adding metadata${DEFAULT}'
	$(PYTHON) $(METADATA) $^ $(OUTPUT_FILE) $(BSS_SIZE)
	@echo -e '${GREEN}Metadata added --> created file $(OUTPUT_FILE)${DEFAULT}'
	@chmod +x $(OUTPUT_FILE)
ifeq ($(USE_NEW_LIB),1)
	@echo -e '${BLUE}Restoring old libraries${DEFAULT}'
	@cp $(LIBCRT_OLD) $(LIBCRT_DIR)/
	@cp $(LIBC_OLD) $(LIBC_DIR)/
	@cp $(LIBGCC_OLD) $(LIBGCC_DIR)/
	@cp $(LIBNOSYS_OLD) $(LIBNOSYS_DIR)/
	@cp $(LIBSIM_OLD) $(LIBSIM_DIR)/	
	@cp $(LIBM_OLD) $(LIBM_DIR)/	
endif


# Tool invocations
$(OUTPUT_FILE_NO_METADATA): $(LD_SRCS) $(OBJ_FILES)
	@echo -e '${GREEN}The application is safe${DEFAULT}'
	@echo -e '${BLUE}Building target: "$@"${DEFAULT}'
	@echo -e 'Invoking: GNU Linker'
	$(COMPILER) $(LINKER_ARGS) -o"$@" $(OBJ_FILES) $(LIBS)
	@echo -e '${GREEN}Finished building target: "$@"${DEFAULT}'
	@echo ' '

REJECT := 0

build_folders:  
	#Copying the asm files from srcdir or app
	@echo "Creating ASM directories and copying .s files"
	-mkdir $(APPASM_DIR)
	-mkdir $(APPOBJ_DIR) 
	-cp $(APPSRC_DIR)/*.s $(APPASM_DIR)/
	-cp $(PISTIS_HOOK) $(APPSRC_DIR)/
	#Replace them with new safe ones
ifeq ($(USE_NEW_LIB),1)
	@echo -e "${ORANGE}########## Using new Libs ###########${DEFAULT}"
ifeq ($(wildcard $(LIBRARIES_BACKUP_DIR)/.*),)
	$(error Please, create a backup copy of the msp430gcc compiler and link it in the Makefile)
endif
	#echo Libcrts is $(LIBCRT_NEW)
	@cp $(LIBCRT_NEW) $(LIBCRT_DIR)/libcrt.a
	@cp $(LIBC_NEW) $(LIBC_DIR)/
	@cp $(LIBGCC_NEW) $(LIBGCC_DIR)/
	@cp $(LIBNOSYS_NEW) $(LIBNOSYS_DIR)/
	@cp $(LIBSIM_NEW) $(LIBSIM_DIR)/
	@cp $(LIBM_NEW) $(LIBM_DIR)/
else
	@echo -e "${ORANGE}########## Using original Libs ###########${DEFAULT}"
endif

# Perform the first verification by running the Rejecter module. Call the make file again with the result
verification: build_folders $(APPASM_FILES)
	$(eval OBJ_FILES += $(patsubst $(APPASM_DIR)/%.s,$(APPOBJ_DIR)/%.o,$(APPASM_FILES)))
ifeq ($(VERIFY),1) 
	@echo -e '${BLUE}Checking for the presence of unsafe instructions in $(APPASM_FILES)${DEFAULT}'
	$(eval REJECT = $(shell $(PYTHON) $(VERIFIER) $(DEBUG_POST_PROCESSOR) $(APPASM_FILES)))
	@echo Reject is "$(REJECT)"
ifeq ($(REJECT),1)
	@echo -e '${RED}REJECTED${DEFAULT}'
	$(error The application contains some unsafe instructions. It has been REJECTED)
else
	@echo -e '${GREEN}First verification passed${DEFAULT}'
endif
endif
	$(MAKE) addMeta REJECT=$(REJECT) OBJ_FILES="$(OBJ_FILES)"



# Create objects files without invoking the linker
# the following flags are not documented and, apparently, not needed... -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)"
$(APPOBJ_DIR)/%.o: $(APPASM_DIR)/%.s
ifeq ($(REJECT),1)
	@echo -e '${RED}REJECTED${DEFAULT}'
	$(error The compiled application has some unsafe code segments)
else
ifeq ($(VERIFY),1) 
	@echo -e '${BLUE}Replacing unsafe instructions${DEFAULT}'
	#@cp main.s old_main.s
	#backup the old asm file
	@cp $< $<.old
	@$(PYTHON) $(MODIFIER) $< $<.modified $(VIRTUAL_LABELS)
	@mv $<.modified $<
	@echo -e '${GREEN}Instructions replaced${DEFAULT}'
endif
endif
	@echo -e '${BLUE}Creating "$@" by building file: "$<"${DEFAULT}'
	@echo 'Invoking: GNU Compiler'
	$(COMPILER) $(ASSEMBLER_ARGS_APP) -o"$@" "$<"
	@echo -e '${GREEN}Finished building: "$<" --> "$@" created${DEFAULT}'
	@echo ' '

#Create assembly files
$(APPASM_DIR)/%.s : $(APPSRC_DIR)/%.c
	@echo -e '${BLUE}Creating ASM file: "$@"${DEFAULT}'
	$(COMPILER) $(ASSEMBLER_ARGS_APP) -S -o"$@" "$<"
	@echo -e '${GREEN}Finished creating: "$@"${DEAFULT}'
	@echo ' '


LIBRARY_COUNT=1
HELPER=0
# Instrment libraries
libraries:
	@python3 ../toolchain/helperScripts/auxGccParser.py src/helper${LIBRARY_COUNT}.s $(LIBRARY_COUNT)
	
	@[ -s src/helper${LIBRARY_COUNT}.s ] && echo -e "${ORANGE} just created helper${LIBRARY_COUNT}.s${DEFAULT}" || echo -e "${ORANGE} just created EMPTY helper${LIBRARY_COUNT}.s${DEFAULT}"
	@[ -s src/helper${LIBRARY_COUNT}.s ] && $(MAKE) clean || echo skipping make clean
	@[ -s src/helper${LIBRARY_COUNT}.s ] && $(MAKE) || echo skipping make
	@echo -e "${ORANGE} just finished invoking main to create helper${LIBRARY_COUNT}.s ${DEFAULT}"
	@[ -s src/helper${LIBRARY_COUNT}.s ] && $(MAKE) libraries LIBRARY_COUNT=${LIBRARY_COUNT}1 || echo skipping make libraries
	@[ ! -s src/helper${LIBRARY_COUNT}.s ] && rm src/helper${LIBRARY_COUNT}.s || echo ""
	@[ ! -f src/helper${LIBRARY_COUNT}.s ] && echo -e "${GREEN} Finished instrumenting libraries. ${DEFAULT}" || echo ""
	


# Other Targets
clean:
	-$(RM) $(APPOBJ_DIR) 
	-$(RM) $(APPASM_DIR)
	-$(RM) $(OUTPUT_FILE) $(OUTPUT_FILE_NO_METADATA)
	-$(RM) $(OUTPUT_MAP)
	-$(RM) $(APPSRC_DIR)/TCMhook.h
	-$(RM) *.s *.tmp
	@echo 'Restoring old libraries'
	@cp $(LIBCRT_OLD) $(LIBCRT_DIR)/
	@cp $(LIBC_OLD) $(LIBC_DIR)/
	@cp $(LIBGCC_OLD) $(LIBGCC_DIR)/
	@cp $(LIBNOSYS_OLD) $(LIBNOSYS_DIR)/
	@cp $(LIBSIM_OLD) $(LIBSIM_DIR)/
	@cp $(LIBM_OLD) $(LIBM_DIR)/	
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean addMeta verification build_folders libraries
.SECONDARY: 
