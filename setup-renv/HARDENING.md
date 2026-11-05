<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--setup-renv/v2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--setup-renv/v2** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): the expression `${{ runner.temp }}` is pasted straight into the bash run: script in the 'Set RENV_PATHS_ROOT' step: `echo "RENV_PATHS_ROOT=${{ runner.temp }}/renv" >> $GITHUB_ENV`. To fix, use the shell variable "$RUNNER_TEMP" in double quotes instead.

Locations:

- `action.yaml:28`

### script-injection (severity: high)

Sub-rule (a): the caller-supplied expression `${{ inputs.profile }}` is pasted straight into the Rscript run: block in the 'Install and activate renv' step: `renv::activate(profile = ${{ inputs.profile }})`. Whatever the caller passes runs as R code. To fix, pass the value through an env: variable and read it with Sys.getenv() instead of putting the expression in the script.

Locations:

- `action.yaml:33`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.profile }}" appears directly in run: block of step "Install and activate renv"; move to env: map

Locations:

- `action.yml:33`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Replaced ${{ runner.temp }} with "$RUNNER_TEMP" (and quoted $GITHUB_ENV). Moved inputs.profile into env INPUT_PROFILE; the R step reads it with Sys.getenv() and parses it without evaluating: a string literal or NULL is used as is, any other text is used as the raw profile name, and an empty value maps to profile = NULL (renv's default). Arbitrary R expressions are no longer executed.

