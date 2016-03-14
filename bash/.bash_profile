# rbenv
eval "$(rbenv init -)"

# opam
eval `opam config env`

# AWS CLI completion
complete -C aws_completer aws

# Load $HOME/.shared_profile
if [ -f ~/.shared_profile.sh ]; then
    source ~/.shared_profile.sh
fi

