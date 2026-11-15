use std/util "path add"

# Lean / elan toolchain: ~/.elan/bin provides elan, lean, lake, leanc, leanpkg.
#
# Gotcha: `default_toolchain` in ~/.elan/settings.toml is the channel alias `stable`.
# If that release is not installed, running `lean` outside a project directory makes
# elan download it (~900 MB). Check resolution with: elan show
path add ($env.HOME | path join ".elan/bin")
