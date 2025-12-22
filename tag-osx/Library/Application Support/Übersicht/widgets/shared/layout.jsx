/**
 * Shared Layout System for Übersicht Widgets
 *
 * Provides screen detection and consistent positioning for:
 * - Left-dock layout on ultrawide monitors (3440x1440)
 * - Hero zone for btop on the right side
 * - Auto-hide on smaller monitors
 *
 * Import in widgets:
 *   import { shouldRender, dockSlot, heroPosition } from '../shared/layout.jsx';
 */

// ============================================================================
// Screen Detection
// ============================================================================

/**
 * Minimum width of monitor to display widgets
 */
const MIN_DISPLAY_WIDTH = 2336;

/**
 * Check if widget should render on current screen
 * Returns false on smaller monitors to hide widgets
 * @returns {boolean} True if widget should render
 */
export const shouldRender = () => window.screen.width >= MIN_DISPLAY_WIDTH;

// ============================================================================
// Layout Constants
// ============================================================================

/**
 * Layout configuration
 *
 * LEFT COLUMN: Weather, World Clocks, GitHub (stacked, normalized width)
 * RIGHT COLUMN: FastFetch (top), btop (below)
 */
const layout = {
  // Padding from screen edges
  padding: 10,
  // Gap between widgets
  gap: 10,
  // Left column normalized width (based on GitHub notifications being widest)
  leftColumnWidth: 300,
  // Right column width (FastFetch and btop share this)
  rightColumnWidth: 880,
  // FastFetch estimated height (for btop positioning)
  fastFetchHeight: 500,
};

/**
 * Slot positions for widgets
 */
const slots = {
  // FastFetch - top RIGHT corner
  0: { top: layout.padding, right: layout.padding },
  // Weather - top LEFT corner
  1: { top: layout.padding, left: layout.padding },
  // World Clocks - LEFT column, below Weather (estimated Weather height ~680px)
  2: { top: 730, left: layout.padding },
  // GitHub Notifications - LEFT column, bottom
  3: { bottom: layout.padding, left: layout.padding },
  // btop - RIGHT column, below FastFetch
  4: { top: layout.padding + layout.fastFetchHeight + layout.gap, right: layout.padding },
};

// For backward compatibility
const dock = { left: layout.padding, width: layout.leftColumnWidth };

// ============================================================================
// Position Generators
// ============================================================================

/**
 * Generate CSS className string for a dock slot
 * @param {number} slot - Slot number (0-3)
 * @returns {string} CSS position string for Übersicht className export
 */
export const dockSlot = (slot) => {
  const pos = slots[slot];
  if (!pos) {
    console.warn(`[layout] Invalid dock slot: ${slot}`);
    return `position: absolute; top: 10px; left: 10px;`;
  }

  const rules = [`position: absolute;`];

  if (pos.left !== undefined) {
    rules.push(`left: ${pos.left}px;`);
  }
  if (pos.right !== undefined) {
    rules.push(`right: ${pos.right}px;`);
  }
  if (pos.top !== undefined) {
    rules.push(`top: ${pos.top}px;`);
  }
  if (pos.bottom !== undefined) {
    rules.push(`bottom: ${pos.bottom}px;`);
  }

  return rules.join('\n  ');
};

/**
 * @deprecated Use dockSlot(4) instead
 */
export const heroPosition = () => dockSlot(4);

/**
 * Get layout configuration for widgets that need width normalization
 */
export const getLayout = () => ({ ...layout });

/**
 * Get raw slot position object (for widgets that need custom handling)
 * @param {number} slot - Slot number (0-3)
 * @returns {{ top?: number, bottom?: number, left: number } | null}
 */
export const getSlotPosition = (slot) => slots[slot] || null;

/**
 * Get dock configuration
 * @returns {{ left: number, width: number }}
 */
export const getDockConfig = () => ({ ...dock });

