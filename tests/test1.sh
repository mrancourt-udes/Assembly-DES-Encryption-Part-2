echo "->test<-" > 'test1.pln'
y | rm -f test1.cry
echo ""
echo "*********************************"
echo "* Encryption de test1.pln       *"
echo "* K1 => 11111111                *"
echo "*********************************"
../DES -c i=test1.pln k=11111111
#v=testtest
echo "*********************************"
echo "* Contenu du fichier test1.cry  *"
echo "*********************************"
xxd test1.cry
echo ""
echo "*********************************"
echo "* Decryption de cry1.cry         *"
echo "* K1 => 11111111                 *"
echo "*********************************"
../DES -d i=test1.cry k=111111111
echo "*********************************"
echo "* Contenu du fichier test1.pln  *"
echo "*********************************"
xxd test1.pln
echo ""