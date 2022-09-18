/* génération fichier asm pour pshell*/
/* lancement par asmpschell <nom bin> -m <nom map> -e <nom executable> */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <sys\stat.h>
//#define ADRCODE  0x20038000
#define TAILLEBUF 2000
int debMain=0;
int taillecode=0;
int tailledatas=0;
int tailletotale=0;
int etatligne,debligne,finligne;
int tabZones[20];
int nbzone=0;

/* calcul valeur  div = 10 ou 16 */
int calculImm(char * imm,int div){
   //printf("Valeur imm=%s",imm);
    char a=*imm;
    int b=0,c=0;
    while (a!=0) {
        b=b*div;
        if (a<58) c=a-48;
        if (a>64) c=a-55;
        if (a>96) c=a-87;  // a b cd e minuscule
        b=b+c;
        imm++;
        a=*imm;
    }
    return  b;
}
/* découpe une ligne en zones (dans tabZones[]) */
int decoupeLigne(char * buf,int debligne) {  // INFO: decoupeLigne
    int nbzone=0,prem=0,deb=0;
    int i=debligne;
    char a;
    while (buf[i]==' ' && i<=finligne) i++;
    char * debzone=buf+i;
    if (i<=finligne) {
    while (i<=finligne) {
        a=buf[i];
         if (a==' ') {
            if (prem==0) {     // 1er espace
            buf[i]=0;
            tabZones[nbzone++]=(int)debzone;
            prem=1;
            }
            deb=0;
        }
            else {
                if (prem==1) {
                    prem=0;
                }
                if (deb==0) {
                    debzone=buf+i;
                    //printf ("debzone= %p\n",debzone);
                    deb=1;
                }
                    
            }
        i++;
    }
    buf[i]=0;
    tabZones[nbzone++]=(int)debzone;
    }
    return nbzone;
}
int debligne,finligne;
int analyseMap(char * buf,int taille) {
      int pos=0,fin=0,textprem=0,dataprem=0;
      char* debVal;
      while (pos>=0) {
          int i=pos;
          fin=0;
          debligne=pos;
          while (fin==0&&i<=taille) {
             char c=buf[i];
             //printf("Char=%d\n",c);
             if (c==10) {
                 finligne=i-1;
                 if (finligne<=debligne) 
                 {finligne=debligne;etatligne=0;}
                 else etatligne=1;
                 fin=1;
             }
               i++;
          }
          pos=i;
          if (pos>taille) pos=-1;
          //printf("deb=%d fin=%d \n",debligne,finligne);
          if (etatligne!=0) {
             int nb=decoupeLigne(buf, debligne);
          
            //printf ("nb zone=%d zone 1=%s\n",nb,(char *) tabZones[0]);
             if (strcmp((char *)tabZones[0],".text")==0&&textprem==0) {
                if (nb<3) {
                  printf("Erreur analyse .text \n");
                  return -1;
                }
              debVal=(char *)tabZones[2];
              debVal=debVal+2;
              taillecode=calculImm(debVal,16);
             // printf("Val=%d\n",taillecode);
              textprem=1;
          }
          if (nb>1) {
             if (strcmp((char *)tabZones[1],"main")==0) {  
                   debVal=(char *)tabZones[0];
                   debVal=debVal+2;
                   debMain=calculImm(debVal,16);
                   //printf("Val main=%d\n",debMain);
                }
              if (strcmp((char *)tabZones[0],".data")==0&&dataprem==0) {
              if (nb<3) {
                  printf("Erreur analyse .data \n");
                  return -1;
              }
              debVal=(char *)tabZones[2];
              debVal=debVal+2;
              tailledatas=calculImm(debVal,16);
              dataprem=1;
              //printf("Val datas=%d\n",tailledatas);
          }
          }
      }
      }
    
    return 0;
}

int main(int ac, char* av[]) {
    char buf[TAILLEBUF];
    char bufcode[TAILLEBUF];
    char bufecr[TAILLEBUF];
    int exec=0;
    int relocation=0;
    char* nomFic;           // nom du fichier .bin
    char* nomFicM;          // nom du fichier map
    char* nomExec;          // nom executable
    if (ac < 4) {
        printf("Nom fichier absent ligne commande\n");
        printf("lancement par asmpschell <nom bin> -m <nom map> -e <nom executable>\n");
        return -1;
    }
       printf("Nom fichier = %s\n",av[1]);
       nomFic = (char*)strdup(av[1]);
     
        char* option = (char*)strdup(av[2]);
  
        if (strcmp(option, "-m") != 0) {
            printf("1ére option inconnue %s\n", option);
            return -1;
            }
      nomFicM = (char*)strdup(av[3]);
      if (ac >4) {
        option = (char*)strdup(av[4]);
        int i = strcmp(option, "-e");
        if (i != 0) {
            printf("2ième option inconnue %s\n", option);
            return -1;
            }
        nomExec = (char*)strdup(av[5]);
        exec=1;
      }
    printf("Nom fichier MAP = %s\n",nomFicM);
    
    int fic = open(nomFicM, O_RDONLY);
    if (fic < 0) {
        printf("Erreur ouverture fichier MAP\n");
        goto exit;
    }
    printf("fichier MAP ouvert\n");
    
    int taille;
    taille=read(fic, buf, TAILLEBUF);
    if (taille < 0) {
        printf("Erreur lecture fichier MAP.\n");
        goto exit_close;
    }
    buf[taille]=0;
    int ret=analyseMap(buf,taille);
    close(fic);

    fic = open(nomFic, O_RDONLY|O_BINARY);
    if (fic < 0) {
        printf("Erreur ouverture fichier BIN: %d\n",fic);
        goto exit;
    }
    printf("fichier source BIN ouvert\n");
    
    int tailleBin=read(fic, buf, TAILLEBUF);
    if (tailleBin < 0) {
        printf("Erreur lecture fichier BIN.\n");
        goto exit_close;
    }
    buf[tailleBin]=0;

    printf ("main=%x taillecode=%d tailledatas=%d taillebin=%d \n",debMain,taillecode,tailledatas,tailleBin);
    memcpy(bufecr,&debMain,4);
    memcpy(bufecr+4,&taillecode,4);
    memcpy(bufecr+8,&tailledatas,4);
    memcpy(bufecr+12,&relocation,4);
    taille=16+tailleBin;
    memcpy(bufecr+16,buf,tailleBin);
    int reste=taille%4;
    int i;
    if (reste!=0) {
        for (i=0;i<(4-reste);i++) {  // Alignement mot
          bufecr[taille++]=0;
        }
    }
    bufecr[taille]=0;
    bufecr[taille+1]=0;
    bufecr[taille+2]=0;
    bufecr[taille+3]=0;
    taille=taille+4;
    if (exec==0) {
        printf("Pas de nom de l'exécutable : pas de création !!\n");
        goto fin;
    }
    int ficecr = open(nomExec, O_WRONLY| O_TRUNC|O_CREAT|O_BINARY,S_IWRITE);
    if (ficecr < 0) {
        printf("Erreur création fichier \n");
        goto exit;
    }
    printf("fichier destination ouvert\n");
    
    int nbecr=write(ficecr,bufecr,taille);
    if (nbecr != taille) {
        printf("erreur ecriture %d\n",nbecr);
    }
    
     printf("Taille finale: %d\n",taille);
     if (ficecr)
        close(ficecr);
fin:
    printf ("Fin programme OK."); 
exit_close:
    if (fic)
        close(fic);

exit:;
    return 0;
}