echo "->test<-" > 'test4.pln'
y | rm -f test4.cry
echo ""
echo "*********************************"
echo "* Encryption de test4.pln       *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "* K4 => 44444444                *"
echo "*********************************"
../DES -c i=test4.pln k=11111111 k=22222222 k=33333333 k=44444444
#v=testtest
echo "*********************************"
echo "* Contenu du fichier test4.cry  *"
echo "*********************************"
xxd test4.cry
echo ""
echo "*********************************"
echo "* Decryption de cry4.cry        *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "* K4 => 44444444                *"
echo "*********************************"
../DES -d i=test3.cry k=111111111 k=22222222 k=33333333 k=4444444
echo "*********************************"
echo "* Contenu du fichier tes4.pln  *"
echo "*********************************"
xxd test4.pln
echo ""