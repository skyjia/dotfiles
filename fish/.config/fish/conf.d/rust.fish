# Rust

# Cargo
set --local cargo_bin $HOME/.cargo/bin

# Ensure the CARGO_HOME environment variable is set
if set --query CARGO_HOME
    set cargo_bin $CARGO_HOME/bin
end

# Add the cargo bin directory to the fish user paths if it exists
ensure_add_to_fish_user_paths "$cargo_bin"

# Rustup
# https://rsproxy.cn/
set -gx RUSTUP_DIST_SERVER "https://rsproxy.cn"
set -gx RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"
