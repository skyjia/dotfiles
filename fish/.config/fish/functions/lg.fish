# lazygit
#   https://github.com/jesseduffield/lazygit#changing-directory-on-exit
function lg --description 'Launch LazyGit with directory change on exit'
    set -x LAZYGIT_NEW_DIR_FILE ~/.lazygit/newdir

    lazygit $argv

    if test -f $LAZYGIT_NEW_DIR_FILE
        cd (cat $LAZYGIT_NEW_DIR_FILE)
        rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    end
end
