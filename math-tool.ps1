[CmdletBinding()]
param(
    [ValidateScript({
        [long]$parsed = 0
        $isInteger = [long]::TryParse(
            $_,
            [Globalization.NumberStyles]::None,
            [Globalization.CultureInfo]::InvariantCulture,
            [ref]$parsed
        )
        $isInteger -and $parsed -ge 0
    })]
    [string]$N = '0'
)

function Get-Fibonacci {
    [OutputType([System.Numerics.BigInteger])]
    param(
        [ValidateScript({
            [long]$parsed = 0
            $isInteger = [long]::TryParse(
                $_,
                [Globalization.NumberStyles]::None,
                [Globalization.CultureInfo]::InvariantCulture,
                [ref]$parsed
            )
            $isInteger -and $parsed -ge 0
        })]
        [string]$N = '0'
    )

    [long]$index = $N
    [System.Numerics.BigInteger]$current = 0
    [System.Numerics.BigInteger]$next = 1

    foreach ($bit in [Convert]::ToString($index, 2).ToCharArray()) {
        [System.Numerics.BigInteger]$doubledCurrent = $current * ((2 * $next) - $current)
        [System.Numerics.BigInteger]$doubledNext = ($current * $current) + ($next * $next)

        if ($bit -eq '0') {
            $current = $doubledCurrent
            $next = $doubledNext
        }
        else {
            $current = $doubledNext
            $next = $doubledCurrent + $doubledNext
        }
    }

    return $current
}

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
