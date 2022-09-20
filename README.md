## Use of assembler program with pshell software for the Raspberry Pico.

Lurk101 along with several other people have created software for the pico which makes it easier to use.

see https://github.com/lurk101/pshell

and the thread under:

https://forums.raspberrypi.com/viewtopic.php?t=336843

It is therefore possible to run some basic commands like ls, mkdir, cat, vi, etc. and even compile C programs directly on the pico
with cc.

I wondered if it was possible to program directly in arm assembler by writing a compiler in C language. It is a heavy task and I had started writing it to discover the format of executable programs in pshell (which does not is not the .uf2 format) and see if a small program could be created and executed.

Alas, my C assembly program quickly reached the maximum size allowed by the Cde pshell compiler.

So I looked for another solution and by examining how I had created assembler programs for the pico, I realized that it was enough to apply the same approach by replacing the python script for converting the bin format created by the standard as and ld utilities, in uf2 format.

So I wrote a C program that uses the data from the .bin and map files created by as and ld on a windows or linux computer to create an executable in the desired format.

The as and ld utilities are the standard utilities provided during the installation of the sdk for the development of C++ programs for the pico.

The directives file for ld (memmap.ld) is modified to suit the addresses of code and data handled by pshell. It must be possible to simplify it even more!!!

The program I developed (asmpshell.c) creates a header containing the execution start address (main), the code size (.text) and the data size (.data). The relocation zone will be at 0 in the absence of information concerning the relocation mechanism managed by pshell.

The program copies the code and data as found in the .bin and inserts 4 trailing binary zeros.

The executable thus created must be transferred to the pico using the command xput nomexecpico. This command uses the xmodem protocol and therefore for windows you must install compatible software such as puttyextra.

For unix, the minicom software works fine.

A first problem arises because the file thus transferred is not recognized by pshell as an executable command.

But you just have to compile with cc a simple C program like hello.c to create an executable and it is this name that you will have to indicate to the transfer program.

For instance :
cc -o nomexecpico hello.c

### Writing an assembler program for pshell.

Using the as utility allows you to use all the functionalities for writing: syntax, include, macros.

pshell does not support the bss section so programs will need to initialize the data if necessary.

In assembler on the pico, there is no call to the operating system and therefore you have to use the C functions of the library used by pshell.
Pshell being a very simple system, it does not provide a mechanism to call these functions. It is therefore necessary to know the addresses of each function, addresses which may vary depending on the version of pshell.

This is why these addresses are described in the functionsC.inc file to be included in each assembler source.
Attention the file in the examples concerns the version of pshell and it is to be completed for the other C functions not referenced.

It will have to be modified for each new version of pshell unless I find the explanation for the relocation (and of course the assembler programs have to be recompiled with each new version of pshell.

Here is a typical example of calling the printf function
```asm
     ldr r0,iAdrszMessage
     push {r0}            // function parameter
     mov r0,#1            // one parameter
     ldr r6,iAdrPrintf    // address function C printf
     blx r6               // call function
     add sp,#4            // stack alignement for one push 
     
.align 2                  // data alignement
iAdrszMessage:    .int szMessage     
```
see other example programs.

Thank to Lurk101 Dwelch67 and to the other people who help with the programming of the pico.
