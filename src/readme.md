### English

Source of the program asmpshell.c for generating the assembler executable for pshell.

Compile this program with a standard C compiler under windows (cl asmpschell.c) or linux (gcc

It is used by the makefile and therefore you have to change its directory if necessary.

Source of the programm cretabfctpshell.c creation of the list of functions C.

Compile this program with a standard C compiler under windows or linux then search in the compilation directory of the pshell project (build)
the pshell_usb.bin and pshell_usb.elf.map files.

And start the execution with:

cretabfctpshell.exe E:\Pico\pshell\build\pshell_usb.bin -m E:\Pico\pshell\build\pshell_usb.elf.map  -e functionsC1.inc

### français

Source du programme asmpshell.cde génération de l'exécutable assembleur pour pshell.

Compiler ce programme avec un compilateur C standard  sous windows (cl asmpschell.c) ou linux (gcc 

Il est utilisé par le makefile et donc il faut changer son répertoire si necessaire.

Source du programme cretabfctpshell.c création de la liste des fonctions C

Compiler ce programme avec un compilateur C standard  sous windows ou linux puis rechercher dans le répertoire de compilation du projet pshell (build)
les fichiers pshell_usb.bin et pshell_usb.elf.map.
Et lancer l'execution par :
 
cretabfctpshell.exe E:\Pico\pshell\build\pshell_usb.bin -m E:\Pico\pshell\build\pshell_usb.elf.map  -e functionsC1.inc
