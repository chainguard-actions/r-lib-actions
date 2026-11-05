<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--setup-r-dependencies/v2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--setup-r-dependencies/v2** was hardened automatically. 20 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) is violated in the 'Set site library path' step (Rscript). A ${{ }} expression is placed directly in the script: `if (nchar("${{ env.R_LIBS_USER && 'ok' || '' }}") == 0) {`.

Locations:

- `action.yaml:100`

### script-injection (severity: high)

Rule (a) is violated in the 'Install pak (Windows)' step (Rscript). The input is placed directly in the R code: `if ("${{ inputs.pak-version }}" == "repo")` and `"${{ inputs.pak-version }}",`. A crafted value could run arbitrary R code.

Locations:

- `action.yaml:118`
- `action.yaml:123`

### script-injection (severity: high)

Rule (a) is violated in the 'Install pak (Unix)' step (bash). `${{ inputs.pak-version }}` is placed directly inside the shell command `$SUDO R -q -e 'if ("${{ inputs.pak-version }}" == "repo") ...'`. A single quote in the value breaks out into the shell, and the value also runs as R code.

Locations:

- `action.yaml:156`

### script-injection (severity: high)

Rule (a) is violated in the 'Query dependencies' step (Rscript). Several inputs are placed directly in the R code: `strsplit("${{ inputs.needs }}", ...)`, `strsplit("${{ inputs.packages }}", ...)`, `strsplit("${{ inputs.extra-packages }}", ...)`, `upgrade = (${{ inputs.upgrade }})`, `dependencies = c(needs, (${{ inputs.dependencies }}))` and `lib = ${{ inputs.lockfile-create-lib }}`.

Locations:

- `action.yaml:186`
- `action.yaml:188`
- `action.yaml:189`
- `action.yaml:196`
- `action.yaml:197`
- `action.yaml:198`

### script-injection (severity: high)

Rule (a) is violated in the 'Check whether pandoc needs to be installed' step (Rscript). The input is placed directly in the script: `o <- '${{ inputs.install-pandoc }}'`.

Locations:

- `action.yaml:256`

### script-injection (severity: high)

Rule (a) is violated in the 'Check whether quarto is needed' step (Rscript). The input is placed directly in the script: `o <- '${{ inputs.install-quarto }}'`.

Locations:

- `action.yaml:292`

### github-env-injection (severity: high)

The 'Set site library path' step writes values from the inherited environment to GITHUB_ENV without removing newlines. Line 96 writes `plib`, which comes from the inherited R_LIBS_SITE: `cat(sprintf("R_LIB_FOR_PAK=%s\n", plib), file = Sys.getenv("GITHUB_ENV"), ...)`. Line 102 writes the inherited R_LIBS_USER: `cat(sprintf("R_LIBS_USER=%s\n", Sys.getenv("R_LIBS_USER")), file = Sys.getenv("GITHUB_ENV"), ...)`. The calling workflow sets these variables, so a value containing a newline could inject extra environment variables.

Locations:

- `action.yaml:96`
- `action.yaml:102`

### github-env-injection (severity: high)

The 'Set JAVA_HOME (Windows)' step writes inherited environment variables to GITHUB_ENV without the `printf '%s' ... | tr -d '\n\r'` step: `echo "JAVA_HOME=${JAVA_HOME_21_X64}" >> $GITHUB_ENV` and `echo "JAVA_HOME=${JAVA_HOME_21_AARCH64}" >> $GITHUB_ENV`.

Locations:

- `action.yaml:139`
- `action.yaml:141`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.pak-version }}" appears directly in run: block of step "Install pak (Windows)"; move to env: map

Locations:

- `action.yml:117`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.pak-version }}" appears directly in run: block of step "Install pak (Windows)"; move to env: map

Locations:

- `action.yml:122`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.pak-version }}" appears directly in run: block of step "Install pak (Unix)"; move to env: map

Locations:

- `action.yml:155`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.pak-version }}" appears directly in run: block of step "Install pak (Unix)"; move to env: map

Locations:

- `action.yml:155`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.needs }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:185`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.packages }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:187`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.extra-packages }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upgrade }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.dependencies }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.lockfile-create-lib }}" appears directly in run: block of step "Query dependencies"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.install-pandoc }}" appears directly in run: block of step "Check whether pandoc needs to be installed"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.install-quarto }}" appears directly in run: block of step "Check whether quarto is needed"; move to env: map

Locations:

- `action.yml:291`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, static-inline-injection

**Notes:**

Changes to action.yaml:
- Set site library path: the expression `env.R_LIBS_USER && 'ok' || ''` moved into env R_LIBS_USER_GH_SET and is read with Sys.getenv. Every write to GITHUB_ENV (R_LIB_FOR_PAK, R_LIBS_SITE, R_LIBS_USER) now goes through sanitize(), which uses gsub to remove \r and \n.
- Install pak (Windows/Unix): inputs.pak-version moved to env INPUT_PAK_VERSION and is read in R with Sys.getenv. On Unix, `sudo -E` keeps the variable available.
- Set JAVA_HOME (Windows): the values are cleaned with printf '%s' | tr -d '\n\r' before being written, and "$GITHUB_ENV" is now quoted.
- Query dependencies: needs, packages, extra-packages, upgrade, dependencies and lockfile-create-lib moved to env vars. The package lists are split with the same regex as upstream. upgrade, dependencies and lockfile-create-lib are documented as R expressions, so they are still run as R code, now with eval(parse(text = Sys.getenv(...))). This keeps upstream behaviour but means a caller can still run R code through those three inputs by design.
- Pandoc and quarto checks: install-pandoc and install-quarto moved to env and are read with Sys.getenv.
Some of the parallel edits garbled the pak Unix and Query dependencies steps and dropped the JAVA_HOME change. I fixed these one at a time and read the full file back to check it.

