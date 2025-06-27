function ensure_add_to_fish_user_paths --argument-names path --description 'Add a path to fish_user_paths if not already present'
    if test -d $path
        contains -- $path $fish_user_paths
        or fish_add_path --prepend --move --path $path
    end
end
