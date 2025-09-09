# Export BitWarden vault for the current user
function bitwarden.export_org_vaults --description 'Export BitWarden vault for the current user
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

    # Query all organization id and name, export all vaults to JSON file
    set -l orgs (bw list organizations --raw | jq -c '.[] | {id: .id, name: .name}')
    for org in $orgs
        set -l org_id (echo $org | jq -r '.id')
        set -l org_name (echo $org | jq -r '.name')
        set -l escaped_org_name (string replace ' ' '_' $org_name | string lower)
        set -l export_file "$export_dir/bw-vault_org_$escaped_org_name""_$(date +'%Y-%m-%d_%H-%M-%S').json"

        echo "Exporting vault for organization '$org_name'..."
        bw export --output $export_file --format json --organizationid $org_id
    end
end
