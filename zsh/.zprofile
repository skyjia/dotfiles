# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.zprofile_secure.sh ]; then
    # shellcheck disable=SC1090
    source ~/.zprofile_secure.sh
fi
