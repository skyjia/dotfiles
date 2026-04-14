#!/usr/bin/env nu
# Check all tools versions installed by asdf, and print the versions to stdout.
# This is useful for CI to check if the correct versions are installed.

# Get all installed versions of a tool matching a regex pattern.
def get_installed_version [tool: string, version_regex: string] {
    asdf list $tool
    | lines
    | str trim
    | str replace -r '^\s*\*\s*' ''
    | where $it =~ $version_regex
}

# Get the latest available version of a tool matching a regex pattern.
def get_latest_version [tool: string, version_regex: string] {
    asdf list all $tool
    | lines
    | where $it =~ $version_regex
    | last
}

# Check if the latest version of a tool is installed and print the result.
def check_tool [tool: string, version_regex: string] {
    let installed = (get_installed_version $tool $version_regex)
    let latest = (get_latest_version $tool $version_regex)

    let color = if $latest in $installed { "green_bold" } else { "red_bold" }
    let status = if $latest in $installed { "is" } else { "is not" }
    let flag = if $latest in $installed { "✅" } else { "❌" }

    print $"($flag) Latest ($tool) version (ansi ($color))($latest)(ansi reset) ($status) installed."
}

print $"(ansi yellow_bold)Current tools versions installed by asdf:(ansi reset)"
asdf list

print $"(ansi yellow_bold)Checking installed versions of tools managed by asdf...(ansi reset)"

check_tool "java"   '^adoptopenjdk-\d+.*LTS$' # e.g. adoptopenjdk-11.0.11+9-LTS
check_tool "nodejs" '^\d+\.\d+\.\d+$' # e.g. 14.17.0
check_tool "ruby"   '^\d+\.\d+\.\d+$' # e.g. 2.7.3
check_tool "ruby"   '^truffleruby\+graalvm-\d+\.\d+\.\d+$' # e.g. truffleruby+graalvm-33.0.1
