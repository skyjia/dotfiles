# Unlock BitWarden vault and set session key
function bitwarden.unlock --description 'Unlock BitWarden vault and set session key'
    # Check if BitWarden CLI is installed
    if not type -q bw
        echo "Error: BitWarden CLI (bw) is not installed." >&2
        return 1
    end

    # Unlock BitWarden vault
    set -l session_key (bw unlock --raw --passwordfile ~/.config/bitwarden/.password)
    if test -z "$session_key"
        echo "Failed to unlock BitWarden vault. Please ensure you are logged in." >&2
        return 1
    end

    if test $status -ne 0
        echo "Failed to unlock BitWarden vault." >&2
        return 1
    end
    
    # Export session key to environment variable
    set -gx BW_SESSION $session_key
    echo "BitWarden vault unlocked successfully."
end
