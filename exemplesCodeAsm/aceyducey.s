/* programme acey ducey  Basic Computer games David H.Ahl 1978 */
/* Author Bill Palmby pour le basic */
/* Assembleur ARM Raspberry Pico VincentARM */
/*   */
.syntax unified
.cpu cortex-m0plus
.thumb
/********************************************/
/*          Constantes                      */
/********************************************/
.include "functionsC.inc"
.equ TAILLEBUF,  100  
.equ STDIN, 0
.equ LGZONENOM, 15

.equ SIO_BASE,                 0xD0000000

.equ SIO_DIV_UDIVIDEND_OFFSET, 0x00000060
.equ SIO_DIV_UDIVISOR_OFFSET,  0x00000064
.equ SIO_DIV_QUOTIENT_OFFSET,  0x00000070
.equ SIO_DIV_REMAINDER_OFFSET, 0x00000074
.equ SIO_DIV_CSR_OFFSET,       0x00000078


/*******************************************/
/* DONNEES INITIALISEES                    */
/*******************************************/ 
.data
szRegles:     .ascii  "Régles du jeu : \n"
              .ascii "L'ordinateur tire 2 cartes au hasard et les affiche. \n"
              .ascii "En fonction de ces 2 cartes, vous pouvez pariez ou non \n"   
              .ascii "selon que vous pensez que la 3ième carte tirée par l'ordinateur \n"
              .ascii "aura une valeur comprise entre les 2 premières (exclues).\n"
              .ascii "Si vous ne voulez pas parier à une proposition, taper 0." 			  
              .asciz   "\n" 
szSaisie:     .asciz  "Quel est le montant de votre pari ? :\n"
szRetourligne:  .asciz  "\n"
sMessMontant:   .ascii  "\033[0mVous avez maintenant "
sNombreEuros:   .space 11,' '
                .asciz " Euros.\n"
sMessCarte:     .ascii  "Carte : "
sNomCarte:      .space LGZONENOM+1,' '
                .asciz "  \n"
szMessNOPari:   .asciz "Ah, ah, ah vous avez peur !!!\n "	
szMessCaisseVide: .asciz "Ah, mais vous n'avez pas assez d'argent !!\n"	
szMessFaillite:   .asciz "Zéro Euros !! Vous êtes ruiné !!\n"
szMessAutrePari:  .asciz " Un autre pari 'o ou n'  ? \n"	
szMessPerdu:      .asciz " Vous avez perdu !!  \n"	
szMessGagne:      .asciz " Bravo, vous avez gagné !!  \n"
szMessErrAppel:   .asciz "Erreur appel systeme. \n"
szMessErrBuf:     .asciz "Buffer trop petit !!\n"
szMessErr:        .asciz  "Nombre trop grand : dépassement de capacite de 32 bits. :\n"
szValet:          .asciz "valet"
szDame:           .asciz "dame"
szRoi:            .asciz "roi"
szAs:             .asciz "As"
szFin:            .asciz "fin"
szClear:          .byte 0x1B 
                  .byte 'c'     // screen clear
                  .byte 0

.align 4
iGraine:          .int 1234567
sBuffer:          .skip TAILLEBUF /* reserve des octets pour stocker chaine saisie */
sValCarte:        .skip 11 

/**********************************************/
/* -- Code section                            */
/**********************************************/
.text            
.global main

main:
    push {r4-r7,lr}
    ldr r0,iAdrszClear         // effacement ecran
    bl affString
    ldr r0,iAdrszRegles
    bl affString 
    movs r6,#100               // nombre d'euros au départ
1:                             // début de boucle de saisie
    mov r0,r6
    ldr r1,iAdrsNombreEuros
    bl conversion10
    ldr r0,iAdrsMessMontant
    bl affString
                                // tirage des 2 cartes
    bl tirage
    mov r8,r0                   // 1ere carte dans r8
    bl tirage
    cmp r0,r8                   // si 2ième tirage plus petit, on inverse les 2 tirages
    bge 11f
    mov r7,r8
    mov r8,r0
    mov r0,r7
11:
    mov r9,r0                   // 2ieme carte dans r9
2:    
    ldr r0,iAdrszSaisie
    bl affString
    ldr r0,iAdrsBuffer          // adresse du buffer de saisie
    movs r1,#TAILLEBUF          // taille buffer
    bl readString
    ldr r0,iAdrsBuffer         // conversion saisie 
    bl conversionAtoD
    cmp r0,#0                  // si 0  message et boucle
    bne 3f
    ldr r0,iAdrszMessNOPari
    bl affString
    b 6f
3:    
    cmp r0,r6                  // verifier si le pari est inferieur au montant total
    ble 4f
    ldr r0,iAdrszMessCaisseVide
    bl affString
    b 2b
    
4:    
    mov r2,r0            // save du montant
    bl tirage            // tirage 3 ieme carte
    cmp r0,r8            // verifier si cette carte est entre les 2 premieres
    blt perdu
    cmp r0,r9
    bgt perdu    
    ldr r0,iAdrszMessGagne  // si oui gagné
    bl affString
    adds r6,r2
    b 5f
perdu:    
    ldr r0,iAdrszMessPerdu
    bl affString
    subs r6,r2
    bne 5f                  // montant < 0 ?
    ldr r0,iAdrszMessFaillite
    bl affString
    b 100f
5:                         // demander autre pari
    ldr r0,iAdrszMessAutrePari
    bl affString
    ldr r0,iAdrsBuffer     // adresse du buffer de saisie
    movs r1,#TAILLEBUF     // taille buffer
    bl readString
    ldr r0,iAdrsBuffer
    ldrb r0,[r0]
    cmp r0,#'o'
    beq 6f
    cmp r0,#'O'            // si oui  boucle
    beq 6f
    b fin
6:
   b 1b    
    
fin:
    mov r0,r6
    ldr r1,iAdrsNombreEuros
    bl conversion10
    ldr r0,iAdrsMessMontant
    bl affString
    movs r0,#0                // code retour OK
 100:  
    pop {r4-r7,pc} 
.align 2
iAdrszClear:          .int szClear
iAdrszRegles:         .int szRegles
iAdrszMessCaisseVide: .int szMessCaisseVide
iAdrszMessNOPari:     .int szMessNOPari
iAdrszMessGagne:      .int szMessGagne
iAdrszMessPerdu:      .int szMessPerdu
iAdrszMessFaillite:   .int szMessFaillite
iAdrszMessAutrePari:  .int szMessAutrePari
iAdrsMessMontant:     .int sMessMontant
iAdrsNombreEuros:     .int sNombreEuros
iAdrszMessErrAppel:   .int szMessErrAppel
iAdrszSaisie:         .int szSaisie
iAdrsBuffer:          .int sBuffer

/******************************************************************/
/*     Tirage d'une carte                               */ 
/******************************************************************/
/* r0 retourne le N0 de la carte de 2 à 14   */
tirage:
    push {r1-r4,lr}
    movs r2,#LGZONENOM
    movs r1,#' '
    ldr r0,iAdrsNomCarte     // raz nom carte
1:    
    strb r1,[r0,r2]
    subs r2,#1
    bne 1b
    
    movs r0,#12
    bl genereraleas
    adds r0,#2               // pour generer 2 à 14
    mov r4,r0                // save tirage
    cmp r0,#10
    ble convnum
    cmp r0,#11
    b valet
    cmp r0,#12
    b dame
    cmp r0,#13
    b roi
    cmp r0,#14
    b as
    
valet:
    ldr r0,iAdrszValet
    ldr r1,iAdrsNomCarte
    bl Copie    
    b affiche
dame:
    ldr r0,iAdrszDame
    ldr r1,iAdrsNomCarte
    bl Copie    
    b affiche    
roi:
    ldr r0,iAdrszRoi
    ldr r1,iAdrsNomCarte
    bl Copie    
    b affiche    
as:
    ldr r0,iAdrszAs
    ldr r1,iAdrsNomCarte
    bl Copie    
    b affiche    
convnum:
    ldr r1,iAdrsValCarte
    bl conversion10
    ldr r2,iAdrsValCarte
    ldr r1,iAdrsNomCarte
    ldrb r3,[r2]          // lit 1 octet
    strb r3,[r1]          // stocke 1 octet
    adds r2,#1
    ldrb r3,[r2]           // lit octet suivant
    adds r1,r1,#1
    strb r3,[r1]
    b affiche    
affiche:    
    ldr r0,iAdrsMessCarte
    bl affString
    mov r0,r4
100:    
    pop {r1-r4,pc} 
.align 2
iAdrsMessCarte:     .int sMessCarte
iAdrsNomCarte:      .int sNomCarte
iAdrsValCarte:      .int sValCarte
iAdrszValet:        .int szValet
iAdrszDame:         .int szDame
iAdrszRoi:          .int szRoi
iAdrszAs:           .int szAs
/***************************************************/
/*   copie chaine                 */
/***************************************************/
/* r0 adresse chaine origine  */
/* r1 adresse zone reception  */
Copie:
    push {r1-r4,lr}
    movs r2,#0
1:
    ldrb r3,[r0,r2]   
    cmp r3,#0
    beq 100f
    strb r3,[r1,r2]
    adds r2,#1
    b 1b  
100:   
    pop {r1-r4,pc}    
   
/***************************************************/
/*   Génération nombre aleatoire                  */
/***************************************************/
/* r0 plage fin  */
genereraleas:
   push {r1-r4,lr}
   mov r4,r0                // save plage
   ldr r0,iAdriGraine
   ldr r0,[r0]
   ldr r1,iNombre1
   muls r0,r0,r1
   adds r0,#1
   ldr r1,iAdriGraine
   str r0,[r1]
                            // prise en compte nouvelle graine
   ldr r1,m                 // diviseur pour registre de 32 bits
   bl divisionRP2040
   mov r0,r3                // division du reste
   ldr r1,m1                // diviseur  10000
   bl divisionRP2040
   mov r0,r4
   muls r0,r2,r0            // on multiplie le quotient par la plage demandéé
   ldr r1,m1                // puis on divise le resultat diviseur
   bl divisionRP2040        // pour garder les chiffres à gauche significatif.
   mov r0,r2                // retour du quotient
  
100:   
   pop {r1-r4,pc}
.align 2
iAdriGraine:     .int iGraine
iNombre1:        .int 31415821
m1:              .int 10000
m:               .int 100000000     
/******************************************************************/
/*     Conversion d'une chaine en nombre stocké dans un registre  */ 
/******************************************************************/
/* r0 contient l'adresse de la zone terminée par 0 ou 0A */
conversionAtoD:
    push {r1-r7,lr}
    movs r1,#0
    movs r2,#10            // facteur
    movs r3,#0             // compteur
    movs r4,r0             // save de l'adresse dans r4
    movs r6,#0             // signe positif par defaut
    movs r0,#0             // init résultat
1:                         // boucle d'élimination des blancs du debut
    ldrb r5,[r4,r3]        // chargement dans r5 de l'octet situé au debut + la position
    cmp r5,#0              // fin de chaine -> fin routine
    beq 100f
    cmp r5,#0x0A           // fin de chaine -> fin routine
    beq 100f
    cmp r5,#' '            // blanc au début ?
    bne 1f                 // non on continue
    adds r3,r3,#1          // oui on boucle en avvançant d'un octet
    b 1b
1:
    cmp r5,#'-'            // premier caracteres est -
    bne 11f
    movs r6,#1             // caractère suivant
11:
    beq 3f                 // puis on avance à la position suivante
2:                         // debut de boucle de traitement des chiffres
    cmp r5,#'0'            // caractere n'est pas un chiffre
    blt 3f
    cmp r5,#'9'            // caractere n'est pas un chiffre
    bgt 3f
                           // caractère est un chiffre
    subs r5,#48
    ldr r1,iMaxi           // verifier le dépassement du registre
    cmp r0,r1
    bhi 99f
    muls r0,r2,r0          // multiplier résultat précédent par facteur
    adds r0,r5             // ajout au résultat = nouveau résultat
3:
    adds r3,r3,#1          // avance à la position suivante
    ldrb r5,[r4,r3]        // chargement de l'octet
    cmp r5,#0              // fin de chaine -> fin routine
    beq 4f
    cmp r5,#0xA             // fin de chaine -> fin routine
    beq 4f
    b 2b                    // boucler
4:
    cmp r6,#1               // test du registre r6 pour le signe
    bne 100f
    //movs r1,#1
    rsbs r0,r0,#0           // resultat négatif
    //muls r0,r0,r1  /* si negatif, on multiplie par -1 */
    b 100f
99:                        // erreur de dépassement
    ldr r0,iAdrszMessErr
    bl   affString
    movs r0,#0             // en cas d'erreur on retourne toujours zero
100:    
    pop {r1-r7,pc}  
.align 2
iMaxi:           .int 2<<30
iAdrszMessErr:   .int szMessErr
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
iAdrszMessErrBuf:  .int szMessErrBuf
/***************************************************/
/*   division   non signée  RP2040                 */
/***************************************************/
/* r0 dividende    */
/* r1 diviseur     */
/* r2 quotient     */
/* r3 reste        */
divisionRP2040:                           @ INFO: divisionRP2040
    push {lr}
    ldr r2,iAdrSioBase
    str r0,[r2,SIO_DIV_UDIVIDEND_OFFSET]
    str r1,[r2,SIO_DIV_UDIVISOR_OFFSET]
    b 1f                                  @ astuce pour avoir un délai de 8 cycles
1:
    b 1f
1:
    b 1f
1:
    b 1f
1:
    ldr r3,[r2,SIO_DIV_REMAINDER_OFFSET]
    ldr r2,[r2,SIO_DIV_QUOTIENT_OFFSET]
    pop {pc} 
.align 2
iAdrSioBase:     .int SIO_BASE
/******************************************************************/
/*     Conversion base 10               */ 
/******************************************************************/
/* r0 contains value and r1 address area   */
/* r0 return size of result (no zero final in area) */
/* area size => 11 bytes          */
.equ LGZONECAL,   10
conversion10:                // INFO: conversion10
    push {r1-r4,lr}          // save registers 
    movs r3,r1
    movs r2,#LGZONECAL
1:                           // start loop
    bl divisionpar10U        // unsigned  r0 <- dividende. quotient ->r0 reste -> r1
    adds r1,#48              // digit
    strb r1,[r3,r2]          // store digit on area
    cmp r0,#0                // stop if quotient = 0 
    beq 11f
    subs r2,#1               // else previous position
    b 1b                     // and loop
                             // and move digit from left of area
11:
    movs r4,#0
2:
    ldrb r1,[r3,r2]
    strb r1,[r3,r4]
    adds r2,#1
    adds r4,#1
    cmp r2,#LGZONECAL
    ble 2b
                             // and move spaces in end on area
    movs r0,r4               // result length 
    movs r1,#' '             // space
3:
    strb r1,[r3,r4]          // store space in area
    adds r4,#1               // next position
    cmp r4,#LGZONECAL
    ble 3b                   // loop if r4 <= area size
 
100:
    pop {r1-r4,pc}           // restaur registres   
/***************************************************/
/*   division par 10   non signé                    */
/***************************************************/
/* r0 dividende   */
/* r0 quotient    */
/* r1 reste   */
divisionpar10U:                // INFO: divisionpar10U
    push {r2,r3, lr}
    lsrs r1,r0,1
    lsrs r2,r0,2
    adds r1,r2
    lsrs r2,r1,4
    adds r1,r2
    lsrs r2,r1,8
    adds r1,r2
    lsrs r2,r1,16
    adds r1,r2
    lsrs r3,r1,3           // quotient
    movs r2,10
    muls r2,r3,r2
    subs r1,r0,r2          // remainder
    adds r0,r1,6
    lsrs r0,4
    add r0,r3
    cmp r1,10
    blt 1f
    subs r1,10
1:
    pop {r2,r3,pc}
/*************************************/
/* display not formatted String      */
/*************************************/
/* r0 contains message address */
affString:                    // INFO: affString
    push {r1-r5,lr}
    movs r4,r0                // save message address
    movs r5,#0                // init indice
1:
    ldrb r0,[r4,r5]           // load one byte of message
    cmp r0,#0                 // end zéro ?
    beq 2f                    // yes
    ldr r2,iAdrPutchar        // display one character
    blx r2
    adds r5,r5,#1             // increment indice
    b 1b                      // and loop
2:
    pop {r1-r5,pc}
.align 2
iAdrPutchar:       .int putchar
