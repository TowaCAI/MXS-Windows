#!/bin/bash

# Check if the user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as the root user. Please run it with administrator privileges."
    exit 1
fi

# Information message
echo "This script will help you create a customized Windows 10 with VirtIO drivers."
echo "Make sure you have downloaded the official Windows 10 ISO from Microsoft's website:"
echo "https://www.microsoft.com/en-us/software-download/windows10"
echo "Rename the file to 'Win10.iso' and place it in the same folder as this script."
echo "Press Enter to continue or Ctrl+C to cancel."
read

# Check if the script is running in the same folder as the Windows 10 ISO
if [ -f "Win10.iso" ]; then
    ISO_PATH="./Win10.iso"
else
    read -p "Please provide the location of the downloaded Windows 10 ISO: " ISO_PATH
fi

# Check if the Windows 10 ISO exists at the provided location
if [ ! -f "$ISO_PATH" ]; then
    echo "The Windows 10 ISO was not found at the provided location."
    exit 1
fi

# Download Virtio ISO
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso -O Virtio.iso

# Create a temporary folder
temp_dir=$(mktemp -d)
mkdir windows
mkdir drivers

# Mount the Windows 10 ISO
mount -o loop "$ISO_PATH" "$temp_dir"
cp -r "$temp_dir"/* windows/
umount "$temp_dir"

# Mount the Virtio ISO
mount -o loop Virtio.iso "$temp_dir"
cp -r "$temp_dir"/* drivers/
umount "$temp_dir"

# Modify the boot.wim file
wimmountrw windows/sources/boot.wim 1 "$temp_dir"
cp -r drivers "$temp_dir/"
wimunmount --commit "$temp_dir"
wimmountrw windows/sources/boot.wim 2 "$temp_dir"
cp -r drivers "$temp_dir/"
wimunmount --commit "$temp_dir"

# Cleanup
rm -rf "$temp_dir" drivers Virtio.iso

# Show the available disks
lsblk -d -o NAME,SIZE,ROTA,PATH --bytes | awk '$2 > 100*1024*1024*1024 {if ($3 == 0) {type="SSD"} else if ($3 == 1) {type="HDD"}; print $4, $1, $2/1024/1024/1024" GB (" type ")"}' | column -t

# Modify disk partitions
read -p "Enter the disk name (e.g., /dev/sdX): " disk

# Check if the entered disk is valid
if [ ! -b "$disk" ]; then
  echo "The entered disk is not valid."
  exit 1
fi

# Delete all partitions on the disk
fdisk "$disk" <<EOF
p
d
1
w
EOF

# Format the disk as NTFS
mkfs.ntfs -f "$disk"

# Create a mount point directory (if it doesn't exist)
mount_point="/mnt/ntfs_disk"
mkdir -p "$mount_point"

# Mount the NTFS partition
mount "$disk" "$mount_point"

echo "The disk has been formatted as NTFS and mounted at $mount_point."
echo "Now it is time to copy Windows files to this location."

# Copy the Windows 10 files to the disk
cp -r windows/* "$mount_point"

# Cleanup
rm -rf windows


echo "The Windows 10 ISO has been successfully modified and prepared for installation."
echo "You can now boot from the disk $mount_point and install Windows 10."
echo "Don't forget to install the VirtIO drivers during the installation process."
echo "Under 'drivers' folder. And use the SSD disk for the installation."
echo "Remember the system reboot you must press 'c' after the Proxmox screen to enter the Grub command line."
echo "Then you can enter the following commands to boot into Windows 10:"
echo "set root=(hd1,gpt1)"
echo "chainloader (hd1,gpt1)/efi/boot/bootx64.efi"
echo "boot"
echo "Press Enter to reboot the system or Ctrl+C to cancel."
read && reboot 