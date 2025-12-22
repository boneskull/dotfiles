/**
 * btop-xterm: Direct xterm.js widget connecting to ttyd WebSocket
 *
 * Prerequisites:
 *   1. Install ttyd: brew install ttyd
 *   2. Run ttyd with btop: ttyd -p 8080 btop
 *
 * This widget loads xterm.js directly and connects to ttyd's WebSocket,
 * bypassing the iframe for TRUE TRANSPARENCY. Peak hubris.
 */

import { theme, synth, tahoe } from "../shared/theme.jsx";
import { shouldRender, dockSlot, getLayout } from "../shared/layout.jsx";

const config = {
  baseUrl: "http://localhost:8080",
  // Width and height now controlled by layout system
  fontSize: 16,
  xtermCdn: "https://cdn.jsdelivr.net/npm/xterm@5.3.0/lib/xterm.min.js",
  xtermCssCdn: "https://cdn.jsdelivr.net/npm/xterm@5.3.0/css/xterm.css",
  fitAddonCdn: "https://cdn.jsdelivr.net/npm/@xterm/addon-fit@0.10.0/lib/addon-fit.min.js",
};

// Singleton state
let terminal = null;
let fitAddon = null;
let ws = null;
let initialized = false;

// Load external script dynamically
const loadScript = (src) => {
  return new Promise((resolve, reject) => {
    if (document.querySelector(`script[src="${src}"]`)) {
      resolve();
      return;
    }
    const script = document.createElement("script");
    script.src = src;
    script.onload = resolve;
    script.onerror = reject;
    document.head.appendChild(script);
  });
};

// Load external CSS dynamically
const loadCss = (href) => {
  if (document.querySelector(`link[href="${href}"]`)) return;
  const link = document.createElement("link");
  link.rel = "stylesheet";
  link.href = href;
  document.head.appendChild(link);
};

// Inject custom CSS overrides
const injectStyles = () => {
  if (document.getElementById("btop-xterm-styles")) return;
  const style = document.createElement("style");
  style.id = "btop-xterm-styles";
  style.textContent = `
    .xterm-viewport {
      scrollbar-width: none !important;
    }
    .xterm-viewport::-webkit-scrollbar {
      display: none !important;
    }
  `;
  document.head.appendChild(style);
};

// Status message element
let statusEl = null;

const setStatus = (msg, isError = false) => {
  if (statusEl) {
    statusEl.textContent = msg;
    statusEl.style.color = isError ? theme.red : theme.green;
  }
};

// Initialize terminal and WebSocket
const initTerminal = async () => {
  if (initialized) return;
  initialized = true;

  const container = document.getElementById("btop-xterm-container");
  statusEl = document.getElementById("btop-xterm-status");

  if (!container) {
    setStatus("Container not found!", true);
    return;
  }

  setStatus("Loading xterm.js...");

  try {
    // Load xterm.js and FitAddon from CDN
    loadCss(config.xtermCssCdn);
    injectStyles(); // Hide scrollbar
    await loadScript(config.xtermCdn);
    await loadScript(config.fitAddonCdn);

    // xterm.js exposes itself as window.Terminal
    const Terminal = window.Terminal;
    const FitAddon = window.FitAddon?.FitAddon;
    if (!Terminal) {
      setStatus("xterm.js failed to load!", true);
      return;
    }

    setStatus("Creating terminal...");

    terminal = new Terminal({
      allowTransparency: true,
      theme: {
        background: "#00000000",
        foreground: theme.cyan,
        cursor: theme.magenta,
        cursorAccent: theme.black,
        selectionBackground: `${theme.cyan}44`,
        black: theme.black,
        red: theme.red,
        green: theme.green,
        yellow: theme.yellow,
        blue: theme.blue,
        magenta: theme.magenta,
        cyan: theme.cyan,
        white: theme.white,
        brightBlack: "#666666",
        brightRed: theme.red,
        brightGreen: theme.green,
        brightYellow: theme.yellow,
        brightBlue: theme.blue,
        brightMagenta: theme.magenta,
        brightCyan: theme.cyan,
        brightWhite: "#ffffff",
      },
      fontFamily: synth.font,
      fontSize: config.fontSize,
      lineHeight: 1.0,
      cursorBlink: true,
      cursorStyle: "block",
    });

    // Load FitAddon if available
    if (FitAddon) {
      fitAddon = new FitAddon();
      terminal.loadAddon(fitAddon);
    }

    terminal.open(container);

    // Fit terminal to container
    if (fitAddon) {
      fitAddon.fit();
    }

    setStatus("Connecting...");

    // Try to fetch token (may fail due to CORS, that's ok - token can be empty)
    let token = "";
    try {
      const tokenResponse = await fetch(`${config.baseUrl}/token`);
      const tokenData = await tokenResponse.json();
      token = tokenData.token || "";
    } catch (err) {
      // CORS error is expected, token can be empty
    }

    // Connect with 'tty' subprotocol - THIS IS REQUIRED!
    const wsUrl = `ws://localhost:8080/ws`;
    ws = new WebSocket(wsUrl, ['tty']);
    ws.binaryType = "arraybuffer";

    ws.onopen = () => {
      // FIRST MESSAGE: JSON auth with token and terminal size
      const authMsg = JSON.stringify({
        AuthToken: token,
        columns: terminal.cols,
        rows: terminal.rows
      });
      ws.send(new TextEncoder().encode(authMsg));
      setStatus("● LIVE");
    };

    ws.onmessage = (event) => {
      const data = new Uint8Array(event.data);
      if (data.length === 0) return;

      // Command is a CHARACTER: '0' = OUTPUT, '1' = TITLE, '2' = PREFS
      const cmdChar = String.fromCharCode(data[0]);
      const payload = data.slice(1);

      if (cmdChar === '0' && payload.length > 0) {
        terminal.write(payload);
      }
      // Ignore title and preferences messages
    };

    ws.onclose = () => {
      setStatus("● DISCONNECTED", true);
    };

    ws.onerror = () => {
      setStatus("● ERROR", true);
    };

    // Send input to ttyd (command '0' = INPUT)
    terminal.onData((data) => {
      if (ws && ws.readyState === WebSocket.OPEN) {
        const encoder = new TextEncoder();
        const payload = encoder.encode(data);
        const msg = new Uint8Array(payload.length + 1);
        msg[0] = '0'.charCodeAt(0); // INPUT command as character
        msg.set(payload, 1);
        ws.send(msg);
      }
    });

  } catch (err) {
    setStatus(`Error: ${err.message}`, true);
  }
};

export const command = "echo 'btop-xterm'";
export const refreshFrequency = false; // Never refresh - live connection

export const className = `
  ${dockSlot(4)}
  z-index: 5;
`;

export const render = () => {
  if (!shouldRender()) return null;

  // Initialize after first render
  if (!initialized) {
    setTimeout(initTerminal, 100);
  }

  const layoutConfig = getLayout();

  const btopHeight = 880;

  return (
    <div
      style={{
        fontFamily: synth.font,
        background: "rgba(0, 0, 0, 0.8)",
        border: `${synth.borderWidth} solid ${theme.magenta}`,
        borderRadius: tahoe.borderRadius,
        boxShadow: `0 0 10px ${theme.magenta}44, 0 0 30px ${theme.magenta}22, inset 0 0 20px ${theme.black}`,
        padding: "4px",
        overflow: "hidden",
        width: layoutConfig.rightColumnWidth,
        height: btopHeight,
        boxSizing: "border-box",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* Header bar */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "space-between",
          padding: "8px 12px",
          borderBottom: `1px solid ${theme.magenta}44`,
          marginBottom: "4px",
        }}
      >
        <span
          style={{
            color: theme.orange,
            fontSize: "18px",
            fontWeight: 'bold',
            letterSpacing: "2px",
            textTransform: "uppercase",
            textShadow: `0 0 1px ${theme.orange}`,
          }}
        >
          btop://xterm.js
        </span>
        <div style={{ width: 60 }} />
      </div>

      {/* Terminal container */}
      <div
        id="btop-xterm-container"
        style={{
          flex: 1,
          padding: "10px",
          boxSizing: "border-box",
          background: "transparent",
          minHeight: 0,
        }}
      />

      {/* Status footer */}
      <div
        style={{
          padding: "6px 12px",
          borderTop: `1px solid ${theme.magenta}44`,
          marginTop: "4px",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <span
          id="btop-xterm-status"
          style={{
            color: theme.green,
            fontSize: "10px",
            textShadow: `0 0 3px ${theme.green}`,
          }}
        >
          ● Initializing...
        </span>
        <span
          style={{
            color: theme.orange,
            fontSize: "10px",
            opacity: 0.7,
          }}
        >
          {config.baseUrl}
        </span>
      </div>
    </div>
  );
};


