install_oh_my_zsh() {
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}
function install_nerdfonts() {
  mkdir -p ~/bin/src/nerdfonts

  font_list="FireCode.zip RobotoMono.zip ComicShannsMono.zip"

  os_kernel=$(uname -s)
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

  for font in $font_list; do
      if [[ ! -f ~/bin/src/nerdfonts/$font ]]; then
          wget -c -O ~/bin/src/nerdfonts/$font \
            https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$font
      fi
  done
  for font in $font_list; do
      unzip ${HOME}/bin/src/nerdfonts/$font -d $install_target
  done
}
