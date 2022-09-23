hello.s   : programme standard hello world

cliLed.s  : blink the led (full assembly)

pgmMini.s : assembly program minimum (no c function call)

lectecr.s : file io  write a file and read the same file 

   résult :
```
Debut du programme.
Valeur du registre = 20008bb8
Ecriture fichier OK
Contenu du buffer : ABCDEFGHIJK
Fin Ok du programme.

CC = 0
```

readString.s   read a string to keyboard ans display the string with putchar
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

lightLed.s  :  touch pin 16 with finger and the led flashes 3 times (type q for stop program)

**testmalloc.c** : example macros to display a text.  Test the function C malloc.

