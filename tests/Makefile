# Define the compiler, linker script, and flags
CC = ~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-gcc
CFLAGS = -Wall -O2 -march=rv64g -mabi=lp64d -nostartfiles
LDFLAGS = -T custom.ld -march=rv64g -mabi=lp64d -nostartfiles

# Define the objcopy, objdump, and hexdump commands
OBJCOPY = ~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-objcopy
OBJCOPY_FLAGS = -O binary -S
OBJCOPY_TEXT_FLAGS = --only-section=.text $(OBJCOPY_FLAGS)
OBJCOPY_DATA_FLAGS = --remove-section=.text $(OBJCOPY_FLAGS)
OBJDUMP = ~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-objdump
OBJDUMP_FLAGS = -S
HEXDUMP = hexdump
HEXDUMP_FLAGS = -ve '1/4 "%08x\n"'

# Source and output directories
SRC_DIR = ./src
OUT_DIR = ./programs

# Get a list of all .c files in the source directory
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)

# Additional source files
ADDITIONAL_SRC = ./common/trm.c ./start.S

# Create a list of corresponding .elf, .text.bin, .data.bin, .text.hex, .data.hex, and .txt files
ELF_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.elf, $(SRC_FILES))
TEXT_BIN_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.text.bin, $(SRC_FILES))
DATA_BIN_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.data.bin, $(SRC_FILES))
TEXT_HEX_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.text.hex, $(SRC_FILES))
DATA_HEX_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.data.hex, $(SRC_FILES))
TXT_FILES = $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.elf.txt, $(SRC_FILES))

# Default target
all: $(TEXT_HEX_FILES) $(DATA_HEX_FILES) $(TXT_FILES)

# Rule to compile .c files to .elf files using the custom linker script
$(OUT_DIR)/%.elf: $(SRC_DIR)/%.c $(ADDITIONAL_SRC)
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(ADDITIONAL_SRC)

# Rule to convert .elf files to .text.bin files
$(OUT_DIR)/%.text.bin: $(OUT_DIR)/%.elf
	$(OBJCOPY) $(OBJCOPY_TEXT_FLAGS) $< $@

# Rule to convert .elf files to .data.bin files
$(OUT_DIR)/%.data.bin: $(OUT_DIR)/%.elf
	$(OBJCOPY) $(OBJCOPY_DATA_FLAGS) $< $@

# Rule to convert .text.bin files to .text.hex files
$(OUT_DIR)/%.text.hex: $(OUT_DIR)/%.text.bin
	$(HEXDUMP) $(HEXDUMP_FLAGS) $< > $@

# Rule to convert .data.bin files to .data.hex files
$(OUT_DIR)/%.data.hex: $(OUT_DIR)/%.data.bin
	$(HEXDUMP) $(HEXDUMP_FLAGS) $< > $@

# Rule to generate disassembly text file from .elf file
$(OUT_DIR)/%.elf.txt: $(OUT_DIR)/%.elf
	$(OBJDUMP) $(OBJDUMP_FLAGS) $< > $@

# Clean up temporary .bin files and other output files
.PHONY: clean
clean:
	rm -f $(OUT_DIR)/*.text.bin
	rm -f $(OUT_DIR)/*.data.bin
	rm -f $(OUT_DIR)/*.text.hex
	rm -f $(OUT_DIR)/*.data.hex
	rm -f $(OUT_DIR)/*.elf
	rm -f $(OUT_DIR)/*.elf.txt

# Ensure intermediate files are not deleted automatically
.SECONDARY: $(TEXT_BIN_FILES) $(DATA_BIN_FILES) $(ELF_FILES)