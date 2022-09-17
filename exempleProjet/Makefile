ARMGNU ?= E:\Pico\Tools\"10 2020-q4-major"\bin\arm-none-eabi

AOPS = --warn --fatal-warnings -mcpu=cortex-m0
COPS = -Wall -O2 -ffreestanding -mcpu=cortex-m0
LOPS = -nostdlib -nostartfiles

all : cliLed.exe

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list
	rm -f *.uf2

cliLed.exe: cliLed.bin
	D:\Developpement\Pico\psShell/asm1/asmpschell cliLed_dep.bin -m cliLed_map.txt -e cliLed
cliLed.o : cliLed.s functionsC.inc
	$(ARMGNU)-as $(AOPS)  cliLed.s -o cliLed.o
cliLed.bin :      memmap.ld cliLed.o
	$(ARMGNU)-ld  -T memmap.ld -e main  cliLed.o -o cliLed.elf -M >cliLed_map.txt
	$(ARMGNU)-objdump -D cliLed.elf > cliLed.list
	$(ARMGNU)-objcopy -O binary cliLed.elf cliLed_dep.bin
