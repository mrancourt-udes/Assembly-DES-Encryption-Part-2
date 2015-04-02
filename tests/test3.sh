echo "->test<-" > 'test3.pln'
y | rm -f test3.cry
echo ""
echo "*********************************"
echo "* Encryption de test3.pln       *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "*********************************"
../DES -c i=test3.pln k=11111111 k=22222222 k=33333333
#v=testtest
echo "*********************************"
echo "* Contenu du fichier test3.cry  *"
echo "*********************************"
xxd test3.cry
echo ""
echo "*********************************"
echo "* Decryption de cry3.cry        *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "*********************************"
../DES -d i=test3.cry k=111111111 k=22222222 k=33333333
echo "*********************************"
echo "* Contenu du fichier test2.pln  *"
echo "*********************************"
xxd test3.pln
echo ""