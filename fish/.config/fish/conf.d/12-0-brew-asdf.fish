# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

if not command --query asdf
    exit
end

if not status is-interactive
    exit
end

# ASDF completions
set -l asdf_completion_file_path $__fish_config_dir/completions/asdf.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $asdf_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $asdf_completion_file_path)
    if test $seconds_since_modified -ge 604800 # 604800 seconds = 7 days
        command docker completion fish > $asdf_completion_file_path
    end
else
  command asdf completion fish > $asdf_completion_file_path
end
