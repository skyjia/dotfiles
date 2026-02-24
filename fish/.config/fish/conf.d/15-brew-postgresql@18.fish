# PostgreSQL 18 path configuration for fish shell
#   $ brew info postgresql@18
set --local postgresql_bin $HOMEBREW_PREFIX/opt/postgresql@18/bin
ensure_add_to_fish_user_paths "$postgresql_bin"
