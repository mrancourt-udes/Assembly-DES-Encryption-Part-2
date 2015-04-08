#!/bin/bash -e
scriptDES
echo "12345678910" > 'plain1.pln'
echo ""
echo "==========================================================================="
echo ""
echo ""
echo "CONTENU INITIAL : "
head plain1.pln
echo ""
DES -c i=plain1.pln k=22222222 k=33333333
echo "" > 'plain1.pln'
echo ""
echo "CONTENU ENCRYPTE : "
head plain1.cry
echo ""
echo ""
DES -d i=plain1.cry k=33333333 k=22222222
echo ""
echo "CONTENU DECRYPTE :"
head plain1.pln
echo ""
echo ""