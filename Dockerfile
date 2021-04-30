FROM balenalib/raspberrypi4-64-ubuntu:impish

ENV UDEV=on
WORKDIR /usr/src/bootloader-update/
RUN install_packages git pciutils rpi-eeprom
RUN git clone https://github.com/raspberrypi/rpi-eeprom.git
COPY init.sh /init
RUN chmod +x /init
CMD ["bash","-x","/init"]
