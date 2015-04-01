scriptDES
echo ""
echo "*********************************"
echo "* Decryption de cry1.cry        *"
echo "* K1 => 01234567                *"
echo "*********************************"
DES -d i=plain1.cry k=01234567
echo "*********************************"
echo "* Contenu du fichier plain1.pln *"
echo "*********************************"
xxd plain1.pln
echo ""
