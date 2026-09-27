[CmdletBinding()]
param(
    [ValidateRange(0, [long]::MaxValue)]
    [long]$N
)

function Get-Fibonacci {
    [OutputType([System.Numerics.BigInteger])]
    param(
        [ValidateRange(0, [long]::MaxValue)]
        [long]$N
    )

    [System.Numerics.BigInteger]$current = 0
    [System.Numerics.BigInteger]$next = 1

    for ([long]$index = 0; $index -lt $N; $index++) {
        [System.Numerics.BigInteger]$sum = $current + $next
        $current = $next
        $next = $sum
    }

    return $current
}

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
