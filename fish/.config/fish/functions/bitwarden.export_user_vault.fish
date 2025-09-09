# Export BitWarden vault for the current user
function bitwarden.export_user_vault --description 'Export BitWarden vault for the current user
    to a specified directory'
    set -l export_dir $argv[1]
    if test -z "$export_dir"
        echo "Usage: bitwarden.export_user_vault <export_directory>"
        return 1
    end

    if test -z "$BW_SESSION"
        echo "BitWarden vault is not unlocked. Please unlock it first."
        return 1
    end

    # Export vaults to JSON file
    set -l export_file "$export_dir/bw-vault_user_$(date +'%Y-%m-%d_%H-%M-%S').json"
    
    echo "Exporting user vault..."
    bw export --output $export_file --format json
end
