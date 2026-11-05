<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--check-r-package/v2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--check-r-package/v2** was hardened automatically. 8 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Check' step (shell: Rscript {0}) puts inputs.check-dir, inputs.args, inputs.build_args and inputs.error-on straight into the R script, where they run as R code. Offending lines: `cat("check-dir-path=", file.path(getwd(), (${{ inputs.check-dir }})), ...)` and `check_results <- rcmdcheck::rcmdcheck(args = (${{ inputs.args }}), build_args = (${{ inputs.build_args }}), error_on = (${{ inputs.error-on }}), check_dir = (${{ inputs.check-dir }}))`. Fix: pass the inputs through env: and read them with Sys.getenv(), parsing them explicitly if they must be R expressions.

Locations:

- `action.yaml:48`
- `action.yaml:49`

### script-injection (severity: high)

Rule (a): the 'Show testthat output' step puts a step output straight into the bash script: `find '${{ steps.rcmdcheck.outputs.check-dir-path }}' -name 'testthat.Rout*' -exec cat '{}' \; || true`. That output comes from inputs.check-dir, and a single quote in the value breaks out of the quoting. Fix: pass it through an env var and use "$CHECK_DIR_PATH".

Locations:

- `action.yaml:58`

### github-env-injection (severity: high)

The 'Check' step writes `check-dir-path=` plus file.path(getwd(), inputs.check-dir) to GITHUB_OUTPUT without stripping newlines or carriage returns first. A value containing a newline could add extra outputs. Fix: remove \n and \r from the value before writing it, the same way the required `printf '%s' ... | tr -d '\n\r'` step does.

Locations:

- `action.yaml:48`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-dir }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:48`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.args }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:49`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.build_args }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:49`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.error-on }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:49`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-dir }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:49`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, static-inline-injection

**Notes:**

Check step (Rscript): moved inputs.check-dir/args/build_args/error-on to env (INPUT_*), read via Sys.getenv() and parsed explicitly with parse(text=...) wrapped in parentheses, so documented R-expression semantics are unchanged. check-dir-path has \r/\n stripped with gsub before writing to GITHUB_OUTPUT. Show testthat output step now reads the step output from env CHECK_DIR_PATH and uses "$CHECK_DIR_PATH".

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

In the 'Show testthat output' step, steps.rcmdcheck.outputs.check-dir-path now goes through env (CHECK_DIR_PATH), and the script uses it as "$CHECK_DIR_PATH" in the find command. How the step behaves is unchanged.

