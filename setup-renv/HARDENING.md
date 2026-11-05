<!-- markdownlint-disable -->

# Hardening Report: r-lib--actions--setup-renv/v1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **r-lib--actions--setup-renv/v1** was hardened automatically. 2 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Set RENV_PATHS_ROOT' step puts a ${{ }} expression straight into its run: script: `echo "RENV_PATHS_ROOT=${{ runner.temp }}/renv" >> $GITHUB_ENV`. Use the $RUNNER_TEMP environment variable instead and double-quote it, e.g. `echo "RENV_PATHS_ROOT=${RUNNER_TEMP}/renv" >> "$GITHUB_ENV"`.

Locations:

- `action.yaml:20`

### unpinned-uses (severity: high)

A composite step refers to an action by a mutable tag instead of a full commit SHA: `uses: actions/cache@v2`. Pin it to a 40-character commit SHA.

Locations:

- `action.yaml:36`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

I fixed both findings in action.yaml. I haven't run the action since the edits.

- **script-injection:** The 'Set RENV_PATHS_ROOT' step no longer puts `${{ runner.temp }}` straight into the shell script. It now uses the runner's own `RUNNER_TEMP` variable, and `$GITHUB_ENV` is quoted: `echo "RENV_PATHS_ROOT=${RUNNER_TEMP}/renv" >> "$GITHUB_ENV"`.
- **unpinned-uses:** `actions/cache@v2` is now pinned to its commit: `actions/cache@8492260343ad570701412c2f464a5877dc76bace # v2`. I looked the commit up rather than guessing it.

One problem pinning doesn't solve: GitHub has shut down the v1 and v2 cache service, so on github.com the restore step will probably not work even when pinned. I kept v2 to match upstream. Moving to a newer major version (v4) would fix it, but that changes the action's behaviour, so it should be a separate decision.

### Iteration 2

**Fixes applied:** unpinned-uses

**Notes:**

Pinned actions/cache@v2 to 8492260343ad570701412c2f464a5877dc76bace # v2 in action.yaml.

### Iteration 3

**Fixes applied:** github-env-injection

**Notes:**

In action.yaml, the 'Set RENV_PATHS_ROOT' step now passes RUNNER_TEMP through printf '%s' | tr -d '\n\r' before writing RENV_PATHS_ROOT to $GITHUB_ENV.

