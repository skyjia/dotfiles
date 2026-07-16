# Go environment setup for Fish shell
#
# Cache `brew --prefix golang` result (TTL: 24 hours) to avoid the
# ~26ms subprocess cost on every fish startup.

set -U BREW_GOLANG_CACHE_TTL 86400

set -l now (date +%s)
if not set -q BREW_GOLANG_CACHE_VALUE
    or not set -q BREW_GOLANG_CACHE_TIME
    or test (math "$now - $BREW_GOLANG_CACHE_TIME") -ge $BREW_GOLANG_CACHE_TTL
    set -U BREW_GOLANG_CACHE_VALUE (brew --prefix golang)
    set -U BREW_GOLANG_CACHE_TIME $now
end

set -x GOROOT $BREW_GOLANG_CACHE_VALUE/libexec

if command --query go
    ensure_add_to_fish_user_paths (go env GOROOT)/bin
    ensure_add_to_fish_user_paths (go env GOPATH)/bin
end
