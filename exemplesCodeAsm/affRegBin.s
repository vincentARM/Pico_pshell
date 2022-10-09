/* pour pgm assembleur avec pShell */
/* affichage des registres mémoire RP2040 en binaire */
.cpu cortex-m0plus
.thumb
.syntax unified
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC1.inc"        // verify version functions address
.equ TAILLEBUF,    100
/****************************************************/
/* macro string display                   */
/****************************************************/
/* attention pas de save du registre d'état */
.macro afficherLib str 
    push {r0-r3}               // save registers
    adr r0,libaff1\@           // string address
    bl affString
    pop {r0-r3}                // restaur registers
    b smacroafficheMess\@      // jump area string store
.align 4
libaff1\@:     .asciz "\str\r\n"
.align 4
smacroafficheMess\@:     
.endm
/*******************************************/
/*  datas                                  */
/*******************************************/
.data 
szDebutPgm:       .asciz "Program start.\n"
szFinPgm:         .asciz "Program end OK.\n"
szMessSaisie:     .asciz "\nEnter the address of a register (fin for end) :\n"
szMessErrBuf:     .asciz "\033[31mBuffer too small !!\033[0m\n"
szFin:            .asciz "fin"
szMessAffBin:     .ascii "Register display : "
szZoneConvBin:    .asciz "0x         0b                                        \n"
sBuffer:          .skip TAILLEBUF
.align 4
ret:              .int 0
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    push    {r4-r7,lr}     // save registers
    ldr r0,iAdrszDebutPgm
    bl affString
    
    afficherLib "Display memory register."
1:
    ldr r0,iAdrszMessSaisie
    bl affString
    ldr r0,iAdrsBuffer
    movs r1,#TAILLEBUF
    bl readString         //   keyboard input
    ldr r0,iAdrsBuffer
    ldr r1,iAdrszFin
    bl compareString      // input fin ?
    cmp r0,#0
    beq 99f
    ldr r0,iAdrsBuffer
    bl convertirChHexa    // conversion hexa address register
    bcs 1b
    mov r4,r0
    ldr r0,[r4]           // load register value
    ldr r1,iAdrszZoneConvBin
    adds r1,2
    bl conversion16       // conversion hexa
    ldr r0,[r4]
    ldr r1,iAdrszZoneConvBin
    adds r1,13
    bl conversion2        // binary conversion
    mov r2,r0             // result length
    adds  r2,#12          // add length of result hexa 
    ldr r0,iAdrszZoneConvBin
    movs r1,#' '
    strb r1,[r0,r2]       // replace final zero of banary conversion with space
    ldr r0,iAdrszMessAffBin
    bl affString          // and display final résult
    b 1b                  // loop other input
99:
    ldr r0,iAdrszFinPgm
    bl affString
    movs r0,#0              // return code OK
100:
    pop    {r4-r7,pc}       // restaur register and return to pshell 
.align 2                    // data alignement
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrszMessSaisie:  .int szMessSaisie
 iAdrszZoneConvBin: .int szZoneConvBin
 iAdrszMessAffBin:  .int szMessAffBin
 iAdrsBuffer:       .int sBuffer
 iAdrszFin:         .int szFin
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
/************************************/
/*       conversion binaire         */
/***********************************/
/* r0 value    */
/* r1 area conversion address */
.thumb_func
conversion2:                // INFO: conversion2
    push {r4,lr}            // save  registers 
    movs r2,0               // character counter
    movs r4,0               // 
1:
    lsls r0,1               // shift one bit left
    bcs 2f                  // carry set ?
    movs r3,'0'             // no -> bit = 0
    b 3f
2:
    movs r3,'1'             // yes -> bit = 1
3:
    strb r3,[r1,r4]         // store bit value in result
    adds r4,1               // increment counter
    cmp r2,7
    beq 4f
    cmp r2,15
    beq 4f
    cmp r2,23
    beq 4f
    b 5f
4:
    movs r3,' '            // add a space every 8 characters
    strb r3,[r1,r4]
    adds r4,1
5:
    adds r2,1              // increment bit counter
    cmp r2,32              // end ?
    blt 1b
    movs r3,0              // 0 final
    strb r3,[r1,r4]
    adds r0,r4,#1           // return length
    pop {r4,pc}             // restaur registers
/******************************************************************/
/*     conversion hexa                       */ 
/******************************************************************/
/* r0 contient la valeur */
/* r1 contient la zone de conversion  */
.thumb_func
conversion16:               // INFO: conversion16
    push {r1-r4,lr}         // save des registres

    movs r2, 28              // start bit position
    movs r4, 0xF             // mask
    lsls r4, 28
    movs r3,r0               // save entry value
1:                          // start loop
    movs r0,r3
    ands r0,r0,r4            // value register and mask
    lsrs r0,r2               // move right 
    cmp r0, 10              // compare value
    bge 2f
    adds r0, 48              // <10  ->digit 
    b 3f
2:    
    adds r0, 55              // >10  ->letter A-F
3:
    strb r0,[r1]            // store digit on area and + 1 in area address
    adds r1, 1
    lsrs r4, 4               // shift mask 4 positions
    subs r2,r2, 4            //  counter bits - 4 <= zero  ?
    bge 1b                  //  no -> loop
    movs r0, 8
    pop {r1-r4,pc}          // restaur des registres
/***************************************************/
/*     conversion chaine hexa en  valeur           */
/***************************************************/
// r0 contains string address
// r0 return value
// carry on if error
.thumb_func
convertirChHexa:               // INFO: convertirChHexa
    push {r4,lr}               // save  registers 
    movs r2, 0                  // indice
    movs r3, 0                  // valeur
    movs r1, 0                  // nombre de chiffres
1:
    ldrb r4,[r0,r2]
    cmp r4, 0                  // string end
    beq 10f
    subs r4,r4, 0x30           // conversion digits
    blt 5f
    cmp r4, 10
    blt 3f                     // digits 0 à 9 OK
    cmp r4, 18                 // < A ?
    blt 5f
    cmp r4, 24
    bge 2f
    subs r4,r4, 8              // letters A-F
2:
    cmp r4, 49                 // < a ?
    blt 5f
    cmp r4, 54                 // > f ?
    bgt 5f
    subs r4,r4, 39             // letters  a-f
3:                             // r4 contains value on right 4 bits
    adds r1, 1
    cmp r1, 8
    bgt 9f                     // plus de 8 chiffres -> erreur
    lsls r3, 4
    eors r3,r4
5:                             // loop to next byte 
    adds r2,r2, 1
    b 1b
9:
    adr r0,szMessErreurConv
    bl affString
    movs r0,0
    cmp r0,r0
    b 100f
10:
    movs r0,r3
    cmn r0,r0
100: 
    pop {r4,pc}              // restaur registers
.align 2
szMessErreurConv:    .asciz "\033[31mTrop de chiffres hexa !!\033[0m\n"
.align 2
/*************************************/
/* keyboard read String                       */
/*************************************/
/* r0 contains buffer address */
/* r1 contains buffer length  */
readString:
     push {r4-r7,lr}
     mov r5,r0
     mov r7,r1
     movs r4,#0
1:
     ldr r6,iAdrGetchar       // display one character
     blx r6
     cmp r0,#0
     beq 3f
     cmp r0,#0xA             // end line
     beq 3f
     cmp r0,#0xD             // end line
     beq 3f
     cmp r0,#0x1B            // <esc>
     beq 3f
     strb r0,[r5,r4]         // store char in buffer position indice
     adds r4,r4,#1            // increment indice position
     cmp r4,r7               // maxi ?
     blt 2f
     movs r0,#'\n'            // display error
     ldr r6,iAdrPutchar
     blx r6
     ldr r0,iAdrszMessErrBuf
     bl affString
     b 3f
 2:
     ldr r6,iAdrPutchar       // display one character
     blx r6
     b 1b                     // and loop
 3:
    movs r0,#0xA
    ldr r6,iAdrPutchar
    blx r6
    movs r0,#0xD
    ldr r6,iAdrPutchar
    blx r6
    movs r0,#0
    strb r0,[r5,r4]           // final zéro
    mov r0,r4                 // return length
     
100:
     pop {r4-r7,pc}
.align 2
iAdrGetchar:       .int getchar
iAdrPutchar:       .int putchar
iAdrszMessErrBuf:  .int szMessErrBuf
/************************************/       
/* string    comparaison            */
/************************************/      
/* r0 et r1 contains string address */
/* return 0 in r0 if equals */
/* return -1 if string r0 < string r1 */
/* return 1  if string r0> string r1 */
compareString:          @ INFO: compareString
    push {r2-r4,lr}       @ save registers
    movs r2,#0            @ indice
1:    
    ldrb r3,[r0,r2]       @ byte chaine 1
    ldrb r4,[r1,r2]       @ byte chaine 2
    cmp r3,r4             @ compare byte
    blt 2f
    bgt 3f
    cmp r3,#0             @ 0 final ?
    beq 4f                @ end
    adds r2,r2,#1          @ increment indice
    b 1b                  @ and loop
2:
    movs r0,#0             @ <
    subs r0,#1
    b 100f
3:
    movs r0,#1             @ >
    b 100f
4:
    movs r0,#0             @ =
100:
    pop {r2-r4,pc}
    