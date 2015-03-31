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

bri10:  /*** SECTION DES ***/

        ldx     [%l1],%l5           ! lecture de 64 bits du tampon dentree
        inc     8,%l1               ! mise a jour de la position dans le buffer d entree

        mov     %l2,%o0             ! la chaine de 64 bits
        mov     %l4,%o1             ! la cle de 64 bits

        cmp     %i0,1               ! Operation : chiffrement
        be      bri15
        nop

        cmp     %i0,2               ! Operation : dechiffrement
        be      bri20
        nop

bri15:  call    DES                 ! encryption de la chaine de 64 bits
        nop

        setx    ptfmT1,%l7,%o0
        call    printf
        nop

        call    bri30
        nop

bri20:  call    DESinv              ! encryption de la chaine de 64 bits
        nop

        setx    ptfmT2,%l7,%o0
        call    printf
        nop
        
bri30:
        stx     %o0,[%l3]           ! ecriture de 64 bits encodes dans le buffer de sortie
        inc     8,%l3               ! mise a jour de la position dans le buffer de sortie

        ba      bri40               ! branchement vers la sortie
        nop

bri40:  /*** FIN DU TRAITEMENT ***/
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