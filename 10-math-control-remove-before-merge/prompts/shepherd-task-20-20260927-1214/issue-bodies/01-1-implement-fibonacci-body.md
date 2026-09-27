## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `10-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`

The resolved repository validation contract is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The existing workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.

The resolved behavior contract is that direct CLI execution writes exactly one result line to stdout in the form `Fibonacci(N) = value`, while functions return a numeric value with no incidental output. Inputs are non-negative integers. The production and test files are the repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.

Research for this campaign established that acceptance is intentionally repository-owned and deterministic: production behavior must be exercised through the pinned Pester runner, unit coverage must dot-source the production script, and CLI coverage must use an isolated child `pwsh` process so direct-execution output is tested independently from function invocation. Implement production code and tests from scratch; do not copy research artifacts.

## Branch and execution order

Use `experiment/shepherd-control` as the base branch for the pull request.

This is implementation subsection 1 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned. Task 2 must not begin until this task is merged into the base branch.

## Implement

Create repository-root `math-tool.ps1` with:

- A script parameter named `N` accepting the campaign's non-negative integer inputs.
- A pure `Get-Fibonacci` function that returns the Fibonacci value as a number and emits no logging, labels, or other incidental pipeline output.
- Direct script execution that invokes the function and writes exactly one stdout line: `Fibonacci(N) = value`, with the supplied integer and computed value substituted.

Create repository-root `math-tool.Tests.ps1` with:

- Dot-sourced unit tests for `Get-Fibonacci`.
- Unit cases for `N=0`, `N=1`, and at least one small representative value beyond the base cases.
- Isolated child-`pwsh` process tests for direct CLI execution, covering the same boundary and representative inputs.
- Assertions that distinguish the numeric function contract from the formatted CLI contract.

Keep the implementation small and idiomatic for the repository. Ensure dot-sourcing exposes the function for unit tests without leaking the direct-execution result line into those tests.

## Completion gates

- `Get-Fibonacci 0` returns numeric `0`; `Get-Fibonacci 1` returns numeric `1`; the representative case returns the mathematically correct value.
- Calling `Get-Fibonacci` produces only its numeric return value, with no incidental output.
- Each direct CLI test exits successfully and captures exactly one stdout line matching `Fibonacci(N) = value`; no extra status or diagnostic lines are present.
- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero.
- The pinned pull-request workflow passes with Pester 5.7.1.
- Only `math-tool.ps1` and `math-tool.Tests.ps1` are changed for this task, apart from unavoidable repository-generated metadata.

## Out of scope

- Factorial calculation, operation dispatch, or changes reserved for implementation subsection 2.
- Replacing, bypassing, or changing the repository-owned test runner or pinned workflow.
- Supporting negative, fractional, or non-numeric inputs beyond the resolved non-negative-integer contract.
- Adding unrelated commands, modules, dependencies, files, documentation, or refactors.
