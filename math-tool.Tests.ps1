Describe 'Get-Fibonacci' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns numeric zero for 0' {
        $result = Get-Fibonacci -N 0

        $result | Should -BeOfType ([long])
        $result | Should -Be 0
    }

    It 'returns numeric one for 1' {
        $result = Get-Fibonacci -N 1

        $result | Should -BeOfType ([long])
        $result | Should -Be 1
    }

    It 'returns numeric five for 5' {
        $result = Get-Fibonacci -N 5

        $result | Should -BeOfType ([long])
        $result | Should -Be 5
    }
}

Describe 'math-tool CLI' {
    BeforeAll {
        $pwshPath = (Get-Command pwsh -ErrorAction Stop).Source
        $scriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    }

    It 'writes exactly one formatted result line for <N>' -TestCases @(
        @{ N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ N = 5; Expected = 'Fibonacci(5) = 5' }
    ) {
        param($N, $Expected)

        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -N $N

        $LASTEXITCODE | Should -Be 0
        $output | Should -HaveCount 1
        $output | Should -Be $Expected
    }
}
