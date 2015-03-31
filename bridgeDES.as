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
        .section ".text"

BridgeDES:

        save    %sp,-208,%sp

        /********************
        * BEGIN DEBUG SECTION
        ********************/
        setx    debug,%l7,%o0
        mov     %i0,%o1
        mov     %i2,%o2
        mov     %i4,%o3
        mov     %i5,%o4
        call    printf
        nop
        setx    dbgBuf,%l7,%o0
        mov     %i1,%o2
        srlx    %o2,32,%o1
        mov     %i3,%o4
        srlx    %o3,32,%o3
        call    printf
        nop
        mov     1,%l4               ! cle 1 temporaire
        /********************
        * END  DEBUG  SECTION
        ********************/

        mov    %i1,%l1              ! recuperation de l''adresse du tamon d''entree
        mov    %i3,%l3              ! recuperation de l''adresse du tamon de sortie

        cmp     %i0,1               ! Operation : chiffrement
        be      bri10
        nop

        cmp     %i0,2               ! Operation : dechiffrement
        be      bri20
        nop

bri10:  /*** SECTION DES ***/

        setx    ptfmT1,%l7,%o0
        call    printf
        nop

        ldx     [%l1],%l5           ! lecture de 64 bits du tampon dentree
        inc     8,%l1               ! mise a jour de la position dans le buffer d entree

        mov     %l2,%o0             ! la chaine de 64 bits
        mov     %l4,%o1             ! la cle de 64 bits

        call    DES                 ! encryption de la chaine de 64 bits
        nop

        stx     %o0,[%l3]           ! ecriture de 64 bits encodes dans le buffer de sortie
        inc     8,%l3               ! mise a jour de la position dans le buffer de sortie

        ba      bri30               ! branchement vers la sortie
        nop

bri20:  /*** SECTION DESINV ***/

        setx    ptfmT2,%l7,%o0
        call    printf
        nop

        mov     %l4,%o1             ! la cle de 64 bits

        call    DESinv              ! decription
        nop

bri30:  /*** FIN DU TRAITEMENT ***/
        ret
        restore

        .section ".rodata"          ! section de donnees en lecture seulement

debug:  .asciz "\n********************\n*      DEBUG       *\n********************\n* Type..............%d\n* Taille texte......%d\n* Taille buffer.....%d\n* Nb cles...........%d\n"
dbgBuf: .asciz "* Buffer in.........%08x%08x\n* Buffer out........%08x%08x\n\n"

ptfmdT: .asciz "Texte : %d\n"
ptfmdK: .asciz "  Cle : %d\n"
ptfmxx: .asciz "%08x%08x\n"
ptfmtd: .asciz "%d\n"

ptfmT1: .asciz "Chiffrement\n"
ptfmT2: .asciz "Dechiffrement\n"