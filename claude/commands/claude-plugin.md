---
description: Execute a command from any installed Claude plugin
argument-hint: <plugin-name> <command-name> [command-args...]
---

# /claude-plugin Command Launcher

Execute commands from installed Claude plugins that aren't directly accessible in Cursor.

## Usage

```
/claude-plugin <plugin-name> <command-name> [command-arguments...]
```

## How It Works

1. **Locate the plugin**: Read `~/.claude/plugins/installed_plugins.json` to find the plugin's install path
2. **Find the command**: Look for the command file at `{installPath}/commands/{command-name}.md`
3. **Execute**: Load and follow the command's instructions with any additional arguments

## Examples

```bash
# Run the brainstorm command from superpowers plugin
/claude-plugin superpowers brainstorm "How can we improve error handling?"

# Run the resolve-review-comments command from github plugin
/claude-plugin github resolve-review-comments 123

# Run the hello command from example-plugin
/claude-plugin example-plugin hello
```

## Implementation

When this command is invoked:

1. **Parse arguments**:
   - First argument: plugin name (e.g., "superpowers", "github")
   - Second argument: command name (e.g., "brainstorm", "resolve-review-comments")
   - Remaining arguments: pass through to the command

2. **Load plugin registry**:

   ```bash
   cat ~/.claude/plugins/installed_plugins.json
   ```

   - Extract the `installPath` for the requested plugin
   - Handle plugin name formats (e.g., "superpowers@superpowers-marketplace")

3. **Locate command file**:
   - Construct path: `{installPath}/commands/{command-name}.md`
   - Verify file exists

4. **Load and execute**:
   - Read the command file
   - Pass any remaining arguments to the command
   - Follow the command's instructions exactly

## Error Handling

If plugin not found:

```text
❌ Plugin '{plugin-name}' not installed.
Available plugins: {list from installed_plugins.json}
```

If command not found:

```text
❌ Command '{command-name}' not found in plugin '{plugin-name}'.
Available commands: {list files in installPath/commands/}
```

If no arguments provided:

```text
❌ Usage: /claude-plugin <plugin-name> <command-name> [args...]

To list installed plugins, use:
  /claude-plugin list

To list commands in a plugin, use:
  /claude-plugin <plugin-name> list
```

## Special Commands

### List all plugins

```text
/claude-plugin list
```

Shows all installed plugins with their versions.

### List commands in a plugin

```text
/claude-plugin <plugin-name> list
```

Shows all available commands in the specified plugin.

## Instructions for Claude

When this command is executed:

1. **Extract arguments from the command invocation**
2. **Read the installed plugins file**:

   ```bash
   cat ~/.claude/plugins/installed_plugins.json
   ```

3. **Find the plugin**:
   - Look for exact match in the `plugins` object keys
   - Keys are formatted as: `{plugin-name}@{marketplace-name}`
   - Extract the `installPath` field

4. **Handle special commands**:
   - If command is "list" and no plugin specified: list all installed plugins
   - If command is "list" and plugin specified: list commands in that plugin

5. **Construct command file path**:

   ```text
   {installPath}/commands/{command-name}.md
   ```

6. **Read the command file**:

   ```bash
   cat {installPath}/commands/{command-name}.md
   ```

7. **Execute the command**:
   - Load the command content
   - Pass through any additional arguments
   - Follow the command's instructions exactly as if it were invoked directly

## Example Execution Flow

User runs:

```text
/claude-plugin github resolve-review-comments 123
```

Claude executes:

```bash
# 1. Load plugin registry
cat ~/.claude/plugins/installed_plugins.json
# Find: "github@boneskull-plugins" with installPath: "~/.claude/plugins/marketplaces/boneskull-plugins/plugins/github"

# 2. Construct command path
# Path: ~/.claude/plugins/marketplaces/boneskull-plugins/plugins/github/commands/resolve-review-comments.md

# 3. Load command
cat ~/.claude/plugins/marketplaces/boneskull-plugins/plugins/github/commands/resolve-review-comments.md

# 4. Execute with argument "123"
# Follow the command's instructions with PR_NUMBER=123
```

## Notes

- Plugin names in `installed_plugins.json` include marketplace suffix (e.g., "superpowers@superpowers-marketplace")
- Match plugin names with or without the marketplace suffix
- Command names are the filename without `.md` extension
- All additional arguments after the command name are passed to the target command
