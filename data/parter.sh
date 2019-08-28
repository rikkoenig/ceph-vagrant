#!/bin/bash

lsblk -d -o name,rota,size > localnote.txt

while read p; do
    my_array=($p)
    echo "My array is ${my_array[0]} ${my_array[1]} ${my_array[2]}"

    if [[ ${my_array[2]} == "10M" ]] ; then
        echo "found it"
        echo "partitioning ${my_array[0]}"
        dEVICE="/dev/${my_array[0]}"
        sudo parted -s $dEVICE mklabel gpt
        sudo parted -s $dEVICE mkpart primary ext2 0M 10MB
    fi
done <localnote.txt


rm localnote.txt
