cat <<EOF > testL.pln
Bacon ipsum dolor amet picanha sirloin brisket pork loin, kevin drumstick strip 
steak ham hock doner jowl porchetta turkey beef ribs. Pork belly alcatra doner 
tenderloin biltong. 

Meatloaf shank hamburger, fatback ground round beef ribs 
sausage andouille chicken short loin shoulder sirloin pancetta. Shankle meatball 
prosciutto tail, landjaeger shank drumstick tenderloin pancetta sirloin turkey 
pork chop.
EOF
echo "" > testL.cry
echo ""
echo "*********************************"
echo "* Encryption de testL.pln       *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "* K4 => 44444444                *"
echo "*********************************"
../DES -c i=testL.pln k=11111111
#v=testtest
echo "*********************************"
echo "* Contenu du fichier testL.cry  *"
echo "*********************************"
xxd testL.cry
echo ""
echo "*********************************"
echo "* Decryption de testL.cry       *"
echo "* K1 => 11111111                *"
echo "* K2 => 22222222                *"
echo "* K3 => 33333333                *"
echo "* K4 => 44444444                *"
echo "*********************************"
../DES -d i=testL.cry k=11111111
echo "*********************************"
echo "* Contenu du fichier tes4.pln  *"
echo "*********************************"
xxd testL.pln
echo ""