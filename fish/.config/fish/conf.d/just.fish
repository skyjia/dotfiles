if not command --query just
    exit
end

set -l just_completion_file_path $__fish_config_dir/completions/just.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $just_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $just_completion_file_path)
    if test $seconds_since_modified -ge 604800 # 604800 seconds = 7 days
        command just --completions fish > $just_completion_file_path
    end
else
  command just --completions fish > $just_completion_file_path
end
