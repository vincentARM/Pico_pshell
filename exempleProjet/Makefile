# build with  make PGM=pgmname
ARMGNU ?= E:\Pico\Tools\"10 2020-q4-major"\bin\arm-none-eabi

AOPS = --warn --fatal-warnings -mcpu=cortex-m0
COPS = -Wall -O2 -ffreestanding -mcpu=cortex-m0
LOPS = -nostdlib -nostartfiles
#PGM=$1
all :  $(PGM).exe

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list

$(PGM).exe: $(PGM).bin
	D:\Developpement\Pico\psShell\debut1\asmpschell $(PGM)_dep.bin -m $(PGM)_map.txt -e $(PGM)
$(PGM).o : $(PGM).s functionsC.inc
	$(ARMGNU)-as $(AOPS)  $(PGM).s -o $(PGM).o
$(PGM).bin :      memmap.ld $(PGM).o
	$(ARMGNU)-ld  -T memmap.ld -e main  $(PGM).o -o $(PGM).elf -M >$(PGM)_map.txt
	$(ARMGNU)-objdump -D $(PGM).elf > $(PGM).list
	$(ARMGNU)-objcopy -O binary $(PGM).elf $(PGM)_dep.bin
