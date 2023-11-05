# Installation Guide

## Part 1: Windows 10 Installation

Please execute the following instructions in 'Console Mode'.

1. Acquire the Windows 10 ISO file from the official Microsoft website: [https://www.microsoft.com/en-us/software-download/windows10](https://www.microsoft.com/en-us/software-download/windows10)

2. Obtain the VirtIO ISO from the following repository: [https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso)

3. Install the wim-tools package with the command: `sudo apt install wimtools -y`.

4. Install GParted by issuing: `sudo apt install gparted -y`.

5. Utilize GParted (`sudo gparted`), to delete the existing HDD partition and create a new NTFS formatted partition on the HDD.

6. Repeat the partitioning process for the largest partition on the SSD. (Optional)

7. Within the directory containing the ISOs from steps 1 and 2, perform the following:

    7.1. Create a directory named "temp" (`mkdir temp`).

    7.2. Create a directory named "windows" (`mkdir windows`).

    7.3. Create a directory named "drivers" (`mkdir drivers`).

8. Mount the Windows 10 ISO to the "temp" directory (`sudo mount -o loop Win10.iso temp`).

9. Transfer the contents from "temp" to "windows" (`sudo cp -r temp/* windows/`).

10. Dismount the ISO from "temp" (`sudo umount temp`).

11. Mount the VirtIO ISO to "temp" (`sudo mount -o loop Virtio.iso temp`).

12. Transfer the contents from "temp" to "drivers" (`sudo cp -r temp/* drivers/`).

13. Dismount the ISO from "temp" (`sudo umount temp`).

14. Mount "boot.wim index 1" to "temp" (`sudo wimmountrw windows/sources/boot.wim 1 temp`).

15. Transfer the "drivers" directory to "temp" (`sudo cp -r drivers/* temp/`).

16. Dismount "temp" with changes committed (`sudo wimunmount --commit temp`).

17. Mount "boot.wim index 2" to "temp" (`sudo wimmountrw windows/sources/boot.wim 2 temp`).

18. Repeat the copying of the "drivers" directory to "temp" (`sudo cp -r drivers/* temp/`).

19. Again, dismount "temp" with changes committed (`sudo wimunmount --commit temp`).

20. Use the Disks application, pre-installed on Linux, to mount the HDD that contains the new partition and note the mount path.

21. Copy all contents from "windows" to the HDD, using the command `sudo cp -r windows/* /CHANGE/THIS/PATH/TO/HDD`. Replace `/CHANGE/THIS/PATH/TO/HDD` with the actual mount path noted in step 20.

22. Restart the system.

23. During boot-up, press "c" to enter Grub's command-line interface.

24. Execute the command: `chainloader (hd1,gpt1)/efi/boot/bootx64.efi`.

25. Enter "boot" to proceed.

26. In the Windows Installation Setup, select 'Next'. When prompted for drivers, select 'Browse'.

27. Navigate to and select the drivers within the "drivers" directory and choose 'Next'.

28. Select the SSD as the installation target.

29. Follow the on-screen instructions to continue with the installation process.

30. Once Windows has been installed, you can access it in ‘Gaming Mode’ using Parsec or Moonlight. Open Microsoft Edge and download Parsec ([https://builds.parsec.app/package/parsec-windows.exe](https://builds.parsec.app/package/parsec-windows.exe)) or Moonlight, install it and connect with your account. On your local computer, download and install Parsec or Moonlight, then connect to your account. Verify its functionality before ceasing the installation of Windows 11 and initiating the machine in “Gaming Mode”.

**Disclaimer:**

This guide is provided "as is" for informational purposes only. The following instructions involve significant changes to your system's software configuration. It is essential that you back up all important data before proceeding. The author of this guide assumes no responsibility for any data loss or system damage that may occur directly or indirectly as a result of following these instructions. Users should proceed with caution and at their own risk.

## Part 2: Windows 11 Installation

1. Download the Windows 11 ISO file, opting for the "Download Windows 11 Disk Image (ISO) for x64 devices" at [https://www.microsoft.com/software-download/windows11](https://www.microsoft.com/software-download/windows11).

2. Retrieve the following file to bypass system checks: [https://github.com/AveYo/MediaCreationTool.bat/blob/main/bypass11/Skip_TPM_Check_on_Dynamic_Update.cmd](https://github.com/AveYo/MediaCreationTool.bat/blob/main/bypass11/Skip_TPM_Check_on_Dynamic_Update.cmd)

3. Execute "Skip_TPM_Check_on_Dynamic_Update.cmd".

4. Right-click on the downloaded Windows 11 ISO and select "Mount".

5. Initiate the "Setup" application.

6. Continue with the standard installation process.

    6.1. If the Setup indicates that your system does not meet the necessary criteria, please restart the process.

## Troubleshooting Common Installation Issues

1. **Issue**: Drivers are not recognized during Windows installation.

    **Solution**: Verify that you have copied the drivers correctly in step 12. If the issue persists, try downloading the latest version of the VirtIO drivers, as they are frequently updated.

2. **Issue**: GParted does not allow partition deletion or formatting.

    **Solution**: You may need to unmount the partitions using the Disks application before GParted can make changes. Be cautious as this will remove all data on the partitions.

3. **Issue**: Error message stating that the Windows version cannot be installed on the selected partition.

    **Solution**: This can be due to a lack of the required partition format or size. Double-check that the partition is formatted as NTFS and meets the minimum size requirements for a Windows installation.

## Troubleshooting Windows 11 Specific Installation Issues

1. **Issue**: Setup reports that the TPM 2.0 requirement is not met.

    **Solution**: Ensure you've correctly run the "Skip_TPM_Check_on_Dynamic_Update.cmd" file to bypass the TPM check. If the issue persists, restart the process and run the script as an administrator.

2. **Issue**: Windows 11 setup does not start after mounting the ISO.

    **Solution**: Verify that the ISO is correctly mounted and appears as a drive in your file explorer. If not, attempt to remount the ISO, or check for any errors that might have occurred during the download process, indicating a corrupt file.
