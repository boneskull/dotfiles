# Übersicht Widgets

> Desktop widgets for [Übersicht](http://tracesof.net/uebersicht/) on macOS.
>
> **Note for AI agents**: When creating a new widget, update this README with the widget's directory structure entry, a "Widget Details" section, and any new dependencies or setup requirements.

## What is Übersicht?

[Übersicht](https://github.com/felixhageloh/uebersicht) turns your macOS desktop into a web page. Widgets are React/JSX components that can be absolutely positioned anywhere on the screen. They execute shell commands periodically and render the output.

Key concepts:

- Widgets are `.jsx` files in directories under `~/Library/Application Support/Übersicht/widgets/`
- Each widget directory must contain an `index.jsx`
- Übersicht hot-reloads on file changes
- Styling uses [Emotion CSS-in-JS](https://emotion.sh)

## Directory Structure

```text
widgets/
├── btop-ttyd/index.jsx           # btop via ttyd iframe (cursed)
├── FastFetch/index.jsx           # System info via fastfetch
├── github-notifications/index.jsx # GitHub notification badges
├── weather/index.jsx             # Weather + NOAA alerts
├── world-clocks/index.jsx        # Multi-timezone clocks
└── shared/theme.jsx              # Shared theme (NOT a widget)
```

## Widget Exports

Every widget can export these:

```jsx
// Shell command to run - output goes to render()
export const command = `echo "Hello World"`;

// Milliseconds between command executions (default: 1000)
export const refreshFrequency = 10000;

// CSS for positioning and base styles (Emotion CSS-in-JS)
export const className = `
  position: absolute;
  top: 50px;
  left: 10px;
`;

// React component receiving command output
export const render = ({ output, error }) => (
  <div>{error ? String(error) : output}</div>
);
```

### Advanced Exports

```jsx
// Initial state before first command runs
export const initialState = { output: 'Loading...' };

// Redux-like state management for complex widgets
export const updateState = (event, previousState) => {
  return { ...previousState, data: event.output };
};

// One-time initialization (WebSockets, etc.)
export const init = (dispatch) => { /* setup code */ };
```

## The Retro Synth Matrix Theme

All widgets share a cohesive 80s cyberpunk aesthetic via `shared/theme.jsx`.

### Import Pattern

```jsx
import { theme, tahoe, synth, glowBox, textGlow } from "../shared/theme.jsx";
```

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| `theme.cyan` | `#00ffff` | Accent highlights |
| `theme.magenta` | `#ff00ff` | Borders, glows |
| `theme.orange` | `#ff9933` | Labels, warnings |
| `theme.green` | `#00ff41` | Primary text, success |
| `theme.blue` | `#00aaff` | Secondary accent |
| `theme.red` | `#ff0066` | Errors, alerts |
| `theme.background` | `rgba(0,0,0,0.8)` | Widget backgrounds |

### Style Generators

```jsx
// Neon border with glow effect
glowBox(theme.magenta)  // Returns CSS string

// Text with neon glow
textGlow(theme.green)   // Returns text-shadow value

// Subtle label glow
labelGlow(theme.orange) // Returns text-shadow value

// SVG icon glow filter
iconGlow(theme.green)   // Returns CSS filter value
```

### Design Constants

```jsx
tahoe.borderRadius       // "30px" - macOS Tahoe's chunky corners
tahoe.borderRadiusSmall  // "15px" - Nested elements
tahoe.borderRadiusPill   // "10px" - Badges/pills

synth.font               // "'3270 Nerd Font Mono', monospace"
synth.borderWidth        // "2px" - Neon tube look
```

## Critical Gotchas

### File Extension Matters

`.jsx` is **mandatory** for ES modules. A `.js` file will fail with "Unexpected token" errors on `export`/`import` statements.

```jsx
// ✅ Works - note the .jsx extension
import { theme } from "../shared/theme.jsx";

// ❌ Fails - .js extension breaks ES module parsing
import { theme } from "../shared/theme.js";
```

### Every Subdirectory is a Widget

Übersicht treats ANY directory under `widgets/` as a widget and tries to parse its files. The `shared/` directory works because its modules use `.jsx` extension—even though they contain no actual JSX.

### API Calls

Use `curl` in the command string and parse JSON in render:

```jsx
export const command = `curl -s "https://api.example.com/data"`;

export const render = ({ output }) => {
  const data = JSON.parse(output);
  return <div>{data.value}</div>;
};
```

### Force Refresh

```bash
osascript -e 'tell application "Übersicht" to refresh'

# Refresh specific widget
osascript -e 'tell application "Übersicht" to refresh widget id "my-widget"'
```

## Widget Details

### btop-ttyd

Embeds a [ttyd](https://github.com/tsl0922/ttyd) terminal session in an iframe. Peak "because I can" energy.

- Refresh: 30 seconds (just for status display; iframe is live)
- Dependencies: `ttyd` (via Homebrew)
- **Setup required**: Run ttyd serving btop with custom HTML (hides scrollbar):

```bash
# Install ttyd
brew install ttyd

# Run btop via ttyd with custom index (keep this running)
# The custom index.html hides the scrollbar and sets the background
ttyd -p 8080 -I ~/.config/ttyd/index.html btop

# Or run in background with nohup
nohup ttyd -p 8080 -I ~/.config/ttyd/index.html btop > /dev/null 2>&1 &
```

**Terribleness rating**: 7/10. You're running a TUI inside a pseudo-terminal, piped through WebSockets to xterm.js, embedded in an iframe inside a WebKit view rendering to your desktop. It's beautiful.

**Troubleshooting**:

- If iframe shows blank/error, check ttyd is running: `curl http://localhost:8080`
- If using HTTPS with self-signed cert, switch to HTTP in the widget config
- Adjust `config.width` and `config.height` in the widget for your screen

### FastFetch

Displays system information using [fastfetch](https://github.com/fastfetch-cli/fastfetch) with ANSI-to-HTML conversion via [aha](https://github.com/theZiz/aha).

- Refresh: 10 seconds
- Dependencies: `fastfetch`, `aha` (both via Homebrew)

### github-notifications

Shows GitHub notification counts by type (mentions, assignments, etc.).

- Refresh: 15 seconds
- **Setup required**: Store GitHub token in macOS Keychain:

```bash
security add-generic-password -a "$USER" -s "github-notifications-token" -w "ghp_your_token"
```

Token needs `notifications` scope. Create at https://github.com/settings/tokens

### weather

7-day forecast with current conditions and NOAA weather alerts.

- Refresh: 10 minutes
- APIs: [Open-Meteo](https://open-meteo.com/) (free, no key) + [NOAA NWS](https://www.weather.gov/documentation/services-web-api)
- Edit `config` object in widget to set location

### world-clocks

Multiple timezone clocks with pulsing colon animation.

- Refresh: 1 second
- No external dependencies (uses native `Intl.DateTimeFormat`)
- Edit `config.timezones` array to customize

## Resources

- [Übersicht GitHub](https://github.com/felixhageloh/uebersicht) - Official docs and examples
- [Übersicht Gallery](http://tracesof.net/uebersicht-widgets/) - Community widgets
- [Emotion Docs](https://emotion.sh/docs/introduction) - CSS-in-JS styling
