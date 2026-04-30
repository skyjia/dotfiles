function reset_app_permissions -d "Reset all macOS permissions for a given app path"
    if test (count $argv) -eq 0
        echo "Usage: reset_app_permissions <app_path>"
        echo "Example: reset_app_permissions /Applications/Moom.app"
        return 1
    end

    set -l app_path $argv[1]

    # Verify the app exists
    if not test -e $app_path
        echo "Error: App not found at $app_path"
        return 1
    end

    # Get the bundle identifier
    set -l bundle_id (mdls -name kMDItemCFBundleIdentifier -raw $app_path 2>/dev/null)

    if test -z "$bundle_id"; or test "$bundle_id" = "(null)"
        echo "Error: Could not determine bundle identifier for $app_path"
        return 1
    end

    echo "App: $app_path"
    echo "Bundle ID: $bundle_id"
    echo "Resetting permissions..."

    # Reset all permissions for the bundle
    tccutil reset All $bundle_id

    if test $status -eq 0
        echo "Successfully reset permissions for $bundle_id"
    else
        echo "Failed to reset permissions for $bundle_id"
        return 1
    end
end