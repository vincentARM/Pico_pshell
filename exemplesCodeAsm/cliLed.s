/* clignotement LED avec pShell */
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.equ LED_PIN, 25
.equ GPIO_FUNC_SIO,   5

.equ IO_BANK0_BASE,   0x40014000
.equ GPIO_25_STATUS,  IO_BANK0_BASE + 8 * 24
.equ GPIO_25_CTRL,    IO_BANK0_BASE + 8 * 25 + 4

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
/*******************************************/
/*  datas                                  */
/*******************************************/
.data 
/*******************************************/
/*  code                                  */
/*******************************************/
.text
.global main
main:
    push    {r4-r7,lr}
    ldr  r1, iAdrGPIO_25_CTRL         // init fonction GPIO
    mov  r0, #GPIO_FUNC_SIO
    str  r0, [r1]                     // fonction 5 pour le pin 25 = LED

    ldr  r1,iAdrSIO_BASE
    mov  r0,#1
    lsl  r0,#LED_PIN
    str  r0, [r1, #GPIO_OE_SET]       // sortie pour le pin 25

    mov  r0,#2                        // 2 eclats
    bl ledEclats
 
    mov r0,#0                         // code retour
    pop    {r4-r7,pc}
/************************************/
/*       LED  Eclat               */
/***********************************/
/* r0 contient le nombre d éclats   */
ledEclats:
    push {r1-r4,lr}
    mov  r4,r0
    mov  r2,#1
    lsl  r2,#LED_PIN
    ldr  r3,iAdrSIO_BASE
1:
    str r2,[r3,#GPIO_OUT_SET]
    mov  r0, #250
    bl attendre
    str r2,[r3,#GPIO_OUT_CLR]
    mov  r0, #250
    bl attendre 
    sub  r4,#1
    bgt 1b 
    pop {r1-r4,pc}
.align 2
iAdrSIO_BASE:       .int SIO_BASE
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

.align 2
iAdrGPIO_25_CTRL:   .int GPIO_25_CTRL
