# Export vaults via BitWarden CLI
function bitwarden.export_vaults --description 'Export BitWarden vaults to a specified directory'
    set -l export_dir $argv[1]
    if test -z "$export_dir"
        echo "Usage: bitwarden.export_vaults <export_directory>"
        return 1
    end

    # Unlock Bitwarden CLI
    bitwarden.unlock

    # Sync from server
    bw sync

    # Export vaults to JSON file
    bitwarden.export_user_vault $export_dir
    bitwarden.export_org_vaults $export_dir

    echo "Bitwarden vaults exported successfully to $export_dir"
end
