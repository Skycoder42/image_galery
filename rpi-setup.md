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
         credential.helper store
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
