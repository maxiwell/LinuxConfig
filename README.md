LinuxConfig
===========


* /etc is not in "collect" and "distribute" script.

* Package.list
    - Created with: dpkg --get-selections > Package.list
    - Recover with: sudo  dpkg --set-selections < Package.list && sudo apt-get dselect-upgrade -y


* Cloning GIT with HTTPS and using the SSH keys
    - git remote set-url origin git@github.com:maxiwell/LinuxConfig.git

* xdg-open don't works with torrent magnet links in the openbox. That only works with gnome, kde, xfce, or lxde.
    - Find the code below in the file /usr/bin/xdg-open 

```bash    
detectDE
if [ x"$DE" = x"" ]; then
   DE=generic
```

    - Replace **DE=generic** to **DE=gnome**
