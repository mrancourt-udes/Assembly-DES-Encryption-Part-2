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
        /********************
        * END  DEBUG  SECTION
        ********************/

        mov     1,%o6					! indice de cle
        mov     1,%l4
        mov     %i1,%l1                 ! recuperation de l''adresse du tamon d''entree
        mov     %i3,%l3                 ! recuperation de l''adresse du tamon de sortie

bri01:  /* CLE 1 */
        ldx    [%fp+2047],%L4           ! chargement de la cle 1
        ba bri05
        nop

bti02:  /* CLE 1 */
        ldx    [%fp+2047+24],%L4        ! chargement de la cle 2
        ba bri05
        nop

bri03:  /* CLE 3 */                    
        ldx    [%fp+2047+32],%L4        ! chargement de la cle 3
        ba bri05
        nop

bri04:  /* CLE 4 */                     
        ldx    [%fp+2047+40],%L4        ! chargement de la cle 4   

bri05:  udivx  	%i2,8,%l6
        clr    	%l2

bri10:

        ldx     [%l1+%l2],%l5       	! lecture de 64 bits du tampon dentree
        inc     8,%l1               	! mise a jour de la position dans le buffer d entree

        mov     %l5,%o0             	! la chaine de 64 bits
        mov     %l4,%o1             	! la cle de 64 bits

        cmp     %i0,1               	! Operation : chiffrement
        be      bri15
        nop

        cmp     %i0,2               	! Operation : dechiffrement
        be      bri20
        nop

bri15:  /*** SECTION DES ***/
        call    DES                 	! encryption de la chaine de 64 bits
        nop

        call    bri30
        nop

bri20:  /*** SECTION DESINV ***/
        call    DESinv              	! encryption de la chaine de 64 bits
        nop

bri30:
        stx     %o0,[%l3]           	! ecriture de 64 bits encodes dans le buffer de sortie
        inc     8,%l3               	! mise a jour de la position dans le buffer de sortie
        inc     %l2

        cmp     %l2,%l6
        bl      bri10
        nop

        cmp     %i5,%o6
        bne     bri05
        inc     %o6


bri40:  /*** FIN DU TRAITEMENT ***/
        ret
        restore

        .section ".rodata"          	! section de donnees en lecture seulement
k1:     .xword 12345678
k2:     .xword 87654321
debug:  .asciz "\n********************\n*      DEBUG       *\n********************\n* Type..............%d\n* Taille texte......%d\n* Taille buffer.....%d\n* Nb cles...........%d\n"
dbgBuf: .asciz "* Buffer in.........%08x%08x\n* Buffer out........%08x%08x\n\n"

ptfmdT: .asciz "Texte : %d\n"
ptfmdK: .asciz "  Cle : %d\n"
ptfmxx: .asciz "%08x%08x\n"
ptfmtd: .asciz "%d\n"

ptfmT1: .asciz "Chiffrement\n"
ptfmT2: .asciz "Dechiffrement\n"