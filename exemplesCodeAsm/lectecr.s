/* io file  pShell */
/*********************************************/
/*           CONSTANTES                      */
/********************************************/
.include "functionsC.inc"
.equ O_RDONLY,      0
.equ O_WRONLY,     01
.equ O_CREAT,     512

.equ LGBUFLECT,   255         
/*********************************************/
/*           DONNEES                      */
/********************************************/
.data 
szDebutPgm:      .asciz "Debut du programme.\n"
szFinPgm:        .asciz "Fin Ok du programme.\n"
szMessErrOpen:   .asciz "Erreur ouverture fichier.\n"
szMessErrWrite:  .asciz "Erreur ecriture fichier.\n"
szMessErrRead:   .asciz "Erreur lecture fichier.\n"
szMessEcrOK:     .asciz "Ecriture fichier OK\n" 
szNomFicEcr:     .asciz "fic1.txt"
szBufLect:       .skip  LGBUFLECT
szBufEcr:        .asciz  "ABCDEFGHIJK"
.equ LGBUFECR,    . - szBufEcr
szAffReg:        .asciz "Valeur du registre = %x\n"
szMessBuffer:    .asciz "Contenu du buffer : %s \n" 
/*********************************************/
/*           CODE                      */
/********************************************/
.text
.global main
main:
     push    {r4-r7,lr}      // registers save
     ldr r0,iAdrszDebutPgm
     bl affMessage
     ldr r0,iAdrszNomFicEcr  // file name address
     ldr r1,iparam
     ldr r6,iAdropen         // open file
     blx r6                  // call function
     cmp r0,#0               // open error ?
     bgt 1f
     ldr r0,iAdrszMessErrOpen
     bl affMessage
     b 100f
1:
     mov r7,r0               // save FD 
     bl affreg               // display value FD
     mov r0,r7               // FD
     ldr r1,iAdrszBufEcr     // write buffer address
     mov r2,#LGBUFECR        // buffer length
     ldr r6,iAdrwrite        // write buffer
     blx r6                  // call function
     cmp r0,#LGBUFECR        // write ok ?
     beq 2f
     ldr r0,iAdrszMessErrWrite
     bl affMessage
     b 99f

2:
     ldr r0,iAdrszMessEcrOK   // write is OK
     bl affMessage
     
     mov r0,r7                // FD
     ldr r6,iAdrclose         // close file
     blx r6                   // call function

     ldr r0,iAdrszNomFicEcr  // file name address
     ldr r1,iparam1          // read mode 
     ldr r6,iAdropen         // file open
     blx r6                  // call function
     cmp r0,#0               // open error ?
     bgt 3f
     ldr r0,iAdrszMessErrOpen
     bl affMessage
     b 100f
     
3:
     mov r0,r7               // FD
     ldr r1,iAdrszBufLect    // read buffer address
     mov r2,#LGBUFLECT       // buffer length
     ldr r6,iAdrread         // read file
     blx r6                  // call function
     cmp r0,#0               // read ok ?
     bge 4f
     ldr r0,iAdrszMessErrRead
     bl affMessage

4:
     mov r1,#0
     strb r1,[r0]           // store buffer zéro final
     ldr r0,iAdrszMessBuffer
     push {r0}
     ldr r0,iAdrszBufLect
     push {r0}
     mov r0,#2
     ldr r6,iAdrPrintf        // display message
     blx r6
     add sp,sp,#8             // stack alignement 2 push 

99:
     mov r0,r7                // FD
     ldr r6,iAdrclose         // close file
     blx r6                   // call function
     
     ldr r0,iAdrszFinPgm
     bl affMessage
100:
     mov r0,#0               // return code
     pop    {r4-r7,pc}       // restaur registers
     
 .align 2                    // data alignement
 iAdrszDebutPgm:    .int szDebutPgm
 iAdrszFinPgm:      .int szFinPgm
 iAdrszNomFicEcr:   .int szNomFicEcr
 iAdrszMessErrOpen: .int szMessErrOpen
 iAdrszMessErrRead:  .int szMessErrRead
 iAdrszMessEcrOK:   .int szMessEcrOK
 iAdropen:          .int open
 iAdrclose:         .int close
 iAdrwrite:         .int write
 iAdrread:          .int read
 iAdrszBufEcr:      .int szBufEcr
 iAdrszBufLect:      .int szBufLect
 iAdrszMessErrWrite: .int szMessErrWrite
 iAdrszMessBuffer:   .int szMessBuffer
 iparam:             .int O_WRONLY + O_CREAT
 iparam1:            .int O_RDONLY
/*************************************/
/* display String                    */
/*************************************/
/* r0 contains message address */
affMessage:
     push {r6,lr}
     push {r0}
     mov r0,#1                // nombre de paramètres
     ldr r6,iAdrPrintf        // fonction librairie C
     blx r6
     add sp,sp,#4             // 1 push 
     pop {r6,pc}
/*************************************/
/* display register value                  */
/*************************************/
/* r0 contains the value */
affreg:
     push {r6,lr}
     ldr r1,iAdrszAffReg
     push {r1}
     push {r0}
     mov r0,#2                // nombre de paramètres
     ldr r6,iAdrPrintf        // display message
     blx r6
     add sp,sp,#8             // 2 push 
     pop {r6,pc}

.align 2                  // data alignement
iAdrPrintf:         .int printf
iAdrszAffReg:       .int szAffReg
