#!/bin/bash

echo
echo ----------------------------------------------------
echo -e "--------------------- \033[31mK\033[0mlipper ---------------------"
echo ------- Dieses Script kompiliert und flasht  -------
echo ------- Klipper fuer die MCUs und den Raspi. ------
echo ----------------------------------------------------
echo
echo ---------------------------------------------------
echo ----------------- Bitte drücken Sie ---------------
echo -e "------------- [\033[34mEnter\033[0m] zum Fortfahren. -------------"
echo ---------------------------------------------------
echo -e "------------- Zum Abbrechen [\033[31mSTRG - C\033[0m] ------------"
read -p $'---------------------------------------------------\n'

# change directory
cd ~/klipper


# shutdown klipper
echo
echo ---------------------------------------------------
echo -e "-------------- \033[31mK\033[0mlipper wird gestoppt --------------"
echo -------- bitte das ROOT Passwort eingeben. --------
echo ---------------------------------------------------
sudo service klipper stop


echo
echo ---------------------------------------------------
echo ------------- Das SKR E3 mini Board ---------------
echo ----------------- wird kompiliert -----------------
echo ---------------------------------------------------

cp config.e3mini .config        # config holen
make clean
make menuconfig
cp .config config.e3mini        # config holen

make

echo
echo ---------------------------------------------------
echo ------------- Das SKR E3 mini Board ---------------
echo ------------------ wird geflasht ------------------
echo ---------------------------------------------------
make flash FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32f103xe_31FFD6053031543939831643-if00

#EBB36
echo
echo ---------------------------------------------------
echo ------------ Das EBB36 wird kompiliert ------------
echo ---------------------------------------------------
cp config.ebb36 .config
make menuconfig
cp .config config.ebb36
make

echo
echo ---------------------------------------------------
echo ------------- Das EBB36 wird geflasht -------------
echo ---------------------------------------------------
python3 ~/klipper/lib/canboot/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u e1fa1bbb06e4
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0


#RPi
echo
echo ---------------------------------------------------
echo ------------- Die RPi wird kompiliert -------------
echo ---------------------------------------------------
cp config.rpi .config
make menuconfig
make clean
cp .config config.rpi
make
echo
echo ---------------------------------------------------
echo -------------- Die RPi wird geflasht --------------
echo ---------------------------------------------------
make flash


#klipper starten
echo
echo ---------------------------------------------------
echo -e "--------- \033[31mK\033[0mlipper wird wieder gestarted -----------"
echo ---------------------------------------------------
sudo service klipper start


echo
echo ---------------------------------------------------
echo --------- Alle MCUs sind wieder aktuell -----------
echo ---------------------------------------------------