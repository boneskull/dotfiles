---
name: readme-authoring
description: Use when creating or updating README.md files. Provides structure guidelines for libraries, applications, and monorepos, plus formatting rules and required sections.
---

# Writing README Files

This skill guides the creation and maintenance of README.md files. Before writing any README content, read the `writing-clearly-and-concisely` skill and apply its principles throughout.

## Project Type Detection

Determine the project type first—it dictates structure:

| Type            | Indicators                                                                                                           |
| --------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Application** | Runnable binary, has `bin` field, Docker deployment, user-facing tool                                                |
| **Library**     | If it doesn't have a binary/executable, it's probably this                                                           |
| **Monorepo**    | `package.json` contains `workspaces`, repo contains `packages/` or `plugins/` directory, multiple package.json files |

## Common Elements (All Types)

### Title and Description

Start with an H1 containing the project name, followed immediately by a one-to-two sentence description:

```markdown
# project-name

A brief description of what this project does and why someone would use it.
```

### License Section (Required, Always Last)

Place this section at the very bottom. Use the `date` command to get the current year:

```bash
date +%Y
```

Format:

```markdown
## License

Copyright © YEAR [Author Name](https://github.com/username). Licensed under the [License Name](LICENSE)
```

## Library Structure

For libraries, use this section order:

```markdown
# library-name

One sentence describing the library.

## Example

[Show a compelling, copy-pasteable example immediately]

## Installation

[Package manager commands]

### Prerequisites

- Node.js >= X.Y
- Peer dependencies (if any)

## Usage

[Detailed usage with examples]

## Configuration

[If applicable]

## Development

[If ARCHITECTURE.md, DEVELOPMENT.md, or CONTRIBUTING.md exist]

## Acknowledgements

[If applicable - penultimate section]

## License

[Always last]
```

### Example Section

Hit the reader in the face with what using this library looks like. Make it copy-pasteable:

<!-- markdownlint-disable MD046 -->

    ## Example

    ```typescript
    import { doThing } from 'library-name';

    const result = doThing({ option: 'value' });
    console.log(result);
    // => Expected output
    ```

### Installation Section

Include package manager commands and prerequisites:

    ## Installation

    ```bash
    npm install library-name
    ```

    ### Prerequisites

    - Node.js >= 18.0.0
    - TypeScript >= 5.0 (if using TypeScript)

<!-- markdownlint-enable MD046 -->

## Application Structure

For applications, use this section order:

```markdown
# app-name

One sentence describing the application.

## Documentation

[Quick links to external docs, if they exist]

## Features

[Bullet points highlighting capabilities]

## Quick Start

### Installation

[Installation commands]

### Prerequisites

[Required dependencies]

## Usage

[How to use the application]

## Advanced Usage

[If applicable]

## Configuration

[If applicable]

## Development

[If ARCHITECTURE.md, DEVELOPMENT.md, or CONTRIBUTING.md exist]

## Acknowledgements

[If applicable - penultimate section]

## License

[Always last]
```

### Features Section

Use bullet points, be specific:

```markdown
## Features

- **Fast** — Processes 10,000 files per second
- **Zero config** — Works out of the box
- **Extensible** — Plugin system for custom behavior
```

## Monorepo Structure

For monorepo root READMEs, serve as an index:

```markdown
# monorepo-name

One sentence describing the monorepo's purpose.

## Packages

| Package                   | Description |
| ------------------------- | ----------- |
| [package-a](./packages/a) | Does X      |
| [package-b](./packages/b) | Does Y      |

## Development

[Link to DEVELOPMENT.md, CONTRIBUTING.md if they exist]

## Acknowledgements

[If applicable - penultimate section]

## License

[Always last]
```

Do **not** include Example, Installation, Usage, or Configuration sections in monorepo root READMEs—those belong in individual package READMEs.

## Optional Sections (Ask First)

### Development Section

Add this section if any of these files exist in the project:

- `ARCHITECTURE.md`
- `DEVELOPMENT.md`
- `CONTRIBUTING.md`

```markdown
## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup instructions.

For architecture details, see [ARCHITECTURE.md](ARCHITECTURE.md).

Contributions welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) first.
```

### Motivation Section

**Ask the user** before adding this section:

> Should I include a "Motivation" section explaining why this project exists?

If yes, explain the problem being solved and why existing solutions were insufficient.

### Project Scope Section

**Ask the user** before adding this section:

> Should I include a "Project Scope" section listing what's in and out of scope?

Format if yes:

```markdown
## Project Scope

### In Scope

- Feature X
- Use case Y

### Out of Scope

- Feature Z (use [other-tool] instead)
- Use case W
```

### Resources Section

Add if external resources are known. Otherwise, **ask the user**:

> Are there external resources (blog posts, videos, related projects) I should link to?

```markdown
## Resources

- [Blog post about X](https://example.com)
- [Video tutorial](https://youtube.com/...)
- [Related project](https://github.com/...)
```

### Acknowledgements Section

**Ask the user** before adding:

> Are there projects or individuals that heavily inspired this work and should be acknowledged?

This section should always be the **penultimate** section (just before License):

```markdown
## Acknowledgements

This project was inspired by [other-project](https://github.com/...) and builds on ideas from [person]'s work on [thing].
```

## Formatting Rules

### Follow Markdownlint Configuration

Check for markdownlint config files in the project root:

- `.markdownlint.json`
- `.markdownlint.yaml`
- `.markdownlint-cli2.yaml`
- `.markdownlintrc`

If present, follow its rules.

### Use Subheadings, Not Bold Text

Avoid this pattern:

```markdown
**Configuration Options:**
```

Markdownlint won't flag it (the colon makes it "okay"), but it's harder to navigate. Use proper subheadings:

```markdown
#### Configuration Options
```

### Fenced Code Blocks Need a Language

Always specify the language. If there's no specific language, use `text`:

<!-- markdownlint-disable MD046 -->

    ```text
    Some plain output here
    ```

<!-- markdownlint-enable MD046 -->

Common languages: `bash`, `typescript`, `javascript`, `json`, `yaml`, `markdown`, `text`

### Headings Must Be Plain Text

No markup in headings:

```markdown
<!-- Bad -->

## `Config` Options

## **Important** Notes

<!-- Good -->

## Config Options

## Important Notes
```

### Section Order Summary

1. Title (H1) + description
2. Documentation links (applications only)
3. Example (libraries) or Features (applications)
4. Installation / Quick Start
5. Usage
6. Advanced Usage (if applicable)
7. Configuration (if applicable)
8. Development (if dev docs exist)
9. Resources (if applicable)
10. Motivation (if applicable)
11. Project Scope (if applicable)
12. Acknowledgements (if applicable) — **always penultimate**
13. License — **always last**

## Checklist Before Finishing

- [ ] Read and applied `writing-clearly-and-concisely` skill
- [ ] Correct project type structure used
- [ ] License section present and at the bottom
- [ ] All code blocks have language specified
- [ ] Headings contain plain text only
- [ ] Used subheadings instead of bold-colon patterns
- [ ] Asked about optional sections (Motivation, Project Scope, Resources, Acknowledgements)
- [ ] Follows markdownlint config if present
