LinuxConfig
===========


* /etc is not in "collect" and "distribute" script.


* Cloning GIT with HTTPS and using the SSH keys

```bash
git remote set-url origin git@github.com:maxiwell/LinuxConfig.git
```

* xdg-open don't works with torrent magnet links in the openbox. That only works with gnome, kde, xfce, or lxde.
To fix that, find the code below in the file /usr/bin/xdg-open and set **gnome**  in the var **DE** 

```bash    
detectDE
if [ x"$DE" = x"" ]; then
   DE=generic
```

* To allow all users to "shutdown" and "reboot" command without sudo pass, added the code below in /etc/sudoers.

```bash
# replace 'myusers' group by your users group
%myusers ALL=(ALL) NOPASSWD:/sbin/shutdown,/sbin/halt,/sbin/reboot
```

* The files **/etc/fail2ban/filter.d/sshd.conf** and **/etc/init.d/firewall** was created to use in Digital Ocean VM. 


