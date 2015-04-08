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

bri00:
        /* BOUCLER SUR LES 4 CLES */
        ldx    [%fp+2047+PARAM],%o1     ! chargement de la cle 1

        ldx     [%i1],%o0               ! la chaine de 64 bits

        cmp     %i0,2                   ! Operation : chiffrement
        be      bri20
        nop

bri15:  /*** SECTION DES ***/
        call    DES                     ! encryption de la chaine de 64 bits
        nop

        ba bri30
        nop

bri20:  /*** SECTION DESINV ***/
        call    DESinv                  ! decryption de la chaine de 64 bits
        nop

bri30:                                  ! ecriture dans le tampon sortie
        stx     %o0,[%i3]               

fin:  /*** FIN DU TRAITEMENT ***/
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
ptfmtst: .asciz "|=|=|=|=|=|=|=|=|=|"