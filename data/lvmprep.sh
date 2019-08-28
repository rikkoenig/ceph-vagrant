#!/bin/bash


#for VDRIVE in `lsblk -d -o name,rota,size`   

#sudo parted -s /dev/$VDRIVE mklabel gpt
#sudo parted -s /dev/$VDRIVE mkpart primary ext2 0M 10MB

#echo "setting localnote text"
lsblk -d -o name,rota,size > localnote.txt
#echo "set counter to 0"
counter=0

while read p; do
    my_array=($p)
    #echo "My array is ${my_array[0]} ${my_array[1]} ${my_array[2]}"

    if [[ ${my_array[1]} == 0 ]] ; then
        #echo "non rotational"
        #echo "creating pv for ${my_array[0]}"
        dEVICE="/dev/${my_array[0]}"
        pvcreate "$dEVICE"
        #echo "creating vg for db 1"
        vgcreate "vg_ceph_db_1" "$dEVICE"
    fi
done <localnote.txt
#echo "end one loop"
while read p; do
    my_array=($p)
    #echo "My array is ${my_array[0]} ${my_array[1]} ${my_array[2]}"

    if [[ ${my_array[2]} == "10G" && ${my_array[1]} == 1 ]] ; then
        #echo "rotational and 10G"
        #echo "creating pv for ${my_array[0]}"
        dEVICE="/dev/${my_array[0]}"
        pvcreate "$dEVICE"
        #echo "creating vgs for vg_ceph_block_$counter"
        
        lvcreate -L 4G -n "lv_ceph_db_$counter" vg_ceph_db_1
        vgcreate "vg_ceph_block_$counter" "$dEVICE"
        lvcreate -l 100%FREE -n "lv_ceph_block_$counter" "vg_ceph_block_$counter"
        #echo "increment"
        ((counter++))
    fi

done <localnote.txt
rm localnote.txt
