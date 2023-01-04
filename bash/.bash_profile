if [ "$(uname)" = "Darwin" ]; then
  # AWS CLI completion
  complete -C aws_completer aws
fi

eval "$(direnv hook bash)"
