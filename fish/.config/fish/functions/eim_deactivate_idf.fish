function eim_deactivate_idf -d "Deactivate the Espressif IoT Development Framework (EIM) environment."
    # Check if the EIM tools directory exists
    set -l eim_tools $HOME/.espressif/tools
    if not test -d $eim_tools
        echo "Error: EIM tools directory does not exist: $eim_tools" >&2
        return 1
    end

    set -l idf_ver $argv[1]
    set -l fish_script "$eim_tools/deactivate_idf_$idf_ver.fish"

    if test -f $fish_script
        echo "Deactivating EIM environment for IDF version: $idf_ver"
        source $fish_script
    else
        echo "Error: deactivation script not found: $fish_script" >&2
        return 1
    end
end

