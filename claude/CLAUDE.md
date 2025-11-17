# Global User Instructions

This file contains personal instructions that apply to ALL Claude Code sessions across ALL projects.

## Git Commit Messages

### CRITICAL: Never Use HEREDOC Syntax

When creating git commits, you **MUST** use `-m` with multiline strings in double quotes. **NEVER** use HEREDOC syntax (`cat <<'EOF'`), as it fails in Claude Code's Bash tool execution environment.

#### ✅ Correct Approach

```bash
git commit -m "feat(tools): add new feature

This is a longer description that explains
what the feature does and why.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

#### ❌ Never Do This

```bash
# THIS WILL FAIL - DO NOT USE
git commit -m "$(cat <<'EOF'
feat(tools): add new feature
EOF
)"
```

**Why:** HEREDOC requires complex shell parsing that breaks in Claude Code's Bash tool. Multiline strings in double quotes work perfectly and are simpler.
