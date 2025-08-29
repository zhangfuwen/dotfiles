install_binaries() {
    # if brew exists
    if command -v lua; then
    else
        if command -v brew; then
            brew install lua
        elif command -v apt; then
            sudo apt install lua
        else
            print("failed to install lua")
        fi
    fi

    lua $HOME/.zsh.d/install_binaries.lua 
}
