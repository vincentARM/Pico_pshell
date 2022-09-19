# Utilisation de programme assembleur avec le logiciel pshell pour le Raspberry pico.
Lurk101 avec plusieurs autres personnes ont crée un logiciel pour le pico qui facilite son utilisation.  
voir https://github.com/lurk101/pshell
Il est donc possible de lancer quelques commandes de base comme ls, mkdir, cat, vi et même de compiler des programmes en C directement sur le pico
avec cc.

Je me suis demandé s'il était possible de programmer directement en assembleur arm en écrivant un compilateur en langage C. C'est une lourde tâche et j'avais commencé à l'écrire pour découvrir le format des programmes exécutables dans pshell (qui n'est pas le format .uf2) et voir si un petit programme pouvait être crée et éxecuté.
Hélas mon programme C d'assemblage a vite atteint la taille maximun autorisée par le compilateur C.

J'ai donc cherché une autre solution et en examinant comme j'avais crée des programmes assembleur pour le pico, je me suis aperçu qu'il suffisait d'aplliquer la même démarche en remplaçant le script python de conversion du format bin crée par les utilitaires standard as et ld
