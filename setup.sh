sudo apt update && sudo apt upgrade

# Packages
sudo apt install gpg fzf bat ca-certificates curl

# Eza
if [ ! -x "$(command -v eza)" ]; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt install -y eza
fi

# Bottom
if [ ! -x "$(command -v bottom)" ]; then
  sudo snap install bottom
  sudo snap connect bottom:mount-observe
  sudo snap connect bottom:hardware-observe
  sudo snap connect bottom:system-observe
  sudo snap connect bottom:process-control
fi

# Configs
if [ ! -x "$(command -v chezmoi)" ]; then
  sudo snap install chezmoi --classic
  chezmoi init https://github.com/maxguuse/dotfiles.git
  chezmoi apply -v
fi

# ZSH
if [ ! -x "$(command -v zsh)" ]; then
  sudo apt install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/P4Cu/cd-reporoot.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cd-reporoot
  git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
  git clone https://github.com/desyncr/auto-ls.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/auto-ls
  git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
fi

# Go
if [ ! -x "$(command -v go)" ]; then
  wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz -O /tmp/go-archive
  if [ -x "$(command -v go)" ]; then
      sudo rm -rf /usr/local/go
  fi
  sudo tar -C /usr/local -xzf /tmp/go-archive
fi

# TODO: Add go tools installation
# Go libs
# SQLC
# gRPC
# Goose
# Swag
# Golangci-lint

# Docker
if [ ! -x "$(command -v docker)" ]; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
fi

# GitHub CLI
if [ ! -x "$(command -v gh)" ]; then
  sudo apt install gh
  gh auth login
fi

zsh -c "source ~/.zshrc"