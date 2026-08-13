# claude-tooling

Custom tooling for Claude Code: output styles and hooks that fix one thing above all
others: the narration.

## What's here

| Piece | Path | What it does |
|---|---|---|
| Silent Proactive | `output-styles/silent-proactive.md` | Built-in Proactive style plus a narration ban |
| No-narration hook | `hooks/no-narration.sh` | Re-injects the ban on every prompt, because styles load once |

## Silent Proactive

Claude Code's built-in **Proactive** style is great at acting on its own. It is terrible
at shutting up about it. Every reply opens with "Let me check...", "Now setting up...",
"First, I'll...", then narrates each step before doing it, then summarizes what it just
said.

**Silent Proactive** keeps the built-in Proactive rules word for word and adds one thing:
a narration ban. Future-tense announcements are forbidden. Past-tense reporting is
required. The agent acts first, then reports what happened, what changed, and what is
blocked.

```
Proactive:          "Let me check the config. Now I'll update the setting.
                     I've updated it. So to summarize, the setting is updated."

Silent Proactive:   "Default set in ~/.claude/settings.json. Takes effect next session."
```

### What it bans

- Future-tense announcements: "Now setting up X", "Let me check Y", "I'll start by"
- Acknowledgement openers: "Understood.", "Got it.", "Right."
- Sequencing preambles: "First... then... finally..."
- Meta-commentary, summary restatements, puns, stating the obvious

### What it requires

- Open with the result
- Report outcomes in past tense, in full: what happened, what it means, what is open
- Name every blocker and every changed file
- Say each fact once

### Install

```sh
mkdir -p ~/.claude/output-styles
curl -fsSL https://raw.githubusercontent.com/lisamoreno/claude-tooling/main/output-styles/silent-proactive.md \
  -o ~/.claude/output-styles/silent-proactive.md
```

Activate for the current session:

```
/output-style silent-proactive
```

Make it the default for every session by setting it in `~/.claude/settings.json`:

```json
{
  "outputStyle": "Silent Proactive"
}
```

Some Claude Code builds do not have the `/output-style` command. The settings.json route
works everywhere; restart your session after setting it.

## No-narration hook

A style is read once at session start, and long sessions drift back into narrating. This
`UserPromptSubmit` hook re-injects a compact version of the ban into context on every
single prompt. The style sets the behavior; the hook keeps it pinned.

### Install

```sh
mkdir -p ~/.claude/hooks
curl -fsSL https://raw.githubusercontent.com/lisamoreno/claude-tooling/main/hooks/no-narration.sh \
  -o ~/.claude/hooks/no-narration.sh
chmod +x ~/.claude/hooks/no-narration.sh
```

Then register it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/no-narration.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

The hook works with any output style, not just Silent Proactive. Use it alone if you
want quieter replies without changing styles.

## Notes

- `keep-coding-instructions: true` in the style's frontmatter keeps Claude Code's
  standard software-engineering instructions active alongside it.
- The six Proactive rules are copied verbatim from the built-in style, including its
  safety rules about destructive actions and data exfiltration. Only the narration
  sections are new.

## License

MIT. Copy it, edit it, ship your own variant.
