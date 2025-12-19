# moonbit
set --local moonbit_bin $HOME/.moon/bin

# Add the moon bin directory to the fish user paths if it exists
ensure_add_to_fish_user_paths "$moonbit_bin"

# Generate fish completion script for moonbit
set -l moonbit_completion_file_path $__fish_config_dir/completions/moonbit.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $moonbit_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $moonbit_completion_file_path)
    if test $seconds_since_modified -ge 604800 # 604800 seconds = 7 days
        command moon shell-completion --shell fish > $moonbit_completion_file_path
    end
else
  command moon shell-completion --shell fish > $moonbit_completion_file_path
end
