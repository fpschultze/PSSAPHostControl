function Test-SapHostControlSourceIdentifier {

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $SourceIdentifier
    )

    if ($null -ne (Get-Variable -Name PSSAPHostControlEvent -Scope Script -ErrorAction Ignore)) {

        $SourceIdentifier -in $Script:PSSAPHostControlEvent
    }
}
