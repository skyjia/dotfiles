function eim_idf_export -d "Export the Espressif IoT Development Framework (EIM) environment variables."
    # Check if the EIM tools directory exists
    set -l eim_dir $HOME/.espressif
    if not test -d $eim_dir
        echo "Error: EIM directory does not exist: $eim_dir" >&2
        return 1
    end

    set -l idf_ver $argv[1]
    set -l fish_script "$eim_dir/$idf_ver/esp-idf/export.fish"

    if test -f $fish_script
        echo "Exporting EIM environment for IDF version: $idf_ver"
        source $fish_script
    else
        echo "Error: export script not found: $fish_script" >&2
        return 1
    end
end

