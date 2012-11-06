#!/bin/sh

# ping-test.sh
# Unix Test Harness
#
# Created by Colin McNamara on 7/9/11.
# Copyright 2011 Colin McNamara. All rights reserved.
#OIFS=$IFS
#IFS=,
version=v1.1
# USAGE # ping-test.sh <number of pings> <ip address of endpoing> <test-name> 
# variables $1 $2 $3 $4
# test for the required local directories
# if they don't exist create them
##### run this as root #####
a=$1
b=$2
c=$3
d=$4

if [ -d tmp ]
then
	echo "******************************************"
	echo " temp directory found "
else
mkdir tmp
fi

if [ -d testing-output ]
then
	echo "******************************************"
	echo " testing output  directory found "
	mv testing-output/* *.bak
	echo ""
	echo "******************************************"    
    echo " cleaning out testing directory "

else
mkdir testing-output
fi


# put the version number into VERSION.TXT
echo "Version $version" > VERSION-PINGTEST.TXT

#fping -p 100 -c 10 -q  10.0.76.1 
# be sure to suid root to skynet.sh
# to set the userid as root, log in as root 
# example sudo su - 
# chmod 4755 ** 
# ping must be run as root for visibility lower then 1 second
# let's run this using fping later, and figure out the summary output issues.

echo "###############################"
echo " "
echo "starting ping"
echo " "

#ping -q -c $1 -i .1 $2 | awk '/packets/' | awk '{ print " $2 , target $1 , $3 , " $1 - $4  }' > ./testing-output/down-test.tmp.txt &
#ping -q -c $a -i .1 $b | awk '/packets/' | awk '{ print " $a , $b , $c , " $1 - $4  }' > ./testing-output/down-test.tmp.txt &
ping -q -c $a -i .1 $b > ./testing-output/ping.output.txt
cat ./testing-output/ping.output.txt | awk '/packets/' > ./testing-output/ping.output.clean.txt
#awk '{ print " $a , $b , $c , " $1 - $4  }' ping.output.clean.txt > ./testing-output/down-test.tmp.txt
awk '{ print $1 - $4  }' ./testing-output/ping.output.clean.txt > ./testing-output/ping.loss.txt 
loss=$(<./testing-output/ping.loss.txt)
echo "###############################"
echo "Results"
echo "Pings=,$1 ,Target=,$2 ,Test=,$3 ,loss=,$loss" > ./testing-output/ping.test.csv

echo "###############################"
echo " "
echo "sleeping 5 seconds to wait for convergence"
echo " "
sleep 5

echo "###############################"
echo " "
echo "Results"
cat ./testing-output/ping.test.csv
echo " "


#echo "###############################"
#echo " "
#echo "starting ping"
#echo " "
# change the output file to $srcssystem.$vdc.something.txt pipe to sed / awk to grap missed packets and putput in csv. Stack the csv lines together to creat output spreadsheet.
#ping -q -c 5 -i .1 $srcsys.vdc$vdcid | awk '/packets/' | awk '{ print " $srcsys , $vdcid , $srcmemeberint , " $1 - $4  }' >> ./testing-output/up-test.tmp.txt &
#echo "###############################"
#echo " "
#echo "bringing up interface"
#echo " "
#./ifup.exp colin 1Cisco123 $srcsys.vdc$vdcid $srcmemberint
#echo "###############################"
#echo " "
#echo " sleeping 5 seconds to wait for convergence"
#echo " "
#sleep 5

#echo "###############################"
#echo " "
#echo "test complete"
#echo " "

#end the while loop reading in file
#done < ./tmp/stripped.interface-assignments.csv.tmp.txt