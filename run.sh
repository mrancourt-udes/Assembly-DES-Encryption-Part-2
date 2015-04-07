scriptDES
echo "allo" > 'plain1.pln'
echo ""
echo "*********************************"
echo "* Encryption de plain1.pln      *"
echo "* K1 => 01234567                *"
echo "*********************************"
DES -c i=plain1.pln k=11111111 k=22222222
echo "*********************************"
echo "* Contenu du fichier plain1.cry *"
echo "*********************************"
xxd plain1.cry
echo ""
echo "*********************************"
echo "* Decryption de cry1.cry        *"
echo "* K1 => 01234567                *"
echo "*********************************"
DES -d i=plain1.cry k=11111111 k=22222222
echo "*********************************"
echo "* Contenu du fichier plain1.pln *"
echo "*********************************"
xxd plain1.pln
echo ""