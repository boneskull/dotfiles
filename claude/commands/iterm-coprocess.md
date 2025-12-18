---
description: Create an iTerm2 coprocess script with Python API integration
argument-hint: <trigger-pattern> <description>
---

# /iterm-coprocess Command

Scaffold a new iTerm2 coprocess script that uses the Python API.

## Usage

```
/iterm-coprocess <trigger-pattern> <description>
```

## Arguments

- **trigger-pattern**: Regex pattern that will trigger this coprocess (e.g., `error TS\d+:`)
- **description**: Brief description of what the coprocess does

## What This Command Does

1. Creates a new Python script with the coprocess boilerplate
2. Sets up PEP 723 inline dependencies (for `uv run`)
3. Includes the critical gotchas already handled:
   - Login shell wrapper in docstring
   - `stdin=subprocess.DEVNULL` for subprocesses
   - `os._exit(0)` for clean termination
   - Debug flag and output
   - ANSI code stripping
   - Scrollback buffer reading

## Instructions for Claude

When this command is invoked:

### 1. Load the Skill Documentation

Read the skill file for reference:

```bash
cat ~/.dotfiles/claude/skills/iterm2-coprocess/SKILL.md
```

### 2. Prompt for Details

Ask the user:

1. **What should the coprocess do when triggered?**
   - Read scrollback and process it?
   - Run a command and display output?
   - Add annotations?
   - Something else?

2. **Where should the script be saved?**
   - Default: `~/bin/<name-based-on-trigger>.py`
   - Or specify a custom path

3. **Does it need to call external tools?**
   - If yes, which ones? (for subprocess setup)

### 3. Generate the Script

Create a Python script with this structure:

```python
#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["iterm2"]
# ///
"""
<Description from argument>

Trigger setup:
  1. iTerm2 → Settings → Profiles → Advanced → Triggers → Edit
  2. Add trigger:
     - Regex: <trigger-pattern>
     - Action: Run Coprocess
     - Parameters: /bin/zsh -l -c '/opt/homebrew/bin/uv run --quiet --script <script-path>'
"""

import argparse
import asyncio
import os
import re
import subprocess
import sys

import iterm2

DEBUG = False
ANSI_ESCAPE = re.compile(r"\x1b\[[0-9;]*m")


def strip_ansi(text: str) -> str:
    return ANSI_ESCAPE.sub("", text)


def debug(msg: str) -> None:
    if DEBUG:
        print(f"[<script-name>] {msg}", file=sys.stderr)


async def main_async() -> None:
    debug("Connecting to iTerm2...")
    
    connection = await iterm2.Connection.async_create()
    app = await iterm2.async_get_app(connection)
    session = app.current_terminal_window.current_tab.current_session
    
    if not session:
        debug("No active session")
        os._exit(1)
    
    # Read scrollback
    line_info = await session.async_get_line_info()
    search_lines = 100
    start = max(line_info.overflow,
                line_info.overflow + line_info.scrollback_buffer_height - search_lines)
    num_lines = min(search_lines,
                    line_info.scrollback_buffer_height + line_info.mutable_area_height)
    
    contents = await session.async_get_contents(start, num_lines)
    lines = [(start + i, strip_ansi(lc.string)) for i, lc in enumerate(contents)]
    
    # TODO: Implement your logic here
    # - Search lines for pattern
    # - Process matched content
    # - Add annotations or take other actions
    
    debug("Done")
    os._exit(0)


def main() -> None:
    global DEBUG
    
    parser = argparse.ArgumentParser(description="<Description>")
    parser.add_argument("--debug", action="store_true", help="Enable debug output")
    args = parser.parse_args()
    DEBUG = args.debug
    
    debug("Starting...")
    
    try:
        asyncio.run(main_async())
    except Exception as e:
        debug(f"Fatal: {e}")
        os._exit(1)


if __name__ == "__main__":
    main()
```

### 4. Customize Based on User's Answers

- Add subprocess calls with `stdin=subprocess.DEVNULL`
- Add annotation logic if needed
- Add pattern matching for specific content
- Fill in the TODO section with actual implementation

### 5. Make Executable and Provide Setup Instructions

```bash
chmod +x <script-path>
```

Then display:

```
✅ Created: <script-path>

To activate, add this iTerm2 trigger:
  - Regex: <trigger-pattern>
  - Action: Run Coprocess
  - Parameters: /bin/zsh -l -c '/opt/homebrew/bin/uv run --quiet --script <script-path>'

Test with:
  echo "<sample matching text>" | <script-path> --debug
```

## Example

```
/iterm-coprocess "npm ERR!" "Explain npm errors with Claude"
```

Creates a script that:
1. Triggers on npm errors
2. Reads the error from scrollback
3. Sends to Claude for explanation
4. Annotates the error line

## References

For implementation details, see:
- `~/.dotfiles/claude/skills/iterm2-coprocess/SKILL.md`
- `~/.dotfiles/claude/skills/iterm2-coprocess/references/`
- Working example: `~/.dotfiles/tag-osx/bin/ts-error-explainer`

