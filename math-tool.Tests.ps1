Describe 'Get-Fibonacci' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns numeric zero for 0' {
        $result = Get-Fibonacci -N 0

        $result | Should -BeOfType ([System.Numerics.BigInteger])
        $result | Should -Be 0
    }

    It 'returns numeric one for 1' {
        $result = Get-Fibonacci -N 1

        $result | Should -BeOfType ([System.Numerics.BigInteger])
        $result | Should -Be 1
    }

    It 'returns numeric five for 5' {
        $result = Get-Fibonacci -N 5

        $result | Should -BeOfType ([System.Numerics.BigInteger])
        $result | Should -Be 5
    }

    It 'returns an exact numeric value beyond Int64 range' {
        $result = Get-Fibonacci -N 93

        $result | Should -BeOfType ([System.Numerics.BigInteger])
        $result | Should -Be ([System.Numerics.BigInteger]::Parse('12200160415121876738'))
    }

    It 'rejects fractional input before conversion' {
        { Get-Fibonacci -N 1.5 } | Should -Throw
    }

    It 'rejects negative input' {
        { Get-Fibonacci -N -1 } | Should -Throw
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

    It 'rejects fractional input before conversion' {
        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -N 1.5 2>&1

        $LASTEXITCODE | Should -Not -Be 0
        $output | Should -Not -BeNullOrEmpty
    }

    It 'rejects negative input' {
        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -N -1 2>&1

        $LASTEXITCODE | Should -Not -Be 0
        $output | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-Factorial' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns numeric <Expected> for <N>' -TestCases @(
        @{ N = 0; Expected = 1 }
        @{ N = 1; Expected = 1 }
        @{ N = 5; Expected = 120 }
    ) {
        param($N, $Expected)

        $result = @(Get-Factorial -N $N)

        $result | Should -HaveCount 1
        $result[0] | Should -BeOfType ([System.Numerics.BigInteger])
        $result[0] | Should -Be $Expected
    }

    It 'rejects fractional input before conversion' {
        { Get-Factorial -N 1.5 } | Should -Throw
    }

    It 'rejects negative input' {
        { Get-Factorial -N -1 } | Should -Throw
    }
}

Describe 'Invoke-MathOperation' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'dispatches <Operation> for <N>' -TestCases @(
        @{ Operation = 'fibonacci'; N = 5; Expected = 'Fibonacci(5) = 5' }
        @{ Operation = 'factorial'; N = 5; Expected = 'Factorial(5) = 120' }
    ) {
        param($Operation, $N, $Expected)

        $result = @(Invoke-MathOperation -Operation $Operation -N $N)

        $result | Should -HaveCount 1
        $result[0] | Should -Be $Expected
    }
}

Describe 'math-tool CLI operation dispatch' {
    BeforeAll {
        $pwshPath = (Get-Command pwsh -ErrorAction Stop).Source
        $scriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    }

    It 'writes exactly one factorial result line for <N>' -TestCases @(
        @{ N = 0; Expected = 'Factorial(0) = 1' }
        @{ N = 1; Expected = 'Factorial(1) = 1' }
        @{ N = 5; Expected = 'Factorial(5) = 120' }
    ) {
        param($N, $Expected)

        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -Operation factorial -N $N

        $LASTEXITCODE | Should -Be 0
        $output | Should -HaveCount 1
        $output | Should -Be $Expected
    }

    It 'dispatches explicit <Operation> for <N>' -TestCases @(
        @{ Operation = 'fibonacci'; N = 5; Expected = 'Fibonacci(5) = 5' }
        @{ Operation = 'factorial'; N = 5; Expected = 'Factorial(5) = 120' }
    ) {
        param($Operation, $N, $Expected)

        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -Operation $Operation -N $N

        $LASTEXITCODE | Should -Be 0
        $output | Should -HaveCount 1
        $output | Should -Be $Expected
    }

    It 'rejects unsupported operations' {
        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -Operation square -N 5 2>&1

        $LASTEXITCODE | Should -Not -Be 0
        $output | Should -Not -BeNullOrEmpty
    }

    It 'rejects negative factorial input' {
        $output = & $pwshPath -NoLogo -NoProfile -File $scriptPath -Operation factorial -N -1 2>&1

        $LASTEXITCODE | Should -Not -Be 0
        $output | Should -Not -BeNullOrEmpty
    }
}
