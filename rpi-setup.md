# RPI-Setup

1. Secure Login
   1. Change default user
      1. Create user:
         - `adduser --shell /bin/zsh <user>`
      2. Add to sudoers:
         - `echo '<user> ALL=(ALL) PASSWD: ALL' > /etc/sudoers.d/020_<user>`
      3. Set ZSH as default + oh my zsh:
         - `chsh -s /bin/zsh`
         - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
      4. Configure .zshrc
         - Plugins: `git docker docker-compose`
         - Exports:
            - `EDITOR=nano`
         - Aliases:
            - `ll=ls -lsa`
      5. Enable SSH Login:
         - On Host: `ssh-keygen -t ed25519`
         - `(umask 077 && mkdir ~/.ssh && touch ~/.ssh/authorized_keys)`
         - Add public key to authorized_keys
   2. Disabled Password & root login
      - `sudo passwd -l root`
      - `sudo usermod -s /usr/sbin/nologin root`
      - `sudo nano /etc/ssh/sshd_config`
         - `ChallengeResponseAuthentication no`
         - `PasswordAuthentication no`
         - `UsePAM no`
         - `PermitRootLogin no`
      - `sudo systemctl reload ssh`
   3. Delete PI user
      - `sudo deluser --remove-home --remove-all-files pi`
   4. Setup Git
      1. Configure Git (globally):
         ```.config
         gpg.program $(which gpg)
         user.name Skycoder42
         user.email Skycoder42@users.noreply.github.com
         user.signingkey <key-id>
         commit.gpgsign on
         pull.rebase on
         pull.ff only
         ```
      2. Import GPG Key
         - Import: `gpg --import <key-file>`
         - Trust: `gpg --edit-key <key-id> trust quit`
         - Add to .zshrc: `export GPG_TTY=$(tty)`
2. Unattended Upgrades
   1. Install: `apt install unattended-upgrades msmtp msmtp-mta`
   2. Setup msmtp, create `/root/.msmtprc`:
      ```.conf
      defaults
      port 465
      tls on
      tls_starttls off

      account <account-name>
      host mail.gmx.net
      from <email>

      auth on
      user <email>
      password <password>

      account default : <account-name>
      ```
   3. Setup Unattended Upgrades
      1. Setup: `sudo dpkg-reconfigure -plow unattended-upgrades`
      2. Modify `/etc/apt/apt.conf.d/20auto-upgrades`:
         ```
         APT::Periodic::Update-Package-Lists "1";
         APT::Periodic::Download-Upgradeable-Packages "1";
         APT::Periodic::Unattended-Upgrade "1";
         APT::Periodic::AutocleanInterval "7";
         ```
      3. Modify `/etc/apt/apt.conf.d/50unattended-upgrades`:
         - ```
           Unattended-Upgrade::Origins-Pattern {
             "origin=*";
           }
           ```
         - `Unattended-Upgrade::AutoFixInterruptedDpkg "true";`
         - `Unattended-Upgrade::MinimalSteps "true";`
         - `Unattended-Upgrade::Mail "<email>";`
         - `Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";`
         - `Unattended-Upgrade::Remove-New-Unused-Dependencies "true";`
         - `Unattended-Upgrade::Remove-Unused-Dependencies "true";`
         - `Unattended-Upgrade::Automatic-Reboot "true";`
         - `Unattended-Upgrade::Automatic-Reboot-WithUsers "true";`
         - `Unattended-Upgrade::Automatic-Reboot-Time "02:00";`
      4. Test: `sudo unattended-upgrade -d [--dry-run]`
3. Setup and test Docker
   1. Install libseccomp backport (Only for Raspbian based on Debian Buster)
      1. Get Signing Keys: `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138`
      2. Add Backport Repo to package sources: `echo 'deb http://httpredir.debian.org/debian buster-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list.d/debian-backports.list`
      3. Update: `sudo apt update`
      4. Install backport: `sudo apt install libseccomp2 -t buster-backports`
   2. Install Docker:
      - Download Script: `curl -fsSL https://get.docker.com -o get-docker.sh`
      - Execute Script: `sudo sh get-docker.sh && rm get-docker.sh`
   3. Test Docker + Alpine Networking: `sudo docker run --rm -it alpine:latest /bin/ping 8.8.8.8`
4. Build Seafile: `sudo build-seafile.sh`
