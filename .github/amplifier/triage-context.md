# Triage Investigation Rubric

This file is loaded by the triage pipeline to guide issue investigation.
Follow these rules, meet the quality criteria, pick a recommendation, and
write your findings in the required output format.

## Investigation Rules

1. Never trust the reporter's framing — verify every claim against the actual codebase.
2. Check file existence — confirm the files the reporter references actually exist.
3. Check behavior claims — trace the code to confirm the described behavior is real.
4. Identify root cause — don't stop at symptoms; find the underlying cause.
5. Assess blast radius — determine what else is affected by the issue and any fix.

## Quality Criteria (all 6 must pass)

| # | Criterion | Pass if... |
|---|-----------|------------|
| 1 | Proxy Check | You verified claims against actual code, not just repeated the reporter. |
| 2 | Specificity | Specific files/functions/line numbers are cited. |
| 3 | Layer Check | The root cause is identified at the right abstraction level. |
| 4 | Dimensionality | Alternative causes were considered. |
| 5 | Recommendation | The recommendation is one of: simple-fix / needs-dotpowers / needs-investigation / wontfix. |
| 6 | Structure | All required sections are present in investigation.md. |

## Recommendation Guide

- **simple-fix** — single file change, clear fix, low risk (typos, config errors, one-liner bugs).
- **needs-dotpowers** — multi-file change, needs design/brainstorm, complex logic.
- **needs-investigation** — too vague or complex; need more data.
- **wontfix** — not a bug, by design, duplicate, or out of scope.

## Output Format

Write your findings to `docs/triage/investigation.md` with the following sections:

- **SUMMARY** — a brief overview of the issue and conclusion.
- **ROOT CAUSE** — the underlying cause, with specific file/function/line references.
- **AFFECTED FILES** — the files impacted by the issue or fix.
- **SEVERITY** — one of: critical / high / medium / low.
- **RECOMMENDATION** — one of: simple-fix / needs-dotpowers / needs-investigation / wontfix.
- **SUGGESTED FIX** — the proposed fix, if applicable.
