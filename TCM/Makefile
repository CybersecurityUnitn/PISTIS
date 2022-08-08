 
#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 

# paths to libraries and binaries for the various tools
GCC_TOOL_ROOT := ../toolchain/compiler/msp430-gcc-9.2.0.50_linux64
LIBRARIES_BACKUP_DIR = $(GCC_TOOL_ROOT)/../msp430-gcc-9.2.0.50_linux64_backup
COMPILER := $(GCC_TOOL_ROOT)/bin/msp430-elf-gcc-9.2.0
OBJ_COPY := $(GCC_TOOL_ROOT)/bin/msp430-elf-objcopy
COMP_INCLUDE := $(GCC_TOOL_ROOT)/msp430-elf/include
INCLUDE_GCC := $(GCC_TOOL_ROOT)/../include_gcc

#Python 3 executable
PYTHON := python3

#Override paths
#include paths.mk

ROOT_DIR := .

TOOLCHAIN_DIR = ../toolchain

VERIFIER := $(TOOLCHAIN_DIR)/postprocessor.py
MODIFIER := $(TOOLCHAIN_DIR)/modifier.py
METADATA := $(TOOLCHAIN_DIR)/metadata.py

RM := rm -rf

# variable used for the verification process
VERIFY:=1

# Whether to compile exclusively PISTIS without the APP
ONLY_PISTIS := 0

# use labels rather than addresses for the virtual functions
VIRTUAL_LABELS = 1

#The base name of the final files
FILE_NAME := deployable

#This will be the file that can be deployed
OUTPUT_FILE := $(FILE_NAME).out

#Output map file
OUTPUT_MAP := $(FILE_NAME).map

# Linker script
LD_SRCS += $(TOOLCHAIN_DIR)/linkerScriptWithCore.ld

#Include the makefiles for the core and the user application
include core/Makefile.include
include app/Makefile.include


############# THE FOLLOWING FILES DETERMINE THE SOURCE FILES TO BE COMPILED
APPASM_DIR = ./app/asm
APPOBJ_DIR = ./app/obj


##### Compiling arguments

# '-mhwmult' and '-mmcu' model dependent
# '-O0' no optimization and '-g' for debugging 
# '-Wall' most warnings
# '-mcode-region=none' both the compiler and the linker do not make any changes to section names
# '-mlarge' use large 20 bit address mode
# '-Wl,-Map,"$(OUTPUT_MAP)" -Wl' pass the address map to the linker
# '--gc-sections' garbage collection on unused sections
# '--no-relax' disable linker relaxation
# '--disable-sec-transformation' Prevent the transformation of sections as specified by the --code-region and --data-region options
COMPILER_ARGS := -mhwmult=f5series -mmcu=msp430f5529 -O3 -w -mcode-region=none -mdata-region=none -mlarge \
-Wl,-Map,"$(OUTPUT_MAP)" -Wl,--gc-sections -L"$(INCLUDE_GCC)" -Wl,--no-relax -Wl,--disable-sec-transformation 

# '-c' Compile and assemble, but do not link.
# '-mdata-region=lower' the compiler assumes data is in the lower region of memory
ASSEMBLER_ARGS := -c -mmcu=msp430f5529 -mhwmult=f5series -I"$(INCLUDE_GCC)" -I"$(ROOT_DIR)" -I"$(COMP_INCLUDE)" \
-O3 -w -mlarge -mcode-region=none -mdata-region=none -Wl,--no-relax -Wl,--disable-sec-transformation

LIBS := -lgcc -lc


# All Target
all: verification

# Tool invocations
$(OUTPUT_FILE): $(LD_SRCS) $(OBJ_FILES) $(CORE_OBJS) 
	@echo "USING OBJ: $(OBJ_FILES)"
	@echo 'The application is safe'
	@echo 'Building target: "$@"'
	@echo 'Invoking: GNU Linker'
	$(COMPILER) $(COMPILER_ARGS) -T"$(LD_SRCS)" -Wl,--start-group $(LIBS) -Wl,--end-group -o"$@" $(OBJ_FILES) -Wl,--whole-archive $(CORE_OBJS) -Wl,-no-whole-archive
	@echo 'Finished building target: "$@"'
	@echo ' '

REJECT := 0

build_folders: 
	#Copying the asm files from srcdir or app
	@echo "Creating ASM directories and copying .s files"
	@-mkdir $(APPASM_DIR) $(COREASM_DIR) $(COREOBJS_DIR) $(CORE_COMP_SRC_DIR)
	@-cp $(APPSRC_DIR)/*.s $(APPASM_DIR)/ 2>/dev/null
	@-cp $(CORESRC_DIR)/*.s $(COREASM_DIR)/
	@-cp $(EXTMODULES_SRC)/*.s $(COREASM_DIR)/
	@-cp $(EXTMODULES_SRC)/*.c $(CORE_COMP_SRC_DIR)/
	@-cp $(EXTMODULES_SRC)/*.h $(CORE_COMP_SRC_DIR)/
	@-cp $(CORESRC_DIR)/*.c $(CORE_COMP_SRC_DIR)/
	@-cp $(CORESRC_DIR)/*.h $(CORE_COMP_SRC_DIR)/
	@-cp $(EXTMODULES_SRC)/remote_attestation/* $(CORE_COMP_SRC_DIR)/


# Perform the first verification by running the Rejecter module. Call the make file again with the result
verification: build_folders $(APPASM_FILES)
ifeq ($(ONLY_PISTIS),0)	
	$(eval OBJ_FILES += $(patsubst $(APPASM_DIR)/%.s,$(APPOBJ_DIR)/%.o,$(APPASM_FILES)))
ifeq ($(VERIFY),1)
	@echo 'Checking for the presence of unsafe instructions in $(APPASM_FILES)'
	$(eval REJECT = $(shell $(PYTHON) $(VERIFIER) 0 $(APPASM_FILES)))
	@echo Reject is "$(REJECT)"
endif
endif
	$(MAKE) $(OUTPUT_FILE) REJECT=$(REJECT) OBJ_FILES="$(OBJ_FILES)"


# Create objects files without invoking the linker
# the following flags are not documented and, apparently, not needed... -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)"
$(APPOBJ_DIR)/%.o: $(APPASM_DIR)/%.s
	-mkdir $(APPOBJ_DIR)
ifeq ($(REJECT),1)
	@echo 'REJECTED'
	$(error The compiled application has some unsafe code segments)
else
ifeq ($(VERIFY),1) 
	@echo 'Replacing unsafe instructions'
	#@cp main.s old_main.s
	#backup the old asm file
	@cp $< $<.old
	@$(PYTHON) $(MODIFIER) $< $<.modified $(VIRTUAL_LABELS)
	@mv $<.modified $<
	@echo 'Instructions replaced'
endif
endif
	@echo 'Creating "$@" by building file: "$<"'
	@echo 'Invoking: GNU Compiler'
	$(COMPILER) $(ASSEMBLER_ARGS) -o"$@" "$<"
	@echo 'Finished building: "$<" --> "$@" created'
	
	@echo ' '



# Other Targets
clean:
	-$(RM) $(APPOBJ_DIR) $(COREOBJS_DIR) $(CORE_COMP_SRC_DIR)
	-$(RM) $(APPASM_DIR) $(COREASM_DIR)
	-$(RM) $(OUTPUT_FILE)
	-$(RM) $(OUTPUT_MAP)
	-$(RM) *.tmp

	@echo 'Finished clean'
	@echo ' '

.PHONY: all clean verification build_folders
.SECONDARY: 
