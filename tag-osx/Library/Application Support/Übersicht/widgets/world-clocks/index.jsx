/**
 * World Clocks Widget for Übersicht
 * Neon tube display aesthetic with synthwave vibes
 *
 * Uses native Intl.DateTimeFormat for timezone handling (no dependencies!)
 * Font: 3270 Nerd Font Mono
 * Theme: Retro Synth Matrix
 */

import { theme, tahoe, synth, glowBox, textGlow, labelGlow } from "../shared/theme.jsx";
import { shouldRender, dockSlot, getLayout } from "../shared/layout.jsx";

// ============================================================================
// CONFIGURATION - Edit this to customize your timezones
// ============================================================================
const config = {
  timezones: [
    { zone: "Asia/Tokyo", label: "TOKYO" },
    { zone: "Pacific/Honolulu", label: "HONOLULU" },
    { zone: "America/Los_Angeles", label: "LOS ANGELES" },
    { zone: "America/Denver", label: "DENVER" },
    { zone: "America/New_York", label: "NEW YORK" },
    { zone: "Europe/Warsaw", label: "WARSAW" },
  ],
};

/**
 * Get formatted time for a timezone using native Intl API
 * @param {string} timeZone - IANA timezone string (e.g., "America/New_York")
 * @returns {{ hours: string, minutes: string }}
 */
const getTimeForZone = (timeZone) => {
  const now = new Date();
  const formatter = new Intl.DateTimeFormat("en-GB", {
    timeZone,
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  });

  const parts = formatter.formatToParts(now);
  const hours = parts.find((p) => p.type === "hour")?.value || "00";
  const minutes = parts.find((p) => p.type === "minute")?.value || "00";

  return { hours, minutes };
};

// Refresh every second for responsive display
export const refreshFrequency = 1000;

// Übersicht requires a command - we just use it to trigger re-render
export const command = "date +%s";

// Widget positioning and base styles
export const className = `
  ${dockSlot(2)}

  * {
    box-sizing: border-box;
  }

  .world-clocks {
    background: ${theme.background};
    ${glowBox()}
    padding: 16px 24px;
    font-family: ${synth.font};
    width: ${getLayout().leftColumnWidth}px;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
  }

  .clock-row {
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 8px 0;
  }

  .clock-row + .clock-row {
    border-top: 1px solid ${theme.magenta}33;
  }

  .time {
    font-size: 42px;
    font-weight: bold;
    color: ${theme.green};
    letter-spacing: 4px;
    text-shadow: ${textGlow(theme.green)};
    min-width: 140px;
  }

  .colon {
    position: relative;
    top: -4px;
    animation: pulse 1s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
  }

  .label {
    font-size: 18px;
    font-weight: bold;
    color: ${theme.orange};
    letter-spacing: 1px;
    text-transform: uppercase;
    text-shadow: ${labelGlow()};
  }

  .error-message {
    color: ${theme.orange};
    font-size: 14px;
    padding: 10px;
  }
`;

// Render function
export const render = () => {
  if (!shouldRender()) return null;

  return (
    <div className="world-clocks">
      {config.timezones.map((tz) => {
        const { hours, minutes } = getTimeForZone(tz.zone);

        return (
          <div key={tz.zone} className="clock-row">
            <span className="time">
              {hours}
              <span className="colon">:</span>
              {minutes}
            </span>
            <span className="label">{tz.label}</span>
          </div>
        );
      })}
    </div>
  );
};
