# build with  make PGM=pgmname

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
	../C/asmpshell $(PGM)_dep.bin -m $(PGM)_map.txt -e $(PGM)
$(PGM).o : $(PGM).s functionsC.inc
	as $(AOPS)  $(PGM).s -o $(PGM).o
$(PGM).bin :      memmap.ld $(PGM).o
	ld  -T memmap.ld -e main  $(PGM).o -o $(PGM).elf -M >$(PGM)_map.txt
	objdump -D $(PGM).elf > $(PGM).list
	objcopy -O binary $(PGM).elf $(PGM)_dep.bin
