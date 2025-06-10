# echo "loading .zshenv"
# echo "loading .zshenv" >> ~/dotfiles/logs/zsh.log

# Set up the Zsh environment
[[ -r ${ZDOTDIR:-$HOME}/.shared-env.zsh ]] && source ${ZDOTDIR:-$HOME}/.shared-env.zsh
