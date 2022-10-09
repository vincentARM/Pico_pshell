**hello.s**   : programme standard hello world

**cliLed.s**  : blink the led (full assembly)

**pgmMini.s** : assembly program minimum (no c function call)

**lectecr.s** : file io  write a file and read the same file 

   résult :
```
Debut du programme.
Valeur du registre = 20008bb8
Ecriture fichier OK
Contenu du buffer : ABCDEFGHIJK
Fin Ok du programme.

CC = 0
```

**readString.s**   read a string to keyboard ans display the string with putchar
  résult :
```
Debut du programme.
Saisir une chaine de caractères (fin pour finir) :
abcdefghij
abcdefghij
Saisir une chaine de caractères (fin pour finir) :
123456
123456
Saisir une chaine de caractères (fin pour finir) :
fin
fin
Fin Ok du programme.

CC = 0

```

**lightLed.s**  :  touch pin 16 with finger and the led flashes 3 times (type q for stop program)

**testmalloc.c** : example macros to display a text.  Test the function C malloc.

Result :
```
Debut du programme.
Utilisation fonction malloc
Valeur du registre = 20008bd0
Fin Ok du programme.

CC = 0

```
**countercycle.s**  : instructions cycles counter

Résult :

```
Debut du programme.
controle
Comptage cycles à vide (13 cycles)
Nombre de cycles = 13
Comptage 1 instruction (14 cycles)
Nombre de cycles = 14
Comptage affichage libellé
Pour test
Nombre de cycles = 16490
Comptage un putchar
ANombre de cycles = 1223
Fin Ok du programme.

CC = 0

```

**variaLed.s**  :   LED brightness dimming

**aceyducey.s** :   cards game 

**paramPshell.s** : display parameters command line


résult :

```
/asm/: exec1 john pierre

Programm start.

 Hello  john
 
 Hello  pierre
 
End programm

CC = 0

```

**affRegBin.s** display RP2040 memory register

Résult :
```
Program start.
affichage registre mémoire

Enter the address of a register (fin for end) :
40064000
Register display : 0x000010B1 0b00000000 00000000 00010000 10110001

Enter the address of a register (fin for end) :
fin
Program end OK.

CC = 0

```


