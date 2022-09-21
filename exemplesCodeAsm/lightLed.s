/*  touch pin 16 with a finger to light led  pShell */
/*  to stop this program type q on thr keyboard */
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"
.equ LED_PIN, 25
.equ GPIO_FUNC_SIO,   5

.equ IO_BANK0_BASE,   0x40014000
.equ PADS_BANK0_BASE, 0x4001C000
.equ GPIO_25_CTRL,    IO_BANK0_BASE + 8 * 25 + 4
.equ GPIO_16_CTRL,    IO_BANK0_BASE + 8 * 16 + 4
.equ GPIO_16_STATUS,  IO_BANK0_BASE + 8 * 16

.equ SIO_BASE,          0xD0000000

.equ CPUID          , 0x000 @ Processor core identifier
.equ GPIO_IN        , 0x004 @ Input value for GPIO pins
.equ GPIO_HI_IN     , 0x008 @ Input value for QSPI pins
.equ GPIO_OUT       , 0x010 @ GPIO output value
.equ GPIO_OUT_SET   , 0x014 @ GPIO output value set
.equ GPIO_OUT_CLR   , 0x018 @ GPIO output value clear
.equ GPIO_OUT_XOR   , 0x01c @ GPIO output value XOR
.equ GPIO_OE        , 0x020 @ GPIO output enable
.equ GPIO_OE_SET    , 0x024 @ GPIO output enable set
.equ GPIO_OE_CLR    , 0x028 @ GPIO output enable clear
.equ GPIO_OE_XOR    , 0x02c @ GPIO output enable XOR
.equ GPIO_HI_OUT    , 0x030 @ QSPI output value
.equ GPIO_HI_OUT_SET, 0x034 @ QSPI output value set
.equ GPIO_HI_OUT_CLR, 0x038 @ QSPI output value clear
.equ GPIO_HI_OUT_XOR, 0x03c @ QSPI output value XOR
.equ GPIO_HI_OE     , 0x040 @ QSPI output enable
.equ GPIO_HI_OE_SET , 0x044 @ QSPI output enable set
.equ GPIO_HI_OE_CLR , 0x048 @ QSPI output enable clear
.equ GPIO_HI_OE_XOR , 0x04c @ QSPI output enable XOR

/*********************************************/
/*           DONNEES                      */
/********************************************/
.data 
szDebutPgm:      .asciz "Debut du programme.\n"
szFinPgm:        .asciz "Fin Ok du programme.\n"
szMessSaisie:    .asciz "Toucher avec le doigt le pin 16 ou appuyer sur q : \n"

/*********************************************/
/*           CODE                      */
/********************************************/
.text
.global main
main:
    push    {r4-r7,lr}      // registers save
    ldr r0,iAdrszDebutPgm
    bl affString
    
    bl initGpioLed           // init de la Led
1:                           // loop begin
    ldr r0,iAdrszMessSaisie
    bl affString

2:
    bl testerDoigts
    mov r0,#200
    ldr r6,iAdrGetchar_timeout_us
    blx r6
    cmp r0,#'q'              // quit ?
    bne 2b                   // no -> loop
     
    ldr r0,iAdrszFinPgm
    bl affString
100:
     mov r0,#0               // return code
     pop    {r4-r7,pc}       // restaur registers
     
 .align 2                    // data alignement
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrszMessSaisie:  .int szMessSaisie
 iAdrGetchar_timeout_us:       .int getchar_timeout_us
/*************************************/
/* display not formatted String      */
/*************************************/
/* r0 contains message address */
affString:
     push {r4-r6,lr}
     mov r4,r0                // save message address
     mov r5,#0                // init indice
1:
     ldrb r0,[r4,r5]          // load one byte of message
     cmp r0,#0                // end zéro ?
     beq 2f                   // yes
     ldr r6,iAdrPutchar       // display one character
     blx r6
     add r5,r5,#1             // increment indice
     b 1b                     // and loop
2:
     pop {r4-r6,pc}
.align 2
iAdrPutchar:       .int putchar
/******************************************************************/
/*     touche d'un pin avec les doigts                                            */ 
/******************************************************************/
testerDoigts:                   @ INFO: testerDoigts
    push {r1-r4,lr}
    ldr  r1,iAdrGPIO16          @ init fonction sio
    mov r0,#GPIO_FUNC_SIO
    str  r0, [r1]

    mov  r2,#1
    lsl  r2,#16                @ GPIO pin 16
    ldr r1,iAdrSioBase
    str r2,[r1,#GPIO_OUT_SET]   @ niveau sortie haut
    str r2,[r1,#GPIO_OE_SET]    @ output actif
    mov r0,#5
    bl attendre

    
    ldr r1,iAdrPads16           @ lecture registre pad pin 16
    mov r0,#0b1000100           @ bit input (6) et pull_down (2)
    str r0,[r1]                 @ maj registre pad


    ldr r1,iAdrSioBase
    ldr  r4, [r1,#GPIO_IN]      @ lecture
    ldr r1,iAdrSioBase
    mov  r2,#1
    lsl  r2,#16                 @ GPIO pin 16
    mov r3,#0                   @ compteur
    str r2,[r1,#GPIO_OE_CLR]    @ output niveau bas
1:
    ldr  r0, [r1,#GPIO_IN]     @ lecture
    add r3,r3,#1               @ incremente compteur
    cmp r0,r4                  @ changement etat ?
    beq 1b                     @ boucle
    cmp r3,#15                 @ Sans appui la boucle dure 10 comptages
    ble 100f                   @ avec appui elle dépasse les 20 comptages
    mov r0,#3                  @ dans ce cas, allumage de la led pour 3 eclats
    bl ledEclats

    
100:
    pop {r1-r4,pc}
.align 2
iAdrGPIO16:            .int GPIO_16_CTRL
iAdrPads16:            .int PADS_BANK0_BASE + 0x44  @ registre pad pin 16

/************************************/
/*       init gpio               */
/***********************************/
.thumb_func
initGpioLed:
    ldr  r1,iAdrGPIO25          @ init fonction sio
    mov r0,#GPIO_FUNC_SIO
    str  r0, [r1]

    ldr  r1,iAdrSioBase
    mov  r0,#1
    lsl  r0,#25                 @ GPIO pin 25 
    str  r0, [r1,#GPIO_OE_SET]  @ output
    bx lr
.align 2
iAdrGPIO25:     .int GPIO_25_CTRL

/************************************/
/*       LED  Eclat               */
/***********************************/
/* r0 contient le nombre d éclats   */
ledEclats:                      @ INFO: ledEclats
    push {r1-r4,lr}
    mov r4,r0
    mov  r2,#1
    lsl  r2,#25                 @ GPIO pin 25
    ldr r3,iAdrSioBase
1:
    str r2,[r3,#GPIO_OUT_XOR]   @ allumage led
    mov r0, #250
    bl attendre
    str r2,[r3,#GPIO_OUT_XOR]   @ extinction led
    movs r0, #250
    bl attendre 
    sub r4,r4,#1                  @ décremente nombre eclats
    bgt 1b                     @ et boucle 
    
    pop {r1-r4,pc}
.align 2
iAdrSioBase:    .int SIO_BASE
/************************************/
/*       boucle attente            */
/***********************************/
/* r0 valeur en milliseconde   */
/* r1 non sauvegardé */
attendre:
    lsl r0,r0,#15             // approximatif
1:
    mov r1,#1
    sub r0,r1
    bne 1b
    bx lr
