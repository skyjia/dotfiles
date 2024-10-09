# echo "loading .zprofile"
# echo "loading .zprofile" >> ~/dotfiles/logs/zsh.log

if [ -f ~/.zprofile_secure.sh ]; then
    # shellcheck disable=SC1090
    source ~/.zprofile_secure.sh
fi
