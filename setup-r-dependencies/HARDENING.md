<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--setup-r-dependencies/v1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--setup-r-dependencies/v1** was hardened automatically. 6 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Install pak and query dependencies' step (shell: Rscript) puts an expression straight into the script: install.packages("pak", repos = "https://r-lib.github.io/p/pak/${{ inputs.pak-version }}/"). A pak-version value containing a double quote can break out of the R string and run arbitrary R code.

Locations:

- `action.yaml:28`

### script-injection (severity: high)

Rule (a): the 'Install dependencies' step (shell: Rscript) puts expressions straight into the script: strsplit("${{ inputs.needs }}", ...) on line 54 and strsplit("${{ inputs.extra-packages }}", ...) on line 57. A crafted value can break out of the R string and run arbitrary R code.

Locations:

- `action.yaml:54`
- `action.yaml:57`

### unpinned-uses (severity: high)

A composite step uses a version tag instead of a full commit SHA: 'uses: actions/cache@v2'.

Locations:

- `action.yaml:41`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.pak-version }}" appears directly in run: block of step "Install pak and query dependencies"; move to env: map

Locations:

- `action.yml:28`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.needs }}" appears directly in run: block of step "Install dependencies"; move to env: map

Locations:

- `action.yml:54`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.extra-packages }}" appears directly in run: block of step "Install dependencies"; move to env: map

Locations:

- `action.yml:57`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, static-inline-injection

**Notes:**

I changed action.yaml so the three inputs no longer go straight into the R scripts. Each is now set in its step's env: block (PAK_VERSION, INPUT_NEEDS, INPUT_EXTRA_PACKAGES) and read with Sys.getenv(). The pak repo URL is built with paste0(). I also pinned actions/cache@v2 to its commit SHA 8492260343ad570701412c2f464a5877dc76bace, which I looked up rather than guessed. I haven't run the action. Behaviour should stay the same: Sys.getenv() returns "" for an empty input, and strsplit("", ...)[[1]] gives character(0), just as the old inline empty string did.

### Iteration 2

**Fixes applied:** unpinned-uses, script-injection, invalid-yaml

**Notes:**

Put back the corrupted line 40 as 'shell: Rscript {0}', which fixes the YAML parse error. Pinned actions/cache@v2 to 8492260343ad570701412c2f464a5877dc76bace (looked up, not guessed). The 'Install dependencies' step now reads the needs input with Sys.getenv("INPUT_NEEDS") instead of pasting the ${{ inputs.needs }} expression into the script.

