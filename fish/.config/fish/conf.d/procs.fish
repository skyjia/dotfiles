if not command --query procs
    exit
end

set -l procs_completion_file_path $__fish_config_dir/completions/procs.fish

# Only generate the completion file if it does not exist or is older than 7 days
if test -f $procs_completion_file_path
    set -l seconds_since_modified (file.seconds_since_modified $procs_completion_file_path)
    if test $seconds_since_modified -gt 604800 # 604800 seconds = 7 days
        command procs --gen-completion-out fish > $procs_completion_file_path
    end
else
    command procs --gen-completion-out fish > $procs_completion_file_path
end
