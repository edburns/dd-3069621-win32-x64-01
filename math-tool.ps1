[CmdletBinding()]
param(
    [ValidateRange(0, [long]::MaxValue)]
    [long]$N
)

function Get-Fibonacci {
    [OutputType([long])]
    param(
        [ValidateRange(0, [long]::MaxValue)]
        [long]$N
    )

    [long]$current = 0
    [long]$next = 1

    for ([long]$index = 0; $index -lt $N; $index++) {
        [long]$sum = $current + $next
        $current = $next
        $next = $sum
    }

    return $current
}

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
