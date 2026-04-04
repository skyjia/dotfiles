if status is-interactive
    # 定义存根函数：只有当你输入 conda 或相关命令时，才会触发真正的初始化
    function conda --description 'Lazy load conda'
        functions --erase conda
        set -l conda_bin $HOMEBREW_PREFIX/anaconda3/bin/conda
        
        if test -f $conda_bin
            eval $conda_bin "shell.fish" hook | source
            conda $argv
        else
            echo "Conda not found at $conda_bin"
        end
    end
else
    # 非交互模式只加路径，不执行 hook，速度提升巨大
    fish_add_path /opt/homebrew/anaconda3/bin
end

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# if test -f /opt/homebrew/anaconda3/bin/conda
#     eval /opt/homebrew/anaconda3/bin/conda "shell.fish" hook $argv | source
# else
#     if test -f "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
#         . "/opt/homebrew/anaconda3/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH /opt/homebrew/anaconda3/bin $PATH
#     end
# end
# # <<< conda initialize <<<
