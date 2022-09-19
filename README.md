# Pico_pshell
assembly program for pshell pico.
## English:

Create on windows or Linux, a working directory.

Copy the Makefile, memmap.ld, functionsC.inc files and your assembler source program.

In the Makefile file, modify the path of your pico assembler compilation environment and modify the path of the asmpshell executable.

Run the script with make PGM=nomdusource (without the .s).

Correct any errors or transfer the executable to the pico using xput nomexecpico.

picoexecname must match an executable program name already created on the pico. This executable can be created by compiling a simple C program with the cc compiler.

## Français :

Créer sur windows ou Linux, un répertoire de travail.
Copier les fichiers Makefile, memmap.ld, functionsC.inc et votre programme source assembleur.

Dans le fichier Makefile, modifier le chemin de votre environnement de compilation assembleur pico
et modifier le chemin de l'exécutable asmpshell.

lancer le script par :
make PGM=nomdusource  (sans le .s).

Corriger les erreurs éventuelles ou transferrer l'exécutable sur le pico en utilisant xput nomexecpico.

nomexecpico doit correspondre à un nom de programme exécutable déjà crée sur le pico. Cet exécutable peut être crée en compilant un simple programme en C avec le compilateur cc.
