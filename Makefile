CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

vpath %.c src
vpath %.s src

#CFLAGS=-ggdb -DSTM32F10X_MD_VL -DUSE_STDPERIPH_DRIVER -mthumb -mcpu=cortex-m3
CFLAGS=-ggdb -D__NO_SYSTEM_INIT -D__STACK_SIZE=0x00002000 -D__START=main -mthumb -mcpu=cortex-m4 -mlittle-endian -march=armv7e-m -O0

BUILD=build

# OBJS is the list of object target files to compile
OBJS=startup_ARMCM4.o main.o i2c.o oled.o uart.o gps.o syscalls.o eeprom.o Systic.o utils.o gpio.o

# Add library paths for compiler
#CFLAGS+= -I$(DEVICE) -I$(CORE) -I$(PERIPH)/inc -Iinc/
CFLAGS+= -Iinc/

_ := $(shell mkdir -p $(BUILD))

flash: main.elf
	openocd -f openocd.cfg -c "program main.elf verify reset exit"

main.elf: clean $(OBJS)
	$(CC) $(CFLAGS) -TARMCMx.ld -o main.elf $(BUILD)/*

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $(BUILD)/$@

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $(BUILD)/$@

%.o: %.S
	$(CC) -c $(CFLAGS) $< -o $(BUILD)/$@



clean:
	rm -f main.elf *.o build/*

