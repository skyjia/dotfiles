# Local claude
set -l clause_local_path "$HOME/.claude/local"

if test -d $clause_local_path
    ensure_add_to_fish_user_paths "$clause_local_path"
end

# Use AnyRouter for Claude Code
set -gx ANTHROPIC_BASE_URL "https://anyrouter.top"
