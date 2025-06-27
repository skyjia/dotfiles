# Android SDK Home
set -gx ANDROID_HOME "$HOME/Library/Android/sdk"

# Add Android SDK platform-tools and cmdline-tools to PATH
if test -d $ANDROID_HOME
    ensure_add_to_fish_user_paths "$ANDROID_HOME/platform-tools"
    ensure_add_to_fish_user_paths "$ANDROID_HOME/cmdline-tools/latest/bin"
end
