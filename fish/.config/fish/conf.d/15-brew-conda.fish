if status is-interactive
    # Uses the first conda installation found in the following list
    set -x CONDA_PATH $HOMEBREW_PREFIX/anaconda3/bin/conda

    function conda
        # echo "Lazy loading conda upon first invocation..."
        functions --erase conda # Erase this stub function
        for conda_path in $CONDA_PATH
            if test -f $conda_path
                # echo "Using Conda installation found in $conda_path"
                eval $conda_path "shell.fish" hook | source # Initialize conda in the current shell
                conda $argv # Execute the original command with the provided arguments
                return
            end
        end
        # echo "No conda installation found in $CONDA_PATH"
    end
else
    # TODO: anaconda is loading too slow.
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    if test -f /opt/homebrew/anaconda3/bin/conda
        eval /opt/homebrew/anaconda3/bin/conda "shell.fish" hook $argv | source
    else
        if test -f "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
            . "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
        else
            set -x PATH /opt/homebrew/anaconda3/bin $PATH
        end
    end
    # <<< conda initialize <<<
end
