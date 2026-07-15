use std/util "path add"

let shims_dir = (
  if ( $env | get --optional ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  } | path join 'shims'
)

# Add the ASDF shims directory to the PATH
path add ($shims_dir)

# Nushell doesn't auto-source completion scripts, so we save asdf's
# completion output to a file and let Nushell load it.
const completion_path = (path self . | path join '12-1-brew-asdf-completion.nu')
const tmp_path = ($completion_path + '.tmp')

# Regenerate only if content changed — avoids redundant disk writes
# and makes actual completion updates visible in `git diff`.
#
# Implementation notes:
# - We save asdf's output to a temp file first, because nushell's
#   `save` strips the trailing newline from byte streams. Comparing
#   the raw byte stream directly against `open --raw <file>` would
#   always differ (one has trailing \n, the other doesn't), causing
#   the file to be rewritten on every startup.
# - After both files have been through `save`, they share the same
#   trailing-newline behavior, so `cmp -s` gives a reliable
#   byte-for-byte comparison.
asdf completion nushell | save -f $tmp_path

let needs_update = if not ($completion_path | path exists) {
    true
} else {
    (^cmp -s $tmp_path $completion_path | complete | get exit_code) != 0
}

if $needs_update {
    mv $tmp_path $completion_path
} else {
    rm $tmp_path
}
