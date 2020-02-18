## notes
not a big fan of wifi-menu, it just seems clunky. will have to check if nmcli is in the iso

## prepare 
1. check for efi  
`ls /sys/firmware/efi/efivars`
2. connect to wifi
   - `ip link`
   - `ip link set [interface] up`
   - `wifi-menu`
3. update the system clock  
`timedatectl set-ntp true`
4. update the arch database
`pacman -Syy`
5. generate a mirror list
    - `pacman -S reflector`
    - `reflector -c "Russia" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist`

## partition
1. pick a disk
`fdisk -l`
2. open up partition menu
`cfdisk [disk]`
3. delete > create > set primary > set bootable [?]
4. format the partition, not the disk
`mkfs.ext4 [partition] 
5. mount it
`mount [parition] /mnt`

## install
1. install base system
`pacstrap /mnt base base-devel linux`
2. generate fstab
`genfstab -U /mnt >> /mnt/etc/fstab`

## chroot
1. get into the install
`arch-chroot /mnt /bin/bash`
2. generate locale, add "LANG=en_US.UTF-8" to locale.conf
    - `locale-gen`
    - `vi /etc/locale.conf`
3. set local time
    - `ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime`
    - `hwclock --systohc`
4. set host name
`echo [name] > /etc/hostname`
5. add matching entries to hosts 
6. set password
    - `passwd`
7. install networkmanager

## grub
1. grab grub and efibootmgr
`pacman -S grub efibootmgr`
2. mkdir /efi
3. mount efi system partition to /efi
4. grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
3. create a config file
`grub-mkconfig -o /boot/grub/grub.cfg`
4. reboot
    - exit
    - umount -R /mnt
    - reboot

## post-install
1. add a new user to the wheel
`useradd -m -g users -G wheel -s /bin/bash sean`
2. uncomment wheel all all 
`EDITOR=nano visudo`
3. connect to wifi
`sudo systemctl enable NetworkManager.service`
`sudo NetworkManager`
`nmcli d wifi connect [name] password [password]`
4. enable audio, remember to unmute the main channel
`pacman -S pulseaudio pulseaudio-alsa pacmixer`
5. blueberry
`git clone github.com/seancallous/blueberry`
`bash blueberry/blueberry.sh`



