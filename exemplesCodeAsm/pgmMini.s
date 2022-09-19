/* pour test pgm assembleur avec pShell */
.cpu cortex-m0plus
.thumb
.data
.text
.global main
main:
     push    {r4-r7,lr}   // save registers
     mov r0,#255          // return code
     pop    {r4-r7,pc}    // restaur register and return to pshell 
   