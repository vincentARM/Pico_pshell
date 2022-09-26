/* pour test pgm assembleur avec pShell */
.syntax unified
.cpu cortex-m0plus
.thumb
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"

.equ PPB_BASE,       0xE0000000
.equ SYST_CSR,       0xE010        // systick
.equ SYST_RVR,       0xE014
.equ SYST_CVR,       0xE018
/****************************************************/
/* macro d'affichage d'un libellé                   */
/****************************************************/
/* pas d'espace dans le libellé     */
/* attention pas de save du registre d'état */
.macro afficherLib str 
    push {r0-r3}                // save des registres
    adr r0,libaff1\@            // recup adresse libellé passé dans str
    bl affString
    pop {r0-r3}                 // restaure des registres
    b smacroafficheMess\@       // pour sauter le stockage de la chaine.
.align 4
libaff1\@:     .asciz "\str\r\n"
.align 4
smacroafficheMess\@:     
.endm                          @ fin de la macro

/*******************************************/
/*  datas                                  */
/*******************************************/
.data 
szDebutPgm:      .asciz "Debut du programme.\n"
szFinPgm:        .asciz "Fin Ok du programme.\n"
szMessSystick:   .asciz "Nombre de cycles = %d \n"
.align 4
ret:             .int 0
iValDepSys:      .int 0
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    push    {r4-r7,lr}   // save registers
    ldr r0,iAdrszDebutPgm
    bl affString
    
    afficherLib controle
    
    bl mesurerCycles
    
    ldr r0,iAdrszFinPgm
    bl affString
    movs r0,#0            // return code OK
100:
    pop    {r4-r7,pc}    // restaur register and return to pshell 
.align 2
iAdrszDebutPgm:     .int szDebutPgm
iAdrszFinPgm:       .int szFinPgm
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
/******************************************************************/
/*     mesure de cycles                                            */ 
/******************************************************************/
mesurerCycles:                       @ INFO: mesurerCycles
    push {r1-r4,lr}
    afficherLib "Comptage cycles à vide (13 cycles) "
    bl debutSystick          @ debut du comptage
    bl finSystick            @ 4 cycles
    
    afficherLib "Comptage 1 instruction (14 cycles) "
    bl debutSystick          @ debut du comptage
    movs r0,#1
    bl finSystick            @ 4 cycles
    
    afficherLib "Comptage affichage libellé "
    bl debutSystick          @ debut du comptage
    afficherLib "Pour test"
    bl finSystick            @ 4 cycles

   afficherLib "Comptage un putchar "
    bl debutSystick          @ debut du comptage
    movs r0,#'A'
    ldr r6,iAdrPutchar        // display one character
    blx r6
    bl finSystick            @ 4 cycles
 100:
    pop {r1-r4,pc}
.align 2
iAdrPutchar:       .int putchar
/******************************************************************/
/*     Début comptage systick                                         */ 
/******************************************************************/
.thumb_func
debutSystick:                  @ INFO: debutSystick
    ldr r0,iAdrSystick_RVR     @ adresse Systick_RVR voir ch 2.4.8
    ldr r1,iParam              @ Reload Value Register
    str r1,[r0]                @ valeur de départ
    adds r2,r0,4               @ adresse Systick_CVR Current Value Register
    movs r1,0                  @ init compteur
    str r1,[r2]
    subs r0,4                  @ adresse Systick_CSR Control and Status Register
    movs r1,5                  @ processeur et activation 
    str r1,[r0]
    ldr r1,iAdriValDepSys
    ldr r0,[r2]                @ lecture valeur
    str r0,[r1]                @ stockage valeur début   2 cycles
100:
    bx lr                      @ 3 cycles
.align 2
iParam:           .int 0x00ffffff
/******************************************************************/
/*     Fin comptage systick                                         */ 
/******************************************************************/
.thumb_func
finSystick:                  @ INFO: finSystick
    push {lr}                @ 2 cycles
    ldr r0,iAdrSystick_CVR   @ adresse Systick_RVR voir ch 2.4.8   2 cycles
    ldr r3,[r0]              @ lecture valeur
    ldr r1,iAdriValDepSys
    ldr r2,[r1]
    subs r2,r3                @ calcul différence
    ldr r0,iAdrszMessSystick 
    push {r0}
    push {r2}
    movs r0,#2                // nombre de paramètres
    ldr r6,iAdrPrintf        // fonction librairie C
    blx r6
    add sp,sp,#8             // 2 push 
100:
    pop {pc}
.align 2
iAdriValDepSys:       .int iValDepSys
iAdrSystick_RVR:      .int PPB_BASE + SYST_RVR
iAdrSystick_CVR:      .int PPB_BASE + SYST_CVR
iAdrszMessSystick:    .int szMessSystick
iAdrPrintf:           .int printf
