#!/bin/bash

# arg 1  =  fájl
# arg 2  = titkosítási kulcs
# arg 3  = crypt vagy decrypt c/d

fajltartalom=""
kulcs=""
fajlnev=""
c="false"
d="false"
valasztott="false"

while getopts "cdf:k:" option; do
	case $option in
		c)
			c="true"
			valasztott="true";;
		d)
			d="true"
			valasztott="true";;
		f)
			fajltartalom=`cat ${OPTARG}`
			fajlnev="${OPTARG}";;
		k)
			kulcs="${OPTARG}";;

	esac
done

if [ "$fajlnev" != "" ] && [ "$kulcs" != "" ] && [ "$valasztott" = 'true' ]
then

echo "A titkositas elotti fajl tartalma:\n"
echo "$fajltartalom\n"
echo "Titkositasi kulcs: $kulcs"

abc="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
kulcshossz=${#kulcs}

echo "Kulcs hossza: $kulcshossz"

kulcsosszeg="0"

#Itt megszámolom az eltolás mértékének egyik paraméterét
for i in $(seq 0 $kulcshossz)
do
	for j in $(seq 0 ${#abc})
	do
		k=`expr substr $kulcs $i 1`
		a=`expr substr $abc $j 1`
		if [ "$k" = "$a" ];
		then
			kulcsosszeg=$(($kulcsosszeg+$j))
			break
		fi
	done
done

eltolas=$(($kulcsosszeg/$kulcshossz))
#echo "$kulcsosszeg / $kulcshossz"
echo "Eltolas: $eltolas"


#Biztonsági intézkedés
until [ $(($eltolas)) -lt $((${#abc})) ]
do
	eltolas=$(($eltolas-(${#abc})))
done
#echo "${#abc}"
#echo "$eltolas"

#Eltolt abc

elso=`expr substr $abc $eltolas ${#abc}`
masodik=`expr substr $abc 1 $(($eltolas-1))`
outputabc="${elso}${masodik}"

echo "$abc"
echo "$outputabc"


if [ "$c" = "true" ]
then

echo "\nKodolunk"
outputtartalom=""
outputbetu=""

for i in $fajltartalom #Szavakat darabol
do
	for j in $(seq 0 ${#i}) #Szavak betuin megy vegig
	do

		for f in $(seq 0 ${#abc})
		do
			k=`expr substr $i $j 1` #szoveg
			a=`expr substr $abc $f 1` #tabla
			if [ "$k" = "" ];
			then
				#echo "Helo mama"
				outputtartalom="${outputtartalom} "
				break
			fi;
			if [ "$k" = "$a" ];
			then
				#echo "$k = $a"
				outputbetu=`expr substr $outputabc $f 1`
				outputtartalom="${outputtartalom}${outputbetu}"
				break
			fi;
		done
	done

done

echo "$outputtartalom"
echo "$outputtartalom" > $fajlnev

fi;

if [ "$d" = "true" ]
then

echo "\nDekodolunk"
outputtartalom=""
outputbetu=""

for i in $fajltartalom #Szavakat darabol
do
	for j in $(seq 0 ${#i}) #Szavak betuin megy vegig
	do

		for f in $(seq 0 ${#abc})
		do
			k=`expr substr $i $j 1` #szoveg
			a=`expr substr $outputabc $f 1` #tabla
			if [ "$k" = "" ];
			then
				#echo "Helo mama"
				outputtartalom="${outputtartalom} "
				break
			fi;
			if [ "$k" = "$a" ];
			then
				#echo "$k = $a"
				outputbetu=`expr substr $abc $f 1`
				outputtartalom="${outputtartalom}${outputbetu}"
				break
			fi;
		done
	done

done

echo "$outputtartalom" > $fajlnev
echo "$outputtartalom"

fi;

else
echo "Kérlek adj meg minden szükséges kapcsolót! -f fájl -k kulcs -c/d"
fi;
