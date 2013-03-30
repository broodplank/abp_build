#!/bin/bash

HOMEDIR=${PWD}/..

clear
busybox sleep 1
clear	
echo "----------------------------------------"
echo "- Android Barebone Packages Lunch Menu -"
echo "- Please choose your device            -"
echo "----------------------------------------"
echo " "
echo " [1] GT-i8150 (Ancora)"
echo " [2] GT-i9001 (Ariesve)" 
echo " "
echo " [x] Exit"
echo " "




read CHOICE

if [[ "$CHOICE" == "1" ]]; then
BOOTLOADER="ancora"
fi;

if [[ "$CHOICE" == "2" ]]; then
BOOTLOADER="ariesve"
fi;


if [[ "$CHOICE" == "x" ]]; then
clear
echo " "
echo " ==========================="
busybox sleep 1 
echo "  http://www.broodplank.net"
busybox sleep 1 
echo " ============================"
busybox sleep 1
echo " "
exit
fi;

	cd ${HOMEDIR}

	clear
	echo " CLEANING..."
	busybox sleep 1

	if [ -d out ] 
	then 
		rm -Rf out
	fi;

	mkdir -p out/target/${BOOTLOADER}/system
	mkdir -p out/target/${BOOTLOADER}/META-INF/com/google/android

	echo " "
	busybox sleep 1
	echo " Chosen device: ${BOOTLOADER}"
	echo " Out dir      : /out/target/${BOOTLOADER}"
	echo " "
	echo " - Copying common prebuilt..."
	busybox sleep 1
	cp -Rf device/common/* out/target/${BOOTLOADER}/system
	echo " -- Done"
	echo " "
	busybox sleep 1
	echo " "
	echo " - Copying device prebuilt..."
	busybox sleep 1
	cd device/samsung/${BOOTLOADER}/
	./copy-prebuilt.sh
	echo " -- Done"
	echo " "
	busybox sleep 1
	echo " "
	echo " - Copying apps..."
	busybox sleep 1
	cd ${HOMEDIR}
	mkdir -p out/target/${BOOTLOADER}/system/app
	cp -Rf apps/*apk out/target/${BOOTLOADER}/system/app/
	echo " -- Done"
	echo " "
	busybox sleep 1 
	echo " "
	echo " - Copying kernel..."
	busybox sleep 1
	cd ${HOMEDIR}
	cp -f boot/${BOOTLOADER}/boot.img out/target/${BOOTLOADER}/boot.img
	echo " -- Done"
	echo " "
	busybox sleep 1 
	echo " "
	echo " - Copying files for ota distribution"
	busybox sleep 1
	cd ${HOMEDIR}
	cp -f build/updater-script out/target/${BOOTLOADER}/META-INF/com/google/android/updater-script
	cp -f build/update-binary out/target/${BOOTLOADER}/META-INF/com/google/android/update-binary
	echo " -- Done"
	echo " "
	busybox sleep 1 
	echo " "
	echo " - Packing zip"
	busybox sleep 1
	cd ${HOMEDIR}/out/target/${BOOTLOADER}
	zip -r ${BOOTLOADER} .
	mv ${BOOTLOADER}.zip ${HOMEDIR}/build/${BOOTLOADER}.zip
	echo " -- Done"
	echo " "
	busybox sleep 1 
	echo " "
	echo " - Signing zip"
	busybox sleep 1

	cd ${HOMEDIR}/build
	java -jar signapk.jar testkey.x509.pem testkey.pk8 ${BOOTLOADER}.zip signed-${BOOTLOADER}.zip
	mv -f signed-${BOOTLOADER}.zip ${HOMEDIR}/out/target/${BOOTLOADER}/signed-${BOOTLOADER}.zip
	mv -f ${BOOTLOADER}.zip ${HOMEDIR}/out/target/${BOOTLOADER}/${BOOTLOADER}.zip

	echo " -- Done"
	echo " "
	echo " "
	echo " --- All actions completed ---"
	echo " "
	echo " Look in ${HOMEDIR}/out/target/${BOOTLOADER} for the signed cwm zip file"
	echo " "

	
	

