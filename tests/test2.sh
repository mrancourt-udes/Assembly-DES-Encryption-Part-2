echo "->test<-" > 'test1.pln'
y | rm -f test2.cry
echo ""
echo "*********************************"
echo "* Encryption de test1.pln       *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "*********************************"
../DES -c i=test2.pln k=11111111 k=22222222
#v=testtest
echo "*********************************"
echo "* Contenu du fichier test2.cry  *"
echo "*********************************"
xxd test2.cry
echo ""
echo "*********************************"
echo "* Decryption de cry2.cry        *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "*********************************"
../DES -d i=test2.cry k=111111111 k=22222222
echo "*********************************"
echo "* Contenu du fichier test2.pln  *"
echo "*********************************"
xxd test2.pln
echo ""