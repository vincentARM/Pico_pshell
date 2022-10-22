/*  push bootsel buuton to light led  pShell */
/*  to stop this program type q on the keyboard */
.syntax unified
.cpu cortex-m0plus
.thumb
/*********************************************/ 
/*           CONSTANTES                      */
/********************************************/
.include "functionsC1.inc"
.equ LED_PIN, 25
.equ GPIO_FUNC_SIO,   5

.equ IO_BANK0_BASE,   0x40014000
.equ PADS_BANK0_BASE, 0x4001C000
.equ GPIO_25_CTRL,    IO_BANK0_BASE + 8 * 25 + 4
.equ GPIO_16_CTRL,    IO_BANK0_BASE + 8 * 16 + 4
.equ GPIO_16_STATUS,  IO_BANK0_BASE + 8 * 16

.equ SIO_BASE,          0xD0000000

.equ CPUID          , 0x000 // Processor core identifier
.equ GPIO_IN        , 0x004 // Input value for GPIO pins
.equ GPIO_HI_IN     , 0x008 // Input value for QSPI pins
.equ GPIO_OUT       , 0x010 // GPIO output value
.equ GPIO_OUT_SET   , 0x014 // GPIO output value set
.equ GPIO_OUT_CLR   , 0x018 // GPIO output value clear
.equ GPIO_OUT_XOR   , 0x01c // GPIO output value XOR
.equ GPIO_OE        , 0x020 // GPIO output enable
.equ GPIO_OE_SET    , 0x024 // GPIO output enable set
.equ GPIO_OE_CLR    , 0x028 // GPIO output enable clear
.equ GPIO_OE_XOR    , 0x02c // GPIO output enable XOR
.equ GPIO_HI_OUT    , 0x030 // QSPI output value
.equ GPIO_HI_OUT_SET, 0x034 // QSPI output value set
.equ GPIO_HI_OUT_CLR, 0x038 // QSPI output value clear
.equ GPIO_HI_OUT_XOR, 0x03c // QSPI output value XOR
.equ GPIO_HI_OE     , 0x040 // QSPI output enable
.equ GPIO_HI_OE_SET , 0x044 // QSPI output enable set
.equ GPIO_HI_OE_CLR , 0x048 // QSPI output enable clear
.equ GPIO_HI_OE_XOR , 0x04c // QSPI output enable XOR

.equ IO_QSPI_BASE,   0x40018000
.equ GPIO_QSPI_SCLK_STATUS,    0
.equ GPIO_QSPI_SCLK_CTRL,      4
.equ GPIO_QSPI_SS_STATUS,      8
.equ GPIO_QSPI_SS_CTRL,        0xC

.equ WATCHDOG_BASE,  0x40058000
.equ WATCHDOG_CTRL,  0
.equ WATCHDOG_LOAD,  4
.equ WATCHDOG_REASON,  8
.equ WATCHDOG_SCRATCH7,  0x28
.equ WATCHDOG_TICK,  0x2C
.equ WATCHDOG_TICK_ENABLE_BITS,   0x00000200

.equ PSM_BASE,  0x40010000
.equ PSM_FRCE_ON,   0
.equ PSM_FRCE_OFF,   4
.equ PSM_WDSEL,      8
.equ PSM_DONE,       0xC
.equ PSM_WDSEL_BITS,   0x0001ffff
.equ PSM_WDSEL_ROSC_BITS,   0x00000001
.equ PSM_WDSEL_XOSC_BITS,   0x00000002

/*********************************************/
/*           DONNEES                      */
/********************************************/
.data 
szDebutPgm:      .asciz "Program start.\n"
szFinPgm:        .asciz "Program end OK.\n"
szMessSaisie:    .asciz "push bootsel button or push q to program exit : \n"
/*********************************************/
/*           CODE                      */
/********************************************/
.text
.global main
main:
    push    {r4-r7,lr}      // registers save
    ldr r0,iAdrszDebutPgm
    bl affString
    
    bl initGpioLed           //  Led initialisation
    bl lancerWatchDog
1:                           // loop begin
    ldr r0,iAdrszMessSaisie
    bl affString

2:
    
    bl boutonLed
     
    ldr r0,iAdrszFinPgm
    bl affString
100:
     movs r0,#0              // return code
     pop    {r4-r7,pc}       // restaur registers
     
 .align 2
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrszMessSaisie:  .int szMessSaisie

/*************************************/
/* display not formatted String      */
/*************************************/
/* r0 contains message address */
affString:
     push {r4-r7,lr}
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
     pop {r4-r7,pc}
.align 2
iAdrPutchar:       .int putchar
iAdraffString:     .int affString
/******************************************************************/
/*     allumage de la Led avec le bouton                           */ 
/******************************************************************/
/*                    */
boutonLed:                          // INFO: boutonLed
    push {r4-r7,lr}
    ldr r6,iAdrPin25                // led pin address
    movs r7,0xD             
    lsls r7,28                      // address SIO_BASE
    movs r0, GPIO_FUNC_SIO
    str  r0, [r6]                   // maj function gpio
    movs r6,1                       // 
    lsls r6,25                      // attention use to light led
    str  r6, [r7, #GPIO_OE_SET]
    movs r5,0xFF                    // precedent button stat
1:
    bl etatPin                      // button state ?
    cmp r0,r5                       // changed ?
    beq 3f
    mov r5,r0
    cmp r0,#0
    beq 2f
    str r6,[r7,#GPIO_OUT_SET]       // r7 = pin 25 led light
    b 3f
2:                                  // eteint la Led
    str r6,[r7,#GPIO_OUT_CLR]       // r7 = pin 25 led off

3:
    bl majWatchDog                  // maj counter watchdog
    movs r0,#200
    ldr r4,iAdrGetchar_timeout_us   // load a keyboard touch
    blx r4
    cmp r0,#'q'                     // quit ?
    bne 1b
    bl stopWatchDog                 // end OK stop watchdog
100:
    pop {r4-r7,pc}
.align 2
iAdrPin25:                .int GPIO_25_CTRL
iAdrGetchar_timeout_us:   .int getchar_timeout_us
/************************************/
/*      pin gpio state              */
/***********************************/
/* see \pico-examples\picoboard\button language C   */
.thumb_func
etatPin:                          // INFO: etatPin
    push {r4,lr}
    mrs r4, PRIMASK               // disable interrupt 
    cpsid i
    ldr r3,iAdrIoQspiBase         // spi base address
    adds r3,#0x0C                 // ctrl register
    ldr r1,[r3]
    movs r2,3
    lsls r2,12
    bics r1,r1,r2                 // reset bits 12 and 13
    movs r2,2
    lsls r2,12
    orrs  r1,r2                   // and store 0b10 in bits 12 and 13
    str r1,[r3]                   // store result in spi ctrl register
    movs r0,50
    bl attendre
    ldr r2,iAdrIoport             // adresse base IO
    ldr r0,[r2,#GPIO_HI_IN]       //  read state gpio in register

    lsrs r0,#1                    // shift right  1
    beq 1f                        // équal to zéro ?
    movs r0,0                     // no push button
    b 2f
1:
    movs r0,1                     // push button
2:
    movs r2,3
    lsls r2,12
    bics r1,r1,r2
    str r1,[r3]
100: 
    msr PRIMASK,r4                // enable interrup 
    pop {r4,pc}
.align 2
iAdrIoport:       .int SIO_BASE
iAdrIoQspiBase:   .int IO_QSPI_BASE
/************************************/
/*       boucle attente            */
/***********************************/
/* r0 valeur en milliseconde   */
.thumb_func
attendre:                     // INFO: attendre
    lsls r0,13                // approximatif 
1:
    subs r0,r0, 1
    bne 1b
    bx lr

/************************************/
/*       init gpio               */
/***********************************/
initGpioLed:
    ldr  r1,iAdrGPIO25          // init fonction sio
    movs r0,#GPIO_FUNC_SIO
    str  r0, [r1]

    ldr  r1,iAdrSIO_BASE
    movs  r0,#1
    lsls  r0,#25                 // GPIO pin 25 
    str  r0, [r1,#GPIO_OE_SET]  // output
    bx lr
.align 2
iAdrGPIO25:     .int GPIO_25_CTRL
iAdrSIO_BASE:   .int SIO_BASE
/******************************************************************/
/*     lancement du watchdog                                         */ 
/******************************************************************/
/*                    */
.thumb_func
lancerWatchDog:               // INFO: lancerWatchDog
    push {lr}
    ldr r2,iAdrWatchDogBase
    ldr r1,iParCycles        // counter watchdog
    str r1,[r2,#WATCHDOG_TICK]
    ldr r1,iparWDem
    str r1,[r2,#WATCHDOG_CTRL]
    
    ldr r2,iAdrPsmBase
    ldr r1,iParPsm
    str r1,[r2,PSM_WDSEL]
    
    pop {pc}
.align 2
iAdrWatchDogBaseXor:    .int WATCHDOG_BASE +0x1000
iAdrWatchDogBaseSet:    .int WATCHDOG_BASE +0x2000
iAdrWatchDogBaseClear:  .int WATCHDOG_BASE +0x3000
iParCycles:             .int WATCHDOG_TICK_ENABLE_BITS| 10
iparWDem:               .int 0x40000064       // enable + 100ms
iAdrPsmBase:            .int PSM_BASE
iParPsm:                .int PSM_WDSEL_BITS & ~(PSM_WDSEL_ROSC_BITS |PSM_WDSEL_XOSC_BITS)
/******************************************************************/
/*     mise à jour compteur majWatchDog                           */ 
/******************************************************************/
majWatchDog:                    // INFO:  majWatchDog
    push {r0-r1,lr}
    ldr r0,iAdrWatchdog         // watchdog counter
    ldr r1,iDelai
    str r1,[r0,#WATCHDOG_LOAD]
    pop {r0-r1,pc}
.align 2
iAdrWatchdog:    .int WATCHDOG_BASE
iDelai:          .int 99000000
/******************************************************************/
/*     arrêt du watchdog                                         */ 
/******************************************************************/
/*                    */
.thumb_func
stopWatchDog:               @ INFO: stopWatchDog
    ldr r2,iAdrWatchDogBase
    movs r1,0
    str r1,[r2,#WATCHDOG_CTRL]
    bx lr
.align 2
iAdrWatchDogBase:       .int WATCHDOG_BASE
