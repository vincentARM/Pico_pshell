/*  macros display a text  and test malloc  */
.cpu cortex-m0plus
.thumb
.syntax unified
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"

/****************************************************/
/* macro d'affichage d'un libellé                   */
/****************************************************/
/* pas d'espace dans le libellé     */
/* attention pas de save du registre d'état */
.macro afficherLib str 
    push {r0-r3}               // save des registres
    adr r0,libaff1\@           // recup adresse libellé passé dans str
    bl affString
    pop {r0-r3}                // restaure des registres
    b smacroafficheMess\@      // pour sauter le stockage de la chaine.
.align 4
libaff1\@:     .asciz "\str\r\n"
.align 4
smacroafficheMess\@:     
.endm                          // fin de la macro

/*******************************************/
/*  datas                                  */
/*******************************************/
.data 
szDebutPgm:      .asciz "Debut du programme.\n"
szFinPgm:        .asciz "Fin Ok du programme.\n"
szAffReg:        .asciz "Valeur du registre = %x\n"
.align 4
iRet:             .int 0
iPtbuf:           .int 0
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    push    {r4-r7,lr}     // save registers
    ldr r0,iAdrszDebutPgm
    bl affString
    
    afficherLib "Utilisation fonction malloc"
    
    movs r0,100
    ldr r6,iAdrMalloc      // reserve 100 bytes
    blx r6
    ldr r4,iAdriPtbuf
    str r0,[r4]
    
    bl affReg              // display the area begin address
    
    movs r0,r4             // free allocation area
    ldr r0,[r4]
    ldr r6,iAdrFree
    blx r6
    
    ldr r0,iAdrszFinPgm
    bl affString
    movs r0,#0              // return code OK
100:
    pop    {r4-r7,pc}       // restaur register and return to pshell 
.align 2                    // data alignement
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrMalloc:        .int malloc
 iAdrFree:          .int free
 iAdriPtbuf:        .int iPtbuf
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
     push {r6,lr}
     ldr r1,iAdrszAffReg
     push {r1}
     push {r0}
     movs r0,#2                // nombre de paramètres
     ldr r6,iAdrPrintf        // display message
     blx r6
     add sp,sp,#8             // 2 push 
     pop {r6,pc}

.align 2                  // data alignement
iAdrPrintf:         .int printf
iAdrszAffReg:       .int szAffReg
