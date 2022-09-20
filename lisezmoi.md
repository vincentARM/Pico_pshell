## Utilisation de programme assembleur avec le logiciel pshell pour le Raspberry Pico.

Lurk101 avec plusieurs autres personnes ont crée un logiciel pour le pico qui facilite son utilisation.  

voir https://github.com/lurk101/pshell

et le fil de discussion sous : 

https://forums.raspberrypi.com/viewtopic.php?t=336843

Il est donc possible de lancer quelques commandes de base comme ls, mkdir, cat, vi, etc et même de compiler des programmes en C directement sur le pico
avec cc.

Je me suis demandé s'il était possible de programmer directement en assembleur arm en écrivant un compilateur en langage C. C'est une lourde tâche et j'avais commencé à l'écrire pour découvrir le format des programmes exécutables dans pshell (qui n'est pas le format .uf2) et voir si un petit programme pouvait être crée et éxecuté.

Hélas mon programme C d'assemblage a vite atteint la taille maximun autorisée par le compilateur Cde pshell.

J'ai donc cherché une autre solution et en examinant comment j'avais crée des programmes assembleur pour le pico, je me suis aperçu qu'il suffisait d'appliquer la même démarche en remplaçant le script python de conversion du format bin crée par les utilitaires standard as et ld, dans le format uf2.

J'ai donc écrit un programme en C qui exploite les données des fichiers .bin et map crée par as et ld sur un ordinateur windows ou linux pour créer un exécutable au format souhaité.

Les utilitaires as et ld sont les utilitaires standards fournis lors de l'installation du sdk pour le developpement de programmes C++  pour le pico.

Le fichier des directives pour ld (memmap.ld) est modifié pour être adapté aux adresses du code et des données gérées par pshell. Il doit être possible de le simplifier encore plus !!!

Le programme que j'ai developpé (asmpshell.c) crée une entète contenant l'adresse de début d'exécution (main), la taille du code (.text) et la taille des données (.data). La zone relocation sera à 0 en l'absence d'information concernant le mécanisme de relocation géré par pshell.

Le programme recopie le code et les données tels que trouvés dans le .bin et insére 4 zéros binaires finaux.

L'exécutable ainsi crée doit être transféré sur le pico par la commande xput nomexecpico. Cette conmmande utilise le protocole xmodem et donc pour windows il faut installer un logiciel compatible comme puttyextra.

Pour unix, le logiciel minicom fonctionne très bien.

Un premier problème surgit car le fichier ainsi transféré n'est pas reconnu par pshell comme une commande exécutable.

Mais il suffit de compiler avec cc un simple programme C comme hello.c pour creer un exécutable et c'est ce nom qu'il faudra indiquer au programme de transert.

Par exemple : 
cc -o nomexecpico hello.c

### Ecriture d'un programme assembleur pour pshell.

L'utilisation de l'utilitaire as permet de reprendre toutes les fonctionnalités pour l'écriture : syntaxe, include,  macros.

pshell ne gére pas la section bss donc les programmes devront initialisés les données si necessaire.

En assembleur sur le pico, il n'y a pas d'appel au système d'exploitation et donc il faut utiliser les fonctions C de la libraire utilisée par pshell.
Pshell étant un système très simple, il ne fournit pas de mécanisme pour appeler ces fonctions. Il est donc necessaire de connaitre les adresses de chaque fonction, adresses qui peuvent varier en fonction de la version de pshell.

C'est pourquoi ces adresses sont décrites dans le  fichier functionsC.inc à inclure dans chaque source assembleur.
Attention le fichier dans les exemples concerne la version de pshell    et il est à compléter pour les autres fonctions C non référencées.

Il sera à modifier pour chaque nouvelle version de pshell à moins que je trouve l'explication de la relocation (et bien sûr les programmes assembleurs sont à recompiler à chaque nouvelle version de pshell.

Voici un exemple type d'appel de la fonction printf 
```asm
     ldr r0,iAdrszMessage // message address
     push {r0}            // function parameter
     mov r0,#1            // one parameter
     ldr r6,iAdrPrintf    // address function C printf
     blx r6               // call function
     add sp,#4            // stack alignement for one push 
     
iAdrPrintf:       .int printf  
```

Voir les autres exemples de programmes.



