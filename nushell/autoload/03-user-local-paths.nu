use std/util "path add"

# Export HOME local bin
path add ($env.HOME | path join "bin")
path add ($env.HOME | path join ".local/bin")
