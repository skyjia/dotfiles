# rbenv
eval "$(rbenv init -)"

# Load $HOME/.shared_profile
if [ -f ~/.shared_profile.sh ]; then
    source ~/.shared_profile.sh
fi

