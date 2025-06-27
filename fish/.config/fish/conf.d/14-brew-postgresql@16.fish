# PostgreSQL 16 path configuration for fish shell
#   $ brew info postgresql@16
set --local postgresql_bin $HOMEBREW_PREFIX/opt/postgresql@16/bin
ensure_add_to_fish_user_paths "$postgresql_bin"
