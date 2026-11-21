---
name: authoring-markdown
description: Whenever writing Markdown, use this skill.
---

# authoring-markdown

This skill contains some general rules for writing Markdown.

## Syntax & Formatting

These rules concern how Markdown is written.

### Use GitHub-Flavored Markdown

GitHub-Flavored Markdown (GFM) is the default Markdown syntax used by GitHub. It is a superset of standard Markdown that adds support for a few extra features.  [Specification](https://github.github.com/gfm/), if you need to know more.

Unless otherwise specified, use GFM. In the context of a Starlight site, see its [reference documentation](https://starlight.astro.build/guides/authoring-content).

### Use GFM Asides Where Appropriate

These are not in the official specification, but these five (5) "asides" are supported by GitHub nevertheless:

```markdown
> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.
```

Use asides to highlight information that users should take into account, even when skimming.

Only use the above when writing GFM.

### Respect Markdownlint Rules

Respect the following Markdownlint rules, unless overridden by the project's Markdownlint configuration (`.markdownlint-cli2.yaml`, `.markdownlintrc`, etc.).

```yaml
ul-style:
  style: dash # always use dashes for list items
emphasis:
  style: underscore # always use underscores for emphasis
ul-indent:
  indent: 2 # always indent list items by 2 spaces
line-length: false # do not enforce line length
no-inline-html: false # allow inline HTML
```

See [Markdownlint Rule Docs](https://github.com/DavidAnson/markdownlint/blob/v0.41.1/doc/Rules.md) for more information rules.

### Fenced Code Blocks

All fenced code blocks must have a language identifier. When a fenced code block contains plain text (or anything not otherwise recognized as code or shell output), use the `text` language identifier.

### Do Not Hard-Wrap Paragraph Text

Never hard-wrap paragraph text at 72, 80, 100, or any other arbitrary line length. This is the responsibility of the Markdown renderer.

### Use EditorConfig

If the project has an `.editorconfig` file, follow its rules.

### Inline Backticks for Code and Filenames

Always use inline backticks to wrap for code, variable names, filenames and paths.

### Forced Linebreaks

If a linebreak must be forced, use trailing double-spaces; `  ` (two spaces).

### Arbitrary HTML

Unless otherwise directed by this document or instructed by the user, avoid using HTML tags. 

_Do not_ remove extant tags.

## Linking

This section concerns when and how to use links.

### Prefer Reference Links

_When a link is used more than once_, use reference links (e.g., `[link text][link reference]`) over inline links (e.g., `[link text](link URL)`).

If inline links already exist, _do not_ go out of your way to convert them to reference links.

### Linking Internal Files

When mentioning a file in the same project, link to it using a relative path link.

If that is not possible, use an `https:` URL to the file on GitHub.

> The URL can usually be deduced from the Git configuration or the `repository` field of the workspace `package.json` file.

### Anchor Links

Make liberal use of intra-document anchor links to other sections.

When referencing sections in other Markdown files, use an anchor link to the section's heading.

## Content

This section concerns the text content of the Markdown document itself.

### Use Title Case

All titles/headings should be in _title case_.

> In title case capitalization, the first letter of each word in a title or heading is capitalised with the exception of certain small words such as "a," "an," "the," "in," "of," etc. The titles of books and articles, as well as newspaper and magazine headlines, frequently employ title case. The norm is not rigid, and deviations are seen in many publications and fields. Title case basically means to capitalize every word with the exception of articles (a, an, the), coordinating conjunctions (and, or, but,...), and (short) prepositions (in, on, for, up,...).

An exception to this rule is the top-level heading, which may be lower case if it refers to a package name (typically shown in the `name` field of its `package.json` or other manifest file).

### Terminology and Definition Lists

If a glossary, terminology or list of definitions is present, use a Definition List (`<dl>`) element (not an unordered list).  Each text body of `<dt>` and `<dd>` elements _must_ be wrapped in double-newlines so that Markdown may be used within the text. Markdown will not render otherwise.

### Proper Nouns for Domain-Specific Terminology

If domain-specific terminology is used, refer to it using a proper noun, e.g., "Proper Noun". Use this in Definition Lists, headings, paragraphs, list and the like (excepting inline or fenced code blocks, unless otherwise indicated).
