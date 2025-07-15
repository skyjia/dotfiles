if not command --query podman
    exit
end

set -l podman_completion_file_path $__fish_config_dir/completions/podman.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $podman_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $podman_completion_file_path)
    if test $seconds_since_modified -ge 604800 # 604800 seconds = 7 days
        command just --completions fish > $podman_completion_file_path
    end
else
  command just --completions fish > $podman_completion_file_path
end
