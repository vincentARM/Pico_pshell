# Pico_pshell
assembly program for pshell pico

Créer sur windows ou Linux, un répertoire de travail.
Copier les fichiers Makefile, memmap.ld, functionsC.inc et votre programme source assembleur.

Dans le fichier Makefile, modifier le chemin de votre environnement de compilation assembleur pico
et modifier le chemin de l'exécutable asmpshell.
lancer le script par
make PGM=nomdusource  (sans le .s).

Corriger les erreurs éventuelles ou transferrer l'exécutable sur le pico en utilisant xput nomexecpico.

nomexecpico doit correspondre à un nom de programme exécutable déjà crée sur le pico. Cet exécutable peut être crée en compilant un simple programme en C avec le compilateur cc.
