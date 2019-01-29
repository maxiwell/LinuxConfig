LinuxConfig
===========

These dotfiles are used with Ubuntu/Fedora and Openbox environment. 

Install
----------

* Clone this repository:

```bash
git clone git@github.com:maxiwell/LinuxConfig.git $HOME/.config/LinuxConfig
```

* Download git submodules:

```bash
cd ~/.config/LinuxConfig
git submodule update --init --recursive
```

* Distribute the files for the first time:

```bash
./distribute.sh
```

* Execute the Ansible Playbook

```bash
cd ~/.config/ansible/
./ansible.sh
```

Now, you'll able to execute the **collect.sh** and **distribute.sh** scripts

Some tips
----------

* VIM plugins are controlled by **Vundle.vim** project. So, ``home/.vim/bundle/Vundle.vim`` is a git submodule.  

* My executable scripts are in ``home/.local/bin/``.

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


