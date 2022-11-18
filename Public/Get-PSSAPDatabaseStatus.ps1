<#
.SYNOPSIS
    Get the status of the database specified.

.DESCRIPTION
    Get the status of the database specified in the parameters.
    On success, returns the overall status of the database. Result contains the components of the database and their status.
    A database component is described by the properties "Database/ComponentName", "Database/ComponentDescription", "Database/ComponentStatusDescription", and "Status"

.NOTES
    Commandline tool
    ----------------
    GetDatabaseStatus
    -dbname <DB name> -dbtype <ada|db6|mss...> [-dbhost <hostname>] [-dbinstance <instance name>] [-dbuser <DB admin username>] [-dbpass <DB admin password>]

    OverloadDefinitions
    -------------------
    void GetDatabaseStatusAsync(<Namespace>.Property[] aArguments)
#>
function Get-PSSAPDatabaseStatus {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapHostControlConnection,

        # Database name
        [Parameter(Mandatory = $true)]
        [string]
        $DBName,

        # Database type
        [Parameter(Mandatory = $true)]
        [ValidateSet('ada', 'syb', 'db6', 'mss', 'ora', 'hdb')]
        [string]
        $DBType,

        # Database instance name
        [Parameter()]
        [string]
        $DBInstanceName,

        # Database host
        [Parameter()]
        [string]
        $DBHost,

        # DB administration credential (mandatory for ada, sap, and db6 on Windows)
        [Parameter()]
        [pscredential]
        $DBCredential
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'GetDatabaseStatusCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapHostControlConnection | Initialize-SapHostControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

#        [PSSAPHostControl.Property[]]$aArguments = $PSBoundParameters | ConvertTo-ArrayOfDBProperty
        $aArguments = $PSBoundParameters | ConvertTo-ArrayOfDBProperty

        $SapHostControlConnection.GetDatabaseStatusAsync($aArguments)


        # Wait for web service response

        $Event = Wait-SapHostControlEvent -SourceIdentifier $SourceIdentifier

        if ($Event -isnot [bool]) {

            $returnValue = [pscustomobject]@{
                Status = $($Event.Status)
                Result = $($Event.Result | ConvertFrom-DatabaseStatusResponse)
            }
        }
        else {

            $returnValue = $Event
        }
    }
    catch {

        Write-Error $_

        $returnValue = $null
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
