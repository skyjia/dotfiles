# Go environment setup for Fish shell
set -x GOROOT (brew --prefix golang)/libexec

if command --query go
    ensure_add_to_fish_user_paths (go env GOROOT)/bin
    ensure_add_to_fish_user_paths (go env GOPATH)/bin
end
