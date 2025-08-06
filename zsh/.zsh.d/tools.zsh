install_oh_my_zsh() {
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}
function install_nerdfonts() {
  mkdir -p ~/bin/src/nerdfonts

  os_kernel = $(uname -s)
  # Darwin or Linux
  install_target="~/.fonts"
  if [[ $os_kernel == "Darwin" ]]; then
      install_target = "~/Library/Fonts"
  elif [[ $os_kernel == "Linux" ]]; then
      install_target="~/.fonts"
  else
      echo "unsupported os"
  fi

  if [[ ! -d $install_target ]]; then
      mkdir -p $install_target
  fi


  if [[ ! -f ~/bin/src/nerdfonts/FireCode.zip ]]; then
      wget -c -O ~/bin/src/nerdfonts/FireCode.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
      unzip ~/bin/src/nerdfonts/FireCode.zip -d $install_target
      echo "now you can set your terminal fonts to 'FiraCode Nerd Font Mono Regular'"
  else
      echo "FireCode font exists"
  fi

  if [[ ! -f ~/bin/src/nerdfonts/RobotoMono.zip ]]; then
      wget -c -O ~/bin/src/nerdfonts/RobotoMono.zip \
            https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
      unzip ~/bin/src/nerdfonts/RobotoMono.zip -d $install_target
      echo "now you can set your terminal fonts to 'RobotoMono Regular'"
  else
      echo "RobotoMono font exists"
  fi
}
