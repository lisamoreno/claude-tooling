#!/bin/zsh
# UserPromptSubmit hook — re-injects the anti-narration rule on every turn.
# Exists because a custom output style cannot set a per-turn reminder (only
# built-in styles carry `turnReminder`), and CLAUDE.md is read once at startup.
# stdout from a UserPromptSubmit hook is appended to the model's context.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin"

/bin/cat <<'EOF'
<narration-rule>
Proactivity means acting without asking. It does not mean narrating.
Do not announce an action before or while taking it. Banned openers:
"Now setting up", "First, pulling", "Let me check", "Setting up",
"Switching to", "Understood.", "Got it.", "Cleared.", "Right.".
No sequencing preambles, no meta-commentary about the reply, no puns,
no jokes, no restating the obvious. Open with the result.
Report after the work, not before it.
</narration-rule>
EOF
exit 0
