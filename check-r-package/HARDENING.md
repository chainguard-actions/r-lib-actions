<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--check-r-package/v1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--check-r-package/v1** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): the 'Check' step puts input values straight into a run: script, which runs with shell Rscript {0}. Offending line: `rcmdcheck::rcmdcheck(args = c(${{ inputs.args }}), build_args = c(${{ inputs.build_args }}), error_on = ${{ inputs.error-on }}, check_dir = ${{ inputs.check-dir }})`. Each value is placed into the R script as raw code, so anyone who controls an input can run any R code they like (for example, system(...)). Fix: pass the inputs through env: variables and read them with Sys.getenv(), then parse them safely instead of placing them into the code.

Locations:

- `action.yaml:30`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.args }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:30`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.build_args }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:30`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.error-on }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:30`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-dir }}" appears directly in run: block of step "Check"; move to env: map

Locations:

- `action.yml:30`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

In action.yaml's Check step (shell: Rscript {0}), moved inputs.args, build_args, error-on and check-dir into env vars. Each is read via Sys.getenv(), parsed as c(<value>), and checked so it holds only literal constants (strings, numbers, logicals, NULL) before eval in baseenv. Any function call such as system() is rejected with an error. Upstream's documented input format (e.g. '"--no-manual", "--as-cran"', '"warning"', '"check"') still works the same. Not tested here.

