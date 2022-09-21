/*  read string with getchar and putchar  pShell */
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"
.equ LGBUFFER,   100
/*********************************************/
/*           DONNEES                      */
/********************************************/
.data 
szDebutPgm:      .asciz "Debut du programme.\n"
szFinPgm:        .asciz "Fin Ok du programme.\n"
szMessSaisie:    .asciz "Saisir une chaine de caractères (fin pour finir) : \n"
szMessErrBuf:    .asciz "Buffer trop petit !!\n"
szFin:           .asciz "fin"
szBuffer:        .skip LGBUFFER
/*********************************************/
/*           CODE                      */
/********************************************/
.text
.global main
main:
    push    {r4-r7,lr}      // registers save
    ldr r0,iAdrszDebutPgm
    bl affString
    
1:                           // loop begin
    ldr r0,iAdrszMessSaisie
    bl affString
    ldr r0,iAdrszBuffer
    mov r1,#LGBUFFER
    bl readString            // read a string
    ldr r0,iAdrszBuffer
    bl affString             // display a string
    mov r0,#'\n'             // carriage return
    ldr r6,iAdrPutchar
    blx r6
     
    ldr r0,iAdrszBuffer      // buffer address
    ldr r1,iAdrszFin         // address string "fin"
    bl compareString
    cmp r0,#0                // strings are equals ?
    bne 1b                   // no -> loop
     
    ldr r0,iAdrszFinPgm
    bl affString
100:
     mov r0,#0               // return code
     pop    {r4-r7,pc}       // restaur registers
     
 .align 2                    // data alignement
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrszMessSaisie:  .int szMessSaisie
 iAdrszBuffer:      .int szBuffer
 iAdrszFin:         .int szFin
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

/*************************************/
/* read String      */
/*************************************/
/* r0 contains buffer address */
/* r1 contains buffer length  */
readString:
     push {r4-r7,lr}
     mov r5,r0
     mov r7,r1
     mov r4,#0
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
     add r4,r4,#1            // increment indice position
     cmp r4,r7               // maxi ?
     blt 2f
     mov r0,#'\n'            // display error
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
    mov r0,#0xA
    ldr r6,iAdrPutchar
    blx r6
    mov r0,#0xD
    ldr r6,iAdrPutchar
    blx r6
    mov r0,#0
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
    mov r2,#0             @ indice
1:    
    ldrb r3,[r0,r2]       @ byte chaine 1
    ldrb r4,[r1,r2]       @ byte chaine 2
    cmp r3,r4             @ compare byte
    blt 2f
    bgt 3f
    cmp r3,#0             @ 0 final ?
    beq 4f                @ end
    add r2,r2,#1          @ increment indice
    b 1b                  @ and loop
2:
    mov r0,#0             @ <
    sub r0,#1
    b 100f
3:
    mov r0,#1             @ >
    b 100f
4:
    mov r0,#0             @ =
100:
    pop {r2-r4,pc}
