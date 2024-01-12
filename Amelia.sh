#!/bin/bash

# Amelia Installer
# Version: 2.6

###########################################################################################
# ### COLOR FUNCTIONS ###

    red="\e[31m"
  redbg="\e[5;1;41m"
  green="\e[32m"
 yellow="\e[33m"
   blue="\e[94m"
   cyan="\e[36m"
 purple="\e[35m"
     nc="\e[0m"
  blink="\e[5m"
reverse="\e[7m"
 bright="\e[1m"
 bwhite="\e[0;97m"

RED(){
    echo -e "${red} $1${nc}"
}

REDB(){
    echo -e "${redb} $1${nc}"
}

REDBG(){
    echo -e "${redbg} $1${nc}"
}

GREEN(){
    echo -e "${green} $1${nc}"
}

YELLOW(){
    echo -e "${yellow} $1${nc}"
}

BLUE(){
    echo -e "${blue} $1${nc}"
}

CYAN(){
    echo -e "${cyan} $1${nc}"
}

PURPLE(){
    echo -e "${purple} $1${nc}"
}

NC(){
    echo -e "${nc} $1${nc}"
}

WHITEB(){
    echo -e "${bwhite} $1${nc}"
}

# ### END COLOR FUNCTIONS ###
###########################################################################################

###########################################################################################
# ### PROMPT FUNCTIONS ###

skip (){
        sleep 0.5
        YELLOW "
    -->  Skipping.. "
}
#----------------------------------------------------------
reload (){
        sleep 0.5
        NC "


  --> [${green}Reloading${nc}] "
}
#----------------------------------------------------------
invalid (){
        sleep 0.5
        RED "

        [!] Invalid response "
        reload
}
#----------------------------------------------------------
err_try (){
        sleep 0.5
        RED "

        [!] Errors occured. Please try again.. "
        reload
}
#----------------------------------------------------------
abort (){
        sleep 0.5
        RED "
        [!]  Aborting..


        "
        exit
}
#----------------------------------------------------------
err_abort (){
        sleep 0.5
        RED "

        [!] Errors occured "
        abort
}
#----------------------------------------------------------
umount_abort (){
        sleep 0.5
        RED "


        [!] Errors occured



        [!] Unmounting and Retrying.. "
        reload
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Unmount Filesystems ${purple}###${nc}


        "
    if umount -R /mnt; then
        sleep 0.5
        NC "

==> [${green}Unmount OK${nc}]"
    else
        sleep 0.5
        RED "


        [!] Unmounting failed "
        abort
    fi
        reload
}
#----------------------------------------------------------
umount_manual (){
        sleep 0.5
        RED "


        [!] Errors occured



        [!] Unmounting and Retrying.. "
        reload
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Unmount Filesystems ${purple}###${nc}
        "
    if umount -R /mnt; then
        sleep 0.5
        NC "



==> [${green}Unmount OK${nc}]"
    else
        sleep 0.5
        RED "


        [!] Unmounting failed "
        abort
    fi
        sleep 0.5
        NC "

  --> [Switching to ${green}Manual Mode${nc}]"
}
#----------------------------------------------------------
err_swapfile (){
        sleep 0.5
        RED "
        [!] Swapfile creation error "
        abort
}
#----------------------------------------------------------
err_reload (){
        sleep 0.5
        RED "

        [!] Errors occured "
        reload
}
#----------------------------------------------------------
err_instl_abort (){
        sleep 0.5
        RED "

        [!] Warning: Installation errored



        [!] Exiting..

        "
        exit
}
#----------------------------------------------------------
choice (){
        sleep 0.5
        RED "
        [!] Please make a choice to continue "
        reload
}
#----------------------------------------------------------
ok (){
        sleep 0.5
        NC "

==> [${green}${prompt} OK${nc}] "
}

# ### END PROMPT FUNCTIONS ###
###########################################################################################

###########################################################################################
# ### FUNCTIONS ###

first_check (){

    if [[ -f /usr/share/kbd/consolefonts/ter-v20b.psf.gz && -f /usr/share/kbd/consolefonts/ter-v32b.psf.gz && "${tty}" == *"tty"* ]]; then
        until slct_font; do : ; done
    elif [[ -f /usr/share/kbd/consolefonts/ter-v20b.psf.gz && -f /usr/share/kbd/consolefonts/ter-v32b.psf.gz && "${tty}" == *"pts"* ]]; then
        YELLOW "

      ###  Supported 'Terminus Font' detected. Switch to console (tty) and re-run the installer to activate "
    fi

    if [[ "${run_as}" == "root" ]]; then
        BLUE "
      ###  The installer runs in [Root Mode]

        "
REDBG "     ----------------------------------------
      ###  WARNING: High Risk Of Data Loss ###
      ----------------------------------------"
        NC
    else
        PURPLE "
      ###  The installer must be run as Root (Not 'wheel' group user) "
        BLUE "
      ###  Currently running with Limited Privileges [Test Mode]

        "
    fi
}

###########################################################################################
slct_font (){

        prompt="Fonts"
        sleep 0.5
        NC "
______________________

${purple}###${nc} Font Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a Font: "
        NC "

            [1]  Terminus Font

            [2]  HiDPI Terminus Font "
        BLUE "


Enter a number: "
        read -p "
==> " fontselect

    if [[ "${fontselect}" == "1" ]]; then
        setfont ter-v20b
    elif [[ "${fontselect}" == "2" ]]; then
        setfont ter-v32b
    else
        invalid
        return 1
    fi
        clear
        ok
}
###########################################################################################
uefi_check (){

        prompt="UEFI Mode"
        sleep 0.5
        NC "
______________________________

${purple}###${nc} UEFI Mode Verification ${purple}###${nc}
        "
    if [[ -e /sys/firmware/efi/efivars ]]; then
        ok
    else
        RED "
        [!] Not in UEFI Mode "
        abort
    fi
}
###########################################################################################
upd_clock (){

        prompt="System Clock"
        sleep 0.5
        NC "
___________________________

${purple}###${nc} System Clock Update ${purple}###${nc}
        "
        timedatectl set-ntp true
        ok
}
###########################################################################################
dtct_microcode (){

        prompt="Microcode"
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Microcode Detection ${purple}###${nc}
        "
        CPU="$(grep vendor_id /proc/cpuinfo)"

    if [[ "${CPU}" == *"GenuineIntel"* ]]; then
        microcode="intel-ucode"
        nrg_plc="x86_energy_perf_policy"
        microname="'Intel'"
    else
        microcode="amd-ucode"
        microname="'AMD'"
    fi
        sleep 0.5
        YELLOW "

        ###  Detection completed, the ""${microname}"" microcode will be installed
        "
        ok
}
###########################################################################################
main_menu (){

        sleep 0.5
        NC "
_________________

${purple}###${nc} Main Menu ${purple}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Personalization

            [2]  System Configuration

            [3]  Disk Management

            [4]  Start Installation "
        BLUE "


Enter a number: "
        read -p "
==> " menu

    case "${menu}" in
        1)
        until persnl_submn; do : ; done;;
        2)
        until sys_submn; do : ; done;;
        3)
        until dsks_submn; do : ; done;;
        4)
        until instl; do : ; done;;
        "")
        sleep 0.5
        RED "

        [!] Please select a Submenu "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac
}
###########################################################################################
persnl_submn (){

        sleep 0.5
        NC "
_______________________

${purple}###${nc} Personalization ${purple}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Locale & Keyboard Layout Setup

            [2]  User, Root User & Hostname Setup

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -p "
==> " persmenu

    case "${persmenu}" in
        1)
        until slct_locale; do : ; done
        until slct_kbd; do : ; done
        return 1;;
        2)
        until user_setup; do : ; done
        until rootuser_setup; do : ; done
        until slct_hostname; do : ; done
        return 1;;
        "")
        until main_menu; do : ; done;;
        *)
        invalid
        return 1;;
    esac
}
###########################################################################################
slct_locale (){

        prompt="Locale"
        sleep 0.5
        NC "
________________________

${purple}###${nc} Locale Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select your Locale    [Hit ${nc}'l'${yellow} to list locales] "
        BLUE "



Enter your Locale ${bwhite}(empty for 'en_US')${blue}: "
        read -p "
==> " SETLOCALE

    if [[ -z "${SETLOCALE}" ]]; then
        SETLOCALE="en_US.UTF-8"
        sleep 0.5
        YELLOW "

        ###  'en_US' Locale has been selected
        "
    elif [[ "${SETLOCALE}" == "l" ]]; then
        more /etc/locale.gen
        return 1

    elif ! grep -q "^#\?$(sed 's/[].*[]/\\&/g' <<< "${SETLOCALE}") " /etc/locale.gen; then
        invalid
        return 1

    else
        sleep 0.5
        YELLOW "

        ###  '"${SETLOCALE}"' Locale has been selected
        "
    fi
        ok
}
###########################################################################################
slct_kbd (){

        prompt="Keyboard Layout"
        sleep 0.5
        NC "
_________________________________

${purple}###${nc} Keyboard Layout Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select your Keyboard Layout    [Hit ${nc}'l'${yellow} to list layouts] "
        BLUE "



Enter your keyboard layout ${bwhite}(empty for 'us')${blue}: "
        read -p "
==> " SETKBD

    if [[ -z "${SETKBD}" ]]; then
        SETKBD="us"
        sleep 0.5
        YELLOW "

        ###  'us' Keyboard Layout has been selected
        "
    elif [[ "${SETKBD}" == "l" ]]; then
        localectl list-keymaps
        return 1

    elif ! localectl list-keymaps | grep -Fxq "${SETKBD}"; then
        invalid
        return 1

    else
        sleep 0.5
        YELLOW "

        ###  '"${SETKBD}"' Keyboard Layout has been selected
        "
        loadkeys "${SETKBD}"
    fi
        ok
}
###########################################################################################
user_setup (){

        prompt="User"
        sleep 0.5
        NC "
__________________

${purple}###${nc} User Setup ${purple}###${nc}
        "
        BLUE "

Enter a username: "
        read -p "
==> " USERNAME
        NC

    if [[ -z "${USERNAME}" ]]; then
        sleep 0.5
        RED "
        [!] Please enter a username to continue "
        reload
        return 1

    elif [[ "${USERNAME}" =~ [[:upper:]] ]]; then
        sleep 0.5
        RED "
        [!] Uppercase is not allowed. Please try again.. "
        reload
        return 1
    fi
        BLUE "
Enter a password for${nc} ${cyan}"${USERNAME}"${blue}: "
        read -p "
==> " USERPASSWD
        NC

    if [[ -z "${USERPASSWD}" ]]; then
        sleep 0.5
        RED "
        [!] Please enter a password for "${USERNAME}" to continue "
        reload
        return 1
    fi

        BLUE "
Re-enter${nc} ${cyan}"${USERNAME}"'s ${blue}password: "
        read -p "
==> " USERPASSWD2
        NC

    if [[ "${USERPASSWD}" != "${USERPASSWD2}" ]]; then
        sleep 0.5
        RED "
        [!] Passwords don't match. Please try again.. "
        reload
        return 1
    fi
        ok
}
###########################################################################################
rootuser_setup (){

        prompt="Root User"
        sleep 0.5
        NC "
_______________________

${purple}###${nc} Root User Setup ${purple}###${nc}
        "
        BLUE "

Enter a password for the${nc}${cyan} Root ${blue}user: "
        read -p "
==> " ROOTPASSWD

    if [[ -z "${ROOTPASSWD}" ]]; then
        sleep 0.5
        RED "

        [!] Please enter a password for the Root user to continue "
        reload
        return 1
    fi

        BLUE "

Re-enter${nc} ${cyan}Root ${blue}user's password: "
        read -p "
==> " ROOTPASSWD2
        NC

    if [[ "${ROOTPASSWD}" != "${ROOTPASSWD2}" ]]; then
        sleep 0.5
        RED "
        [!] Passwords don't match. Please try again.. "
        reload
        return 1
    fi
        ok
}
###########################################################################################
slct_hostname (){

        prompt="Hostname"
        sleep 0.5
        NC "
______________________

${purple}###${nc} Hostname Setup ${purple}###${nc}
        "
        BLUE "

Enter a hostname: "
        read -p "
==> " HOSTNAME
        NC

    if [[ -z "${HOSTNAME}" ]]; then
        sleep 0.5
        RED "
        [!] Please enter a hostname to continue "
        reload
        return 1

    elif [[ "${HOSTNAME}" =~ [[:upper:]] ]]; then
        sleep 0.5
        RED "
        [!] Lowercase is preferred. Please try again.. "
        reload
        return 1
    fi
        ok
}
###########################################################################################
sys_submn (){

        sleep 0.5
        NC "
____________________________

${purple}###${nc} System Configuration ${purple}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Kernel & Bootloader Setup

            [2]  Filesystem & Swap Setup

            [3]  Graphics Setup

            [4]  Desktop Setup

            [5]  EFI Boot Entries Deletion

            [6]  Wireless Regulatory Domain Setup

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -p "
==> " sysmenu

    case "${sysmenu}" in
        1)
        until slct_krnl; do : ; done
        until ask_bootldr; do : ; done
        return 1;;
        2)
        until ask_fs; do : ; done
        until ask_swap; do : ; done
        return 1;;
        3)
        until dtct_vga; do : ; done
        return 1;;
        4)
        until slct_dsktp; do : ; done
        return 1;;
        5)
        until boot_entr; do : ; done
        return 1;;
        6)
        until wireless_rgd; do : ; done
        return 1;;
        "")
        until main_menu; do : ; done;;
        *)
        invalid
        return 1;;
    esac
}
###########################################################################################
slct_krnl (){

        prompt="Kernel"
        sleep 0.5
        NC "
________________________

${purple}###${nc} Kernel Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a Kernel: "
        NC "

            [1]  Linux

            [2]  Linux LTS

            [3]  Linux Hardened

            [4]  Linux Zen "
        BLUE "


Enter a number: "
        read -p "
==> " kernelnmbr

    case "${kernelnmbr}" in
        1)
        kernel="linux"
        kernelname="'Linux'"
        entrname="Arch Linux";;
        2)
        kernel="linux-lts"
        kernelname="'Linux LTS'"
        entrname="Arch Linux LTS";;
        3)
        kernel="linux-hardened"
        kernelname="'Linux Hardened'"
        entrname="Arch Linux Hardened";;
        4)
        kernel="linux-zen"
        kernelname="'Linux Zen'"
        entrname="Arch Linux Zen";;
        "")
        sleep 0.5
        RED "

        [!] Please select a Kernel "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac
        sleep 0.5
        YELLOW "

        ###  The ${kernelname} kernel has been selected
        "
    if [[ "${kernelnmbr}" == "3" ]]; then
        CYAN "
        [!] Swapping is not supported
        "
    fi
        ok
}
###########################################################################################
ask_bootldr (){

        prompt="Bootloader"
        sleep 0.5
        NC "
____________________________

${purple}###${nc} Bootloader Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a Bootloader: "
        NC "

            [1]  Systemd-boot

            [2]  Grub

            [3]  Other    ${cyan}[!] Edit the installer script beforehand [!]${nc} "
        BLUE "


Enter a number: "
        read -p "
==> " bootloader

    case "${bootloader}" in
        1)
        sleep 0.5
        YELLOW "

        ###  'Systemd-boot' has been selected
        ";;
        2)
        sleep 0.5
        YELLOW "

        ###  'Grub' has been selected
        ";;
        3)
        sleep 0.5
        YELLOW "

        ###  Custom choice:    ${red}[!] Edit the installer script beforehand [!]${nc}
        "
        skip;;
        "")
        sleep 0.5
        RED "

        [!] Please select a Bootloader "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac
        ok
}
###########################################################################################
ask_fs (){

        prompt="Filesystem Setup"
        sleep 0.5
        NC "
____________________________

${purple}###${nc} Filesystem Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select Filesystem to be used: "
        NC "

            [1]  Ext4

            [2]  Btrfs "
        BLUE "


Enter a number: "
        read -p "
==> " fs
        NC

    case "${fs}" in
        1)
        fsname="'Ext4'"
        fs_mod="ext4"
        fstools="e2fsprogs"
        roottype="/ROOT"
        sleep 0.5
        YELLOW "
        ###  "${fsname}" has been selected
        ";;
        2)
        fsname="'Btrfs'"
        fs_mod="btrfs"
        fstools="btrfs-progs"
        roottype="/@"
        btrfs_opts="rootflags=subvol=@"
        sleep 0.5
        YELLOW "
        ###  "${fsname}" has been selected
        "
        sleep 0.5
        YELLOW "

        >  Label your Btrfs snapshot directory: "
        BLUE "


Enter a name: "
        read -p "
==> " snapname

            if [[ -z "${snapname}" ]]; then
                invalid
                return 1
            fi;;
        "")
        sleep 0.5
        RED "
        [!] Please select a Filesystem "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac
        ok
}
###########################################################################################
ask_swap (){

        prompt="Swap Setup"
        sleep 0.5
        NC "
______________________

${purple}###${nc} Swap Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select Swap type: "
        NC "

            [1]  Swap Partition

            [2]  Swapfile

            [3]  None "
        BLUE "


Enter a number: "
        read -p "
==> " swapmode

    case "${swapmode}" in
        1)
        swaptype="swappart"
        sleep 0.5
        YELLOW "

        ###  Swap Partition has been selected
        ";;
        2)
            if [[ "${fs}" == "1" ]]; then
                swaptype="swapfile"
            elif [[ "${fs}" == "2" ]]; then
                swaptype="swapfile_btrfs"
            fi
        sleep 0.5
        YELLOW "

        ###  Swapfile has been selected

        "
        until set_swapsize; do : ; done;;
        3)
        sleep 0.5
        YELLOW "

        ###  No Swap will be used
        "
        skip;;
        "")
        sleep 0.5
        RED "

        [!] Please make a selection to continue "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac
        ok
}
###########################################################################################
set_swapsize (){

        BLUE "
Enter Swapfile size ${bwhite}(in GiB)${blue}: "
        read -p "
==> " swapsize
        NC

    if [[ -z "${swapsize}" ]]; then
        sleep 0.5
        RED "
        [!] Please enter a value to continue "
        reload
        NC "
        "
        return 1
    elif [[ "${swapsize}" =~ [[:digit:]] ]]; then
        NC "

==> [${green}Swapsize OK${nc}] "

    else
        sleep 0.5
        RED "
        [!] Please use only digits as a value "
        reload
        NC "
        "
        return 1
    fi
}
###########################################################################################
dtct_vga (){

        prompt="Graphics"
        sleep 0.5
        NC "
______________________

${purple}###${nc} Graphics Setup ${purple}###${nc}
        "
    vgacount="$(lspci | grep -E -c 'VGA|Display|3D')"
    vgacard="$(lspci | grep -E 'VGA|Display|3D' | sed 's/^.*: //g')"
    intelcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Intel Corporation')"
    intelcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Intel Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"
    amdcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Advanced Micro Devices')"
    amdcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Advanced Micro Devices' | sed 's/.*\[AMD\/ATI\] //g' | cat --number | sed 's/.[0-9]//')"
    nvidiacount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'NVIDIA Corporation')"
    nvidiacards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'NVIDIA Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"
    hypervisor="$(systemd-detect-virt)"

    if [[ "${vgacount}" == "1" ]]; then

            if [[ "${intelcount}" -ge "1" ]]; then
                vendor="Intel"
                sourcetype="Open-source"
                perf_stream="dev.i915.perf_stream_paranoid = 0"
                vgapkgs="intel-media-driver libva-intel-driver vulkan-intel vulkan-mesa-layers"
            elif [[ "${amdcount}" -ge "1" ]]; then
                vendor="AMD"
                sourcetype="Open-source"
                vgapkgs="libva-mesa-driver mesa-vdpau vulkan-mesa-layers vulkan-radeon"
            elif [[ "${nvidiacount}" -ge "1" ]]; then
                vendor="Nvidia"
                sourcetype="Proprietary"
            elif [[ "${hypervisor}" != "none" ]]; then
                vendor="Virtual Machine"
            fi

        sleep 0.5
        YELLOW "

        ###  ""${vendor}"" Graphics detected : ${nc}""${vgacard}"""

            if [[ "${vendor}" == "Virtual Machine" ]]; then
                vgaconf="n"
                NC
                skip
                ok
                return 0
            fi

        YELLOW "
        ###  "${sourcetype}" drivers will be used


        >  Enable HW acceleration and auto-configure the graphics subsystem ? [y/n]
        "
        if [[ "${vendor}" == "Nvidia" ]]; then
        RED "
        [!] The latest drivers will be installed.

        [!] Apply only if your hardware is currently being supported "
        fi

BLUE "


Enter [y/n]: "
        read -p "
==> " vgaconf

        if [[ "${vgaconf}" == "y" ]]; then

            if [[ "${vendor}" == "AMD" ]]; then
                sleep 0.5
                YELLOW "

        >  Enable 'amdgpu' driver support for: "
                NC "

            [1]  'Southern Islands' Graphics

            [2]  'Sea Islands' Graphics "
                BLUE "


Enter a number ${bwhite}(empty to Skip)${blue}: "
                read -p "
==> " islands
                    if [[ -z "${islands}" ]]; then
                        skip
                        NC
                    elif [[ "${islands}" == "1" ]]; then
                        NC "

==> [${green}Southern Islands OK${nc}]

                        "
                    elif [[ "${islands}" == "2" ]]; then
                        NC "

==> [${green}Sea Islands OK${nc}]

                    "
                    else
                        invalid
                        return 1
                    fi

            elif [[ "${vendor}" == "Nvidia" ]]; then

                if [[ "${kernelnmbr}" == "1" ]]; then
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia nvidia-settings nvidia-utils opencl-nvidia"
                elif [[ "${kernelnmbr}" == "2" ]]; then
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-lts nvidia-settings nvidia-utils opencl-nvidia"
                else
                    vgapkgs="libva-nvidia-driver libvdpau-va-gl nvidia-dkms nvidia-settings nvidia-utils opencl-nvidia"
                fi
            fi

            sleep 0.5
            YELLOW "

        ###  ""${vendor}"" Graphics will be automatically configured
            "
        elif [[ "${vgaconf}" == "n" ]]; then
            NC
            skip
        else
            invalid
            return 1
        fi
    else
            if [[ "${vgacount}" == "2" ]]; then
                vendor="Dual"
            elif [[ "${vgacount}" == "3" ]]; then
                vendor="Triple"
            fi

        sleep 0.5
        YELLOW "

        ###  "${vendor}" Graphics setup detected, consisting of: "
        NC "

        _______________________________"

            if [[ "${intelcount}" -ge "1" ]]; then
                perf_stream="dev.i915.perf_stream_paranoid = 0"
                NC "
        ["${intelcount}"]  Intel   Graphics device(s)

${intelcards}
        _______________________________"
            fi

            if [[ "${amdcount}" -ge "1" ]]; then
                NC "
        ["${amdcount}"]  AMD     Graphics device(s)

${amdcards}
        _______________________________"
            fi

            if [[ "${nvidiacount}" -ge "1" ]]; then
                NC "
        ["${nvidiacount}"]  Nvidia  Graphics device(s)

${nvidiacards}
        _______________________________"
            fi

        YELLOW "


        >  Please configure the graphics subsystem after installation has finished
        "
    fi
        ok
}
###########################################################################################
slct_dsktp (){

        prompt="Desktop Setup"
        sleep 0.5
        NC "
_________________________

${purple}###${nc} Desktop Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a Desktop: "
        NC "

            [1]  Plasma

            [2]  Optimized Plasma & Systemd-boot & Wayland

            [3]  Gnome

            [4]  Xfce

            [5]  Cinnamon

            [6]  Deepin

            [7]  Budgie

            [8]  Lxqt

            [9]  Mate

           [10]  Base System (No Desktop)

           [11]  Custom System    ${cyan}[!] Edit the installer script beforehand [!]${nc} "
        BLUE "


Enter a number: "
        read -p "
==> " packages

    case "${packages}" in
        1)  desktopname="'Plasma'";;
        2)  desktopname="'Optimized Plasma'";;
        3)  desktopname="'Gnome'";;
        4)  desktopname="'Xfce'";;
        5)  desktopname="'Cinnamon'";;
        6)  desktopname="'Deepin'";;
        7)  desktopname="'Budgie'";;
        8)  desktopname="'Lxqt'";;
        9)  desktopname="'Mate'";;
       10)  desktopname="'Base System'";;
       11)  desktopname="'Custom System'";;
       "")
        sleep 0.5
        RED "

        [!] Please make a selection.. "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac

        sleep 0.5
        YELLOW "

        ###  ${desktopname} has been selected
        "
        ok
}
###########################################################################################
boot_entr (){

        prompt="Boot Entries"
        sleep 0.5
        NC "
_________________________________

${purple}###${nc} EFI Boot Entries Deletion ${purple}###${nc}
        "
        YELLOW "

        >  Select an EFI Boot Entry to Delete  ${red}[!] (CAUTION) [!]${yellow}

        "
        sleep 0.5
        efibootmgr
        boot_entry=" "

    while [[ -n "${boot_entry}" ]]; do
        BLUE "


Enter a${nc} ${cyan}BootOrder${blue} number for Deletion ${bwhite}(empty to Skip)${blue}: "
        read -p "
==> " boot_entry
        NC

            if [[ -n "${boot_entry}" ]]; then

                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.5
                    RED "
        [!] Root Privileges Missing.. "
                    reload
                    until sys_submn; do : ; done
                fi

                if efibootmgr -b "${boot_entry}" -B; then
                    sleep 0.5
                    NC "

==> [${green}Entry "${boot_entry}" Deleted${nc}] "
                else
                    err_try
                    return 1
                fi
            else
                skip
                ok
            fi
    done
}
###########################################################################################
wireless_rgd (){

        prompt="Wireless Regdom Setup"
        hypervisor="$(systemd-detect-virt)"
        sleep 0.5
        NC "
________________________________________

${purple}###${nc} Wireless Regulatory Domain Setup ${purple}###${nc}
        "
        if [[ "${hypervisor}" != "none" ]]; then
        sleep 0.5
        YELLOW "

        ###  Virtual Machine detected
        "
            skip
            ok
            return 0
        fi

        BLUE "

Enter your Country Code, ie:${nc} ${cyan}US ${bwhite}(empty to Skip)${blue}: "
        read -p "
==> " REGDOM

    if [[ -z "${REGDOM}" ]]; then
        NC
        skip
    elif [[ "${REGDOM}" =~ [[:lower:]] ]]; then
        sleep 0.5
        RED "

        [!] Lowercase is not allowed. Please try again.. "
        reload
        return 1
    elif ! [[ "${REGDOM}" =~ ^(00|AD|AE|AF|AI|AL|AM|AN|AR|AS|AT|AU|AW|AZ|BA|BB|BD|BE|BF|BG|BH|BL|BM|BN|BO|BR|BS|BT|BY|BZ|CA|CF|CH|CI|CL|CN|CO|CR|CU|CX|CY|CZ|DE|DK|DM|DO|DZ|EC|EE|EG|ES|ET|FI|FM|FR|GB|GD|GE|GF|GH|GL|GP|GR|GT|GU|GY|HK|HN|HR|HT|HU|ID|IE|IL|IN|IR|IS|IT|JM|JO|JP|KE|KH|KN|KP|KR|KW|KY|KZ|LB|LC|LI|LK|LS|LT|LU|LV|MA|MC|MD|MF|MH|MK|MN|MO|MP|MQ|MR|MT|MU|MV|MW|MX|MY|NG|NI|NL|NO|NP|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PR|PT|PY|PY|QA|RE|RO|RS|RU|RW|SA|SE|SG|SI|SK|SN|SR|SV|SY|TC|TD|TG|TH|TN|TR|TT|TW|TZ|UA|UG|US|UY|UZ|VC|VE|VI|VN|VU|WF|WS|YE|YT|ZA|ZW)$ ]]; then
        invalid
        return 1
    else
        wireless_reg="wireless-regdb"
        sleep 0.5
        YELLOW "

        ###  '"${REGDOM}"' Country Code has been selected
        "
    fi
        ok
}
###########################################################################################
dsks_submn (){

        sleep 0.5
        NC "
_______________________

${purple}###${nc} Disk Management ${purple}###${nc}
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Disk GPT Manager

            [2]  Partition Manager

            [3]  Installation Disk & Encryption

            [ ]  Return to Main Menu "
        BLUE "


Enter a number: "
        read -p "
==> " diskmenu

    case ${diskmenu} in
        1)  until gpt_mngr; do : ; done;;
        2)  until disk_mngr; do : ; done;;
        3)  until instl_dsk; do : ; done
                if [[ -z "${fs}" ]]; then
                    sleep 0.5
                    RED "


        [!] Please complete 'Filesystem Setup' to continue
                    "
                    until ask_fs; do : ; done
                fi
            until ask_crypt; do : ; done
            return 1;;
       "")  until main_menu; do : ; done;;
        *)  invalid
            return 1;;
    esac
}
###########################################################################################
gpt_mngr (){

        prompt="Disk GPT"
        sleep 0.5
        NC "
________________________

${purple}###${nc} Disk GPT Manager ${purple}###${nc}
        "
        gpt_dsk_nmbr=" "

    while [[ -n "${gpt_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk to manage its GPT: "
        NC "

${disks} "
        BLUE "


Enter a disk number ${bwhite}(empty to Skip)${blue}: "
        read -p "
==> " gpt_dsk_nmbr

        if [[ -n "${gpt_dsk_nmbr}" ]]; then
            gptdrive="$(echo "${disks}" | awk "\$1 == "${gpt_dsk_nmbr}" { print \$2}")"
                if [[ -e "${gptdrive}" ]]; then
                    if [[ "${run_as}" != "root" ]]; then
                        sleep 0.5
                        RED "

        [!] Root Privileges Missing.. "
                        reload
                        until dsks_submn; do : ; done
                    fi

                    NC "
______________________________________________
                    "
                    gdisk "${gptdrive}"
                    sleep 0.5
                    NC "

==> [${green}${gptdrive} OK${nc}] "
                else
                    invalid
                    return 1
                fi
        else
            skip
            ok

            if [[ "${quick_install}" == "1" ]]; then
                until instl_dsk; do : ; done
            else
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###########################################################################################
disk_mngr (){

        prompt="Disks"
        sleep 0.5
        NC "
_________________________

${purple}###${nc} Partition Manager ${purple}###${nc}
        "
        cgdsk_nmbr=" "

    while [[ -n "${cgdsk_nmbr}" ]]; do
        NC "
- - - - - - - - - - - - - - - - - -

Discoverable Partitions GUID Codes:

${cyan}EFI${nc} system partition      >   ${cyan}ef00${nc}
Linux x86-64 ${cyan}root (/)${nc}     >   ${cyan}8304${nc}
Linux ${cyan}/home${nc}               >   ${cyan}8302${nc}
Linux ${cyan}swap${nc}                >   ${cyan}8200${nc}

- - - - - - - - - - - - - - - - - -
        "
        YELLOW "
        >  Select a disk to Manage: "
        NC "

${disks}"
        BLUE "


Enter a disk number${bwhite} (empty to Skip)${blue}: "
        read -p "
==> " cgdsk_nmbr

        if [[ -n "${cgdsk_nmbr}" ]]; then
            drive="$(echo "${disks}" | awk "\$1 =="${cgdsk_nmbr}" {print \$2}")"
                if [[ -e "${drive}" ]]; then
                    if [[ "${run_as}" != "root" ]]; then
                        sleep 0.5
                        RED "

        [!] Root Privileges Missing.. "
                        reload
                        until dsks_submn; do : ; done
                    fi
                    cgdisk "${drive}"
                    clear
                    sleep 0.5
                    NC "


==> [${green}Disk "${drive}" OK${nc}] "
                    return 1
                else
                    invalid
                    return 1
                fi
        else
            skip
            ok

            if [[ -z "${sanity}" ]]; then
                until dsks_submn; do : ; done
            elif [[ "${sanity}" == "no" ]]; then
                until instl_dsk; do : ; done
            elif [[ "${sanity}" == "ok" ]]; then
                if [[ "${automode}" == "1" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###########################################################################################
instl_dsk (){

        sleep 0.5
        NC "
___________________________________

${purple}###${nc} Installation Disk Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a disk to Install to: "
        NC "

${disks} "
        BLUE "


Enter a disk number: "
        read -p "
==> " instl_dsk_nmbr
        NC

    if [[ -n "${instl_dsk_nmbr}" ]]; then
        instl_drive="$(echo "${disks}" | awk "\$1 == "${instl_dsk_nmbr}" {print \$2}")"
            if [[ -e "${instl_drive}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.5
                    RED "
        [!] Root Privileges Missing.. "
                    reload
                    until dsks_submn; do : ; done
                fi
                volumes="$(fdisk -l | grep '^/dev' | cat --number)"
                rota="$(lsblk "${instl_drive}" --nodeps --noheadings --output=rota | awk "{print \$1}")"
                if [[ "${rota}" == "0" ]]; then
                    sbvl_mnt_opts="rw,noatime,compress=zstd:1"
                    trim="fstrim.timer"
                else
                    sbvl_mnt_opts="rw,compress=zstd"
                fi
                parttable="$(fdisk -l "${instl_drive}" | grep '^Disklabel type' | awk "{print \$3}")"
                if [[ "${parttable}" != "gpt" ]]; then
                    sleep 0.5
                    RED "
        [!] No GPT found on selected disk "
                    reload
                    until gpt_mngr; do : ; done
                    return 0
                fi
                until sanity_check; do : ; done
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
}
###########################################################################################
sanity_check (){

        prompt="Installation Disk"
        sleep 0.5
        NC "
____________________

${purple}###${nc} Sanity Check ${purple}###${nc}
        "
        root_dev="$(fdisk -l "${instl_drive}" | grep 'root' | awk "{print \$1}")"
        boot_dev="$(fdisk -l "${instl_drive}" | grep 'EFI' | awk "{print \$1}")"
        home_dev="$(fdisk -l "${instl_drive}" | grep 'home' | awk "{print \$1}")"
        swap_dev="$(fdisk -l "${instl_drive}" | grep 'swap' | awk "{print \$1}")"

    if [[ ! -e "${root_dev}" && ! -e "${boot_dev}" ]]; then
        sanity="no"
        sleep 0.5
        RED "
        [!] Linux x86-64 Root (/) Partition not detected "
        sleep 0.5
        RED "
        [!] EFI System Partition not detected "
        sleep 0.5
        YELLOW "

            -->  Please comply with the Discoverable Partitions Specification to continue..


        ### Ensure that a Linux x86-64 Root (/) Partition with a valid GUID code ${nc}(8304)${yellow} is present on disk

        ### Ensure that an EFI System Partition with a valid GUID code ${nc}(ef00)${yellow} is present on disk "
        sleep 0.5
        RED "

        [!] Sanity Check Failed [!] "
        sleep 2
        reload
        until disk_mngr; do : ; done
        return 0

    elif [[ ! -e "${root_dev}" && -e "${boot_dev}" ]]; then
        sanity="no"
        sleep 0.5
        NC "

==> [EFI System Partition ${green}OK${nc}] "
        sleep 0.5
        RED "

        [!] Linux x86-64 Root (/) Partition not detected "
        sleep 0.5
        YELLOW "

            -->  Please comply with the Discoverable Partitions Specification to continue..


        ### Ensure that a Linux x86-64 Root (/) Partition with a valid GUID code ${nc}(8304)${yellow} is present on disk "
        sleep 0.5
        RED "

        [!] Sanity Check Failed [!] "
        sleep 2
        reload
        until disk_mngr; do : ; done
        return 0

    elif [[ -e "${root_dev}" && ! -e "${boot_dev}" ]]; then
        sanity="no"
        sleep 0.5
        NC "

==> [Linux x86-64 Root (/) ${green}OK${nc}] "
        sleep 0.5
        RED "

        [!] EFI Partition not detected "
        sleep 0.5
        YELLOW "

            -->  Please comply with the Discoverable Partitions Specification to continue..


        ### Ensure that an EFI System Partition with a valid GUID code ${nc}(ef00)${yellow} is present on disk "
        sleep 0.5
        RED "

        [!] Sanity Check Failed [!] "
        sleep 2
        reload
        until disk_mngr; do : ; done
        return 0

    elif [[ -e "${root_dev}" && -e "${boot_dev}" ]]; then
        sleep 0.5
        NC "

==> [Linux x86-64 Root (/) ${green}OK${nc}] "
        sleep 0.5
        NC "

==> [EFI System Partition ${green}OK${nc}] "
    fi

    if [[ "${swapmode}" == "1" ]]; then
        if [[ -e "${swap_dev}" ]]; then
            sleep 0.5
            NC "

==> [Linux Swap ${green}OK${nc}] "
        else
            sanity="no"
            sleep 0.5
            RED "

        [!] Linux Swap Partition not detected "
            sleep 0.5
            YELLOW "

            -->  Please comply with the Discoverable Partitions Specification to continue..


        ### Ensure that a Linux Swap Partition with a valid GUID code ${nc}(8200)${yellow} is present on disk "
            sleep 0.5
            RED "

        [!] Sanity Check Failed [!] "
            sleep 2
            reload
            until disk_mngr; do : ; done
            return 0
        fi
    fi

    if [[ -e "${home_dev}" ]]; then
        sleep 0.5
        NC "

==> [Linux (/Home) ${green}OK${nc}] "
    fi

        sanity="ok"

    if [[ "${sanity}" == "ok" ]]; then
        ok
    fi
}
###########################################################################################
ask_crypt (){

        prompt="Encryption Setup"
        sleep 0.5
        NC "
________________________

${purple}###${nc} Encryption Setup ${purple}###${nc}
        "
        BLUE "

        >  Enable "${roottype}" Encryption? [LUKS] "
        NC "

            * Type '${cyan}no${nc}' to proceed without encryption

            * Type '${cyan}yes${nc}' to encrypt your "${roottype}"
        "
        read -p "
==> " encrypt
        NC

    if [[ "${encrypt}" == "no" ]]; then
        skip
        ok
        return 0

    elif [[ "${encrypt}" == "yes" ]]; then
        sleep 0.5
        YELLOW "
        >  Enter a name for your Encrypted "${roottype}" Partition: "
        BLUE "


Enter a name: "
        read -p "
==> " ENCROOT
        NC

        if [[ -z "${ENCROOT}" ]]; then
            sleep 0.5
            RED "
        [!] Please enter a name to continue "
            reload
            return 1
        elif [[ "${ENCROOT}" =~ [[:upper:]] ]]; then
            sleep 0.5
            RED "
        [!] Uppercase is not allowed. Please try again.. "
            reload
            return 1
        elif [[ -n "${ENCROOT}" ]]; then
            sleep 0.5
            NC "

==> [${green}Encrypted "${roottype}" Label OK${nc}] "
        fi

        if [[ -e "${home_dev}" ]]; then
            if [[ "${fs}" == "1" ]]; then
                sleep 0.5
                YELLOW "


        ###  A /HOME Partition has been detected "
                sleep 0.5
                BLUE "


        >  Encrypt /HOME partition? [LUKS] "
                NC "

            * Type '${cyan}no${nc}' to proceed without encryption

            * Type '${cyan}yes${nc}' to encrypt your /HOME
                "
                read -p "
==> " homecrypt
                NC

                    if [[ "${homecrypt}" == "no" ]]; then
                        skip
                        ok
                    elif [[ "${homecrypt}" == "yes" ]]; then
                        sleep 0.5
                        YELLOW "
        >  Enter a name for your Encrypted Home Partition: "
                        BLUE "


Enter a name: "
                        read -p "
==> " ENCRHOME
                        NC

                        if [[ -z "${ENCRHOME}" ]]; then
                            sleep 0.5
                            RED "
        [!] Please enter a name to continue "
                            reload
                            return 1
                        elif [[ "${ENCRHOME}" =~ [[:upper:]] ]]; then
                            sleep 0.5
                            RED "
        [!] Uppercase is not allowed. Please try again.. "
                            reload
                            return 1
                        elif [[ -n "${ENCRHOME}" ]]; then
                            sleep 0.5
                            NC "

==> [${green}Encrypted /HOME Label OK${nc}] "
                            ok
                        fi

                    else
                        sleep 0.5
                        RED "
        [!] Please type 'yes' or 'no' to continue "
                        reload
                        return 1
                    fi
            fi
        fi
    else
        sleep 0.5
        RED "
        [!] Please type 'yes' or 'no' to continue "
        reload
        return 1

        ok
    fi
}
###########################################################################################
instl (){

        quick_install="1"

    if [[ -z "${SETLOCALE}" ]]; then
        sleep 0.5
        RED "


        [!] Please complete 'Locale & Keyboard Layout Selection' to continue

        "
        until slct_locale; do : ; done
        until slct_kbd; do : ; done
    fi

    if [[ -z "${USERNAME}" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'User, Root User & Hostname Setup' to continue

        "
        until user_setup; do : ; done
        until rootuser_setup; do : ; done
        until slct_hostname; do : ; done
    fi

    if [[ -z "${kernelnmbr}" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'Kernel & Bootloader Selection' to continue

        "
        until slct_krnl; do : ; done
        until ask_bootldr; do : ; done
    fi

    if [[ -z "${fs}" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'Filesystem & Swap Selection' to continue

        "
        until ask_fs; do : ; done
        until ask_swap; do : ; done
    fi

    if [[ -z "${vgaconf}" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'Graphics Setup' to continue

        "
        until dtct_vga; do : ; done
    fi

    if [[ -z "${packages}" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'Desktop Selection' to continue

        "
        until slct_dsktp; do : ; done
    fi

    if [[ "${sanity}" != "ok" ]]; then
        sleep 0.5
        RED "



        [!] Please complete 'Installation Disk' & 'Encryption' to continue

        "
        until instl_dsk; do : ; done
        until ask_crypt; do : ; done
    fi
#------------------------------------------------------------------------------------------
    if [[ "${swapmode}" == "1" ]]; then
        until "${swaptype}"; do : ; done
    fi

    if [[ "${encrypt}" == "no" ]]; then
        until set_mode; do : ; done
        until confirm_status; do : ; done

    elif [[ "${encrypt}" == "yes" ]]; then
        until sec_erase; do : ; done
        until luks; do : ; done
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done

            if [[ "${swapmode}" == "2" ]]; then
                until "${swaptype}"; do : ; done
            fi
            if [[ -n "${REGDOM}" ]]; then
                until wireless_regdom; do : ; done
            fi

        until chroot_conf; do : ; done
    fi
}
###########################################################################################
swappart (){

        prompt="Swap Partition"
        sleep 0.5
        NC "
_________________________________

${purple}###${nc} Swap Partition Activation ${purple}###${nc}
        "
    if mkswap "${swap_dev}"; then
        ok
    else
        err_reload
        until disk_mngr; do : ; done
        until swappart; do : ; done
        return 0
    fi
}
###########################################################################################
set_mode (){

        sleep 0.5
        NC "
______________________

${purple}###${nc} Mode Selection ${purple}###${nc}
        "
        YELLOW "

        >  Select a Mode to continue: "
        NC "

            [1]  Auto     (Automatically Format, Label & Mount partitions)

            [2]  Manual   (Manually Format, Label & Mount partitions) "
        BLUE "


Enter a Mode number: "
        read -p "
==> " setmode
        NC

    case "${setmode}" in
        1)
        until auto_mode; do : ; done;;
        2)
        until manual_mode; do : ; done;;
        "")
        RED "
        [!] Please select a Mode to continue "
        reload
        return 1;;
        *)
        invalid
        return 1;;
    esac

        sleep 0.5
        NC "
------------------------------------------------------------------------------------------------------------


==> [${green}Filesystems OK${nc}]


        "
        sleep 0.5
        lsblk -f
        NC
        sleep 1
}
###########################################################################################
auto_mode (){

        automode="1"
        sleep 0.5
        YELLOW "

        >  Auto Mode Selected

        "
        sleep 1

    if [[ "${fs}" == "1" ]]; then
        if mkfs.ext4 -F -L Root "${root_dev}"; then
            if mount "${root_dev}" /mnt; then
                sleep 0.5
                NC "

==> [${green}/ROOT OK${nc}]

                "
            else
                umount_manual
                until disk_mngr; do : ; done
                until form_root; do : ; done
                until mount_mnt; do : ; done
            fi
        else
            umount_manual
            until disk_mngr; do : ; done
            until form_root; do : ; done
            until mount_mnt; do : ; done
        fi
#------------------------------------------------------------------------------------------
    elif [[ "${fs}" == "2" ]]; then
        mkfs.btrfs -f -L ROOT "${root_dev}" &&
        mount "${root_dev}" /mnt &&
        btrfs subvolume create /mnt/@ &&
        btrfs subvolume create /mnt/@home &&
        btrfs subvolume create /mnt/@cache &&
        btrfs subvolume create /mnt/@log &&
        btrfs subvolume create /mnt/@tmp &&
        btrfs subvolume create /mnt/@snapshots &&
        if [[ "${swapmode}" == "2" ]]; then
            btrfs subvolume create /mnt/@swap
        fi
        if umount /mnt; then
        mount -o "${sbvl_mnt_opts}",subvol=@ "${root_dev}" /mnt &&
        if [[ "${swapmode}" == "2" ]]; then
            mkdir -p /mnt/swap &&
            mount -o rw,nodatacow,subvol=@swap "${root_dev}" /mnt/swap
        fi
        mkdir -p /mnt/{var/cache,home,var/log,var/tmp,"${snapname}"} &&
        mount -o "${sbvl_mnt_opts}",subvol=@cache "${root_dev}" /mnt/var/cache &&
        mount -o "${sbvl_mnt_opts}",subvol=@home "${root_dev}" /mnt/home &&
        mount -o "${sbvl_mnt_opts}",subvol=@log "${root_dev}" /mnt/var/log &&
        mount -o "${sbvl_mnt_opts}",subvol=@snapshots "${root_dev}" /mnt/"${snapname}" &&
            if mount -o "${sbvl_mnt_opts}",subvol=@tmp "${root_dev}" /mnt/var/tmp; then
                sleep 0.5
                NC "

==> [${green}/@ OK${nc}]
                "
            else
                umount_manual
                until disk_mngr; do : ; done
                until form_root; do : ; done
                until mount_mnt; do : ; done
            fi
        else
            err_abort
        fi
    fi
        sleep 0.5
#------------------------------------------------------------------------------------------
    if mkdir -pv /mnt/boot; then
        if mkfs.fat -F 32 -n Boot "${boot_dev}"; then
            if mount "${boot_dev}" /mnt/boot; then
                sleep 0.5
                NC "

==> [${green}/BOOT OK${nc}]

                "
            else
                umount_manual
                until disk_mngr; do : ; done
                until form_efi; do : ; done
                until mount_mnt; do : ; done
                until mount_boot; do : ; done
            fi
        else
            umount_manual
            until disk_mngr; do : ; done
            until form_efi; do : ; done
            until mount_mnt; do : ; done
            until mount_boot; do : ; done
        fi
    else
        sleep 0.5
        RED "
        [!] Failed creating /mnt/boot directory "
        abort
    fi
        sleep 0.5
#------------------------------------------------------------------------------------------
    if [[ -e "${home_dev}" && "${fs}" == "1" ]]; then
        BLUE "

        >  A /Home partition has been detected. Format as "${fsname}"? [y/n]


        "
        read -p "
==> " homeform

        if [[ "${homeform}" == "y" ]]; then
            if mkdir -pv /mnt/home; then
                if mkfs.ext4 -F -L Home "${home_dev}"; then
                    if mount "${home_dev}" /mnt/home; then
                        sleep 0.5
                        NC "

==> [${green}/HOME OK${nc}]

                        "
                    else
                        umount_manual
                        until disk_mngr; do : ; done
                        until form_home; do : ; done
                        until mount_mnt; do : ; done
                        until mount_boot; do : ; done
                        until mount_home; do : ; done
                    fi
                else
                    umount_manual
                    until disk_mngr; do : ; done
                    until form_home; do : ; done
                    until mount_mnt; do : ; done
                    until mount_boot; do : ; done
                    until mount_home; do : ; done
                fi
            else
                sleep 0.5
                RED "
        [!] Failed creating /mnt/home directory "
                abort
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
            NC "

==> [${green}/HOME OK${nc}]

            "
        else
            invalid
            ask_homepart_form
        fi
    fi
        automode="0"
}
###########################################################################################
manual_mode (){

    if [[ -e "${home_dev}" ]]; then
        if [[ "${fs}" == "1" ]]; then
            until form_efi; do : ; done
            until form_root; do : ; done
            until form_home; do : ; done
            until mount_mnt; do : ; done
            mkdir -pv /mnt/{boot,home}
            until mount_boot; do : ; done
            until mount_home; do : ; done
        elif [[ "${fs}" == "2" ]]; then
            until form_efi; do : ; done
            until form_root; do : ; done
            until mount_mnt; do : ; done
            mkdir -pv /mnt/boot
            until mount_boot; do : ; done
        fi
    else
        until form_efi; do : ; done
        until form_root; do : ; done
        until mount_mnt; do : ; done
        mkdir -pv /mnt/boot
        until mount_boot; do : ; done
    fi
}
###########################################################################################
form_efi (){

        sleep 0.5
        NC "
______________________________

${purple}###${nc} Format /BOOT Partition ${purple}###${nc}
        "
        YELLOW "

        >  Select a partition to format as EFI [/BOOT] "
        NC "

${volumes} "
        BLUE "


Enter a partition number: "
        read -p "
==> " form_boot_nmbr

    if [[ -n "${form_boot_nmbr}" ]]; then
        bootpart="$(echo "${volumes}" | awk "\$1 == "${form_boot_nmbr}" { print \$2}")"
            if [[ -e "${bootpart}" ]]; then
                if mkfs.fat -F 32 -n BOOT "${bootpart}"; then
                    sleep 0.5
                    NC "


==> [${green}Format /BOOT OK${nc}] "
                    sleep 0.5
                    NC "


==> [${green}Label /BOOT OK${nc}] "
                    return 0
                else
                    umount_abort
                    until disk_mngr; do : ; done
                    until form_efi; do : ; done
                    return 0
                fi
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
}
###########################################################################################
form_root (){

        sleep 0.5
        NC "
_____________________________

${purple}###${nc} Format Root Partition ${purple}###${nc}
        "
        YELLOW "

        >  Select a partition to format as "${fsname}" ["${roottype}"] "
        NC "

${volumes} "
        BLUE "


Enter a partition number: "
        read -p "
==> " form_root_nmbr

    if [[ -n "${form_root_nmbr}" ]]; then
        rootpart="$(echo "${volumes}" | awk "\$1 == "${form_root_nmbr}" { print \$2}")"
            if [[ -e "${rootpart}" ]]; then
#------------------------------------------------------------------------------------------
                if [[ "${fs}" == "1" ]]; then
                    if mkfs.ext4 -F "${rootpart}"; then
                        sleep 0.5
                        NC "


==> [${green}Format "${roottype}" OK${nc}] "
                    else
                        umount_abort
                        until disk_mngr; do : ; done
                        until form_root; do : ; done
                        return 0
                    fi
#------------------------------------------------------------------------------------------
                elif [[ "${fs}" == "2" ]]; then
                    if mkfs.btrfs -f "${rootpart}"; then
                        mount "${rootpart}" /mnt &&
                        btrfs subvolume create /mnt/@ &&
                        btrfs subvolume create /mnt/@home &&
                        btrfs subvolume create /mnt/@cache &&
                        btrfs subvolume create /mnt/@log &&
                        btrfs subvolume create /mnt/@tmp &&
                        btrfs subvolume create /mnt/@snapshots &&
                        if [[ "${swapmode}" == "2" ]]; then
                            btrfs subvolume create /mnt/@swap
                        fi
                        if umount /mnt; then
                            sleep 0.5
                            NC "


==> [${green}Format "${roottype}" OK${nc}] "
                        else
                            sleep 0.5
                            RED "
        [!] Unmounting failed "
                            abort
                        fi
                    else
                        reload
                        until disk_mngr; do : ; done
                        until form_root; do : ; done
                        return 0
                    fi
                fi
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
#------------------------------------------------------------------------------------------
        rootpartname=" "

    while [[ -n "${rootpartname}" ]]; do
        sleep 0.5
        YELLOW "

        >  Label the "${roottype}" partition "
        BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
        read -p "
==> " rootpartname

        if [[ -n "${rootpartname}" ]]; then
            if [[ "${fs}" == "1" ]]; then
                e2label "${rootpart}" "${rootpartname}"
            elif [[ "${fs}" == "2" ]]; then
                mount "${rootpart}" /mnt &&
                btrfs filesystem label /mnt "${rootpartname}" &&
                umount /mnt
            fi

            if [[ "$?" -eq 0 ]]; then
                sleep 0.5
                NC "

==> [${green}Label "${roottype}" OK${nc}] "
                return 0
            else
                err_try
                until disk_mngr; do : ; done
                until form_root; do : ; done
                return 0
            fi
        fi

        skip
        NC "

==> [${green}Label "${roottype}" OK${nc}] "
    done
}
###########################################################################################
ask_homepart_form (){

    if [[ -e "${home_dev}" && "${fs}" == "1" ]]; then
        BLUE "



        >  A /Home partition has been detected. Format as "${fsname}"? [y/n]


        "
        read -p "
==> " homeform
        NC

        if [[ "${homeform}" == "y" ]]; then
            if mkdir -pv /mnt/home; then
                if mkfs.ext4 -F -L Home "${home_dev}"; then
                    if mount "${home_dev}" /mnt/home; then
                        sleep 0.5
                        NC "

==> [${green}/HOME OK${nc}]

                        "
                    else
                        umount_manual
                        until disk_mngr; do : ; done
                        until form_home; do : ; done
                        until mount_mnt; do : ; done
                        until mount_boot; do : ; done
                        until mount_home; do : ; done
                    fi
                else
                    umount_manual
                    until disk_mngr; do : ; done
                    until form_home; do : ; done
                    until mount_mnt; do : ; done
                    until mount_boot; do : ; done
                    until mount_home; do : ; done
                fi
            else
                sleep 0.5
                RED "
        [!] Failed creating /mnt/home directory "
                abort
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
            NC "

==> [${green}/HOME OK${nc}]

            "
        else
            invalid
            ask_homepart_form
        fi
    fi
}
###########################################################################################
form_home (){

        sleep 0.5
        NC "
______________________________

${purple}###${nc} Format /HOME Partition ${purple}###${nc}
        "
        form_home_nmbr=" "

    while [[ -n "${form_home_nmbr}" ]]; do
        YELLOW "

        >  Select a partition to format as 'Ext4' [/HOME] "
        NC "


${volumes} "
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -p "
==> " form_home_nmbr

        if [[ -n "${form_home_nmbr}" ]]; then
            homepart="$(echo "${volumes}" | awk "\$1 == "${form_home_nmbr}" { print \$2}")"
                if [[ -e "${homepart}" ]]; then
                    if mkfs.ext4 -F "${homepart}"; then
                        sleep 0.5
                        NC "


==> [${green}Format /HOME OK${nc}] "
                    else
                        umount_abort
                        until disk_mngr; do : ; done
                        until form_home; do : ; done
                        return 0
                    fi
                else
                    invalid
                    return 1
                fi

            YELLOW "

        >  Label the /HOME partition "
            BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
            read -p "
==> " homepartname

            if [[ -n "${homepartname}" ]]; then
                if e2label "${homepart}" "${homepartname}"; then
                    sleep 0.5
                    NC "

==> [${green}Label /HOME OK${nc}] "
                    return 0
                else
                    err_try
                    until disk_mngr; do : ; done
                    until form_home; do : ; done
                    return 0
                fi
            fi

            skip
            NC "


==> [${green}Label /HOME OK${nc}] "
            return 0
        else
            skip
            NC "


==> [${green}Format /HOME OK${nc}] "
            return 0
        fi
    done
}
###########################################################################################
mount_mnt (){

        sleep 0.5
        NC "
____________________________

${purple}###${nc} Mount Root Partition ${purple}###${nc}
        "
        YELLOW "

        >  Select a partition to mount to /mnt "
        NC "


${volumes} "
        BLUE "


Enter your${nc} ${cyan}"${roottype}"${blue} partition number: "
        read -p "
==> " mntroot_nmbr
        NC

    if [[ -n "${mntroot_nmbr}" ]]; then
        rootpart="$(echo "${volumes}" | awk "\$1 == "${mntroot_nmbr}" { print \$2}")"
            if [[ -e "${rootpart}" ]]; then
#------------------------------------------------------------------------------------------
                if [[ "${fs}" == "1" ]]; then
                    mount "${rootpart}" /mnt
#------------------------------------------------------------------------------------------
                elif [[ "${fs}" == "2" ]]; then
                    mount -o "${sbvl_mnt_opts}",subvol=@ "${rootpart}" /mnt &&
                    if [[ "${swapmode}" == "2" ]]; then
                        mkdir -p /mnt/swap &&
                        mount -o rw,nodatacow,subvol=@swap "${rootpart}" /mnt/swap
                    fi
                    mkdir -p /mnt/{var/cache,home,var/log,var/tmp,"${snapname}"} &&
                    mount -o "${sbvl_mnt_opts}",subvol=@cache "${rootpart}" /mnt/var/cache &&
                    mount -o "${sbvl_mnt_opts}",subvol=@home "${rootpart}" /mnt/home &&
                    mount -o "${sbvl_mnt_opts}",subvol=@log "${rootpart}" /mnt/var/log &&
                    mount -o "${sbvl_mnt_opts}",subvol=@snapshots "${rootpart}" /mnt/"${snapname}" &&
                    mount -o "${sbvl_mnt_opts}",subvol=@tmp "${rootpart}" /mnt/var/tmp
                fi
#------------------------------------------------------------------------------------------
                if [[ "$?" -eq 0 ]]; then
                    sleep 0.5
                    NC "

==> [${green}Mount "${roottype}" OK${nc}]

                    "
                    return 0
                else
                    umount_abort
                    until mount_mnt; do : ; done
                fi
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
}
###########################################################################################
mount_boot (){

        prompt="Mount /BOOT"
        sleep 0.5
        NC "
____________________________

${purple}###${nc} Mount Boot Partition ${purple}###${nc}
        "
        YELLOW "

        >  Select a partition to mount to /mnt/boot "
        NC "


${volumes} "
        BLUE "


Enter your${nc} ${cyan}/BOOT${blue} partition number: "
        read -p "
==> " mntboot_nmbr
        NC

    if [[ -n "${mntboot_nmbr}" ]]; then
        bootpart="$(echo "${volumes}" | awk "\$1 == "${mntboot_nmbr}" { print \$2}")"
            if [[ -e "${bootpart}" ]]; then
                if mount "${bootpart}" /mnt/boot; then
                    ok
                    return 0
                else
                    umount_abort
                    until mount_mnt; do : ; done
                    until mount_boot; do : ; done
                fi
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
}
###########################################################################################
mount_home (){

        prompt="Mount /HOME"
        sleep 0.5
        NC "
____________________________

${purple}###${nc} Mount Home Partition ${purple}###${nc}
        "
        YELLOW "

        >  Select a partition to mount to /mnt/home "
        NC "


${volumes} "
        BLUE "


Enter your${nc} ${cyan}/HOME${blue} partition number: "
        read -p "
==> " mnthome_nmbr
        NC

    if [[ -n "${mnthome_nmbr}" ]]; then
        homepart="$(echo "${volumes}" | awk "\$1 == "${mnthome_nmbr}" { print \$2}")"
            if [[ -e "${homepart}" ]]; then
                if mount "${homepart}" /mnt/home; then
                    ok
                    return 0
                else
                    umount_abort
                    until mount_mnt; do : ; done
                    until mount_boot; do : ; done
                    until mount_home; do : ; done
                fi
            else
                invalid
                return 1
            fi
    else
        choice
        return 1
    fi
}
###########################################################################################
confirm_status (){

        prompt="System Ready"
        sleep 0.5
        NC "
___________________________________

${purple}###${nc} Confirm Installation Status ${purple}###${nc}
        "
        BLUE "

        >  Proceed ? "
        NC "

            * Type '${cyan}yes${nc}' to continue installation

            * Type '${cyan}no${nc}' to revise installation

        "
        read -p "
==> " agree
        NC

    if [[ "${agree}" == "yes" ]]; then
        ok
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
            until wireless_regdom; do : ; done
        fi
        until chroot_conf; do : ; done

    elif [[ "${agree}" == "no" ]]; then
        reload
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Unmount Filesystems ${purple}###${nc}
        "
        if umount -R /mnt; then
            sleep 0.5
            NC "

==> [${green}Unmount OK${nc}]"
        else
            sleep 0.5
            RED "
        [!] Unmounting failed "
            abort
        fi

        pre_instl
        instl

    else
        sleep 0.5
        RED "
        [!] Please type 'yes' or 'no' to continue.. "
        reload
        return 1
    fi
}
###########################################################################################
pre_instl (){

    until slct_krnl; do : ; done
    until ask_bootldr; do : ; done
    until ask_fs; do : ; done
    until ask_swap; do : ; done
    until dtct_vga; do : ; done
    until slct_dsktp; do : ; done
    until instl_dsk; do : ; done
    until ask_crypt; do : ; done
}
###########################################################################################
sec_erase (){

        prompt="Secure Erasure"
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Secure Disk Erasure ${purple}###${nc}
        "
        erase_dsk_nmbr=" "

    while [[ -n "${erase_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk for Secure Erasure  ${red}[!] (CAUTION) [!]${nc} "
        NC "


${disks}"
        BLUE "


Enter a disk number${bwhite} (empty to Skip)${blue}: "
        read -p "
==> " erase_dsk_nmbr
        NC

        if [[ -n "${erase_dsk_nmbr}" ]]; then
            erasedrive="$(echo "${disks}" | awk "\$1 == "${erase_dsk_nmbr}" {print \$2}")"
                if [[ -e "${erasedrive}" ]]; then
                    cryptsetup open --type plain -d /dev/urandom "${erasedrive}" temp &&
                    dd if=/dev/zero of=/dev/mapper/temp status=progress bs=1M oflag=direct &&
                        if cryptsetup close temp; then
                            sleep 0.5
                            NC "


==> [${green}Drive "${erasedrive}" Erased OK${nc}] "
                        else
                            err_try
                            return 1
                        fi
                else
                    invalid
                    return 1
                fi
        else
            skip
        fi
    done
        ok
}            
###########################################################################################
luks (){

        sleep 0.5
        NC "
_______________________

${purple}###${nc} LUKS Encryption ${purple}###${nc}



        "
    if cryptsetup -y -v luksFormat --label CRYPTROOT "${root_dev}"; then
        if [[ "${rota}" == "0" ]]; then
            cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${root_dev}" "${ENCROOT}"
        else
            cryptsetup luksOpen "${root_dev}" "${ENCROOT}"
        fi
#------------------------------------------------------------------------------------------
            if [[ "${fs}" == "1" ]]; then
                if mkfs.ext4 -F -L ROOT /dev/mapper/"${ENCROOT}"; then
                    if mount /dev/mapper/"${ENCROOT}" /mnt; then
                        sleep 0.5
                        NC "

==> [${green}Encrypted Root OK${nc}]

                        "
                    else
                        err_abort
                    fi
                else
                    err_abort
                fi
#------------------------------------------------------------------------------------------
            elif [[ "${fs}" == "2" ]]; then
                if mkfs.btrfs -L ROOT /dev/mapper/"${ENCROOT}"; then
                    mount /dev/mapper/"${ENCROOT}" /mnt &&
                    btrfs subvolume create /mnt/@ &&
                    btrfs subvolume create /mnt/@home &&
                    btrfs subvolume create /mnt/@cache &&
                    btrfs subvolume create /mnt/@log &&
                    btrfs subvolume create /mnt/@snapshots &&
                    btrfs subvolume create /mnt/@tmp &&
                    if [[ "${swapmode}" == "2" ]]; then
                        btrfs subvolume create /mnt/@swap
                    fi
                    umount /mnt &&
                    mount -o "${sbvl_mnt_opts}",subvol=@ /dev/mapper/"${ENCROOT}" /mnt &&
                    if [[ "${swapmode}" == "2" ]]; then
                        mkdir -p /mnt/swap &&
                        mount -o rw,nodatacow,subvol=@swap /dev/mapper/"${ENCROOT}" /mnt/swap
                    fi
                    mkdir -p /mnt/{var/cache,home,var/log,var/tmp,"${snapname}"} &&
                    mount -o "${sbvl_mnt_opts}",subvol=@cache /dev/mapper/"${ENCROOT}" /mnt/var/cache &&
                    mount -o "${sbvl_mnt_opts}",subvol=@home /dev/mapper/"${ENCROOT}" /mnt/home &&
                    mount -o "${sbvl_mnt_opts}",subvol=@log /dev/mapper/"${ENCROOT}" /mnt/var/log &&
                    mount -o "${sbvl_mnt_opts}",subvol=@snapshots /dev/mapper/"${ENCROOT}" /mnt/"${snapname}" &&
                    mount -o "${sbvl_mnt_opts}",subvol=@tmp /dev/mapper/"${ENCROOT}" /mnt/var/tmp &&
                    sleep 0.5
                    NC "

==> [${green}Encrypted /@ OK${nc}]

                    "
                else
                    err_abort
                fi
            fi
    else
        umount_abort
        until luks; do : ; done
    fi
#------------------------------------------------------------------------------------------
        NC "

        "
    if [[ -e "${swap_dev}" ]]; then
        if cryptsetup -y -v luksFormat --label CRYPTSWAP "${swap_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${swap_dev}" swap
            else
                cryptsetup luksOpen "${swap_dev}" swap
            fi
                if mkswap /dev/mapper/swap; then
                    sleep 0.5
                    NC "

==> [${green}Encrypted Swap OK${nc}]

                    "
                else
                    err_abort
                fi
        else
            umount_abort
            until luks; do : ; done
        fi
    fi
#------------------------------------------------------------------------------------------
        NC "

        "
    if [[ "${homecrypt}" == "yes" ]]; then
        if cryptsetup -y -v luksFormat --label CRYPTHOME "${home_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${home_dev}" "${ENCRHOME}"
            else
                cryptsetup luksOpen "${home_dev}" "${ENCRHOME}"
            fi
            mkfs.ext4 -F -L HOME /dev/mapper/"${ENCRHOME}" &&
            mkdir -p /mnt/home &&
                if mount /dev/mapper/"${ENCRHOME}" /mnt/home; then
                    sleep 0.5
                    NC "

==> [${green}Encrypted Home OK${nc}]

                    "
                else
                    err_abort
                fi
        else
            umount_abort
            until luks; do : ; done
        fi

    elif [[ "${homecrypt}" == "no" ]]; then
        BLUE "

        >  A /Home partition has been detected. Format as "${fsname}"? [y/n]

        "
        read -p "
==> " homeform
        NC

        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L HOME "${home_dev}"; then
                mkdir -p /mnt/home &&
                    if mount "${home_dev}" /mnt/home; then
                        sleep 0.5
                        NC "


==> [${green}/Home OK${nc}]
                        "
                    else
                        err_abort
                    fi
            else
                umount_abort
                until luks; do : ; done
            fi

        elif [[ "${homeform}" == "n" ]]; then
            skip
            NC "


==> [${green}/Home OK${nc}]
            "
        else
            invalid
            return 1
        fi
    fi
#------------------------------------------------------------------------------------------
    if mkfs.fat -F 32 -n BOOT "${boot_dev}"; then
        mkdir -pv /mnt/boot &&
            if mount "${boot_dev}" /mnt/boot; then
                sleep 0.5
                NC "

==> [${green}/BOOT OK${nc}]
                "
            else
                umount_abort
                until luks; do : ; done
            fi
    else
        umount_abort
        until luks; do : ; done
    fi
        sleep 0.5
        NC "


==> [${green}Encryption OK${nc}]"
        sleep 0.5
        NC "
------------------------------------------------------------------------------------------------------------------


==> [${green}Filesystems OK${nc}]


        "
        sleep 0.5
        lsblk -f
        NC
        sleep 1
}   
###########################################################################################
opt_pcmn (){

        prompt="PacMan"
        sleep 0.5
        NC "
_______________________

${purple}###${nc} Optimize PacMan ${purple}###${nc}
        "
        YELLOW "

        >  Select a country for your Arch Mirrors: "
        CYAN "

Argentina  ${nc}Australia  ${cyan}Austria  ${nc}Azerbaijan  ${cyan}Bangladesh  ${nc}Belarus  ${cyan}Belgium  ${nc}Bosnia and Herzegovina  ${cyan}Brazil  ${nc}Bulgaria  ${cyan}Cambodia  ${nc}Canada  ${cyan}Chile  ${nc}China  ${cyan}Colombia  ${nc}Croatia  ${cyan}Czechia  ${nc}Denmark  ${cyan}Equador  ${nc}Estonia  ${cyan}Finland  ${nc}France  ${cyan}Georgia  ${nc}Germany  ${cyan}Greece  ${nc}Hong Kong  ${cyan}Hungary  ${nc}Iceland  ${cyan}India  ${nc}Indonesia  ${cyan}Iran  ${nc}Ireland  ${cyan}Israel  ${nc}Italy  ${cyan}Japan  ${nc}Kazakhstan  ${cyan}Kenya  ${nc}Latvia  ${cyan}Lithuania  ${nc}Luxembourg  ${cyan}Mauritius  ${nc}Mexico  ${cyan}Moldova  ${nc}Monaco  ${cyan}Netherlands  ${nc}New Caledonia  ${cyan}New Zealand  ${nc}North Macedonia  ${cyan}Norway  ${nc}Paraguay  ${cyan}Poland  ${nc}Portugal  ${cyan}Romania  ${nc}Russia  ${cyan}Reunion  ${nc}Serbia  ${cyan}Singapore  ${nc}Slovakia  ${cyan}Slovenia  ${nc}South Africa  ${cyan}South Korea  ${nc}Spain  ${cyan}Sweden  ${nc}Switzerland  ${cyan}Taiwan  ${nc}Thailand  ${cyan}Turkey  ${nc}Ukraine  ${cyan}United Kingdom  ${nc}United States  ${cyan}Uzbekistan  ${nc}Vietnam  ${purple}Worlwide"

        BLUE "


Enter country name ${bwhite}(Empty for Defaults)${blue}: "
        read -p "
==> " COUNTRY
        NC

    if [[ -z "${COUNTRY}" ]] ; then
        sleep 0.5
        NC "

==> [${green}Default Mirrors OK${nc}] "

    elif [[ -n "${COUNTRY}" ]] ; then
        NC "
        "
        if reflector --verbose -c "${COUNTRY}" --threads $(nproc) --age 5 -p https --sort rate --save /etc/pacman.d/mirrorlist; then
            sleep 0.5
            NC "

==> [${green}"${COUNTRY}"'s Mirrors OK${nc}] "

        else
            err_try
            return 1
        fi
    fi
#------------------------------------------------------------------------------------------
        YELLOW "


        >  Enable Pacman's 'Parallel Downloads' feature? [y/n] "
        BLUE "



Enter [y/n]: "
        read -p "
==> " parallel
        NC

    if [[ "${parallel}" == "y" ]]; then
        sleep 0.5
        YELLOW "

        >  Select number of Parallel Downloads [2-5] "
        NC "

        ${green}**${nc} [2]

            ${cyan}***${nc} [3]

                ${yellow}****${nc} [4]

                    ${red}*****${nc} [5] "
        BLUE "

Enter a number: "
        read -p "
==> " parallelnmbr
        NC

            if [[ "${parallelnmbr}" =~ ^(2|3|4|5)$ ]]; then
                sed -i "s|#ParallelDownloads = 5|ParallelDownloads = "${parallelnmbr}"|g" /etc/pacman.conf
            else
                invalid
                return 1
            fi
                sleep 0.5
                NC "

==> [${green}"${parallelnmbr}" Parallel Downloads OK${nc}]"

    elif [[ "${parallel}" == "n" ]]; then
        skip

    elif [[ -z "${parallel}" ]]; then
        sleep 0.5
        RED "
        [!] Please make a selection to continue "
        reload
        return 1

    else
        invalid
        return 1
    fi
    ok
}
###########################################################################################
pacstrap_system (){

        prompt="${desktopname}"
        sleep 0.5
        NC "
_______________________

${purple}###${nc} Pacstrap System ${purple}###${nc}


        "
    if [[ "${bootloader}" == "2" ]]; then
        if [[ "${fs}" == "1" ]]; then
            bootldr_pkgs="efibootmgr grub os-prober"
        elif [[ "${fs}" == "2" ]]; then
            bootldr_pkgs="efibootmgr grub-btrfs os-prober"
        fi
    fi

    if [[ "${vendor}" == "Virtual Machine" ]]; then
        basepkgs="base base-devel "${kernel}" "${kernel}"-headers nano vim "${microcode}" "${fstools}" "${bootldr_pkgs}""
    else
        basepkgs="base base-devel "${kernel}" "${kernel}"-headers linux-firmware nano vim "${microcode}" "${wireless_reg}" "${vgapkgs}" "${fstools}" "${bootldr_pkgs}""
    fi

    case "${packages}" in
        1)
        deskpkgs=""${basepkgs}" plasma"
        displaymanager="sddm"
        bluetooth="bluetooth"
        network="NetworkManager";;
        2)
        deskpkgs=""${basepkgs}" alsa-firmware alsa-utils arj ark bluedevil breeze-gtk ccache cups-pdf cups-pk-helper dolphin-plugins e2fsprogs efibootmgr elisa exfatprogs fdkaac ffmpegthumbs firefox git glibc-locales gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb kamera kamoso kate kcalc kde-gtk-config kdegraphics-mobipocket kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-kio kdesdk-thumbnailers kdialog keditbookmarks kget kimageformats5 kinit kio-admin kio-gdrive kio-zeroconf kompare konsole kscreen kvantum kwrited latte-dock libappimage libfido2 libktorrent libmms libnfs libva-utils lirc lrzip lua52-socket lzop mac man-db man-pages mesa-demos mesa-utils nano-syntax-highlighting nss-mdns ntfs-3g okular opus-tools p7zip packagekit-qt5 pacman-contrib partitionmanager pdfmixtool pigz pipewire-alsa pipewire-pulse pkgstats plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-wayland-protocols plasma-wayland-session power-profiles-daemon powerdevil powerline powerline-fonts print-manager python-pyqt5 python-reportlab qbittorrent qt5-feedback qt5-imageformats qt5-virtualkeyboard qt5-xmlpatterns realtime-privileges reflector rng-tools sddm-kcm skanlite sof-firmware soundkonverter sox spectacle sshfs system-config-printer terminus-font timidity++ ttf-ubuntu-font-family ufw-extras unarchiver unrar unzip usb_modeswitch usbutils vdpauinfo vlc vorbis-tools vorbisgain wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xsane zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting "${nrg_plc}"";;
        3)
        deskpkgs=""${basepkgs}" gnome gnome-extra networkmanager"
        displaymanager="gdm"
        bluetooth="bluetooth"
        network="NetworkManager";;
        4)
        deskpkgs=""${basepkgs}" xfce4 xfce4-goodies lightdm-slick-greeter network-manager-applet"
        displaymanager="lightdm"
        network="NetworkManager";;
        5)
        deskpkgs=""${basepkgs}" cinnamon blueberry lightdm-slick-greeter system-config-printer gnome-keyring"
        displaymanager="lightdm"
        bluetooth="bluetooth"
        network="NetworkManager";;
        6)
        deskpkgs=""${basepkgs}" deepin deepin-extra deepin-kwin networkmanager"
        displaymanager="lightdm"
        network="NetworkManager";;
        7)
        deskpkgs=""${basepkgs}" budgie budgie-desktop-view budgie-backgrounds gdm network-manager-applet materia-gtk-theme papirus-icon-theme"
        displaymanager="gdm"
        network="NetworkManager";;
        8)
        deskpkgs=""${basepkgs}" lxqt breeze-icons network-manager-applet sddm xscreensaver"
        displaymanager="sddm"
        network="NetworkManager";;
        9)
        deskpkgs=""${basepkgs}" mate mate-extra mate-media blueman network-manager-applet mate-power-manager system-config-printer lightdm-slick-greeter"
        displaymanager="lightdm"
        bluetooth="bluetooth"
        network="NetworkManager";;
        10)
        deskpkgs=""${basepkgs}" networkmanager"
        network="NetworkManager";;
#------------------------------------------------------------------------------------------
        11)
# ### ATTENTION ### : Append your desired packages to the "custompkgs" variable below, seperated by a space: ###

        custompkgs=""

        deskpkgs="base "${kernel}" "${microcode}" "${vgapkgs}" "${fstools}" "${bootldr_pkgs}" "${wireless_reg}" "${custompkgs}"";;
#------------------------------------------------------------------------------------------
    esac

    if pacstrap -K -i /mnt archlinux-keyring ${deskpkgs}; then
        if [[ "${fs}" == "2"  ]]; then
            genfstab -t PARTUUID /mnt >> /mnt/etc/fstab
        fi
        ok
    else
        err_reload
        return 1
    fi
}
###########################################################################################
swapfile (){

        prompt="Swapfile"
        sleep 0.5
        NC "
___________________________

${purple}###${nc} Swapfile Activation ${purple}###${nc}
        "
        arch-chroot /mnt <<-SWAP
        dd if=/dev/zero of=/swapfile bs=1M count=${swapsize}k status=progress &&
        chmod 0600 /swapfile &&
        mkswap -U clear /swapfile &&
        swapon /swapfile
SWAP

    if [[ "$?" -eq 0 ]] ; then
        cat >> /mnt/etc/fstab <<-FSTAB
        /swapfile none swap defaults 0 0
FSTAB

    else
        err_swapfile
    fi

    if [[ "$?" -eq 0 ]] ; then
        ok
    else
        sleep 0.5
        RED "
        [!] Populating the 'fstab' file has failed "
        abort
    fi
}
###########################################################################################
swapfile_btrfs (){

        prompt="Btfrs Swapfile"
        sleep 0.5
        NC "
_________________________________

${purple}###${nc} Btrfs Swapfile Activation ${purple}###${nc}
        "
        arch-chroot /mnt <<-SWAP
        btrfs filesystem mkswapfile --size ${swapsize}g --uuid clear /swap/swapfile &&
        swapon /swap/swapfile
SWAP

    if [[ "$?" -eq 0 ]] ; then
        cat >> /mnt/etc/fstab <<-FSTAB
        /swap/swapfile none swap defaults 0 0
FSTAB

    else
        err_swapfile
    fi

    if [[ "$?" -eq 0 ]] ; then
        ok
    else
        sleep 0.5
        RED "
        [!] Populating the 'fstab' file has failed "
        abort
    fi
}
###########################################################################################
wireless_regdom (){

        prompt="Wireless-Regdom"
        sleep 0.5
        NC "
__________________________________

${purple}###${nc} Setting Up Wireless-Regdom ${purple}###${nc}
        "
        cat >> /mnt/etc/conf.d/wireless-regdom <<-REGDOM
        WIRELESS_REGDOM="${REGDOM}"
REGDOM

    if [[ "$?" -eq 0 ]] ; then
        ok
    else
        err_reload
        return 1
    fi
}
###########################################################################################
chroot_conf (){

        sleep 0.5
        NC "
_________________________________

${purple}###${nc} Chroot & Configure System ${purple}###${nc}
        "
# ### ATTENTION ### : Enter your desired kernel parameters in the "cust_bootopts" variable below: ###

        cust_bootopts=""

#------------------------------------------------------------------------------------------

    if [[ "${kernelnmbr}" == "3" ]]; then
        swapmode="3"
    fi

    if [[ "${encrypt}" == "yes" ]]; then

        encr_root_dev="/dev/mapper/"${ENCROOT}""
        encr_root_opts="rd.luks.name=$(blkid -s UUID -o value "${root_dev}")="${ENCROOT}""
        encr_root_bootopts="root="${encr_root_dev}" "${encr_root_opts}""

        if [[ "${swapmode}" == "1" ]]; then
            encr_swap_opts="rd.luks.name=$(blkid -s UUID -o value "${swap_dev}")=swap"
            encr_swap_bootopts="resume=/dev/mapper/swap "${encr_swap_opts}""
        elif [[ "${swapmode}" == "2" ]]; then
            if [[ "${fs}" == "1" ]]; then
                offst="$(filefrag -v /mnt/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')"
            elif [[ "${fs}" == "2" ]]; then
                offst="$(btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile)"
            fi
            encr_swap_bootopts="resume="${encr_root_dev}" resume_offset="${offst}""
        elif [[ "${swapmode}" == "3" ]]; then
            encr_swap_bootopts=""
        fi

        if [[ "${vgaconf}" == "y" ]]; then
            if [[ "${vendor}" == "Intel" ]]; then
                mkinitcpio_mods="MODULES=(i915 "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block sd-encrypt filesystems fsck)"
            elif [[ "${vendor}" == "Nvidia" ]]; then
                mkinitcpio_mods="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf block sd-encrypt filesystems fsck)"
                vga_bootopts="modeset=1"
            elif [[ "${vendor}" == "AMD" ]]; then
                mkinitcpio_mods="MODULES=(amdgpu radeon "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block sd-encrypt filesystems fsck)"
                if [[ "${islands}" == "1" ]]; then
                    vga_bootopts="radeon.si_support=0 amdgpu.si_support=1 amdgpu.dc=1"
                elif [[ "${islands}" == "2" ]]; then
                    vga_bootopts="radeon.cik_support=0 amdgpu.cik_support=1 amdgpu.dc=1"
                elif [[ -z "${islands}" ]]; then
                    vga_bootopts="amdgpu.dc=1"
                fi
            fi

        elif [[ "${vgaconf}" == "n" ]]; then
            if [[ "${vendor}" == "Nvidia" ]]; then
                mkinitcpio_mods="MODULES=("${fs_mod}" nouveau)"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block sd-encrypt filesystems fsck)"
            else
                mkinitcpio_mods="MODULES=("${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block sd-encrypt filesystems fsck)"
            fi
        fi

        boot_opts=""${encr_root_bootopts}" "${encr_swap_bootopts}" "${vga_bootopts}" "${cust_bootopts}" "${btrfs_opts}" "

#------------------------------------------------------------------------------------------

    elif [[ "${encrypt}" == "no" ]]; then

        if [[ "${swapmode}" == "1" ]]; then
            swap_bootopts="resume=UUID=$(blkid -s UUID -o value "${swap_dev}")"
        elif [[ "${swapmode}" == "2" ]]; then
            if [[ "${fs}" == "1" ]]; then
                offst="$(filefrag -v /mnt/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')"
            elif [[ "${fs}" == "2" ]]; then
                offst="$(btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile)"
            fi
            swap_bootopts="resume=UUID=$(blkid -s UUID -o value "${root_dev}") resume_offset="${offst}" "
        elif [[ "${swapmode}" == "3" ]]; then
            swap_bootopts=""
        fi

        if [[ "${vgaconf}" == "y" ]]; then
            if [[ "${vendor}" == "Intel" ]]; then
                mkinitcpio_mods="MODULES=(i915 "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block filesystems fsck)"
            elif [[ "${vendor}" == "Nvidia" ]]; then
                mkinitcpio_mods="MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf block filesystems fsck)"
                vga_bootopts="modeset=1"
            elif [[ "${vendor}" == "AMD" ]]; then
                mkinitcpio_mods="MODULES=(amdgpu radeon "${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block filesystems fsck)"
                if [[ "${islands}" == "1" ]]; then
                    vga_bootopts="radeon.si_support=0 amdgpu.si_support=1 amdgpu.dc=1"
                elif [[ "${islands}" == "2" ]]; then
                    vga_bootopts="radeon.cik_support=0 amdgpu.cik_support=1 amdgpu.dc=1"
                elif [[ -z "${islands}" ]]; then
                    vga_bootopts="amdgpu.dc=1"
                fi
            fi
        elif [[ "${vgaconf}" == "n" ]]; then
            if [[ "${vendor}" == "Nvidia" ]]; then
                mkinitcpio_mods="MODULES=("${fs_mod}" nouveau)"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block filesystems fsck)"
            else
                mkinitcpio_mods="MODULES=("${fs_mod}")"
                mkinitcpio_hooks="HOOKS=(systemd keyboard autodetect modconf kms block filesystems fsck)"
            fi
        fi

        boot_opts=""${cust_bootopts}" "${swap_bootopts}" "${vga_bootopts}" "${btrfs_opts}""
    fi

#------------------------------------------------------------------------------------------

    if [[ "${packages}" =~ ^(1|3|4|5|6|7|8|9|10)$ ]]; then

        arch-chroot /mnt <<-SYSTEM
        sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen &&
        locale-gen &&
        echo LANG=${SETLOCALE} > /etc/locale.conf &&
        export LANG=${SETLOCALE} &&
        echo KEYMAP=${SETKBD} > /etc/vconsole.conf &&
        update-pciids &&
        echo "
        ${mkinitcpio_mods}
        ${mkinitcpio_hooks}
        COMPRESSION_OPTIONS=(-c -T$(nproc) -)" | tee /etc/mkinitcpio.conf.d/custom.conf &&
        mkinitcpio -P &&
        ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &&
        hwclock --systohc &&
        echo ${HOSTNAME} > /etc/hostname &&
        echo "127.0.0.1 localhost
        ::1 localhost
        127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts &&
        echo root:${ROOTPASSWD2} | chpasswd &&
        useradd -m -G wheel -s /bin/bash ${USERNAME} &&
        echo ${USERNAME}:${USERPASSWD2} | chpasswd &&
        echo "
        Defaults editor=/usr/bin/nano
        %wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoedits &&
        visudo -c /etc/sudoers.d/sudoedits
SYSTEM

        if [[ -f /mnt/etc/lightdm/lightdm.conf ]]; then
            if [[ "${packages}" == "6" ]]; then
                arch-chroot /mnt <<-DEEPIN
                sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-deepin-greeter|g' /etc/lightdm/lightdm.conf
DEEPIN
            else
                arch-chroot /mnt <<-LIGHTDM
                sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf
LIGHTDM
            fi
        fi

        if [[ "${bootloader}" == "1" ]]; then
            arch-chroot /mnt <<-BOOTCTL
            bootctl install --graceful &&
            echo "default arch.conf" > /boot/loader/loader.conf &&
            echo "title ${entrname}
            linux /vmlinuz-${kernel}
            initrd /${microcode}.img
            initrd /initramfs-${kernel}.img
            options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf &&
            systemctl enable systemd-boot-update ${bluetooth} ${displaymanager} ${network} ${trim}
BOOTCTL
        elif [[ "${bootloader}" == "2" ]]; then
            arch-chroot /mnt <<-GRUB
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &&
            sed -i \
            -e 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="${boot_opts}"|g' \
            -e "/^#GRUB_DISABLE_OS_PROBER=false/s/^#//" \
            /etc/default/grub &&
            grub-mkconfig -o /boot/grub/grub.cfg &&
            systemctl enable ${bluetooth} ${displaymanager} ${network} ${trim}
GRUB

            if [[ "${bootloader}" == "2" && "${fs}" == "2" ]]; then
                arch-chroot /mnt <<-GRUBBTRFSD
                systemctl enable grub-btrfsd
GRUBBTRFSD
            fi

            if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]]; then
                arch-chroot /mnt <<-NVIDIA
                sed -i "/^#GRUB_TERMINAL_OUTPUT=console/s/^#//" /etc/default/grub &&
                grub-mkconfig -o /boot/grub/grub.cfg
NVIDIA
            fi
        fi

        if [[ "$?" -eq 0 ]]; then
            NC "



==> [${green}System OK${nc}] "
            sleep 1

        else
            err_instl_abort
        fi
    fi
#------------------------------------------------------------------------------------------

    if [[ "${packages}" == "2" ]]; then

        if [[ -n "${nrg_plc}" ]]; then
            arch-chroot /mnt <<-NRG
            ${nrg_plc} performance
NRG
        fi

        arch-chroot /mnt <<-OPTIMIZED
        sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen &&
        locale-gen &&
        echo LANG=${SETLOCALE} > /etc/locale.conf &&
        export LANG=${SETLOCALE} &&
        echo KEYMAP=${SETKBD} > /etc/vconsole.conf &&
        sed -i "/^#Color/s/^#//" /etc/pacman.conf &&
        balooctl disable &&
        balooctl purge &&
        update-pciids &&
        echo '
        ${mkinitcpio_mods}
        ${mkinitcpio_hooks}
        COMPRESSION_OPTIONS=(-c -T$(nproc) -)
        MODULES_DECOMPRESS="yes"' | tee /etc/mkinitcpio.conf.d/custom.conf &&
        mkinitcpio -P &&
        cp -v /etc/makepkg.conf /etc/makepkg.conf.bak &&
        sed -i \
        -e 's|-march=[^ ]* -mtune=[^ ]*|-march=native|g' \
        -e 's|^#RUSTFLAGS.*|RUSTFLAGS="-C opt-level=2"|g' \
        -e 's|^#MAKEFLAGS.*|MAKEFLAGS="-j$(nproc)"|g' \
        -e 's|^BUILDENV.*|BUILDENV=(!distcc color ccache check !sign)|g' \
        -e 's|^COMPRESSGZ.*|COMPRESSGZ=(pigz -c -f -n)|g' \
        -e 's|^COMPRESSBZ2.*|COMPRESSBZ2=(pbzip2 -c -f)|g' \
        -e 's|^COMPRESSXZ.*|COMPRESSXZ=(xz -c -z --threads=0 -)|g' \
        -e 's|^COMPRESSZST.*|COMPRESSZST=(zstd -c -z -q --threads=0 -)|g' \
        /etc/makepkg.conf &&
        ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &&
        hwclock --systohc &&
        echo ${HOSTNAME} > /etc/hostname &&
        echo "127.0.0.1 localhost
        ::1 localhost
        127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts &&
        echo "net.core.netdev_max_backlog = 16384
        net.core.somaxconn = 8192
        net.core.rmem_default = 1048576
        net.core.rmem_max = 16777216
        net.core.wmem_default = 1048576
        net.core.wmem_max = 16777216
        net.core.optmem_max = 65536
        net.ipv4.tcp_rmem = 4096 1048576 2097152
        net.ipv4.tcp_wmem = 4096 65536 16777216
        net.ipv4.udp_rmem_min = 8192
        net.ipv4.udp_wmem_min = 8192
        net.ipv4.tcp_fastopen = 3
        net.ipv4.tcp_max_syn_backlog = 8192
        net.ipv4.tcp_max_tw_buckets = 2000000
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.tcp_fin_timeout = 10
        net.ipv4.tcp_slow_start_after_idle = 0
        net.ipv4.tcp_keepalive_time = 60
        net.ipv4.tcp_keepalive_intvl = 10
        net.ipv4.tcp_keepalive_probes = 6
        net.ipv4.tcp_mtu_probing = 1
        net.ipv4.tcp_sack = 1
        net.core.default_qdisc = cake
        net.ipv4.tcp_congestion_control = bbr
        net.ipv4.ip_local_port_range = 30000 65535
        net.ipv4.conf.default.rp_filter = 1
        net.ipv4.conf.all.rp_filter = 1
        vm.vfs_cache_pressure = 50
        vm.mmap_min_addr = 65536
        kernel.printk = 0 0 0 0
        ${perf_stream}" | tee /etc/sysctl.d/99-performance.conf &&
        echo "[defaults]
        ntfs:ntfs3_defaults=uid=1000,gid=1000" | tee /etc/udisks2/mount_options.conf &&
        echo '// Original rules: https://github.com/coldfix/udiskie/wiki/Permissions
        // Changes: Added org.freedesktop.udisks2.filesystem-mount-system, as this is used by Dolphin.

        polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        var permission = {
            // required for udisks1:
            "org.freedesktop.udisks.filesystem-mount": YES,
            "org.freedesktop.udisks.luks-unlock": YES,
            "org.freedesktop.udisks.drive-eject": YES,
            "org.freedesktop.udisks.drive-detach": YES,
            // required for udisks2:
            "org.freedesktop.udisks2.filesystem-mount": YES,
            "org.freedesktop.udisks2.encrypted-unlock": YES,
            "org.freedesktop.udisks2.eject-media": YES,
            "org.freedesktop.udisks2.power-off-drive": YES,
            // Dolphin specific:
            "org.freedesktop.udisks2.filesystem-mount-system": YES,
            // required for udisks2 if using udiskie from another seat (e.g. systemd):
            "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
            "org.freedesktop.udisks2.filesystem-unmount-others": YES,
            "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
            "org.freedesktop.udisks2.encrypted-unlock-system": YES,
            "org.freedesktop.udisks2.eject-media-other-seat": YES,
            "org.freedesktop.udisks2.power-off-drive-other-seat": YES
        };
        if (subject.isInGroup("wheel")) {
            return permission[action.id];
        }
        });' | tee /etc/polkit-1/rules.d/99-udisks2.rules &&
        mkdir -p /etc/systemd/journald.conf.d &&
        echo "[Journal]
        SystemMaxUse=100M" | tee /etc/systemd/journald.conf.d/00-journald.conf &&
        mkdir -p /etc/systemd/user.conf.d &&
        echo "[Manager]
        DefaultTimeoutStopSec=5s
        DefaultTimeoutAbortSec=5s" | tee /etc/systemd/user.conf.d/00-user.conf &&
        sed -i 's|^hosts.*|hosts: mymachines mdns_minimal resolve [!UNAVAIL=return] files myhostname dns|g' /etc/nsswitch.conf &&
        sed -i 's/ interface = [^ ]*/ interface = all/g' /etc/ipp-usb/ipp-usb.conf &&
        sed -i "/# set linenumbers/"'s/^#//' /etc/nanorc &&
        echo tcp_bbr | tee /etc/modules-load.d/modules.conf &&
        echo "country=${REGDOM}
        wps_cred_add_sae=1
        pmf=2" | tee /etc/wpa_supplicant/wpa_supplicant.conf &&
        bootctl install --graceful &&
        echo "default arch.conf" > /boot/loader/loader.conf &&
        echo "title ${entrname}
        linux /vmlinuz-${kernel}
        initrd /${microcode}.img
        initrd /initramfs-${kernel}.img
        options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf &&
        echo root:${ROOTPASSWD2} | chpasswd &&
        chsh -s /bin/zsh &&
        useradd -m -G wheel,realtime -s /bin/zsh ${USERNAME} &&
        echo ${USERNAME}:${USERPASSWD2} | chpasswd &&
        echo "Defaults env_reset
        Defaults pwfeedback
        Defaults editor=/usr/bin/nano
        %wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoedits &&
        visudo -c /etc/sudoers.d/sudoedits &&
        systemctl enable avahi-daemon bluetooth cups ipp-usb NetworkManager rngd sddm systemd-boot-update ufw ${trim}
OPTIMIZED

        if [[ "$?" -eq 0 ]]; then
            NC "



==> [${green}System OK${nc}] "
            sleep 1
        else
            err_instl_abort
        fi
    fi
#------------------------------------------------------------------------------------------

# ### ATTENTION ### : If 'Custom Setup' was selected, append your extra configurations to the "HERE document" below:

    if [[ "${packages}" == "11" ]]; then
        arch-chroot /mnt <<-CUSTOM
        sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen &&
        locale-gen &&
        echo LANG=${SETLOCALE} > /etc/locale.conf &&
        export LANG=${SETLOCALE} &&
        echo KEYMAP=${SETKBD} > /etc/vconsole.conf &&
        echo "
        ${mkinitcpio_mods}
        ${mkinitcpio_hooks}
        COMPRESSION_OPTIONS=(-c -T$(nproc) -)" | tee /etc/mkinitcpio.conf.d/custom.conf &&
        mkinitcpio -P &&
        ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &&
        hwclock --systohc &&
        echo ${HOSTNAME} > /etc/hostname &&
        echo "127.0.0.1 localhost
        ::1 localhost
        127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts &&
        echo root:${ROOTPASSWD2} | chpasswd &&
        useradd -m -G wheel -s /bin/bash ${USERNAME} &&
        echo ${USERNAME}:${USERPASSWD2} | chpasswd &&
        echo "
        %wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoedits &&
        visudo -c /etc/sudoers.d/sudoedits
CUSTOM

        if [[ "${bootloader}" == "1" ]]; then
            arch-chroot /mnt <<-BOOTCTL
            bootctl install --graceful &&
            echo "default arch.conf" > /boot/loader/loader.conf &&
            echo "title ${entrname}
            linux /vmlinuz-${kernel}
            initrd /${microcode}.img
            initrd /initramfs-${kernel}.img
            options rw ${boot_opts}" | tee /boot/loader/entries/arch.conf &&
            systemctl enable systemd-boot-update
BOOTCTL
        elif [[ "${bootloader}" == "2" ]]; then
            arch-chroot /mnt <<-GRUB
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &&
            sed -i \
            -e 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="${boot_opts}"|g' \
            -e "/^#GRUB_DISABLE_OS_PROBER=false/s/^#//" \
            /etc/default/grub &&
            grub-mkconfig -o /boot/grub/grub.cfg
GRUB
            if [[ "${bootloader}" == "2" && "${fs}" == "2" ]]; then
                arch-chroot /mnt <<-GRUBBTRFSD
                systemctl enable grub-btrfsd
GRUBBTRFSD
            fi

            if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]]; then
                arch-chroot /mnt <<-NVIDIA
                sed -i "/^#GRUB_TERMINAL_OUTPUT=console/s/^#//" /etc/default/grub &&
                grub-mkconfig -o /boot/grub/grub.cfg
NVIDIA
            fi
        fi

        if [[ "$?" -eq 0 ]]; then
            NC "



==> [${green}System OK${nc}] "
            sleep 1
        else
            err_instl_abort
        fi
    fi
}

# ### END FUNCTIONS ###
###########################################################################################

        clear
        set -e
        run_as="$(whoami)"
        tty="$(tty)"
        disks="$(lsblk --nodeps --paths --noheadings --output=name,size,model | cat --number)"

    if [[ -e /run/archiso/cowspace ]]; then
        mount -o remount,size="80%" /run/archiso/cowspace
    fi
        first_check
        sleep 1
        CYAN "


*********************************

###  Arch Linux Installation  ###


 $(date)

*********************************


        "
        read -s -p "  > Hit 'Enter' to Proceed < " installation
        NC "

        "
    if [[ -n "${installation}" ]]; then
        abort
    fi
        uefi_check
        upd_clock
        dtct_microcode
        until main_menu; do : ; done
        umount -R /mnt
        sleep 0.5
        CYAN "

*******************************

###  Installation Complete  ###


 $(date)

******************************* 


        "
        sleep 1
