use std/util "path add"

let shims_dir = (
  if ( $env | get --ignore-errors ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  } | path join 'shims'
)

# Add the ASDF shims directory to the PATH
path add ($shims_dir)

# FIXME: This is a tricky part, as the completion script is not
# automatically sourced by Nushell. We need to manually save the
# completion script to a file that Nushell can source.
const completion_path = (path self . | path join '12-1-brew-asdf-completion.nu')
asdf completion nushell | save -f $completion_path
