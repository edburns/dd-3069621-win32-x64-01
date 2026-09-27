## Campaign context and required reading

On the `experiment/shepherd-control` branch, the directory `10-math-control-remove-before-merge` contains the plan (`math-tool-ignorance-reduction-plan.md`) and supporting resources (diagrams, decision records). Spike subdirectories are research artifacts — read the plan's Resolution sections for findings, not the spike source code.

Read the entire plan before working. Then re-read these exact sections:

- `## Ignorance reduction`
- `### Repository-owned validation`
- `### Output and ordering contracts`
- `## Implementation`
- `### 1. Implement Fibonacci with unit and isolated CLI coverage`
- `### 2. Add factorial and operation dispatch`

The resolved repository validation contract is the committed command `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1`. The existing workflow `.github/workflows/shepherd-task-math-tool.yml` installs exactly Pester 5.7.1 and invokes that repository-owned runner; do not replace or bypass either contract.

The resolved behavior contract is that direct CLI execution writes exactly one result line to stdout: `Fibonacci(N) = value` or `Factorial(N) = value`. Functions return numeric values with no incidental output. Inputs are non-negative integers. The implementation and test files remain the repository-root `math-tool.ps1` and `math-tool.Tests.ps1`.

Research for this campaign established that acceptance is intentionally repository-owned and deterministic. The combined regression suite must continue to use dot-sourced unit tests for pure functions and isolated child-`pwsh` process tests for direct CLI output, under the pinned Pester runner. Implement the extension in production code and production tests; do not copy research artifacts.

## Branch and execution order

Use `experiment/shepherd-control` as the base branch for the pull request.

This is implementation subsection 2 of 2. The tasks are assigned, completed, and merged serially in plan order. Do not begin work until this issue is assigned and issue 1 has been merged into the base branch. Start from the merged Fibonacci implementation and preserve its behavior.

## Implement

Extend repository-root `math-tool.ps1` with:

- A pure `Get-Factorial` function that returns the factorial as a number and emits no logging, labels, or other incidental pipeline output.
- An `Operation` parameter that dispatches between `fibonacci` and `factorial` while retaining the existing `N` parameter.
- Direct script output of exactly `Fibonacci(N) = value` for Fibonacci or `Factorial(N) = value` for factorial.
- Backward-compatible Fibonacci behavior: existing Fibonacci function calls and direct CLI invocations covered by task 1 must continue to produce the same values and output.

Extend repository-root `math-tool.Tests.ps1` with focused coverage for:

- `Get-Factorial` at `N=0`, `N=1`, and at least one small representative value.
- Isolated direct CLI execution of the factorial operation at the same boundary and representative inputs.
- Dispatch to both supported operations.
- The complete Fibonacci unit and CLI regression behavior introduced by task 1.

Keep the interface and tests objective and small. Follow the existing test structure where it remains suitable, but ensure production tests exercise production code and the real script entry point.

## Completion gates

- `Get-Factorial 0` and `Get-Factorial 1` each return numeric `1`; the representative case returns the mathematically correct value.
- `Get-Factorial` produces only its numeric return value, with no incidental output.
- Dispatch selects the correct calculation for both `fibonacci` and `factorial`.
- Every factorial CLI case exits successfully and emits exactly one stdout line matching `Factorial(N) = value`, with no extra output.
- All task-1 Fibonacci unit and isolated CLI cases still pass unchanged, including exact one-line `Fibonacci(N) = value` output.
- `pwsh -NoLogo -NoProfile -File ./eng/test-math-tool.ps1` exits zero for the combined regression suite.
- The pinned pull-request workflow passes with Pester 5.7.1.
- Changes remain limited to `math-tool.ps1` and `math-tool.Tests.ps1`, apart from unavoidable repository-generated metadata.

## Out of scope

- Replacing, bypassing, or changing the repository-owned test runner or pinned workflow.
- Adding operations other than Fibonacci and factorial.
- Supporting negative, fractional, or non-numeric inputs beyond the resolved non-negative-integer contract.
- Adding unrelated commands, modules, dependencies, files, documentation, or refactors.
