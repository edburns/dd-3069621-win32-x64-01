[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N = 0,

    [ValidateSet('fibonacci', 'factorial')]
    [string] $Operation = 'fibonacci'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Fibonacci {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $N
    )

    $previous = [bigint]::Zero
    $current = [bigint]::One
    for ($i = 0; $i -lt $N; $i++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $previous
}

function Get-Factorial {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $N
    )

    $result = [bigint]::One
    for ($i = 2; $i -le $N; $i++) {
        $result *= $i
    }

    return $result
}

if ($MyInvocation.InvocationName -ne '.') {
    if ($Operation -eq 'factorial') {
        Write-Output "Factorial($N) = $(Get-Factorial -N $N)"
    }
    else {
        Write-Output "Fibonacci($N) = $(Get-Fibonacci -N $N)"
    }
}
