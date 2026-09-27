Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

BeforeAll {
    $script:ScriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $script:ScriptPath
}

Describe 'Get-Fibonacci' {
    It 'returns <Expected> for N=<N>' -TestCases @(
        @{ N = 0; Expected = 0 }
        @{ N = 1; Expected = 1 }
        @{ N = 2; Expected = 1 }
        @{ N = 6; Expected = 8 }
        @{ N = 10; Expected = 55 }
    ) {
        param($N, $Expected)

        Get-Fibonacci -N $N | Should -Be $Expected
    }

    It 'returns a single numeric value without incidental output' {
        $output = Get-Fibonacci -N 6

        @($output).Count | Should -Be 1
        $output | Should -BeOfType [long]
    }

    It 'does not emit the direct-CLI result line when dot-sourced' {
        $output = . $script:ScriptPath

        $output | Should -BeNullOrEmpty
    }
}

Describe 'Direct CLI execution' {
    It 'writes exactly one result line for N=<N>' -TestCases @(
        @{ N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ N = 6; Expected = 'Fibonacci(6) = 8' }
    ) {
        param($N, $Expected)

        $stdout = & pwsh -NoLogo -NoProfile -File $script:ScriptPath -N $N
        $LASTEXITCODE | Should -Be 0

        $lines = @($stdout)
        $lines.Count | Should -Be 1
        $lines[0] | Should -BeExactly $Expected
    }
}
