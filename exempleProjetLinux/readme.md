For use on raspberry pi :

compile asmpshellLinux.c with :

 gcc -Wall -o asmpshell -c asmpshellLinux.c
 
 create work directory and copy functionsC.inc, memmap.ld (idem windows) and copy your assembly program.

copy this Makefile in directory.

in Makefile file, modify path of program asmpchell

run Makefile with this command :

make PGM=namesrcasm

chmod 777 nameexecasm 

tranfert exec program on pico with xput nameexecpico

