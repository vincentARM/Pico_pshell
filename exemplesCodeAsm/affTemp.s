/* Assembly pgm  for pShell */
/* Temperature display  */
/* Squeeze the pico in your hand and the temperature should rise!! */

.cpu cortex-m0plus
.thumb
.syntax unified
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC1.inc"

.equ SIO_BASE,        0xD0000000

.equ RESETS_BASE,       0x4000c000
.equ RESETS_RESET,      0
.equ RESETS_WDSEL,      4
.equ RESETS_RESET_DONE, 8
.equ ADC_BASE,          0x4004c000
.equ ADC_CS,          0
.equ ADC_RESULT,      4
.equ ADC_FCS,         8
.equ ADC_FIFO,        0xC
.equ ADC_DIV,         0x10
.equ ADC_INTR,        0x14
.equ ADC_INTE,        0x18
.equ ADC_INTF,        0x1C
.equ ADC_INTS,        0x20

/****************************************************/
/* macro d'affichage d'un libellé                   */
/****************************************************/
/* pas d'espace dans le libellé      */
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
szAffReg:        .asciz "Valeur hexa du registre = %x\n"
szMessTemp:      .asciz "Température = %g\n"
szClear:          .byte 0x1B 
                  .byte 'c'     // screen clear
                  .byte 0
.align 4
ret:             .int 0
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    push    {r4-r7,lr}     // save registers
    ldr r0,iAdrszDebutPgm
    bl affString
    
1:
    ldr r0,iAdrszClear
    bl affString
    afficherLib "Température (q for end program)."
    bl testTemp
    
    movs r0,#255
    lsls r0,#2
    bl attendre
    movs r0,#200
    ldr r6,iAdrGetchar_timeout_us
    blx r6
    cmp r0,#'q'              // quit ?
    bne 1b                   // no -> loop
 99:
    ldr r0,iAdrszFinPgm
    bl affString
    movs r0,#0              // return code OK
100:
    pop    {r4-r7,pc}       // restaur register and return to pshell 
.align 2                    // data alignement
 iAdrszDebutPgm:         .int szDebutPgm
 iAdrszFinPgm:           .int szFinPgm
 iAdrGetchar_timeout_us: .int getchar_timeout_us
 iAdrszClear:            .int szClear
/******************************************************************/
/*     Température                                           */ 
/******************************************************************/
.thumb_func
testTemp:
    push {lr}

    ldr r2,iAdrAdcBase      // measure run
    ldr r1,[r2,ADC_CS]
    ldr r3,iParam           
    orrs r3,r3,r1           //
    str r3,[r2,ADC_CS]
    movs r0,100             // wait 
    bl attendre
    movs r1,1
    lsls r1,8               // pour bit 8 à 1
1:                          // loop wait 
    ldr r0,[r2,ADC_CS]
    tst r0,r1
    beq 1b
    
    str r3,[r2,ADC_CS]       // lancement mesure
    
    ldr r4,[r2,ADC_RESULT]

    movs r0,'S'
    movs r1,'F'
    bl appelDatasRom         // search begin float functions
    mov r5,r0                // address float functions
    
    ldr r2,[r5,0x34]         // conversion in float
    movs r0,r4
    blx r2
    
    ldr r1,iCst4
    ldr r2,[r5,8]            // operateur multiplication
    blx r2
    
    ldr r2,[r5,4]            // operateur soustraction
    ldr r1,iCst1
    blx r2

    ldr r2,[r5,0xC]          // opérateur division
    ldr r1,iCst3
    blx r2

    ldr r2,[r5,4]            // operateur soustraction
    movs r1,r0
    ldr r0,iCst2
    blx r2
    mov r4,r0
    
    ldr r0,iAdrszMessTemp
    push {r0}
    push {r4}
    ldr r0,iCst5             // to display float
    ldr r6,iAdrPrintf        // function librairie C
    blx r6
    add sp,sp,#8             // 2 push 

    pop {pc}
.align 2
iParam:           .int 0x100007
iCst1:            .float 0.706
iCst2:            .float 21.0    // adjust this for you pico
iCst3:            .float 0.001721
iCst4:            .float 0.000805664
//iCst6:            .int 27000
//iCst7:            .int 468
//iCst8:            .int 410226
iCst5:           .int 0x00000422
iAdrszMessTemp:   .int szMessTemp
iAdrAdcBase:      .int ADC_BASE
/************************************************/
/* call ROM functions  part Datas               */
/* see RP2040 Datasheet 2.8.3. Bootrom Contents */
/************************************************/
/* r0 Code 1  */
/* r1 code 2  */
.thumb_func
appelDatasRom:
    push {r2-r3,lr}         // save  registers 
    lsls r1,#8              // codes conversion
    orrs r1,r0              // paramètre 2 address search
    movs r0,#0x18           // Rom_table_lookup
    movs r2,#0
    ldrh r2,[r0]
    movs r0,#0x16           // DatasTable
    movs r3,#0
    ldrh r3,[r0]            // load 16 bits 
    movs r0,r3              // parametre 1 address search
    blx r2                  //  

    pop {r2-r3,pc}          // restaur registers
.align 2

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

.align 2
iAdrszAffReg:       .int szAffReg
iAdrPrintf:         .int printf
/************************************/
/*       boucle attente            */
/***********************************/
/* r0 valeur en milliseconde   */
.thumb_func
attendre:                     @ INFO: attendre
    lsls r0,13               @ approximatif 
1:
    subs r0,r0, 1
    bne 1b
    bx lr
    
