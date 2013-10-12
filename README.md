LinuxConfig
===========


* /etc is not in "collect" and "distribute" script.

* Package.list
    - Created with: dpkg --get-selections > Package.list
    - Recover with: sudo  dpkg --set-selections < Package.list && sudo apt-get dselect-upgrade -y


* Cloning GIT with HTTPS and using the SSH keys
    - git remote set-url origin git@github.com:maxiwell/LinuxConfig.git

