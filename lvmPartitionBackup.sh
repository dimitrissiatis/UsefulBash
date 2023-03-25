#!/bin/sh

# !!!!! This is neither tested nor recommended for root Logical Volumes be cautious !!!!!

TIMESTAMP="$(date +%Y%m%d-%Hh%M)"

# only run as root
if [ "$(id -u)" != '0' ]
then
        echo "You need to be root to execute this script"
        exit 1
fi

# Set the backup filename and directory
backup_filename="lv_backup_$(date +%Y%m%d_%H%M%S).img"
read -p "Provide the path in which you need the backup to be saved (make sure that there is enough space): " backup_directory

# Prompt user to give the LV path for backup
lvdisplay -C -o "lv_dm_path"
read -p "Copy and paste the path for the lv that you want to backup: " lv_path

# Perform the backup using the dd command
sudo dd if=$lv_path of=$backup_directory/$backup_filename bs=1M

# Exit the script
echo "Backup Completed!"
exit 0


# To recover it just do as below as root:

# lvcreate -L 50M -n lv5 rl      ---> Replace the 50M with capacity equal or more of your backup .img file and replace lv5 with the name of the new lv
# dd if=lv_backup_<date>.img of=/dev/mapper/rl-lv5       ---> Replace the /dev/mapper/rl-lv5 with the map of your actual path to the logical volume
# mkdir /mnt/thetest        --> Make a directory to mount the volume group
# mount /dev/mapper/rl-lv5 /mnt/thetest/      ---> Mount the new volume group and if you need this persistent do not forget to edit your /etc/fstab file
