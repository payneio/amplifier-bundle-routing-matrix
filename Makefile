## Test harness for the triage attractor pipeline.
##
## Quick start:
##   make dry-run              # no GitHub posting, uses routing-matrix issue
##   make dry-run EVENT=test/events/simple.json
##   make triage               # POSTS a real GitHub comment — needs real event
##   make install              # install amplifier-triage CLI from ../amplifier-app-actions
##
## Environment variables (inherit from shell or pass inline):
##   ANTHROPIC_API_KEY   required
##   GITHUB_TOKEN        required for github_checkout_repo + comment posting
##   MODEL               optional model override (e.g. claude-haiku-4-5-20251001)

# ── Defaults ─────────────────────────────────────────────────────────────────

EVENT  ?= test/events/routing-matrix.json
DOT    ?= .github/amplifier/triage-review.dot
MODEL  ?=

# ── Helpers ──────────────────────────────────────────────────────────────────

_model_flag = $(if $(MODEL),--model $(MODEL),)

.PHONY: dry-run triage install check-env help

# ── Targets ───────────────────────────────────────────────────────────────────

## dry-run: investigate + quality gate, no GitHub comment posted.
## Same prompts and thread design as the real pipeline — safe to run repeatedly.
## Clears /tmp/workspace/ first to avoid stale cached checkouts from previous runs.
dry-run: check-env
	rm -rf /tmp/workspace/
	amplifier-triage \
	  --attractor-source test/triage-dry-run.dot \
	  --event-path $(EVENT) \
	  $(_model_flag)

## triage: full pipeline including comment_draft → posts a real GitHub comment.
## Requires GITHUB_TOKEN and a real event JSON pointing at an actual issue.
triage: check-env
	amplifier-triage \
	  --attractor-source $(DOT) \
	  --event-path $(EVENT) \
	  $(_model_flag)

## install: install amplifier-triage CLI from the local amplifier-app-actions checkout.
install:
	@echo "Installing amplifier-triage from ../amplifier-app-actions..."
	cd ../amplifier-app-actions && uv tool install --editable .
	@echo "Done. Run: amplifier-triage --help"

## check-env: verify required env vars are set.
check-env:
	@test -n "$$ANTHROPIC_API_KEY" || \
	  { echo "Error: ANTHROPIC_API_KEY is not set"; exit 1; }
	@test -n "$$GITHUB_TOKEN" || \
	  { echo "Warning: GITHUB_TOKEN is not set — checkout and comment posting will fail"; }

## help: list available targets.
help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /'
