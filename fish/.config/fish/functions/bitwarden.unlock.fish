# Unlock BitWarden vault and set session key
function bitwarden.unlock --description 'Unlock BitWarden vault and set session key'
    # Check if BitWarden CLI is installed
    if not type -q bw
        echo "Error: BitWarden CLI (bw) is not installed." >&2
        return 1
    end

    # Verify password file exists and has secure permissions (defense in depth)
    set -l pwfile ~/.config/bitwarden/.password
    if not test -f $pwfile
        echo "Error: Password file not found: $pwfile" >&2
        return 1
    end
    # stat -f %Lp works on macOS; stat -c %a on Linux
    set -l perms (stat -f %Lp $pwfile 2>/dev/null || stat -c %a $pwfile 2>/dev/null)
    if test "$perms" != "600"
        echo "Error: $pwfile has mode $perms (must be 600). Refusing to read master password." >&2
        echo "Run: chmod 600 $pwfile" >&2
        return 1
    end

    # Unlock BitWarden vault
    set -l session_key (bw unlock --raw --passwordfile $pwfile)
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
