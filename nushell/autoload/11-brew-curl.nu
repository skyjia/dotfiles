use std/util "path add"

# make Homebrew use brewed curl
# https://github.com/orgs/Homebrew/discussions/1752
$env.HOMEBREW_FORCE_BREWED_CURL = "1"

# curl (via Homebrew)
let curl_bin = ($env.HOMEBREW_PREFIX | path join "opt/curl/bin")
path add ($curl_bin)
