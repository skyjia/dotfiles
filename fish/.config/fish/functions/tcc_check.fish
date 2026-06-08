function tcc_check --description "Query macOS TCC permissions for a given app path"
    # 1. Check if an argument is passed
    if test (count $argv) -lt 1
        echo "❌ Error: Please provide an application path."
        echo "Usage: tcc_check /Applications/Example.app"
        return 1
    end

    set -l app_path $argv[1]

    # 2. Check if the app directory actually exists
    if not test -d $app_path
        echo "❌ Error: Path does not exist -> $app_path"
        return 1
    end

    # 3. Extract the Bundle ID using the mdls tool
    set -l bundle_id (mdls -name kMDItemCFBundleIdentifier -raw $app_path 2>/dev/null)

    if test -z "$bundle_id"; or test "$bundle_id" = "(null)"
        echo "Error: Could not determine bundle identifier for $app_path"
        return 1
    end

    echo "🔍 App Found: $app_path"
    echo "🆔 Bundle ID: $bundle_id"
    echo "--------------------------------------------------------"

    # 64. Run the SQLite query against the user TCC database
    set -l db_path "$HOME/Library/Application Support/com.apple.TCC/TCC.db"

    if not head -c 10 "$db_path" >/dev/null 2>&1
        echo "❌ Permission denied: Current terminal application requires [Full Disk Access]"
        return 1
    end
    
    sqlite3 -box -header "$db_path" "
    SELECT 
        CASE service
            WHEN 'kTCCServiceSystemPolicyAllFiles'          THEN 'Full Disk Access'
            WHEN 'kTCCServiceSystemPolicyDesktopFolder'     THEN 'Desktop Folder'
            WHEN 'kTCCServiceSystemPolicyDocumentsFolder'   THEN 'Documents Folder'
            WHEN 'kTCCServiceSystemPolicyDownloadsFolder'   THEN 'Downloads Folder'
            WHEN 'kTCCServiceSystemPolicyDeveloperFiles'    THEN 'Developer Files'
            WHEN 'kTCCServiceSystemPolicyNetworkVolumes'    THEN 'Network Volumes'
            WHEN 'kTCCServiceSystemPolicyRemovableVolumes'  THEN 'Removable Volumes'
            WHEN 'kTCCServiceFileProviderDomain'            THEN 'Cloud File Provider'
            WHEN 'kTCCServiceCamera'                        THEN 'Camera'
            WHEN 'kTCCServiceMicrophone'                    THEN 'Microphone'
            WHEN 'kTCCServicePhotos'                        THEN 'Photos Library'
            WHEN 'kTCCServiceAddressBook'                   THEN 'Contacts'
            WHEN 'kTCCServiceCalendar'                      THEN 'Calendar'
            WHEN 'kTCCServiceReminders'                     THEN 'Reminders'
            WHEN 'kTCCServiceMediaLibrary'                  THEN 'Media Library'
            WHEN 'kTCCServiceScreenCapture'                 THEN 'Screen Recording'
            WHEN 'kTCCServicePostEvent'                     THEN 'Accessibility (Control)'
            WHEN 'kTCCServiceListenEvent'                   THEN 'Input Monitoring'
            WHEN 'kTCCServiceAppleEvents'                   THEN 'Automation'
            WHEN 'kTCCServiceSpeechRecognition'             THEN 'Speech Recognition'
            ELSE service 
        END AS 'Permission Type',
        CASE auth_value
            WHEN 0 THEN '[DENIED]'
            WHEN 1 THEN '[UNKNOWN]'
            WHEN 2 THEN '[ALLOWED]'
            WHEN 3 THEN '[LIMITED]'
            ELSE 'CODE (' || auth_value || ')'
        END AS 'Status',
        CASE auth_reason
            WHEN 1 THEN 'Error induced'
            WHEN 2 THEN 'User clicked Allow on popup'
            WHEN 3 THEN 'User changed manually in Settings'
            WHEN 4 THEN 'System default setting'
            WHEN 5 THEN 'Internal service policy'
            WHEN 6 THEN 'MDM profile deployment'
            WHEN 7 THEN 'System security override'
            WHEN 11 THEN 'App Signature Entitlement'
            ELSE 'Unknown reason (' || auth_reason || ')'
        END AS 'Reason'
    FROM access 
    WHERE client='$bundle_id';"
end
