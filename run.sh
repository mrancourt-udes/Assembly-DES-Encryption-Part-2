scriptDES
echo ""
echo "*********************************"
echo "* Encryption de plain1.pln      *"
echo "* K1 => 00000001                *"
echo "*********************************"
DES -c i=plain1.pln k=00000001
echo "*********************************"
echo "* Contenu du fichier plain1.cry *"
echo "*********************************"
xxd plain1.cry
echo ""
