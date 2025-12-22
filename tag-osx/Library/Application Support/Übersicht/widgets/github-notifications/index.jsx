/**
 * GitHub Notifications Widget for Übersicht
 * Converted from CoffeeScript to modern ESM/JSX
 *
 * SETUP:
 * 1. Store your GitHub API token in macOS Keychain:
 *    security add-generic-password -a "$USER" -s "github-notifications-token" -w "ghp_your_token_here"
 *
 * 2. (Optional) To update the token later:
 *    security delete-generic-password -a "$USER" -s "github-notifications-token"
 *    Then run the add command again.
 *
 * 3. The token needs "notifications" scope. Create one at:
 *    https://github.com/settings/tokens
 */

import { theme, tahoe, synth, glowBox, iconGlow } from "../shared/theme.jsx";
import { shouldRender, dockSlot, getLayout } from "../shared/layout.jsx";

// Configuration
const config = {
  // Your GitHub username
  user: "boneskull",
  // Use GitHub Enterprise instead of public GitHub?
  enterprise: false,
  // GitHub Enterprise API URL (only used if enterprise is true)
  enterpriseApi: "https://github.example.com/api/v3",
  // Proxy URL (only used if useProxy is true)
  proxyUrl: "",
  useProxy: false,
};

// Build the command to fetch notifications
// Fetches the API key from macOS Keychain securely
const api = config.enterprise ? config.enterpriseApi : "https://api.github.com";
const proxyCmd = config.useProxy ? `-x "${config.proxyUrl}"` : "";

export const command = `
  # Fetch GitHub token from macOS Keychain
  TOKEN=$(security find-generic-password -a "$USER" -s "github-notifications-token" -w 2>/dev/null)

  if [ -z "$TOKEN" ]; then
    echo '{"error": "No GitHub token found in Keychain. Run: security add-generic-password -a \\"$USER\\" -s \\"github-notifications-token\\" -w \\"your_token_here\\""}'
    exit 0
  fi

  curl -s --user "${config.user}:$TOKEN" "${api}/notifications" ${proxyCmd}
`;

export const refreshFrequency = 15000; // 15 seconds

// Octicons SVG components (from octicons 19.21.1)
// Each icon is 16x16 and uses currentColor for fill
const Octicons = {
  // GitHub logo (mark-github)
  markGithub: (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
      <path d="M8 0c4.42 0 8 3.58 8 8a8.013 8.013 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38 0-.27.01-1.13.01-2.2 0-.75-.25-1.23-.54-1.48 1.78-.2 3.65-.88 3.65-3.95 0-.88-.31-1.59-.82-2.15.08-.2.36-1.02-.08-2.12 0 0-.67-.22-2.2.82-.64-.18-1.32-.27-2-.27-.68 0-1.36.09-2 .27-1.53-1.03-2.2-.82-2.2-.82-.44 1.1-.16 1.92-.08 2.12-.51.56-.82 1.28-.82 2.15 0 3.06 1.86 3.75 3.64 3.95-.23.2-.44.55-.51 1.07-.46.21-1.61.55-2.33-.66-.15-.24-.6-.83-1.23-.82-.67.01-.27.38.01.53.34.19.73.9.82 1.13.16.45.68 1.31 2.69.94 0 .67.01 1.3.01 1.49 0 .21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8Z"/>
    </svg>
  ),
  // @mention - the @ symbol in a circle
  mention: (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
      <path d="M8 .5a7.499 7.499 0 0 1 7.499 7.462l.002.038v1.164a2.612 2.612 0 0 1-4.783 1.454A3.763 3.763 0 0 1 8 11.776 3.776 3.776 0 1 1 11.776 8v1.164a1.112 1.112 0 0 0 2.225 0L14 8a6 6 0 1 0-3.311 5.365.75.75 0 0 1 .673 1.341A7.5 7.5 0 1 1 8 .5Zm0 5.225a2.275 2.275 0 1 0 0 4.552 2.275 2.275 0 0 0 0-4.552Z"/>
    </svg>
  ),
  // person - for author notifications
  person: (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
      <path d="M10.561 8.073a6.005 6.005 0 0 1 3.432 5.142.75.75 0 1 1-1.498.07 4.5 4.5 0 0 0-8.99 0 .75.75 0 0 1-1.498-.07 6.004 6.004 0 0 1 3.431-5.142 3.999 3.999 0 1 1 5.123 0ZM10.5 5a2.5 2.5 0 1 0-5 0 2.5 2.5 0 0 0 5 0Z"/>
    </svg>
  ),
  // person-add - for assign notifications
  personAdd: (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
      <path d="M7.9 8.548h-.001a5.528 5.528 0 0 1 3.1 4.659.75.75 0 1 1-1.498.086A4.01 4.01 0 0 0 5.5 9.5a4.01 4.01 0 0 0-4.001 3.793.75.75 0 1 1-1.498-.085 5.527 5.527 0 0 1 3.1-4.66 3.5 3.5 0 1 1 4.799 0ZM13.25 0a.75.75 0 0 1 .75.75V2h1.25a.75.75 0 0 1 0 1.5H14v1.25a.75.75 0 0 1-1.5 0V3.5h-1.25a.75.75 0 0 1 0-1.5h1.25V.75a.75.75 0 0 1 .75-.75ZM5.5 4a2 2 0 1 0-.001 3.999A2 2 0 0 0 5.5 4Z"/>
    </svg>
  ),
  // eye - for subscribed notifications
  eye: (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
      <path d="M8 2c1.981 0 3.671.992 4.933 2.078 1.27 1.091 2.187 2.345 2.637 3.023a1.62 1.62 0 0 1 0 1.798c-.45.678-1.367 1.932-2.637 3.023C11.67 13.008 9.981 14 8 14c-1.981 0-3.671-.992-4.933-2.078C1.797 10.83.88 9.576.43 8.898a1.62 1.62 0 0 1 0-1.798c.45-.677 1.367-1.931 2.637-3.022C4.33 2.992 6.019 2 8 2ZM1.679 7.932a.12.12 0 0 0 0 .136c.411.622 1.241 1.75 2.366 2.717C5.176 11.758 6.527 12.5 8 12.5c1.473 0 2.825-.742 3.955-1.715 1.124-.967 1.954-2.096 2.366-2.717a.12.12 0 0 0 0-.136c-.412-.621-1.242-1.75-2.366-2.717C10.824 4.242 9.473 3.5 8 3.5c-1.473 0-2.825.742-3.955 1.715-1.124.967-1.954 2.096-2.366 2.717ZM8 10a2 2 0 1 1-.001-3.999A2 2 0 0 1 8 10Z"/>
    </svg>
  ),
};

// Icon mapping: notification reason → [Octicon component, tooltip label]
// URLs filter to unread notifications by reason
const iconMapping = [
  ["mention", Octicons.mention, "@mentioned", "https://github.com/notifications?query=is%3Aunread+reason%3Amention"],
  ["author", Octicons.person, "Author", "https://github.com/notifications?query=is%3Aunread+reason%3Aauthor"],
  ["assign", Octicons.personAdd, "Assigned", "https://github.com/notifications?query=is%3Aunread+reason%3Aassign"],
  ["subscribed", Octicons.eye, "Watching", "https://github.com/notifications?query=is%3Aunread+reason%3Asubscribed"],
];

// Styles
export const className = `
  ${dockSlot(3)}

  a:link, a:visited, a:hover, a:active {
    color: ${theme.green};
    text-decoration: none;
  }

  .github-notifications {
    ${glowBox()}
    padding: 10px;
    background-color: ${theme.background};
    display: flex;
    align-items: center;
    justify-content: center;
    color: ${theme.green};
    width: ${getLayout().leftColumnWidth}px;
    box-sizing: border-box;
  }

  .octicon {
    width: 24px;
    height: 24px;
    display: block;
  }

  .octicon svg {
    width: 100%;
    height: 100%;
    filter: ${iconGlow()};
  }

  .count-group {
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    width: 50px;
    text-align: center;
    position: relative;
  }

  .count-group + .count-group {
    padding-left: 5px;
    border-left: 1px solid ${theme.magenta}44;
  }

  .count {
    font-size: 11px;
    font-family: ${synth.font};
    background-color: ${theme.orange};
    color: ${theme.black};
    border-radius: ${tahoe.borderRadiusPill};
    padding: 2px 5px;
    position: absolute;
    top: -5px;
    right: 2px;
    min-width: 12px;
    text-align: center;
    font-weight: bold;
  }

  .error-message {
    font-family: system-ui, sans-serif;
    font-size: 12px;
    color: ${theme.orange};
    padding: 5px;
  }
`;

export const render = ({ output }) => {
  if (!shouldRender()) return null;

  if (!output) {
    return (
      <div className="github-notifications">
        <span className="error-message">Loading...</span>
      </div>
    );
  }

  let data;
  try {
    data = JSON.parse(output);
  } catch (ex) {
    return (
      <div className="github-notifications">
        <span className="error-message">Error parsing response</span>
      </div>
    );
  }

  // Handle error from our command (keychain issues)
  if (data.error) {
    return (
      <div className="github-notifications">
        <span className="error-message">{data.error}</span>
      </div>
    );
  }

  // Handle GitHub API errors
  if (data.message) {
    return (
      <div className="github-notifications">
        <span className="error-message">GitHub: {data.message}</span>
      </div>
    );
  }

  // Count notifications by reason
  const counts = {
    mention: 0,
    author: 0,
    assign: 0,
    subscribed: 0,
  };

  for (const notification of data) {
    if (counts[notification.reason] !== undefined) {
      counts[notification.reason]++;
    }
  }

  return (
    <div className="github-notifications">
      <a href="https://github.com" className="count-group" title="GitHub">
        <span className="octicon">{Octicons.markGithub}</span>
      </a>
      {iconMapping.map(([reason, Icon, tooltip, url]) => (
        <a key={reason} href={url} className="count-group" title={tooltip}>
          <span className="octicon">{Icon}</span>
          {counts[reason] > 0 && <span className="count">{counts[reason]}</span>}
        </a>
      ))}
    </div>
  );
};

