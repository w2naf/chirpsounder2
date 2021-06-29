#!/bin/bash
#while true; do rsync -av --remove-source-files --exclude=tmp* --progress /mnt/ramdisk/hf25/cha /mnt/8tb/chirpsounder/hf25/ ; sleep 1 ; done

drf mirror cp --ignore_existing /mnt/ramdisk/hf25 /mnt/10tb/chirpsounder
