#!/bin/bash -xe

# install session manager
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent

# install extra packages
sudo apt install unzip -y

# set hostname 
sudo hostnamectl set-hostname "Ec2Db${var.project_name}${count.index + 1}"

# formt disk 
mysql_dir="/var/lib/mysql"
mkdir -p $mysql_dir
disk=$(sudo fdisk -l | awk '/${var.disk_size} GiB/ {printf substr($2,1,12)}')
disk_uuid=$(sudo mkfs.btrfs -f $disk | awk '/UUID/ {printf $2}')
sudo echo "UUID=$disk_uuid $mysql_dir btrfs defaults 0 0" >> /etc/fstab
mount -a
