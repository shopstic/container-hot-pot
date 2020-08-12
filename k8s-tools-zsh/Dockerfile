FROM shopstic/k8s-tools:1.2.3

RUN \
  apt-get update && \
  # install vim
  apt-get install vim -y && \
  update-alternatives --set editor /usr/bin/vim.basic && \
  # install zsh, oh-my-zsh, zsh-syntax-highlighting and powerlevel10k theme
  apt-get install zsh -y && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  touch /root/.z && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
  # install fzf; after migration to ubuntu >= 19.0 use simply apt-get, until then installation is manual
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  yes | ~/.fzf/install && \
  # install ripgrep; after migration to ubuntu >= 18.10 use simply apt-get, until then installation is manual
  wget https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb && \
  dpkg -i ripgrep_12.1.1_amd64.deb && \
  rm ripgrep_12.1.1_amd64.deb && \
  # install bat; after migration to ubuntu >= 19.0 use simply apt-get, until then installation is manual
  wget https://github.com/sharkdp/bat/releases/download/v0.15.4/bat_0.15.4_amd64.deb && \
  dpkg -i bat_0.15.4_amd64.deb && \
  rm bat_0.15.4_amd64.deb && \
  # install exa
  wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip && \
  unzip exa-linux-x86_64-0.9.0.zip && \
  mv exa-linux-x86_64 /usr/bin/exa && \
  rm exa-linux-x86_64-0.9.0.zip

RUN \
  sed -i 's/^bash$/zsh\n/g' /usr/bin/entrypoint.sh && \
  sed -i 's|/root/.bashrc|/root/.zshrc|g' /usr/bin/entrypoint.sh

ADD ./.zshrc /root/.zshrc
ADD ./.p10k.zsh /root/.p10k.zsh

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
