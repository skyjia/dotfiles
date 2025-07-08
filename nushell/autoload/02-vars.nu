# Language locale
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# Golang
$env.GOPATH = ($env.HOME | path join "Codes/go")

# Dotnet
$env.DOTNET_ROOT = ($env.HOME | path join ".dotnet")

# GPG
$env.GPG_TTY = (tty)
