# Utilisation de programme assembleur avec le logiciel pshell pour le Raspberry pico.
Lurk101 avec plusieurs autres personnes ont crée un logiciel pour le pico qui facilite son utilisation.  
voir https://github.com/lurk101/pshell
Il est donc possible de lancer quelques commandes de base comme ls, mkdir, cat, vi et même de compiler des programmes en C directement sur le pico
avec cc.

Je me suis demandé s'il était possible de programmer directement en assembleur arm en écrivant un compilateur en langage C. C'est une lourde tâche et j'avais commencé à l'écrire pour découvrir le format des programmes exécutables dans pshell (qui n'est pas le format .uf2) et voir si un petit programme pouvait être crée et éxecuté.
Hélas mon programme C d'assemblage a vite atteint la taille maximun autorisée par le compilateur C.

J'ai donc cherché une autre solution et en examinant comme j'avais crée des programmes assembleur pour le pico, je me suis aperçu qu'il suffisait d'appliquer la même démarche en remplaçant le script python de conversion du format bin crée par les utilitaires standard as et ld dans le format uf2.

J'ai donc écrit un programme en C qui exploite les données des fichiers .bin et map crée par as et ld sur un ordinateur windows et linux pour créer un exécutable au format souhaité.

Le programme crée une entète contenant l'adresse du main, la taille du code (.text) et la taille des données (.data). La zone relocation sera à 0 en l'anbsence d'information concernant le mécanisme de relocation géré par pshell.
Le programme recopie le code et les données tels que trouvés da,s le .bin et insere 4 zéros binaires finaux.

L'éxécutable ainsi crée doit être transféré sur le pico par la commande xput nonexecpico. Cette conmmande utilise le protocole xmodem et donc pour windows il faut installer un logiciel compatible comme extraputty.
Pour unix, le logiciel minicom fonctionne très bien.

Un premier problème surgit car le fichier ainsi transféré n'est pas reconnu par pshell comme une commande exécutable.
Mais il suffit de compiler avec cc un simple programme C comme hello.c pour creer un exécutable et c'est ce nom qu'il faudra indiquer au programme de transert.
Par exemple : 


