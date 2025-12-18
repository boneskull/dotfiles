# Session Class Methods

Reference: https://iterm2.com/python-api/session.html

The `Session` class represents a single terminal session (pane) and provides methods for reading content, adding annotations, sending input, and more.

## Getting a Session

```python
# Current session in current window/tab
session = app.current_terminal_window.current_tab.current_session

# By session ID
session = app.get_session_by_id(session_id)

# All sessions proxy (for notifications)
all_sessions = iterm2.Session.all_proxy(connection)
```

## Reading Content

### async_get_line_info()

Get information about the session's lines:

```python
line_info = await session.async_get_line_info()

line_info.overflow              # Lines lost to scrollback overflow
line_info.scrollback_buffer_height  # Lines in scrollback
line_info.mutable_area_height   # Visible screen height
line_info.first_visible_line_number  # Current scroll position
```

### async_get_contents(first_line, number_of_lines)

Read terminal content:

```python
# Read last 100 lines
start = max(line_info.overflow, 
            line_info.overflow + line_info.scrollback_buffer_height - 100)
contents = await session.async_get_contents(start, 100)

for line_content in contents:
    print(line_content.string)  # The text content
```

### async_get_screen_contents()

Read the mutable (visible) screen area:

```python
screen = await session.async_get_screen_contents()
```

## Annotations

### async_add_annotation(range, text)

Add an annotation (sticky note) to terminal content:

```python
# Annotate a full line
coord_range = iterm2.CoordRange(
    iterm2.Point(0, line_number),       # Start: (column, line)
    iterm2.Point(line_length, line_number),  # End
)
await session.async_add_annotation(coord_range, "Annotation text")
```

**Note**: Annotations are attached to coordinates, not text. They persist in scrollback.

## Sending Input

### async_send_text(text, suppress_broadcast=False)

Type text as if user typed it:

```python
await session.async_send_text("ls -la\n")
```

### async_inject(data)

Inject data as if it were program output:

```python
await session.async_inject(b"Injected output\n")
```

## Session Control

### async_activate(select_tab=True, order_window_front=True)

Make session active:

```python
await session.async_activate()
```

### async_close(force=False)

Close the session:

```python
await session.async_close(force=True)
```

### async_restart(only_if_exited=False)

Restart the session:

```python
await session.async_restart()
```

## Coprocess Methods

### async_get_coprocess()

Get currently running coprocess command (if any):

```python
coprocess_cmd = await session.async_get_coprocess()
```

### async_run_coprocess(command_line)

Start a coprocess programmatically:

```python
success = await session.async_run_coprocess("/path/to/script")
```

### async_stop_coprocess()

Stop running coprocess:

```python
stopped = await session.async_stop_coprocess()
```

## Variables

### async_get_variable(name)

Get a session variable:

```python
cwd = await session.async_get_variable("path")
job_name = await session.async_get_variable("jobName")
```

### async_set_variable(name, value)

Set a user variable (must start with "user."):

```python
await session.async_set_variable("user.myVar", "value")
```

## Properties

```python
session.session_id    # Unique identifier
session.grid_size     # Size in cells (iterm2.util.Size)
session.tab          # Containing Tab
session.window       # Containing Window
```

## Screen Streaming

For real-time screen updates:

```python
async with session.get_screen_streamer() as streamer:
    while True:
        contents = await streamer.async_get()
        # Process screen contents
```

## Selection

### async_get_selection()

Get currently selected text regions:

```python
selection = await session.async_get_selection()
```

### async_get_selection_text(selection)

Get text within a selection:

```python
text = await session.async_get_selection_text(selection)
```

