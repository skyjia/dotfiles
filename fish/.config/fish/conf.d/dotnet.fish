# set -gx DOTNET_ROOT $HOME/.dotnet
set --local dotnet_root_local $HOME/.dotnet

# Ensure the DOTNET_ROOT environment variable is set
if set --query DOTNET_ROOT
    set dotnet_root_local $DOTNET_ROOT
end

# Add the dotnet root and tools directories to the fish user paths if they exist
ensure_add_to_fish_user_paths "$dotnet_root_local"
ensure_add_to_fish_user_paths "$dotnet_root_local/tools"
