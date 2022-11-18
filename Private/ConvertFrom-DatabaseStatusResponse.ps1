function ConvertFrom-DatabaseStatusResponse
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $DatabaseStatusResponse
    )

    Process {

        $h = @{}

        $DatabaseStatusResponse.mProperties | ForEach-Object {

            $h.Add($_.mKey, $_.mValue)
        }

        $h.Add('Status', $DatabaseStatusResponse.mStatus)

        [PSCustomObject]$h
    }
}
