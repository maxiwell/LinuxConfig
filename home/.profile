# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
#if [ -n "$BASH_VERSION" ]; then
#    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#	. "$HOME/.bashrc"
#    fi
#fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi


# Android
PATH=$PATH:/opt/android/sdks/platform-tools:/opt/android/sdks/tools

#ArchC
export PATH=$PATH:/home/max/x-tools/mips-newlib-elf/bin
export PATH=$PATH:/home/max/x-tools/arm-newlib-eabi/bin
export PATH=$PATH:/home/max/x-tools/powerpc-newlib-elf/bin
export PATH=$PATH:/home/max/x-tools/sparc-newlib-elf/bin
export PATH=$PATH:/home/max/x-tools/arm-unknown-linux-gnueabi/bin
export PATH=$PATH:/home/max/x-tools/mips-unknown-linux-gnu/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/ArchC/tools/systemc-2.3.0/lib-linux64/
export AC_LIBRARY_PATH=$AC_LIBRARY_PATH:/lib/x86_64-linux-gnu


#OVP
export IMPERAS_HOME=/home/max/ArchC/ovp-env/Imperas.20140127
export IMPERAS_ARCH=Linux32
export IMPERAS_UNAME=Linux
export IMPERAS_SHRSUF=so
export IMPERAS_VLNV=$IMPERAS_HOME/lib/$IMPERAS_ARCH/ImperasLib
#export IMPERAS_RUNTIME=CpuManager
export IMPERAS_RUNTIME=OVPsim
export PATH=$PATH:$IMPERAS_HOME/bin/$IMPERAS_ARCH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$IMPERAS_HOME/bin/$IMPERAS_ARCH:$IMPERAS_HOME/lib/$IMPERAS_ARCH/External/lib
export LM_LICENSE_FILE=$LM_LICENSE_FILE:$IMPERAS_HOME/OVPsim.lic




