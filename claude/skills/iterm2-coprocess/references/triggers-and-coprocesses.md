# Triggers and Coprocesses

Reference: https://iterm2.com/documentation-triggers.html

## Triggers Overview

Triggers are regex patterns that fire actions when matched in terminal output.

### Configuration

iTerm2 → Settings → Profiles → Advanced → Triggers → Edit

Each trigger has:

| Field | Description |
|-------|-------------|
| **Regular Expression** | Pattern to match (uses ICU regex syntax) |
| **Action** | What to do when matched |
| **Parameters** | Action-specific parameters |
| **Instant** | Fire immediately vs. wait for newline |
| **Enabled** | Toggle on/off |

### Available Actions

| Action | Use Case |
|--------|----------|
| **Run Coprocess** | Execute a script that can interact with terminal |
| **Run Silent Coprocess** | Coprocess with no output shown |
| **Run Command** | Execute shell command (no interaction) |
| **Send Text** | Type text into terminal |
| **Post Notification** | macOS notification |
| **Highlight Text** | Color the matched text |
| **Ring Bell** | Play alert sound |
| **Capture Output** | Save to Toolbelt |
| **Open URL** | Open matched URL |
| **Set Title** | Change window/tab title |
| **Set Mark** | Add navigation mark |
| **Annotate** | Add annotation to matched text |

## Coprocess Behavior

### How Coprocesses Work

1. **Trigger fires** → starts the coprocess command
2. **All terminal output** → piped to coprocess stdin
3. **All coprocess stdout** → typed into terminal as user input
4. **Coprocess stderr** → displayed in terminal

### Environment Limitations

Coprocesses run with a **minimal environment**:

- No shell initialization (`.zshrc`, `.bashrc`)
- No aliases
- Limited PATH
- May lack GUI session variables

**Solution**: Wrap command in login shell:

```
/bin/zsh -l -c '/path/to/your/command'
```

### stdin Behavior

- Coprocess stdin receives **all terminal output continuously**
- stdin **never closes** while the session is active
- Scripts must handle this (exit explicitly, use timeouts)

### Parameters Field

The Parameters field is the command to execute:

```
# Simple command
/usr/local/bin/my-script

# With arguments
/usr/local/bin/my-script --arg value

# With login shell (recommended)
/bin/zsh -l -c '/opt/homebrew/bin/uv run --quiet --script ~/bin/my-script'
```

## Silent Coprocesses

Use "Run Silent Coprocess" when you don't want the coprocess output to appear as terminal input. Useful for:

- Background logging
- File transfers (ZModem)
- Notification-only scripts

## Regex Tips

iTerm2 uses ICU regex syntax:

```regex
# Match TypeScript errors
error TS\d+:

# Match tsc summary
Found \d+ errors? in

# Match git push
\[remote:.*\]

# Match npm errors  
npm ERR!
```

### Escaping in Parameters

When using triggers with the Python API or complex commands:

```
# Double-escape for regex + shell
Found \\d+ errors?
```

## Trigger Strategy

### Trigger on Summary Lines

For patterns that repeat (errors, warnings), trigger on the **summary** that appears after all items:

```
# BAD: Fires 50 times for 50 errors
error TS\d+:

# GOOD: Fires once after all errors listed
Found \d+ errors? in
```

This ensures all output is available in scrollback when your script runs.

### Use Instant Sparingly

"Instant" triggers fire immediately without waiting for newline. Use when:

- Pattern is at end of line anyway
- You need immediate response
- The line won't have more content

## Debugging Triggers

1. **Test regex** in iTerm2's trigger editor (shows matches in real-time)
2. **Add `--debug` flag** to your scripts that outputs to stderr
3. **Watch stderr** — coprocess stderr appears in terminal
4. **Check if command works standalone**: 
   ```bash
   echo "test output matching your pattern" | your-command
   ```

## Programmatic Trigger Management

Triggers are stored in iTerm2 profiles. You can:

1. Export profile as JSON (includes triggers)
2. Use Dynamic Profiles to manage triggers as code
3. Use Python API to modify profiles (advanced)

