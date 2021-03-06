        .global BridgeDES
/*  BridgeDES : sous-programme d'encodage (Data Encryption Standard).
    entree    : 1 (chiffrement) 2 (dechiffrement)
                L'dresse du tampon d'entree
                Taille du texte
                Adresse du tampon de sortie
                Taille du tampon de sortie
                Nombre de cles (1 a 4)
                Cles (Une a quatre de type)
    sortie : Aucune.
    auteur : Vincent Ribou et Martin Rancourt Universite de Sherbrooke, 2015.
    Technique de recuperation des parametres : 
        Utilisation de la pile à l'aide du registre %fp
    Technique d'encription : 
        Chaque blocs de 8 octets sont encryptes un apres l'autre avec les x cles
*/
        PARAM = 176

        .section ".text"

BridgeDES:

        save    %sp,-208,%sp

        mov     0,%l0                   ! position dens les tampons
        mov     %fp,%l2                 ! adresse de fp

bri00:
        mov     1,%l1                   ! indice de la cle
        mov     %l2,%l3                 ! adresse de la cle

bri05:                                  ! Boucle sur les cles

        ldx     [%l3+2047+PARAM],%o1    ! chargement de la cle
        inc     8,%l3                   ! adresse de la cle

        ldx     [%i1+%l0],%o0           ! la chaine de 64 bits

        cmp     %i0,2                   ! Operation : chiffrement
        be      bri20
        nop

bri15:                                  ! section DES
        call    DES                     ! encryption de la chaine de 64 bits
        nop

        ba bri30                        ! bypass de la decription
        nop

bri20:                                  ! section DESINV
        call    DESinv                  ! decryption de la chaine de 64 bits
        nop

bri30:

        stx     %o0,[%i1+%l0]           ! ecriture dans le tampon sortie
        cmp     %l1,%i5                 ! branchement selon lindice de la cle
        bl      bri05
        inc     1,%l1                   ! index de la cle

        stx     %o0,[%i3+%l0]           ! ecriture dans le tampon sortie
        inc     8,%l0                   ! mise a jour de la position dans les tampons

        cmp     %l0,%i2
        bl      bri00                   ! traitement du prochain octet
        nop

bri40:                                  ! fin du traitement
        ret
        restore