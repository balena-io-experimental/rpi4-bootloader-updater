# rpi4-bootloader-updater

Raspberry Pi 4 is different as compared to the previous generations of the Pi family, when it comes to the way it boots up. There's an eeprom onboard that is checked for boot config settings, which includes the boot sequence.

The objective of this app is to make it easy to boot a Pi4 from an SSD over USB3.

---

# Build logs

- Not able to find rpi-eeprom packages
- Cloning using git now https://github.com/raspberrypi/rpi-eeprom.git
- Can't find `vcgencmd`
```
[Logs]    [4/30/2021, 10:50:05 AM] [main]     raise child_exception_type(errno_num, err_msg, err_filename)
[Logs]    [4/30/2021, 10:50:05 AM] [main] FileNotFoundError: [Errno 2] No such file or directory: 'vcgencmd'
[Live]    Device state settled
```
- userland packages aren't available in 64 bit? https://github.com/raspberrypi/firmware/issues/1118
- talking to Trong about this - https://www.flowdock.com/app/rulemotion/r-beginners/threads/tvfDu6KwBY2q1oHIuufrP3uB1HB
- going to use 32 bit images on the container (balenalib/raspberrypi3-python)
```
Logs]    [4/30/2021, 12:26:07 PM] [main] + vcgencmd version
[Logs]    [4/30/2021, 12:26:07 PM] [main] Oct 22 2020 13:59:45
[Logs]    [4/30/2021, 12:26:07 PM] [main] Copyright (c) 2012 Broadcom
[Logs]    [4/30/2021, 12:26:07 PM] [main] version 74e754ff8947c58d2773253f77f6f68a303188f8 (clean) (release) (start_cd)
[Logs]    [4/30/2021, 12:26:07 PM] [main] + vcgencmd bootloader_version
[Logs]    [4/30/2021, 12:26:07 PM] [main] Sep  3 2020 13:11:43
[Logs]    [4/30/2021, 12:26:07 PM] [main] version c305221a6d7e532693cc7ff57fddfc8649def167 (release)
[Logs]    [4/30/2021, 12:26:07 PM] [main] timestamp 1599135103
[Logs]    [4/30/2021, 12:26:07 PM] [main] + ./rpi-eeprom/rpi-eeprom-config
[Logs]    [4/30/2021, 12:26:08 PM] [main] [all]
[Logs]    [4/30/2021, 12:26:08 PM] [main] BOOT_UART=0
[Logs]    [4/30/2021, 12:26:08 PM] [main] WAKE_ON_GPIO=1
[Logs]    [4/30/2021, 12:26:08 PM] [main] POWER_OFF_ON_HALT=0
[Logs]    [4/30/2021, 12:26:08 PM] [main] DHCP_TIMEOUT=45000
[Logs]    [4/30/2021, 12:26:08 PM] [main] DHCP_REQ_TIMEOUT=4000
[Logs]    [4/30/2021, 12:26:08 PM] [main] TFTP_FILE_TIMEOUT=30000
[Logs]    [4/30/2021, 12:26:08 PM] [main] ENABLE_SELF_UPDATE=1
[Logs]    [4/30/2021, 12:26:08 PM] [main] DISABLE_HDMI=0
[Logs]    [4/30/2021, 12:26:08 PM] [main] BOOT_ORDER=0xf41
[Logs]    [4/30/2021, 12:26:08 PM] [main]
[Logs]    [4/30/2021, 12:26:08 PM] [main] + sleep infinity
```
- Above log is from a device already booting from a SSD, notice the `BOOT_ORDER=0xf41`
- Below is an example of Pi4 running off a SD card-
```

30.04.21 16:21:53 (+0530)  main  + vcgencmd version
30.04.21 16:21:53 (+0530)  main  Oct 22 2020 13:59:27
30.04.21 16:21:53 (+0530)  main  Copyright (c) 2012 Broadcom
30.04.21 16:21:53 (+0530)  main  version 74e754ff8947c58d2773253f77f6f68a303188f8 (clean) (release) (start)
30.04.21 16:21:53 (+0530)  main  + vcgencmd bootloader_version
30.04.21 16:21:53 (+0530)  main  Mar 19 2020 14:27:25
30.04.21 16:21:53 (+0530)  main  version 940f978d13e45be9baef77f3f4a13b76a832f7b4 (release)
30.04.21 16:21:53 (+0530)  main  timestamp 1584628045
30.04.21 16:21:53 (+0530)  main  + ./rpi-eeprom/rpi-eeprom-config
30.04.21 16:21:53 (+0530)  main  [all]
30.04.21 16:21:53 (+0530)  main  BOOT_UART=0
30.04.21 16:21:53 (+0530)  main  WAKE_ON_GPIO=1
30.04.21 16:21:53 (+0530)  main  POWER_OFF_ON_HALT=0
30.04.21 16:21:53 (+0530)  main  DHCP_TIMEOUT=45000
30.04.21 16:21:53 (+0530)  main  DHCP_REQ_TIMEOUT=4000
30.04.21 16:21:53 (+0530)  main  TFTP_FILE_TIMEOUT=30000
30.04.21 16:21:53 (+0530)  main  TFTP_IP=
30.04.21 16:21:53 (+0530)  main  TFTP_PREFIX=0
30.04.21 16:21:53 (+0530)  main  BOOT_ORDER=0x1
30.04.21 16:21:53 (+0530)  main  SD_BOOT_MAX_RETRIES=3
30.04.21 16:21:53 (+0530)  main  NET_BOOT_MAX_RETRIES=5
30.04.21 16:21:53 (+0530)  main  [none]
30.04.21 16:21:53 (+0530)  main  FREEZE_VERSION=0
```
- Notice the bootloader differences
The old -
```
30.04.21 16:21:53 (+0530)  main  + vcgencmd bootloader_version
30.04.21 16:21:53 (+0530)  main  Mar 19 2020 14:27:25
30.04.21 16:21:53 (+0530)  main  version 940f978d13e45be9baef77f3f4a13b76a832f7b4 (release)
30.04.21 16:21:53 (+0530)  main  timestamp 158462804

```
and the new
```
4/30/2021, 12:26:07 PM] [main] + vcgencmd bootloader_version
4/30/2021, 12:26:07 PM] [main] Sep  3 2020 13:11:43
4/30/2021, 12:26:07 PM] [main] version c305221a6d7e532693cc7ff57fddfc8649def167 (release)
4/30/2021, 12:26:07 PM] [main] timestamp 1599135103
```
