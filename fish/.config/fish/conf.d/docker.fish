if not command --query docker
    exit
end

set -l docker_completion_file_path $__fish_config_dir/completions/docker.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $docker_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $docker_completion_file_path)
    if test $seconds_since_modified -ge 604800 # 604800 seconds = 7 days
        command just --completions fish > $docker_completion_file_path
    end
else
  command just --completions fish > $docker_completion_file_path
end
