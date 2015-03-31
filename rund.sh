scriptDES
echo ""
echo "*********************************"
echo "* Decryption de cry1.cry        *"
echo "* K1 => 00000001                *"
echo "*********************************"
DES -d i=cry1.cry k=00000001
echo "*********************************"
echo "* Contenu du fichier cry1.pln *"
echo "*********************************"
xxd cry1.pln
echo ""
