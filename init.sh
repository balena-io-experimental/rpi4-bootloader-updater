vcgencmd version
vcgencmd bootloader_version
cp -rf rpi-eeprom/firmware/ /usr/bin/
rpi-eeprom-update -a
sleep infinity
