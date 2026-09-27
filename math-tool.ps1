[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N = 0
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

    $previous = [long] 0
    $current = [long] 1
    for ($i = 0; $i -lt $N; $i++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $previous
}

if ($MyInvocation.InvocationName -ne '.') {
    Write-Output "Fibonacci($N) = $(Get-Fibonacci -N $N)"
}
