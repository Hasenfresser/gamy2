#!/bin/bash

# Variables
M2=games_m2
HDD=games_hdd

DEV=/dev/disk/by-uuid/
DEV_M2=$DEV"bfc2b949-6458-47e6-a9c3-9d7d7e812522"
DEV_HDD=$DEV"af768f9e-b984-4185-8684-75e41a3daeeb"

KEY=/root/
KEY_M2=$KEY$M2
KEY_HDD=$KEY$HDD

DM=/dev/mapper/
DM_M2=$DM$M2
DM_HDD=$DM$HDD

MNT=/run/media/hasenfresser/
MNT_M2=$MNT"Linux-Games"
MNT_HDD=$MNT"Linux-Games-HDD"

# Script
mkdir -p $MNT_M2 $MNT_HDD || exit 1

[ -e $DM_M2 ] || cryptsetup open $DEV_M2 --key-file=$KEY_M2 $M2 || exit 10
sleep 5
mountpoint -q $MNT_M2 || mount -o defaults,noatime $DM_M2 $MNT_M2 || exit 11

[ -e $DM_HDD ] || (cat $KEY_HDD | cryptsetup open --type bitlk $DEV_HDD $HDD) || exit 20
sleep 5
mountpoint -q $MNT_HDD || mount -o defaults $DM_HDD $MNT_HDD || exit 21

echo All games disks decrypted and mounted!
exit 0
