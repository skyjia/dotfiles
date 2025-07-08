# Configures Nushell to use Homebrew paths and sets up the environment variables
# for Homebrew on macOS, specifically for Apple Silicon (ARM64) installations.

use std/util "path add"

$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"

path add ("/opt/homebrew/sbin")
path add ("/opt/homebrew/bin")

$env.INFOPATH = (
	(if ($env.INFOPATH? | is-empty) {
		"/opt/homebrew/share/info"
	} else {
		($env.INFOPATH | split row (char esep) | append "/opt/homebrew/share/info" | str join (char esep))
	})
)
