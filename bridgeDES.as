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
*/
        PARAM = 176

        .section ".text"

BridgeDES:

        save    %sp,-208,%sp

        mov     1,%o6                       ! indice de cle
        mov     1,%l2                       ! compteur
        udivx   %i2,8,%l6

bri00:  

        mov     %i1,%l1                     ! recuperation de l''adresse du tampon d''entree
        mov     %i3,%l3                     ! recuperation de l''adresse du tampon de sortie

        ldx    [%fp+2047+PARAM],%o1          ! chargement de la cle 1
        inc     8,%fp


bri10:

        ldx     [%l1],%l5               ! lecture de 64 bits du tampon dentree

        mov     %l5,%o0                 ! la chaine de 64 bits

        cmp     %i0,1                   ! Operation : chiffrement
        be      bri15
        nop

        cmp     %i0,2                   ! Operation : dechiffrement
        be      bri20
        nop

bri15:  /*** SECTION DES ***/
        call    DES                     ! encryption de la chaine de 64 bits
        nop

        ba    bri30
        nop

bri20:  /*** SECTION DESINV ***/
        call    DESinv                  ! encryption de la chaine de 64 bits
        nop

bri30:
        cmp     %i5,%o6
        bne     bri32
        nop
bri31:                                  ! ecriture dans le tampon sortie
        stx     %o0,[%l3]               ! ecriture de 64 bits encodes dans le buffer de sortie
        ba      bri33
        inc     8,%l3                   ! mise a jour de la position dans le buffer de sortie

bri32:                                  ! ecriture dans le tampon de entree
        stx     %o0,[%l1]               ! ecriture de 64 bits encodes dans le buffer d entree

bri33: 
        inc     8,%l1                   ! mise a jour de la position dans le buffer d entree

        cmp     %l2,%l6
        bl      bri10
        inc     %l2

        cmp     %i5,%o6
        bg      bri00
        inc     %o6

 
bri40:  /*** FIN DU TRAITEMENT ***/
        ret
        restore

        .section ".rodata"              ! section de donnees en lecture seulement
debug:  .asciz "\n********************\n*      DEBUG       *\n********************\n* Type..............%d\n* Taille texte......%d\n* Taille buffer.....%d\n* Nb cles...........%d\n"
dbgBuf: .asciz "* Buffer in.........%08x%08x\n* Buffer out........%08x%08x\n\n"

ptfmdT: .asciz "Texte : %d\n"
ptfmdK: .asciz "  Cle : %d\n"
ptfmxx: .asciz "%08x%08x\n"
ptfmtd: .asciz "%a\n"

ptfmT1: .asciz "Chiffrement\n"
ptfmT2: .asciz "Dechiffrement\n"
ptfmtst: .asciz "#########################\n#####################"