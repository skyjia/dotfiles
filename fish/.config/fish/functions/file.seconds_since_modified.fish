# Returns the number of seconds since a file was last modified
# Example usage: file.seconds_since_modified ~/myfile.txt
function file.seconds_since_modified --description 'Returns the number of seconds since a file was last modified'
    set -l file_path $argv[1]

    if test -z "$file_path"
        echo "Usage: file.seconds_since_modified <file_path>" >&2
        return 1
    end

    if not test -f "$file_path"
        echo "Error: '$file_path' is not a valid file." >&2
        return 1
    end

    set -l current_time (date +%s)
    set -l last_modified 0

    if test (uname) = "Darwin"
        set last_modified (stat -f %m "$file_path")
    else
        set last_modified (stat -c %Y "$file_path")
    end

    echo (math "$current_time - $last_modified")
end
