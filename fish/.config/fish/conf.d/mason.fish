
set -l mason_bin $HOME/.local/share/nvim/mason/bin
if test -d $mason_bin
    ensure_add_to_fish_user_paths $mason_bin
end
