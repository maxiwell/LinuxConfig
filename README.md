LinuxConfig
===========

* /etc is not in "collect" and "distribute" script.

* The files **/etc/fail2ban/filter.d/sshd.conf** and **/etc/init.d/firewall** was created to use in Digital Ocean VM. 

Reminders
---------

* Mapping the "comma key" in the "dot numpad".

```bash
xmodmap -e "keycode 91 = comma"
``` 

* Config the Powernote keyboard to USA with dead keys

```bash
 setxkbmap -layout us -variant intl
```

* GIT: remove files from repository based on .gitignore but not delete them

```bash
git rm --cached `git ls-files -i -X .gitignore`
```

* xdg-open don't works with torrent magnet links in the openbox. That only works with gnome, kde, xfce, or lxde.
To fix that, find the code below in the file /usr/bin/xdg-open and set **gnome**  in the var **DE** 

```bash    
detectDE
if [ x"$DE" = x"" ]; then
   DE=generic
```

* Disable nemo desktop

```bash
gsettings set org.nemo.desktop show-desktop-icons false
```

* To allow all users to "shutdown" and "reboot" command without sudo pass, added the code below in /etc/sudoers.

```bash
# replace 'myusers' group by your users group
%myusers ALL=(ALL) NOPASSWD:/sbin/shutdown,/sbin/halt,/sbin/reboot
```



