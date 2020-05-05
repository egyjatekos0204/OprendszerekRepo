#!/bin/bash

# arg 1  =  fájl
# arg 2  = titkosítási kulcs
# arg 3  = crypt vagy decrypt c/d

fajltartalom=`cat $1`
kulcs="$2"
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
echo "$kulcsosszeg / $kulcshossz"
echo "Eltolas: $eltolas"


#Biztonsági intézkedés
until [ $(($eltolas)) -lt $((${#abc})) ]
do
	eltolas=$(($eltolas-(${#abc})))
done
echo "${#abc}"
echo "$eltolas"

#Eltolt abc

elso=`expr substr $abc $eltolas ${#abc}`
masodik=`expr substr $abc 1 $(($eltolas-1))`
outputabc="${elso}${masodik}"

echo "$abc"
echo "$outputabc"


crypt()
{
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
				echo "Helo mama"
				outputtartalom="${outputtartalom} "
				break
			fi
			if [ "$k" = "$a" ];
			then
				echo "$k = $a"
				outputbetu=`expr substr $outputabc $f 1`
				outputtartalom="${outputtartalom}${outputbetu}"
				break
			fi
		done
	done

done

echo "$outputtartalom" > $1

}

decrypt(){

}
