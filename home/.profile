# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    export PATH=$HOME/.bin:$PATH
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH=$HOME/.local/bin:$PATH
fi

# Android App Dev
PATH=/opt/android/platform-tools:/opt/android/tools:$PATH

# Eclipse
PATH=/opt/eclipse/:$PATH

#ArchC
export PATH=/home/max/x-tools/mips-newlib-elf/bin:$PATH
export PATH=/home/max/x-tools/arm-newlib-eabi/bin:$PATH
export PATH=/home/max/x-tools/powerpc-newlib-elf/bin:$PATH
export PATH=/home/max/x-tools/sparc-newlib-elf/bin:$PATH
export PATH=/home/max/x-tools/arm-unknown-linux-gnueabi/bin:$PATH
export PATH=/home/max/x-tools/mips-unknown-linux-gnu/bin:$PATH
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/ArchC/tools/systemc/2.3.1/install/lib-linux64/
export AC_LIBRARY_PATH=/lib/x86_64-linux-gnu:$AC_LIBRARY_PATH
#export PKG_CONFIG_PATH="$HOME/ArchC/archc/master/install/lib/pkgconfig:$HOME/ArchC/tools/systemc/2.3.1/install/lib-linux64/pkgconfig:${PKG_CONFIG_PATH}"

#OVP
export IMPERAS_HOME=/home/max/ArchC/ovp-env/Imperas.20140127
export IMPERAS_ARCH=Linux32
export IMPERAS_UNAME=Linux
export IMPERAS_SHRSUF=so
export IMPERAS_VLNV=$IMPERAS_HOME/lib/$IMPERAS_ARCH/ImperasLib
#export IMPERAS_RUNTIME=CpuManager
export IMPERAS_RUNTIME=OVPsim
export PATH=$IMPERAS_HOME/bin/$IMPERAS_ARCH:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$IMPERAS_HOME/bin/$IMPERAS_ARCH:$IMPERAS_HOME/lib/$IMPERAS_ARCH/External/lib
export LM_LICENSE_FILE=$LM_LICENSE_FILE:$IMPERAS_HOME/OVPsim.lic

# Android Build ROM
export USE_CCACHE=1
if [ "$HOSTNAME" == "powernote" ]; then 
    export CCACHE_DIR=/media/ssdfiles/.ccache/
elif [ "$HOSTNAME" == "maxsamy" ]; then
    export CCACHE_DIR=/files/.ccache/
fi

export CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1024x768
 
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'

[[ -f ~/env.padtec ]] && source ~/env.padtec


export PATH="$HOME/.cargo/bin:$PATH"
