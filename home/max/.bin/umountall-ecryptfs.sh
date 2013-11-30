#!/bin/bash





ENCRYPT_PATH=`df -t ecryptfs | tail -n +2 | cut -d\  -f1`

for x in $ENCRYPT_PATH
do
    sudo umount $x
done



