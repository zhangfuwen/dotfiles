install_oh_my_zsh() {
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}
function install_nerdfonts() {
  mkdir -p ~/bin/src/nerdfonts
  mkdir ~/.fonts

  wget -O ~/bin/src/nerdfonts/FireCode.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
  unzip ~/bin/src/nerdfonts/FireCode.zip -d ~/.fonts/
  echo "now you can set your terminal fonts to 'FiraCode Nerd Font Mono Regular'"

  wget -O ~/bin/src/nerdfonts/RobotoMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
  unzip ~/bin/src/nerdfonts/RobotoMono.zip -d ~/.fonts/
  echo "now you can set your terminal fonts to 'RobotoMono Regular'"
}
