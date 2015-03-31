        .global BridgeDES
/*  BridgeDES : sous-programme d'encodage (Data Encryption Standard).
    entree 	  : 1 (chiffrement) 2 (dechiffrement)
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
        
        setx    debug,%l7,%o0  
        mov     %i0,%o1
        mov     %i2,%o2
        mov     %i4,%o3
        mov     %i5,%o4
        call    printf            
        nop

        setx    debugBuff,%l7,%o0  
        mov     %i1,%o2             
        srlx    %o2,32,%o1      
        call    printf            
        nop

        ret
        restore

        .section ".rodata"          ! section de donnees en lecture seulement

debug: .asciz "\n********************\nDEBUG\n********************\n Type..............%d\n Taille texte......%d\n Taille buffer.....%d\n Nb cles...........%d\n"
debugBuff: .asciz " Buffer in.........08x%08x\n Buffer out........08x%08x\n\n"

ptfmtd: .asciz "%d\n"
ptfmtxx:.asciz "%08x%08x\n"