# Lean / elan toolchain
#
# Retained deliberately: the Lean toolchain is in use. ~/.elan/bin holds elan, lean,
# lake, leanc and leanpkg. Also wired for zsh (zsh/.shared-env.zsh) and nushell
# (nushell/autoload/13-lean.nu).
#
# Gotcha: ~/.elan/settings.toml sets default_toolchain = "leanprover/lean4:stable",
# and "stable" is a channel alias. If that release is not installed, running `lean`
# outside a project directory makes elan download it (~900 MB). Check with `elan show`.
ensure_add_to_fish_user_paths "$HOME/.elan/bin"
