LinuxConfig
===========

Here you will find my dotfiles used with Openbox environment. I clone this repo into ``~/.config/LinuxConfig`` and use 
the scripts **collect** and **distribute** to organize the files.

Install
----------

Before use the scripts, it's necessary download all git submodules:

```bash
cd ~/.config/LinuxConfig
git submodule update --init --recursive
```
Now, you'll able to execute the **collect** and **distribute** scripts

Some tips
----------

* VIM plugins are controlled by **Vundle.vim** project. So, ``home/.vim/bundle/Vundle.vim`` is a git submodule.  

* My executable scripts are in ``home/.local/bin/``.

* /etc is not in "collect" and "distribute" script.

* The files ``/etc/fail2ban/filter.d/sshd.conf`` and ``/etc/init.d/firewall`` was created to use in Digital Ocean VM. 

Reminders
-----------

* GIT: remove files from repository based on .gitignore but not delete them

```bash
git rm --cached `git ls-files -i -X .gitignore`
```

* xdg-open don't works with torrent magnet links in the openbox. That only works with gnome, kde, xfce, or lxde.
To fix that, find the code below in the file ``/usr/bin/xdg-open`` and set **gnome**  in the var **DE** 

```bash    
detectDE
if [ x"$DE" = x"" ]; then
   DE=generic
```


