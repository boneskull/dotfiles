# Building iTerm2 Coprocess Scripts with the Python API

This skill covers creating iTerm2 coprocess scripts that leverage the [iTerm2 Python API](https://iterm2.com/python-api/) for terminal automation and integration.

## What is a Coprocess?

A coprocess is a script that runs alongside an iTerm2 terminal session with a bidirectional relationship:

- **All terminal output** is sent to the coprocess as stdin
- **All coprocess output** is typed into the terminal as if the user typed it

Coprocesses are typically launched via **Triggers** — regex patterns that fire when matched in terminal output.

## Quick Start

### Prerequisites

1. **Enable Python API**: iTerm2 → Settings → General → Magic → Enable Python API
2. **Install uv** (recommended): `brew install uv` — handles dependencies via PEP 723 inline metadata
3. **Create script** with inline dependencies:

```python
#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["iterm2"]
# ///

import asyncio
import iterm2

async def main():
    connection = await iterm2.Connection.async_create()
    app = await iterm2.async_get_app(connection)
    session = app.current_terminal_window.current_tab.current_session
    # Do stuff with session...

if __name__ == "__main__":
    asyncio.run(main())
```

### Setting Up a Trigger

1. iTerm2 → Settings → Profiles → Advanced → Triggers → Edit
2. Add trigger:
   - **Regex**: Pattern to match (e.g., `error TS\d+:`)
   - **Action**: `Run Coprocess`
   - **Parameters**: Full command to run

## Critical Gotchas

### 1. Coprocesses Have No Shell Environment

The coprocess runs without your `.zshrc`, aliases, or PATH. Wrap in a login shell:

```
/bin/zsh -l -c '/opt/homebrew/bin/uv run --quiet --script ~/bin/my-script'
```

### 2. stdin Never Closes

Coprocesses receive ALL terminal output continuously. If you read stdin, you must:
- Exit explicitly with `os._exit(0)` after completing work
- Or use a timeout pattern

### 3. Subprocesses Need stdin=DEVNULL

If your coprocess spawns other processes (like CLI tools), they may hang waiting for input:

```python
subprocess.run(
    ["some-command", "--arg"],
    stdin=subprocess.DEVNULL,  # CRITICAL: prevents hanging
    capture_output=True,
)
```

### 4. Keychain Access Requires Login Shell

macOS Keychain (used by OAuth-authenticated CLIs) needs proper environment. The login shell wrapper (`/bin/zsh -l -c '...'`) handles this.

### 5. Trigger on Summary Lines, Not Individual Events

If matching repeated patterns (like compiler errors), trigger on the **summary** line that appears AFTER all events. This ensures all output is in the scrollback buffer when your script runs.

## Reading Terminal Scrollback

Instead of capturing stdin (unreliable due to startup latency), read the scrollback buffer directly:

```python
async def read_scrollback(session, num_lines=100):
    line_info = await session.async_get_line_info()
    start = max(
        line_info.overflow,
        line_info.overflow + line_info.scrollback_buffer_height - num_lines
    )
    contents = await session.async_get_contents(start, num_lines)
    return [(start + i, line.string) for i, line in enumerate(contents)]
```

## Adding Annotations

Annotations are sticky notes attached to terminal output:

```python
coord_range = iterm2.CoordRange(
    iterm2.Point(0, line_number),      # Start: column 0
    iterm2.Point(line_length, line_number),  # End: full line width
)
await session.async_add_annotation(coord_range, "Your annotation text")
```

## Streaming Subprocess Output

For long-running subprocesses, use `Popen` with threading to stream output:

```python
import subprocess
import threading

process = subprocess.Popen(
    ["command", "--args"],
    stdin=subprocess.DEVNULL,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
)

def read_stderr():
    for line in process.stderr:
        print(f"stderr: {line.rstrip()}", file=sys.stderr)

stderr_thread = threading.Thread(target=read_stderr, daemon=True)
stderr_thread.start()

for line in process.stdout:
    print(f"stdout: {line.rstrip()}")

process.wait(timeout=30)
```

## Example: TypeScript Error Explainer

See `tag-osx/bin/ts-error-explainer` for a complete example that:

1. Triggers on `Found \d+ errors? in` (tsc summary line)
2. Reads scrollback to find error blocks
3. Sends errors to Claude CLI for explanation
4. Annotates the error line with the explanation

## Debugging Tips

1. **Add a `--debug` flag** that prints to stderr
2. **iTerm2 shows coprocess stderr** in the terminal
3. **Test with pipes first**: `echo "test output" | your-script --debug`
4. **Check if commands work without shell**: `env -i PATH=/opt/homebrew/bin:/usr/bin HOME=$HOME your-command`

## References

For deeper material, see:

- `references/python-api-overview.md` — iTerm2 Python API class reference
- `references/session-methods.md` — Session class methods for reading/writing
- `references/triggers-and-coprocesses.md` — Trigger configuration details

