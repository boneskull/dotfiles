# Cursor Settings

## MCP Servers

Put any sensitive env vars in `${HOME}/.extra.zsh` and reference them in `mcp.json` like so:

```json
"github": {
  "command": "${userHome}/bin/github-mcp-server",
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_MCP_TOKEN}"
  },
  "args": ["stdio"]
}
```
