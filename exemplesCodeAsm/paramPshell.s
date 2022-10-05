/* assembly pgm with pShell */
/* display parameters command line */
/* exemple : paramPshell  John Pierre */
.syntax unified
.cpu cortex-m0plus
.thumb
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"

/****************************************************/
/* macro  message display                  */
/****************************************************/
/* attention no save flag register */
.macro afficherLib str 
    push {r0-r3}                  // save registers
    adr r0,libaff1\@              // load string of str
    bl affString
    pop {r0-r3}                   // restaure registers
    b smacroafficheMess\@         // to jump string storage
.align 4
libaff1\@:     .asciz "\str\r\n"  // string to display 
.align 4
smacroafficheMess\@:     
.endm

/*******************************************/
/*  datas                                  */
/*******************************************/
.data 
szMessAcc:       .asciz " Hello  %s \n"
szAffReg:        .asciz "Valeur du registre = %x\n"
.align 4
ret:             .int 0
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    mov r7,sp
    push    {r4-r7,lr}   // save registers
    afficherLib "Programm start. "
    ldr r5,[r7]            // parameters address
    ldr r4,[r7,#4]         // Parameters number
    cmp r4,#2
    blt 2f                // if < 2
    ldr r0,iAdrszMessAcc  // message address 
    push {r0}
    ldr r0,[r5,#4]        // first parameter address
    push {r0}
    movs r0,#2             // 2 parameters
    ldr r6,iAdrPrintf    // address function C printf
    blx r6               // call function
    add sp,#8            // stack alignement for 2 push 
    cmp r4,#3
    blt 2f                // if number parameter < 3
    ldr r0,iAdrszMessAcc  // message address 
    push {r0}
    ldr r0,[r5,#8]        // second parameter address
    push {r0}
    movs r0,#2             // 2 parameters
    ldr r6,iAdrPrintf    // address function C printf
    blx r6               // call function
    add sp,#8            // stack alignement for 2 push 
    
2:
    
    afficherLib "End programm "
    movs r0,#0            // return code OK
100:
    pop    {r4-r7,pc}    // restaur register and return to pshell 
.align 2
iAdrszMessAcc:     .int szMessAcc

/*************************************/
/* display not formatted String      */
/*************************************/
/* r0 contains message address */
affString:
    push {r4-r7,lr}
    movs r4,r0                // save message address
    movs r5,#0                // init indice
1:
    ldrb r0,[r4,r5]           // load one byte of message
    cmp r0,#0                 // end zéro ?
    beq 2f                    // yes
    ldr r6,iAdrPutchar        // display one character
    blx r6
    adds r5,r5,#1             // increment indice
    b 1b                      // and loop
2:
    pop {r4-r7,pc}
.align 2
iAdrPutchar:       .int putchar
/*************************************/
/* display register value                  */
/*************************************/
/* r0 contains the value */
affReg:
     push {r0-r6,lr}
     ldr r1,iAdrszAffReg
     push {r1}
     push {r0}
     movs r0,#2                // nombre de paramètres
     ldr r6,iAdrPrintf        // display message
     blx r6
     add sp,sp,#8             // 2 push 
     pop {r0-r6,pc}

.align 2                  // data alignement
iAdrPrintf:         .int printf
iAdrszAffReg:       .int szAffReg
