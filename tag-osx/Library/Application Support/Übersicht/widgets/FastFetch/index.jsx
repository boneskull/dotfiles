// Two separate commands: one for logo only, one for data only
export const command = `
  export PATH="/opt/homebrew/bin:$PATH"
  echo "===LOGO==="
  fastfetch --structure "Break" --logo-print-remaining true --pipe off | aha --no-header --stylesheet
  echo "===DATA==="
  fastfetch --logo none --pipe off | aha --no-header --stylesheet
`;

export const refreshFrequency = 10000; // Refresh every 10 seconds

export const className = `
  position: absolute;
  top: 50px;
  left: 10px;
  z-index: 10;
`;

// Retro Synth Matrix inline styles for aha output
// Logo colors - keep original yellow for Apple logo
const logoColorStyles = {
  red: "color: #ff0066;",
  green: "color: #00ff41;",
  yellow: "color: #ffcc00;",  // Keep yellow for logo
  olive: "color: #ffcc00;",   // aha sometimes uses "olive" for yellow
  cyan: "color: #00ffff;",
  purple: "color: #ff00ff;",
  blue: "color: #00aaff;",
  white: "color: #ffffff;",
  black: "color: #333333;",
};

// Data colors - orange instead of yellow for text labels
const dataColorStyles = {
  red: "color: #ff0066;",
  green: "color: #00ff41;",
  yellow: "color: #ff9933;",  // Orange for data labels
  olive: "color: #ff9933;",   // aha sometimes uses "olive" for yellow
  cyan: "color: #00ffff;",
  purple: "color: #ff00ff;",
  blue: "color: #00aaff;",
  white: "color: #ffffff;",
  black: "color: #333333;",
};

// Convert aha class-based spans to inline styles
function applyTronStyles(html, colorStyles) {
  if (!html) return html;

  return html.replace(/<span class="([^"]+)">/g, (match, classes) => {
    const classList = classes.trim().split(/\s+/);
    let styles = [];

    for (const color of Object.keys(colorStyles)) {
      if (classList.includes(color)) {
        styles.push(colorStyles[color]);
        break;
      }
    }

    styles.push('font-size: 1.2em')

    if (styles.length > 0) {
      return `<span style="${styles.join(" ")}">`;
    }
    return "<span>";
  });
}

export const render = ({ output }) => {
  if (!output) return <div>Loading...</div>;

  // Split the output into logo and data sections
  const parts = output.split(/===(?:LOGO|DATA)===/);
  const logoPart = applyTronStyles(parts[1]?.trim() || "", logoColorStyles);
  const dataPart = applyTronStyles(parts[2]?.trim() || "", dataColorStyles);

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
        alignItems: "flex-start",
        gap: "20px",
        fontFamily: "'3270 Nerd Font Mono', monospace",
        whiteSpace: "pre",
        color: "#00ff41",
        padding: "15px",
      }}
    >
      {/* ASCII Logo - left column */}
      <div
        style={{ flexShrink: 0 }}
        dangerouslySetInnerHTML={{ __html: logoPart }}
      />
      {/* System Info - right column */}
      <div
        style={{ flexShrink: 0 }}
        dangerouslySetInnerHTML={{ __html: dataPart }}
      />
    </div>
  );
};
