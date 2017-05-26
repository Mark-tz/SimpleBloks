
filename = simplebloks

DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F10X_MD

CC = arm-none-eabi-gcc

OBJCOPY = arm-none-eabi-objcopy

FLAGS = -mcpu=cortex-m3 -mthumb -mlittle-endian -mthumb-interwork

STM = /usr/local/stm32/library

INCLUDES = -I $(STM)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/ \
	-I $(STM)/Libraries/CMSIS/CM3/CoreSupport/ \
	-I $(STM)/Libraries/STM32F10x_StdPeriph_Driver/inc/ \
	-I . \
	-I ./SYSTEM

CON_INC = $(STM)/Libraries/STM32F10x_StdPeriph_Driver/src

SRC = $(filename).c \
	protocol.c \
	gpio.c \
	SYSTEM/delay.c \
	SYSTEM/sys.c \
	SYSTEM/usart.c \
	system_stm32f10x.c \
	$(CON_INC)/stm32f10x_gpio.c \
	$(CON_INC)/stm32f10x_rcc.c \
	$(CON_INC)/stm32f10x_usart.c \
	$(CON_INC)/stm32f10x_exti.c \
	$(CON_INC)/stm32f10x_tim.c \
	$(CON_INC)/stm32f10x_i2c.c \
	$(CON_INC)/stm32f10x_spi.c \
	$(CON_INC)/misc.c	

STARTUP = $(STM)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.S

all: $(filename).hex
.PHONE: all

$(filename).elf: $(SRC) $(STARTUP)
	$(CC) $(FLAGS) $(DEFS) $(INCLUDES)   -Wl,-T,stm32f10x.ld  $^ -lnosys -o $(filename).elf

$(filename).hex: $(filename).elf
	$(OBJCOPY) -Oihex $(filename).elf $(filename).hex
clean: 
	rm -rf *.hex *.elf *.dump *.o *.list
.PHONE: clean





#sourcetree
