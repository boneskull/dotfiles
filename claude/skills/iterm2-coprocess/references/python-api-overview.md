# iTerm2 Python API Overview

Reference: https://iterm2.com/python-api/

The iTerm2 Python API provides programmatic control over iTerm2 from Python scripts.

## Core Classes

### Connection

Entry point for all API interactions:

```python
connection = await iterm2.Connection.async_create()
```

### App

Represents the iTerm2 application:

```python
app = await iterm2.async_get_app(connection)

# Access windows, tabs, sessions
window = app.current_terminal_window
tab = window.current_tab
session = tab.current_session
```

### Window

A terminal window containing tabs:

```python
# List all windows
for window in app.terminal_windows:
    print(window.window_id)

# Create new window
new_window = await iterm2.Window.async_create(connection)
```

### Tab

A tab within a window, containing sessions (split panes):

```python
# Get all sessions in tab
sessions = tab.sessions

# Get current session
session = tab.current_session
```

### Session

A single terminal session (pane). Most operations happen here.

See `session-methods.md` for detailed Session class reference.

## Installation

```bash
pip install iterm2
# Or with uv inline:
# /// script
# dependencies = ["iterm2"]
# ///
```

## Async Pattern

All iTerm2 API methods are async. Use with `asyncio`:

```python
import asyncio
import iterm2

async def main():
    connection = await iterm2.Connection.async_create()
    app = await iterm2.async_get_app(connection)
    # ... your code ...

if __name__ == "__main__":
    asyncio.run(main())
```

## Class Hierarchy

```
App
├── Window (terminal_windows)
│   └── Tab (tabs)
│       └── Session (sessions) — or Splitter for split panes
│           └── Screen contents, variables, profile
```

## Additional Classes

| Class | Purpose |
|-------|---------|
| `Profile` | Terminal profile settings |
| `Color` | Color values |
| `Selection` | Text selection ranges |
| `Screen` | Screen contents and streaming |
| `StatusBar` | Status bar components |
| `Broadcast` | Input broadcasting |
| `Focus` | Focus change notifications |

## Resources

- [Tutorial](https://iterm2.com/python-api/tutorial/index.html)
- [Examples](https://iterm2.com/python-api/examples/index.html)
- [Full API Reference](https://iterm2.com/python-api/)

