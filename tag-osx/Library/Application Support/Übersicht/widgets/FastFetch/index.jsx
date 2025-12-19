import { theme, tahoe, synth, glowBox, labelGlow } from "../shared/theme.js";

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
  red: `color: ${theme.red};`,
  green: `color: ${theme.green};`,
  yellow: `color: ${theme.yellow};`,  // Keep yellow for logo
  olive: `color: ${theme.yellow};`,   // aha sometimes uses "olive" for yellow
  cyan: `color: ${theme.cyan};`,
  purple: `color: ${theme.magenta};`,
  blue: `color: ${theme.blue};`,
  white: `color: ${theme.white};`,
  black: "color: #333333;",
};

// Data colors - orange instead of yellow for text labels
const dataColorStyles = {
  red: `color: ${theme.red};`,
  green: `color: ${theme.green};`,
  yellow: `letter-spacing: 1px; font-weight: bold; color: ${theme.orange}; text-transform: uppercase; text-shadow: ${labelGlow()};`,
  olive: `color: ${theme.orange};`,   // aha sometimes uses "olive" for yellow
  cyan: `color: ${theme.cyan};`,
  purple: `color: ${theme.magenta};`,
  blue: `color: ${theme.blue};`,
  white: `color: ${theme.white};`,
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
        fontFamily: synth.font,
        whiteSpace: "pre",
        color: theme.green,
        padding: "15px",
        border: `${synth.borderWidth} solid ${theme.magenta}`,
        borderRadius: tahoe.borderRadius,
        boxShadow: `0 0 10px ${theme.magenta}44, 0 0 30px ${theme.magenta}22, inset 0 0 20px ${theme.black}`
      }}
    >
      {/* ASCII Logo - left column */}
      <div
        style={{ flexShrink: 0 }}
        dangerouslySetInnerHTML={{ __html: logoPart }}
      />
      {/* System Info - right column */}
      <div
        style={{ flexShrink: 0, lineHeight: 1.2 }}
        dangerouslySetInnerHTML={{ __html: dataPart }}
      />
    </div>
  );
};
