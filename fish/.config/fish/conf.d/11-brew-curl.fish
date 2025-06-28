# make Homebrew use brewed curl
# https://github.com/orgs/Homebrew/discussions/1752
set -gx  HOMEBREW_FORCE_BREWED_CURL 1

# curl (via Homebrew)
set --local curl_bin $HOMEBREW_PREFIX/opt/curl/bin
ensure_add_to_fish_user_paths "$curl_bin"
