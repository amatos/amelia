# 'Amelia' is an Arch Linux installer, written in Bash.

-----------------------------------------------------
The main concept behind this installer is: Automation and Interaction.

'Amelia' is mainly targeted towards the average user, but power users might find it useful too.



- ## Automation:

There is no support for older non-GPT platforms, as the installer makes use of the "Discoverable Partitions Specification", to automate detection of the underlying partitions, perform a sanity-check (and other checks throughout the installation process) based on your preferences, and auto-mount or auto-activate partitions when necessary (e.g. swap), without the use of the fstab file.

In particular, when the "ext4" filesystem is being used, the "genfstab" command is not even executed in the script, and your "fstab" file will be empty (except only if "Swapfile" use is desired), as systemd's automation takes care of it.

In the same manner, "systemd" (instead of "base" & "udev") will be used in your initramfs, as it provides the tools for the said automation.

The installation process completes in "one-go", meaning after it's over and the system has rebooted, you're basically done.


- ## Interaction:

There will be full interaction with the user.


### Visual interaction:

The installer follows a menu-driven, step-by-step principal, presenting you with a sane sequence of installation steps, aided by colored prompts, making the installation process easy, pleasant and intuitive.

For disk partitioning, "cgdisk" is used, as it offers a pseudo-gui (ncurses) interface, making the process of managing the partition table, setting GUIDs etc. easy and safe(r).


### Input interaction:

You will be asked to make your own choices, and there will always be a confirmation upon success or failure of the outcome of those choices.

You will definitely know what your choice was, what has succeded and if anything went wrong.

The installer has been purposely made in such a way that it will exit if unresolvable errors occur, so it ^should be^ impossible to end up with an errored installation or with parts unfinished.

In several cases, it will try to remedy the situation by taking certain steps (e.g. unmounting a partition, in case it was already mounted from before) and bring you a few steps back, to re-run installation stages that might help you continue with success.

All stages are informative.


Where applicable, configuration takes place EXCLUSIVELY in the corresponding drop-in directories and never at the original ".conf" files, so the installed system preserves its functionality across updates and maintenance is minimized.



# Installer overview:


- ### First Check - Warning: [Auto]

A check/detection takes place, notifying you about the mode the installer runs on, along with the potential hazzard of running as root.

Normally should be runing as root, off the Arch-installation media.
If that's not the case, you will be informed accordingly.

If there is "terminus-font" detected (already included in the Arch installation media), you will be asked to use this font or its HiDPI version, while at console (tty), or you will be prompted to change tty and use console (if you're just simply test-running the installer in your own system with X or Wayland).

If not, setting different fonts is skipped.


- ### Uefi Mode Verification: [Auto]

Checks if the platform runs in uefi mode, and exits if not.


- ### System Clock Update: [Auto]

Self-explanatory.


- ### Microcode Detection: [Auto]

Cpu microcode detection takes place, ensuring the necessary "*-ucode" package will be installed later on.

In case of "Intel" cpus, if "Optimized Plasma" is selected, "x86_energy_perf_policy" package will be installed and will be set to "performance" mode for obtaining maximum cpu performance during installation.



## Main Menu:

- [ ] [1] Personalization
- [ ] [2] System Configuration
- [ ] [3] Disk Management
- [ ] [4] Start Installation


### Personalization Submenu:

- [ ] [1] Locale & Keyboard Layout Selection
- [ ] [2] User, Root User & Hostname Setup
- [ ] [ ] Return to Main Menu


### System Configuration Submenu:

- [ ] [1] Kernel & Bootloader Selection
- [ ] [2] Filesystem & Swap Selection
- [ ] [3] Graphics Setup
- [ ] [4] Desktop Selection
- [ ] [5] EFI Boot Entries Deletion
- [ ] [6] Wireless Regulatory Domain Setup
- [ ] [ ] Return to Main Menu


### Disk Management Submenu:

- [ ] [1] Disk GPT Manager
- [ ] [2] Partition Manager
- [ ] [3] Installation Disk & Encryption
- [ ] [ ] Return to Main Menu

-----------------------------------------------

- ### Locale Selection: [Interactive - Skippable]

Set your locale, choose from the locale list or use default.

Skip for Default: en_US.UTF-8


- ### Keyboard Layout Selection: [Interactive - Skippable]

Set your keyboard layout, choose from the keyboard layout list or use default.

Skip for Default: us


- ### User Setup: [Interactive]

Set username, password and verify.


- ### Root User Setup: [Interactive]

Set password and verify.


- ### Hostname Setup: [Interactive]

Self-explanatory.


- ### Kernel Selection: [Interactive]

Choose between Linux, Linux LTS, Linux Hardened & Linux Zen Kernels.


- ### Bootloader Selection: [Interactive -Skippable]

Choose between Systemd-boot or Grub



- ### Filesystem Selection: [Interactive]

Choose Filesystem to be used (Ext4 / Btrfs)

If "Btrfs" is chosen, you will be asked to label your "snapshots" directory.


- ### Swap Selection: [Interactive - Skippable]

Choose between Swap partition, Swapfile or none.

If " Swapfile" is chosen, then set desired "Swapfile" size, and automatically create & activate the "Swapfile" and configure the "fstab" file accordingly.

Skip if "none" is chosen.


- ### Graphics Setup: [Interactive - Skippable]

A check/detection takes place, notifying you about the underlying graphics subsystem.

If Dual/Triple graphics setup is detected, a message will notify you to configure graphics after installation has finished.

If Virtual Machine graphics are detected, the setup is skipped, and graphics configuration defaults to "n".

If single graphics are detected, you will be offered the choice to automatically have drivers installed, hardware acceleration enabled and the graphics subsystem configured (mkinitcpio.conf, kernel parameters etc).

Notice that only the latest available drivers will be installed, so should you choose "y" to auto-configure, ensure your graphics subsystem is currently supported.

Xorg DXX drivers (xf86-xxxx-xxxx) for Intel - AMD - Nvidia will not be automatically installed.

In case of AMD graphics, "amdgpu" driver support for "Southern Islands" and "Sea Islands" graphics is offered through auto-configuring.

In case of Nvidia graphics, according to the gpu architecture, there's support for the newer 'nvidia-open' drivers and the 'Nvidia Hook' will also be automatically created.

The purpose of this part of the installer is not to replace specialized or complicated/sofisticated software (like e.g. Manjaro's MHWDT or others) but only to offer support for a quick start.


- ### Desktop Selection [Interactive]

In this step, you will be presented with a list of setups to choose from:

- [ ]  1. Plasma
- [ ]  2. Optimized Plasma & Systemd-boot & Wayland
- [ ]  3. Gnome
- [ ]  4. Xfce
- [ ]  5. Cinnamon
- [ ]  6. Deepin
- [ ]  7. Budgie
- [ ]  8. Lxqt
- [ ]  9. Mate
- [ ] 10. Base System (No Desktop)
- [ ] 11. Custom System
---------------------------------------------------------------

- All desktops (except "Optimized Plasma") are completely "Vanilla", and come with network support (networkmanager). For any additional functionality, please consult the Archwiki.

- The installer offers the convenient option to set your own kernel parameters on-the-fly for any selected Desktop Setup.

- "Optimized Plasma" will install a KDE Plasma system-optimized version plus additional software, systemd-boot loader and Wayland.

You'll find my preferred packages inside the "deskpkgs" variable and all of my configurations at the involved part of the "chroot_conf" function.

- "Base System" is literally a basic Arch linux system, consisting of the following packages: "base, linux{lts-hardened-zen}, linux-firmware, *-ucode, nano, vim, networkmanager, wireless-regdb and e2fsprogs/btrfs-progs" (depending on the filesystem chosen).

- "Custom System": In this step, you can create your own system, on-the-fly, using the following Menus:


- ### Custom System Setup [Interactive]

- [ ]  Custom Packages Setup
- [ ]  Custom Services Setup
- [ ]  Custom Kernel Parameters Setup
---------------------------------------------------------------

It offers only the minimal configuration required to make your system run.


- ### EFI Boot Entries Deletion: [Interactive - Skippable]

Choose if you wish to delete any EFI boot entries or skip.


- ### Wireless Regulatory Domain Setup: [Interactive - Skippable]

Enter your 2-letter Country Code (e.g. 'US') to set the correct wifi regulations for your country.


- ### Disk GPT Manager: [Interactive - Skippable]

Use "gdisk" to perform various disk operations to any detected drive in your system (e.g. zapping the GPT and create a new one, etc.


- ### Partition Manager: [Interactive - Skippable]

Use "cgdisk" to perform various disk operations to any detected drive in your system.

This is a key part of the installation, as it depends on YOU to correctly set the GUIDs in every relevant partition that is to be used in the installation disk.

For convenience, a message will be printed on screen, showing you the corresponding GUID codes.

Creation of an "EFI" System Partition and a "Root x86-64" Partition is mandatory.

The partitions layout in this step should reflect your previous choices, e.g. if you chose to use a "Swap" partition, and it does not exist, now is the time to create it.

If you need a seperate "Home" partition, create it now or an existing one can also be used.

For the systemd "auto-gpt-generator" automation to work, all involved partitions MUST reside in the same physical disk/device.


- ### Installation Disk Selection & Sanity Check: [Interactive]

Select a disk to install Arch Linux on.

Not to be confused with the "Disk Manager" step.

This step only asks you to just point to the right disk for installation.

Also, this step incorporates and performs a "Sanity Check" on the chosen disk.

This means the installer will verify that the choices you've made so far, are correctly reflected on the partitions layout, before it lets you continue with the installation.

The aim here is to make the installation process error-proof.

It will ensure that an "EFI" System Partition indeed exists, that a "Root x86-64" partition exists, that a "Swap" partition exists IF you chose to use a "Swap" partition and will also detect an existing seperate "Home" partition.

If the Sanity Check fails, the installer will send you back to the "Disk Manager" step, so you can correct any errors/omissions.


- ### Encryption Setup: [Interactive - Skippable]

Choose if you will enable LUKS encryption on your "Swap","Root x86-64" partition (and -if using "ext4" filesystem- on your separate "Home" partition, if exists).

Also, you will be asked to Label your partition(s).

Again, the scope here is not to create an inpenetrable system but a decently protected system.

An unencrypted "EFI" System partition and a LUKS encrypted "Root"/"Home"/"Swap" partition should suffice.


- ### Swap Partition Activation: [Auto]

If you chose to create a "Swap" partition, now it will be activated.


    ### If the answer to the "Disk Encryption" step was "no" :


- ### Mode Selection: [Interactive]

The installer asks the user to choose the preferred "Install" Mode.

- [ ] "Auto" will perform Formatting, Labeling and Mounting of all of the involved partitions automatically, but it will ask for your confirmation before formatting a separate "ext4" "Home" partition (if found), in case it belongs to another Os and you would like to keep it intact.

- [ ] "Manual" mode will perform the above by asking the user to choose which partitions to format, choose desired name to label the partitions, and mount them accordingly.

The "Auto" mode will switch to "Manual" mode if errors are encountered (so the user gets control of the procedure), and when the said mini-step is completed (e.g formatting "EFI") it will continue in "Auto" mode for the rest of the partitions.

Upon completion, both "Auto" and "Manual" mode present the user with a summary of the partitions and mounts layout, preparing for the next step.


- ### Confirm Installation Status [Interactive]

Decide if you will procceed with the installation.

If you are satisfied with the result (presented to you in the previous step and still showing on screen), answer "yes".

If your answer is "no", then the installer unmounts all mounted partitions and reloads "System Configuration" and all necessary installation stages, so you can revise your choices until you are satisfied with the outcome.


- ### Optimize Pacman: [Interactive]

Oftentimes, the mirrorlist created from Reflector's auto-run at start-up is not ideal.

So, in this step you are being presented with the current full list of countries that are hosting Archlinux mirrors, to choose one of your preference.

If the field is left empty, the default Reflector's mirrorlist will be used.

If a country from the list is chosen, Reflector will rate its mirrors, using [ l 10 -p https -f 10 ].
If no mirrors are found, it means that the country chosen doesn't fulfill Reflector's set criteria.
Try with another country.

Then you will be asked to enable Pacman's Parallel Downloads feature, and if the answer is "y" you will be asked to choose a number of parallel downloads, ranging from 2 up to 5 max.

- ### Pacstrap System: [Auto]

Your selected setup will be installed now.


- ### Chroot & Configure System: [Auto]

During this stage, the majority of configuration takes place.

Detection of rotational or solid state drives has already taken place, so "fstrim.timer" will be activated accordingly for the installation drive.

Also, if a non-rotational drive is being used during installation, and LUKS encryption has been chosen, then specific options will be applied to open the LUKS container.

Graphics setup, encryption setup, swap/swapfile activation/offset calculation, specific filesystem-based options, interactive package pacstrapping, pciid database update, auto configuration of your timezone based on your computer's ip address, makepkg optimization, sysctl / mkinitcpio / udisks / systemd / sudoers file configuration, systemd services activation etc. all happen here.

As mentioned earlier, configuration takes place using only the respective drop-in directories and never the original ".conf" files, where applicable.

"Optimized Plasma" option offers KDE Plasma with maximum system configuration and optimizations.

All other setups offer only the minimal/typical configuration required to make your system run.


    ### If the answer to the "Disk Encryption" step was "yes":


- ### Secure Disk Erasure: [Interactive - Skippable]

Since LUKS encryption has been chosen in a previous step, the installer offers the option to securely erase the involved drive before continuing with the installation, if so desired.


- ### LUKS Encryption: [Interactive - Skippable]

Your selected "Root x86-64" partition will be encrypted using LUKS.

If a separate "Home" partition is detected, and the filesystem chosen is "ext4", then you will be offered the option to encrypt "Home" too.

Should you choose "yes" to that option, then auto-configuration will take place, so an extra LUKS password won't be needed to unlock said volume.

Should you choose "no", the installer will still ask for your confirmation before formatting the "Home" partition to "ext4", in case it belongs to another Os and you would like to keep it intact.

This stage cannot offer automatic error-resolving by automatically taking actions such as re-running previous steps of the installation precedure, like [Auto] or [Manual] mode does, as after LUKS encryption has finished, partprobing and informing the kernel about further/new changes will require a system restart.

As a result, if any errors occur at this stage, will eventually terminate the installation, and you will be required to reboot and re-run the installer.

For the same reason, the installer cannot offer the choice of reloading previous phases, as it does in the "Confirm Installation Status" stage.

From here onwards, all stages are the same as the Non-Encrypted Installation.

-----------------------------------------------------------------------------


That's pretty much it.

Online research was very helpful in the creation of this installer, as a few ideas came from scripts of others.

All instructions used, stem from the Arch wiki.

Any feedback will be greatly appreciated.

Have fun everyone!

