BeforeAll {
    $script:MathToolPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $script:MathToolPath -N 0
}

Describe 'Get-Fibonacci' {
    It 'returns <Expected> for N=<N>' -ForEach @(
        @{ N = 0; Expected = 0 }
        @{ N = 1; Expected = 1 }
        @{ N = 2; Expected = 1 }
        @{ N = 10; Expected = 55 }
        @{ N = 20; Expected = 6765 }
    ) {
        $result = @(Get-Fibonacci -N $N)
        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType ([System.Numerics.BigInteger])
        $result[0] | Should -Be $Expected
    }

    It 'returns the correct value beyond the Int64 range' {
        Get-Fibonacci -N 100 | Should -Be ([System.Numerics.BigInteger]::Parse('354224848179261915075'))
    }

    It 'rejects negative input' {
        { Get-Fibonacci -N -1 } | Should -Throw
    }
}

Describe 'math-tool.ps1 CLI' {
    It 'prints exactly "<Expected>" for N=<N>' -ForEach @(
        @{ N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ N = 1; Expected = 'Fibonacci(1) = 1' }
        @{ N = 10; Expected = 'Fibonacci(10) = 55' }
    ) {
        $output = @(& pwsh -NoLogo -NoProfile -NonInteractive -File $script:MathToolPath -N $N)
        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly $Expected
    }

    It 'fails for negative input' {
        $null = & pwsh -NoLogo -NoProfile -NonInteractive -File $script:MathToolPath -N -1 2>&1
        $LASTEXITCODE | Should -Not -Be 0
    }
}
