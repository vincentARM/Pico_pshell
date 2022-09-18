/* pour test pgm assembleur avec pShell */
.data 
message:   .asciz   "Hello world"
.text
.global main
main:
     push    {r4-r7,lr}   // registers save
     ldr r0,iAdrmessage
     push {r0}            // function parameter
     mov r0,#1            // one parameter
     ldr r6,iAdrPrintf    // address function C printf
     blx r6               // call function
     add sp,#4            // stack alignement for one push 
     mov r0,#0            // return code
     pop    {r4-r7,pc}    // restaur registers
.align 2                  // data alignement
iAdrmessage:    .int message
iAdrPrintf:     .int 0x1000ac85
