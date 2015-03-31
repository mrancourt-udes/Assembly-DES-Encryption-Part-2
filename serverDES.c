#include <stdlib.h>              // Fonctions de base
#include <time.h>                // Fonctions sur les horloges
#include <string.h>              // Fonctions sur les chaines de caracteres
#include <stdio.h>               // Functions d'entree/sortie standard

extern void BridgeDES(unsigned int,         // Action
                      char *, unsigned int, // Tampon d'entree et taille du texte
                      char *, unsigned int, // Tampon de sortie et sa taille
                      unsigned int, ...);   // Nombre de cles et les cles

const unsigned int INPUT_BUFFER_SIZE = 640000;  // Taille du tampon d'entree:
                                                // multiple de 8
const unsigned int OUTPUT_BUFFER_SIZE = 640000; // Taille du tampon de sortie:
                                                // multiple de 8

unsigned int main(int argc, char *argv[])

/* Description: Programme d'appel pour le chiffrement d'un texte en clair et
                le dechiffrement d'un cryptogramme.
   Entree:      argv: arguments d'entree
                        i=nom_fichier_entree.pln ou nom_fichier_entree.cry
                        o=nom_fichier_de_sortie,
                        k=cle
                        -c (pour chiffrement) ou -d (pour dechiffrement).
   Sortie:      0 (aucune erreur).
   Auteur:      Richard St-Denis.
   Date:        Mars 2015.
*/

{
 unsigned int nb_arg = argc - 1;   // Nombre d'arguments
 char arg[31];                     // Argument

 unsigned int action = 1;          // Chiffrement par defaut
 char input_file_name[30];         // Nom du fichier d'entree
 char output_file_name[30];        // Nom du fichier de sortie
 char tmp[30];                     // Chaine de travail

 unsigned int nb_keys = 0;         // Nombre de cles
                                   // 16 pour alignement sinon BUS ERRO
                                   // voir le cast dans preparation des cles
 char key1[16];                    // Premiere cle
 char key2[16];                    // Deuxieme cle
 char key3[16];                    // Troisieme cle
 char key4[16];                    // Quatrieme cle


/* -------------------------------------------------------------------------- */

 input_file_name[0] = 0;
 output_file_name[0] = 0;

                                   // Extraction des arguments
 while (nb_arg > 0)
       {
        if (strlen(argv[argc - nb_arg]) > 30)
           {
            printf("*** Argument demesure.\n");   exit(1);
           }
        else
            strcpy(arg, argv[argc - nb_arg]);

        if (strncmp(arg,"i=",2) == 0)
            strcpy(input_file_name, &(arg[2]));
        else if (strncmp(arg,"o=",2) == 0)
                 strcpy(output_file_name, &(arg[2]));
        else if (strncmp(arg,"k=",2) == 0)
                {
                 if (nb_keys == 0)
                     strcpy(key1, &(arg[2]));
                 else if (nb_keys == 1)
                          strcpy(key2, &(arg[2]));
                 else if (nb_keys == 2)
                          strcpy(key3, &(arg[2]));
                 else if (nb_keys == 3)
                          strcpy(key4, &(arg[2]));
                 nb_keys++;
                }
        else if (strcmp(arg,"-c") == 0)
                 action = 1;
        else if (strcmp(arg,"-d") == 0)
                 action = 2;
        else
           {
            printf("*** Argument  non valide.\n");
            exit(1);
           }
        nb_arg--;
       }

/* -------------------------------------------------------------------------- */

                                   // Validation des cles
 if (nb_keys == 0 || nb_keys > 4)
    {
     printf("*** Nombre de cles incorrect.\n");   exit(1);
    }
 if ((nb_keys > 0 && strlen(key1) != 8) ||
     (nb_keys > 1 && strlen(key2) != 8) ||
     (nb_keys > 2 && strlen(key3) != 8) ||
     (nb_keys > 3 && strlen(key4) != 8))
    {
     printf("*** Cle de 8 caracteres requises.\n");   exit(1);
    }
 
                                   // Validation du fichier d'entree
 size_t length = strlen(input_file_name);
 if (length < 5)
    {
     printf("*** Nom de fichier d'entree non valide.\n");   exit(1);
    }
 if (action == 1 && strcmp(&input_file_name[length-4],".pln") != 0)
    {
     printf("*** Un fichier .pln est requis.\n");   exit(1);
    }
 if (action == 2 && strcmp(&input_file_name[length-4],".cry") != 0)
    {
     printf("*** Un fichier .cry est requis.\n");   exit(1);
    }

                                   // Creation du nom du fichier de sortie
 if (strlen(output_file_name) == 0)
    {
     strncpy(output_file_name, input_file_name, length-4);
     output_file_name[length-4] = 0;

     if (action == 1)
         strcat(output_file_name, ".cry");
     else if (action == 2)
              strcat(output_file_name,".pln");
    }

                                   // Ouverture du fichier d'entree
 FILE *in_file;
 if ((in_file = fopen(input_file_name, "r")) == NULL)
    {
     printf("*** Fichier d'entree absent.\n");   exit(1);
    }


/* -------------------------------------------------------------------------- */

                                   // Initialisation du tampon d'entree
 char ibuf[INPUT_BUFFER_SIZE];

 fread(ibuf, 1, 1, in_file);
 if (!feof(in_file))
    {
     for (unsigned int i = 0; i < INPUT_BUFFER_SIZE; i++)
          ibuf[i] = ' ';
                                   // Lecture du fichier
     rewind(in_file);
     fread(ibuf, INPUT_BUFFER_SIZE, 1, in_file);

     if (!feof(in_file))
        {
         printf("*** Fichier trop grand.\n");   exit(1);
        }
    }
 else
    {
     printf("*** Fichier d'entree vide.\n");   exit(1);
    }

/* -------------------------------------------------------------------------- */

 char date_time[32];
 time_t t = time(0);
                                   // Prologue
 strftime(date_time, 31, "%c", localtime(&t));
 printf("%s", date_time);
 if (action == 2)
     printf(" - Dechiffrement ");
 else
     printf(" - Chiffrement ");
 printf("(%s) de %s\n", key1, input_file_name);

 clock_t t1 = clock();

 if (t1 == (clock_t)(-1))
    {
     printf("*** No clock.\n");
     exit(1);
    }

/* -------------------------------------------------------------------------- */

                                   // Completion a un multiple de 8
 unsigned int size_buf = INPUT_BUFFER_SIZE;
 unsigned int real_size;
 while (size_buf > 0 && ibuf[--size_buf] != 0XA) {}

 real_size = (size_buf / 8) * 8;
 if (real_size != size_buf)
    {
     for (unsigned int i = size_buf; i < real_size + 8; i++)
          ibuf[i] = ' ';
     real_size += 8;
    }
                                   // Preparation des cles
 unsigned long long k1, k2, k3, k4;
 k1 = *((unsigned long long *) key1);
 k2 = *((unsigned long long *) key2);
 k3 = *((unsigned long long *) key3);
 k4 = *((unsigned long long *) key4);

 char obuf[INPUT_BUFFER_SIZE+1];

                                   // Traitement
 if (nb_keys == 1)
     BridgeDES(action, ibuf, real_size, obuf, OUTPUT_BUFFER_SIZE, nb_keys, k1);
 else if (nb_keys == 2)
          BridgeDES(action, ibuf, real_size, obuf, OUTPUT_BUFFER_SIZE,
                 nb_keys, k1, k2);
 else if (nb_keys == 3)
          BridgeDES(action, ibuf, real_size, obuf, OUTPUT_BUFFER_SIZE,
                 nb_keys, k1, k2, k3);
 else if (nb_keys == 4)
          BridgeDES(action, ibuf, real_size, obuf, OUTPUT_BUFFER_SIZE,
                 nb_keys, k1, k2, k3, k4);
                                   // Ouverture du fichier de sortie
 FILE *out_file;
 if ((out_file = fopen(output_file_name, "w")) == NULL)
    {
     printf("*** Ouverture du fichier de sortie impossible.\n");   exit(1);
    }

 obuf[real_size] = 0XA;            // Ajout d'un LF
 fwrite(obuf, real_size+1, 1, out_file);

/* -------------------------------------------------------------------------- */

                                   // Epilogue
 clock_t t2 = clock();
 
 if (t2 == (clock_t)(-1))
    {
     printf("*** No clock.\n");
     exit(1);
    }

 printf("%u caracteres ont ete ecrits.\n", real_size);

 t = time(0);
 strftime(date_time, 31, "%c", localtime(&t));
 printf("%s", date_time);
 if (action == 2)
     printf(" - Fin du dechiffrement\n");
 else
     printf(" - Fin du chiffrement\n");

 printf("  Temps de traitement: %u ticks (%u ticks per second)\n",t2-t1, CLOCKS_PER_SEC);

 return 0;

}
