# OpenSSL 3.0

# Ensure the OpenSSL 3.0 binary path is set
set --local openssl_bin $HOMEBREW_PREFIX/opt/openssl@3/bin
ensure_add_to_fish_user_paths "$openssl_bin"

# Ensure the OpenSSL 3.0 pkg-config path is set
set -gx PKG_CONFIG_PATH $HOMEBREW_PREFIX/opt/openssl@3/lib/pkgconfig $PKG_CONFIG_PATH

# Ensure the OpenSSL 3.0 libraries and headers are available
# Note: The following lines are commented out to avoid conflicts with other configurations
# set -gx LDFLAGS "-L$HOMEBREW_PREFIX/opt/openssl@3/lib $LDFLAGS"
# set -gx CPPFLAGS "-I$HOMEBREW_PREFIX/opt/openssl@3/include $CPPFLAGS"
