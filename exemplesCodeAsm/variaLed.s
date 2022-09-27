/*  to stop this program type q on the keyboard */
.syntax unified
.cpu cortex-m0plus
.thumb
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
szMessSaisie:    .asciz "Appuyer sur q pour quitter le programme : \n"

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
    bl variaLED
    movs r0,#200
    ldr r6,iAdrGetchar_timeout_us
    blx r6
    cmp r0,#'q'              // quit ?
    bne 2b                   // no -> loop
     
    ldr r0,iAdrszFinPgm
    bl affString
100:
     movs r0,#0               // return code
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
     movs r4,r0                // save message address
     movs r5,#0                // init indice
1:
     ldrb r0,[r4,r5]          // load one byte of message
     cmp r0,#0                // end zéro ?
     beq 2f                   // yes
     ldr r6,iAdrPutchar       // display one character
     blx r6
     adds r5,r5,#1             // increment indice
     b 1b                     // and loop
2:
     pop {r4-r6,pc}
.align 2
iAdrPutchar:       .int putchar
/************************************/
/*       LED  variation             */
/***********************************/
/* r0 contains cycles number    */
variaLED:
    push {r1-r7,lr}
    movs r4,r0                   // save cycles number
    movs r2,#1
    lsls r2,#LED_PIN
    ldr  r3,iAdrSIO_BASE
    movs r6,#1
    lsls r6, r6,#9               // X initial value = 512
    movs r5,#0                   // init Y
1:
    movs r7,#128
2:                               // loop begin
                                 // algorithme  Minsky circle
    asrs r1, r5,#5               // -dx = y >> 5
    subs r6, r1                  //  x += dx
    asrs r1, r6,#5               //  dy = x >> 5
    adds r5, r1                  //  y += dy
    
    movs r0,#1                   // computr light time
    lsls r0,#9
    adds r0,r6                   // add 512 for positive number
    movs r1,#1
    lsls r1,#10                  // calcul temps d'extinction (1024 - temps d'allumage)
    adds r1,#1
    subs r1,r1,r0
 
    str  r2,[r3,#GPIO_OUT_SET]   // light Led
    
    lsls r0,#7                   // approximatif 
3:                               // loop light time
    subs r0,r0,#1
    bne 3b
 
    str  r2,[r3,#GPIO_OUT_CLR]   // Ledoff 

    lsls r1,#9                   // approximatif 
4:                               // loop led off
    subs r1,#1
    bne 4b 

    subs r7,#1                   @ décrement durée 
    bgt 2b                      // et boucle
    
    subs r4,#1                  // decrément nombre de variations
    bge 1b                      // et boucle
    
    pop {r1-r7,pc}
/************************************/
/*       init gpio               */
/***********************************/
.thumb_func
initGpioLed:
    ldr  r1,iAdrGPIO25          // init fonction sio
    movs r0,#GPIO_FUNC_SIO
    str  r0, [r1]

    ldr  r1,iAdrSIO_BASE
    movs  r0,#1
    lsls  r0,#25                // GPIO pin 25 
    str  r0, [r1,#GPIO_OE_SET]  // output
    bx lr
.align 2
iAdrGPIO25:     .int GPIO_25_CTRL
iAdrSIO_BASE:   .int SIO_BASE

