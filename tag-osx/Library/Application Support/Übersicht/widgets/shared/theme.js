/**
 * Shared Theme for Übersicht Widgets
 * Retro Synth Matrix / Tahoe-compatible aesthetic
 *
 * Import in widgets:
 *   import { theme, tahoe, synth, glowBox } from '../shared/theme.js';
 */

// ============================================================================
// Color Palette - Retro Synth Matrix
// ============================================================================
export const theme = {
  black: "#000000",
  cyan: "#00ffff",
  magenta: "#ff00ff",
  orange: "#ff9933",
  green: "#00ff41",
  blue: "#00aaff",
  red: "#ff0066",
  yellow: "#ffcc00",
  white: "#ffffff",
};

// ============================================================================
// macOS Tahoe Design Constants
// ============================================================================
export const tahoe = {
  // macOS Tahoe went absolutely bonkers with 30px corners
  borderRadius: "30px",
  // Smaller radius for nested elements
  borderRadiusSmall: "15px",
  borderRadiusPill: "10px",
};

// ============================================================================
// Retro Synth Matrix Style Constants
// ============================================================================
export const synth = {
  // Standard font stack - that sweet IBM 3270 terminal look
  font: "'3270 Nerd Font Mono', monospace",
  // Border width for that neon tube look
  borderWidth: "2px",
};

// ============================================================================
// Style Generators
// ============================================================================

/**
 * Generate the signature glowing box style
 * @param {string} color - Border/glow color (defaults to magenta)
 * @returns {string} CSS string for the glow effect
 */
export const glowBox = (color = theme.magenta) => `
  border: ${synth.borderWidth} solid ${color};
  border-radius: ${tahoe.borderRadius};
  box-shadow:
    0 0 10px ${color}44,
    0 0 30px ${color}22,
    inset 0 0 20px ${theme.black};
`;

/**
 * Generate neon text glow effect
 * @param {string} color - Primary text color
 * @param {string} glowColor - Secondary glow color (optional)
 * @returns {string} CSS text-shadow string
 */
export const textGlow = (color, glowColor = theme.magenta) => `
  0 0 1px ${color}cc,
  0 0 3px ${color}66,
  0 0 6px ${glowColor}33
`;

/**
 * Generate subtle label glow
 * @param {string} color - Label color
 * @returns {string} CSS text-shadow string
 */
export const labelGlow = (color = theme.orange) => `
  0 0 1px ${color}88,
  0 0 2px ${color}44
`;

/**
 * Generate SVG filter glow effect (for icons)
 * @param {string} color - Glow color
 * @returns {string} CSS filter string
 */
export const iconGlow = (color = theme.green) =>
  `drop-shadow(0 0 4px ${color}) drop-shadow(0 0 8px ${color}66)`;

