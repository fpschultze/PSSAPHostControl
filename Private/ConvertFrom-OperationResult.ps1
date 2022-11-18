function ConvertFrom-OperationResult
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $OperationResult
    )

    $returnValue = @{
        OperationID = $OperationResult.mOperationID
        OperationResults = @()
    }

    $total = $OperationResult.mOperationResults.Count

    if ($total -gt 0) {

        $chunkSize = 4

        $parts = [math]::Ceiling($total / $chunkSize)

        for ($i = 0; $i -le $parts; $i++) {

            $start = $i * $chunkSize
            $end = (($i + 1) * $chunkSize) - 1

            $h = @{}

            $OperationResult.mOperationResults[$start..$end] | ForEach-Object {

                $h.Add($_.mMessageKey, $_.mMessageValue)
            }

            $returnValue.OperationResults += [PSCustomObject]$h
        }
    }

    [PSCustomObject]$returnValue
}
